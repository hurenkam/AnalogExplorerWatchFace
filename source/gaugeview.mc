using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Math;
using Toybox.Application;
using Toybox.Timer;

class GaugeView extends WatchUi.WatchFace {
	var analogClock;
	
    function initialize() {
        WatchFace.initialize();
        self.analogClock = new AnalogTime();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
		self.analogClock.onLayout(dc);
    }
    
    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc)
    {
    	analogClock.onMinutesUpdate(dc);
    }
    
    function onPartialUpdate(dc)
    {
    	analogClock.onSecondsUpdate(dc);
    }
    
    function drawDigitalClock(dc, time)
    {
        var timeFormat = "$1$:$2$:$3$";
        var hours = time.hour;
        if (!System.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        } else {
            if (Application.getApp().getProperty("UseMilitaryFormat")) {
                timeFormat = "$1$$2$";
                hours = hours.format("%02d");
            }
        }
        var timeString = Lang.format(timeFormat, [hours.format("%02d"), time.min.format("%02d"), time.sec.format("%02d")]);
        var dimensions = dc.getTextDimensions(timeString,Graphics.FONT_LARGE);
        var w = dimensions[0];
        var h = dimensions[1];
        var x = 120 - w/2;
        var y = 150 - h/2;

		dc.setClip(x,y,w,h);
    	dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(120,150,Graphics.FONT_LARGE,timeString,Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }
    
    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

	//function timerCallback() {
	//    View.requestUpdate();
	//}
	
    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
	    //self.timer.start(method(:timerCallback), 1000, true);
	    //WatchUi.requestUpdate();
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    	//self.timer.stop();
	    //WatchUi.requestUpdate();
    }
}
