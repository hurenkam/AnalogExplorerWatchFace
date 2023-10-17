import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

using WidgetBarrel.AnalogGauges as Gauges;

class NewWatchFaceView extends WatchUi.WatchFace {
    hidden var _analogTime;
    hidden var _compass;
    hidden var _altimeter;
    hidden var _speedometer;
    hidden var _supportsPartialUpdate = false;
    hidden var _buffer = null;
    hidden var _sleeping = false;
    hidden var _previousSeconds = 0;

    function initialize()
    {
        WatchFace.initialize();

        if (WatchUi.WatchFace has :onPartialUpdate )
        {
            self._supportsPartialUpdate = true;
        }
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void
    {
        setLayout(Rez.Layouts.WatchFace(dc));

        var scale = dc.getWidth()/454.0;

        self._analogTime = new Gauges.Clock(
            { :x => 227 * scale, :y => 227 * scale, :radius => 227 * scale, :size => 50 * scale, :fullscreen => 1 }
        );

        self._compass = new Gauges.Compass(
            { :x => (227-90)  * scale, :y => (227-80) * scale, :radius => 70 * scale, :size => 20 * scale, :fullscreen => 0 }
        );

        self._altimeter = new Gauges.Altimeter(
            { :x => (227+90) * scale, :y => (227-80) * scale, :radius => 70 * scale, :size => 20 * scale, :fullscreen => 0 }
        );

        self._speedometer = new Gauges.Speedometer(
            { :x => 227 * scale, :y => (227+140) * scale, :radius => 120 * scale, :size => 25 * scale, :fullscreen => 0 }
        );
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void 
    {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void 
    {
        self._buffer = null;
        var bufferdc = null;

        if (self._sleeping && self._supportsPartialUpdate)
        {
            self._buffer = Graphics.createBufferedBitmap({
                :width=>dc.getWidth(),
                :height=>dc.getHeight()
            }).get();        	
        
            bufferdc = self._buffer.getDc();
        } else {
            bufferdc = dc;
        }

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(bufferdc);

        // draw face plates
        self._analogTime.drawFace(bufferdc);
        self._compass.drawFace(bufferdc);
        self._altimeter.drawFace(bufferdc);
        self._speedometer.drawFace(bufferdc);

        // draw hands
        self._compass.drawHands(bufferdc,45);         // heading in degrees
        self._altimeter.drawHands(bufferdc,2250);     // altitude in meters
        self._speedometer.drawHands(bufferdc,12);     // pace in minutes per kilometer
        self._analogTime.drawHands(bufferdc,System.getClockTime());

        if (self._sleeping && self._supportsPartialUpdate)
        {
            dc.clearClip();
            dc.drawBitmap(0,0,self._buffer);
            self.onPartialUpdate(dc);
        }
    }

    function onPartialUpdate(dc as Dc) as Void
    {
        var seconds = System.getClockTime().sec;
        self._analogTime.clearSecondsHand(dc as Dc,self._buffer as BufferedBitmap);
        self._analogTime.drawSecondsHand(dc as Dc,seconds);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void
    {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void
    {
        self._sleeping = false;
        self._analogTime.onExitSleep();
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void
    {
        self._analogTime.onEnterSleep();
        self._sleeping = true;
    }
}
