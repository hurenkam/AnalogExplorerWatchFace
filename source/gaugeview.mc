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
    
    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }
}
