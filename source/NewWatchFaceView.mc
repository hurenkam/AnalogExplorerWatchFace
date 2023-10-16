import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

using WidgetBarrel.AnalogGauges as Gauges;

class NewWatchFaceView extends WatchUi.WatchFace {
    hidden var _outer;
    hidden var _topleft;
    hidden var _topright;
    hidden var _bottom;
    hidden var _hourhand;
    hidden var _minutehand;
    hidden var _secondhand;
    hidden var _headinghand;
    hidden var _altitudehand;
    hidden var _speedhand;

    function initialize() {
        WatchFace.initialize();

        // clock on outer dial
        self._outer = new Gauges.Gauge(
            { :x => 227, :y => 227, :radius => 227, :size => 50, :fullscreen => 0 },
            { :text => Graphics.COLOR_BLUE, :stripes => Graphics.COLOR_BLUE, :dots => Graphics.COLOR_WHITE, :background => Graphics.COLOR_BLACK },
            ["*....|....|....*....|....|         |....|....*....|....|....","12","3","9"]
        );
        self._hourhand = new Gauges.Hand(
            {:x => 227.0, :y => 227.0},
            {:dx => -15.0, :dy => -200.0, :scale => 1.0, :reference => Rez.Drawables.HourHand}
        );
        self._minutehand = new Gauges.Hand(
            {:x => 227.0, :y => 227.0},
            {:dx => -15.0, :dy => -200.0, :scale => 1.0, :reference => Rez.Drawables.MinuteHand}
        );
        self._secondhand = new Gauges.Hand(
            {:x => 227.0, :y => 227.0},
            {:dx => -15.0, :dy => -200.0, :scale => 1.0, :reference => Rez.Drawables.SecondHand}
        );

        // compass on top left dial
        self._topleft = new Gauges.Gauge(
            { :x => 227-90, :y => 227-80, :radius => 70, :size => 20, :fullscreen => 0 },
            { :text => Graphics.COLOR_WHITE, :stripes => Graphics.COLOR_WHITE, :dots => Graphics.COLOR_WHITE, :background => Graphics.COLOR_BLACK },
            ["*.|.*.|.*.|.*.|.*.|.*.|.*.|.*.|.","N","|","E","|","S","|","W","|"]
        );
        self._headinghand = new Gauges.Hand(
            {:x => 227.0 - 90, :y => 227.0 - 80},
            {:dx => -15.0, :dy => -200.0, :scale => 0.3, :reference => Rez.Drawables.CompassNeedle}
        );


        // altitude on top right dial
        self._topright = new Gauges.Gauge(
            //{ :x => 227+90, :y => 227-80, :radius => 70, :size => 24 },
            { :x => 227+90, :y => 227-80, :radius => 70, :size => 20, :fullscreen => 0 },
            { :text => Graphics.COLOR_WHITE, :stripes => Graphics.COLOR_WHITE, :dots => Graphics.COLOR_WHITE, :background => Graphics.COLOR_BLACK },
            ["*....|....*....|         |....*....|....","2k","3k","1k"]
            // Analog Clock:   ["*....|....|....*....|....|....*....|....|....*....|....|....","12","3","6","9"]
            // Altitude:       ["*....|....*....|....*         *....|....*....|....","5k","7k","9k","1k","3k"]
            // Heading:        ["*.|.*.|.*.|.*.|.*.|.*.|.*.|.*.|.","N","|","E","|","S","|","W","|"]
        );
        self._altitudehand = new Gauges.Hand(
            {:x => 227.0 + 90, :y => 227.0 - 80},
            {:dx => -15.0, :dy => -200.0, :scale => 0.3, :reference => Rez.Drawables.SpeedNeedle }
        );


        // speed on bottom dial
        self._bottom = new Gauges.Gauge(
            { :x => 227, :y => 227+140, :radius => 120, :size => 25, :fullscreen => 0 },
            { :text => Graphics.COLOR_WHITE, :stripes => Graphics.COLOR_WHITE, :dots => Graphics.COLOR_WHITE, :background => Graphics.COLOR_BLACK },
            ["*|*|*|*       *|*|*|","20","15","10","5","35","30","25"]
            //["* ...|... * ...|... * ...|... *                                       * ...|... * ...|... * ...|... ","70","90","110","130","10","30","50"]
            // Hiking pace:          ["*|*|*|*       *|*|*|","20","15","10","5","35","30","25"]
            // Cycling speed:        ["*|*|*|*       *|*|*|","20","25","30","35","5","10","15"]
            // Car speed:            ["*|*|*|*       *|*|*|","70","90","110","130","10","30","50"]
            // Analog Clock:         ["*....|....|....*....|....|         |....|....*....|....|....","12","3","9"]
        );
        self._speedhand = new Gauges.Hand(
            {:x => 227.0, :y => 227.0 + 140},
            {:dx => -15.0, :dy => -200.0, :scale => 0.5, :reference => Rez.Drawables.SpeedNeedle }
        );
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        self._outer.draw(dc);
        self._topleft.draw(dc);
        self._topright.draw(dc);
        self._bottom.draw(dc);

        dc.clearClip();

		var time = System.getClockTime();
        var secondangle = (time.sec/60.0)   * 2.0 * Math.PI;
        var minuteangle = (time.min/60.0)   * 2.0 * Math.PI;
        var hourangle =   (time.hour/12.0)  * 2.0 * Math.PI + minuteangle/12;
        var headingangle = 0.35 * Math.PI;
        var altitudeangle = 0.15 * Math.PI;
        var speedangle = 0.25 * Math.PI;

        self._hourhand.draw(dc,hourangle);
        self._minutehand.draw(dc,minuteangle);
        self._secondhand.draw(dc,secondangle);
        self._headinghand.draw(dc,headingangle);
        self._altitudehand.draw(dc,altitudeangle);
        self._speedhand.draw(dc,speedangle);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }
}
