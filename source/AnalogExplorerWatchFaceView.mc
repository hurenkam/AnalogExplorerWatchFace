import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

using WidgetBarrel.AnalogGauges as Gauges;

// Notes:
// This application requires v4.2.x of the Connect IQ SDK, and is intended
// to run on round displays. (support for rectangle is not planned)
//
// Supported device:            Resolution  Shape       Display Technology
// - Fenix 7s                   240 x 240 	round	    Memory-In-Pixel (64 colors)
// - Fenix 7                    260 x 260 	round	    Memory-In-Pixel (64 colors)
// - Fenix 7X                   280 x 280 	round	    Memory-In-Pixel (64 colors)
// - Epix gen2 42mm             390 x 390	round	    AMOLED
// - Epix gen2 47mm             416 x 416	round	    AMOLED
// - Epix gen2 51mm             454 x 454	round	    AMOLED
//
// Todo:
// - Approach® S70 42mm 	    390 x 390	round	    AMOLED
// - Approach® S70 47mm 	    454 x 454	round	    AMOLED
// - D2™ Air X10        	    416 x 416	round	    AMOLED
// - D2™ Mach 1         	    416 x 416	round	    AMOLED
// - Forerunner® 255s   	    218 x 218  	round	    Memory-In-Pixel (64 colors)
// - Forerunner® 255s Music	    218 x 218  	round	    Memory-In-Pixel (64 colors)
// - Forerunner® 255            260 x 260 	round	    Memory-In-Pixel (64 colors)
// - Forerunner® 255 Music	    260 x 260 	round	    Memory-In-Pixel (64 colors)
// - Forerunner® 265s   	    360 x 360 	round	    AMOLED
// - Forerunner® 265    	    416 x 416	round	    AMOLED
// - Forerunner® 955 / Solar   	260 x 260	round	    Memory-In-Pixel (64 colors)
// - Forerunner® 965    	    454 x 454	round	    AMOLED
// - MARQ® (Gen 2)      	    390 x 390	round	    AMOLED
// - Venu® 2            	    416 x 416	round	    AMOLED
// - Venu® 2 Plus       	    416 x 416	round	    AMOLED
// - Venu® 2S           	    360 x 360	round	    AMOLED
// - Venu® 3            	    454 x 454	round	    AMOLED
// - Venu® 3S           	    390 x 390	round	    AMOLED
// - vívoactive® 5      	    390 x 390	round	    AMOLED

// Not planned to be supported (rectangle shape devices)
// - Venu® Sq 2             	320 x 360	rectangle   AMOLED
// - Venu® Sq 2 Music       	320 x 360	rectangle	AMOLED


// Resolutions to be added:
// - 218 x 218
// - 360 x 360

/*

<layout id="WatchFace">
    <drawable id="Outer" class="FacePlate">
        <param name="Background">Rez.Drawables.Background_454</param>
        <param name="CenterX">227</param>
        <param name="CenterY">227</param>
        <param name="Radius">227</param>
        <param name="BigFontSize">50</param>
        <param name="SmallFontSize">35</param>
    </drawable>
</layout>


class FacePlate extends WatchUi.Drawable {
    hidden var _clock;
    hidden var _params;

    function initialize(params as Dictionary) {
        Drawable.initialize(params);
        self._params = params;
    }

    function onLayout(dc as Dc) as Void {
        self._clock = new Gauges.Clock(
            { :x => self._params[:CenterX],
              :y => self._params[:CenterY],
              :radius => self._params[:Radius],
              :size => self._params[:BigFontSize]
            },
            { :radius => self._params[:Radius], 
              :face => self._params[:Background],
              :hourhand => Rez.Drawables.HourHand,
              :minutehand => Rez.Drawables.MinuteHand,
              :secondhand => Rez.Drawables.SecondHand
            }
        );
    }

    function draw(dc as Dc) as Void {
        Drawable.draw(dc);
        // Draw the move bar here
        var background = WatchUi.loadResource(self._params[:Background]);
        dc.drawBitmap(0, 0, background);

        //self._clock.drawFace(dc);
        //self._clock.drawHands(dc,System.getClockTime());
    }
}
*/
class AnalogExplorerWatchFaceView extends WatchUi.WatchFace {
    hidden var _analogTime;
    hidden var _compass;
    hidden var _altimeter;
    hidden var _speedometer;
    hidden var _supportsPartialUpdate = false;
    hidden var _buffer = null;
    hidden var _sleeping = false;
    hidden var _previousSeconds = 0;
    hidden var _properties as Dictionary = {};
    hidden var _location as Array<Number> = [];
    hidden var _decoration as Dictionary = {};

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

        var clockProperties = WatchUi.loadResource(Rez.JsonData.Clock);
        var clockBitmaps = MappedResources.ByRadius[clockProperties["Location"]["r"]];
        self._analogTime = new Gauges.Clock(clockProperties,clockBitmaps);

        var compassProperties = WatchUi.loadResource(Rez.JsonData.Compass);
        var compassBitmaps = MappedResources.ByRadius[compassProperties["Location"]["r"]];
        self._compass = new Gauges.Compass(compassProperties,compassBitmaps);

        var altimeterProperties = WatchUi.loadResource(Rez.JsonData.Altimeter);
        var altimeterBitmaps = MappedResources.ByRadius[altimeterProperties["Location"]["r"]];
        self._altimeter = new Gauges.Altimeter(altimeterProperties,altimeterBitmaps);

        var speedometerProperties = WatchUi.loadResource(Rez.JsonData.Speedometer);
        var speedometerBitmaps = MappedResources.ByRadius[speedometerProperties["Location"]["r"]];
        self._speedometer = new Gauges.Speedometer(speedometerProperties,speedometerBitmaps);

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

        // tell gauges to update their data fields
        var info = Activity.getActivityInfo();
        self._analogTime.updateInfo(info);
        self._compass.updateInfo(info);
        self._altimeter.updateInfo(info);
        self._speedometer.updateInfo(info);

        // draw face plates
        self._analogTime.drawFace(bufferdc);
        self._compass.drawFace(bufferdc);
        self._altimeter.drawFace(bufferdc);
        self._speedometer.drawFace(bufferdc);

        // draw hands
        self._compass.drawHands(bufferdc);
        self._altimeter.drawHands(bufferdc);
        self._speedometer.drawHands(bufferdc);
        self._analogTime.drawHands(bufferdc);

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
        self._altimeter.onExitSleep();
        self._compass.onExitSleep();
        self._speedometer.onExitSleep();
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void
    {
        self._analogTime.onEnterSleep();
        self._altimeter.onEnterSleep();
        self._compass.onEnterSleep();
        self._speedometer.onEnterSleep();
        self._sleeping = true;
    }
}
