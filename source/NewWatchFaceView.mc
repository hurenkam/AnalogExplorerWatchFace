import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class NewWatchFaceView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
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
        self.drawBackground(dc);
        //self.drawCompassGauge(dc,227,227,227,48);
        //self.drawSpeedGauge(dc,227,227,227,48);
        //self.drawClockGauge(dc,227,227,227,48);
        self.drawCompassGauge(dc,227-90,227-90,80,24);
        self.drawSpeedGauge(dc,227-90,227+90,80,24);
        self.drawClockGauge(dc,227+90,227-90,80,24,["1","2","3","4","5","6","7","8","9","10","11","12"]);
        self.drawClockGauge(dc,227,227,227,48,["1","2","3","4","5","6","7","8","9","10","11","12"]);
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


    function drawBackground(dc as Dc) as Void {
        //dc.setColor(Toybox.Graphics.COLOR_BLACK, Toybox.Graphics.COLOR_WHITE);
        //dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());

		var background = Toybox.WatchUi.loadResource(Rez.Drawables.Background);
        dc.drawBitmap(0, 0, background);
    }

    function drawCompassGauge(dc as Dc, x as Lang.Number, y as Lang.Number, r as Lang.Number, s as Lang.Number) as Void {
        dc.setColor(Toybox.Graphics.COLOR_WHITE, Toybox.Graphics.COLOR_BLACK);
        dc.drawRadialText(x, y, Graphics.getVectorFont({ :face => "BionicBold", :size => s }), "N", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER, 90, r*0.95, Graphics.RADIAL_TEXT_DIRECTION_CLOCKWISE);
        dc.drawRadialText(x, y, Graphics.getVectorFont({ :face => "BionicBold", :size => s }), "E", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER, 0, r*0.95, Graphics.RADIAL_TEXT_DIRECTION_CLOCKWISE);
        dc.drawRadialText(x, y, Graphics.getVectorFont({ :face => "BionicBold", :size => s }), "S", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER, 270, r*0.95, Graphics.RADIAL_TEXT_DIRECTION_CLOCKWISE);
        dc.drawRadialText(x, y, Graphics.getVectorFont({ :face => "BionicBold", :size => s }), "W", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER, 180, r*0.95, Graphics.RADIAL_TEXT_DIRECTION_CLOCKWISE);

        dc.drawRadialText(x, y, Graphics.getVectorFont({ :face => "BionicBold", :size => s/2 }), "NE", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER, 45, r*0.95, Graphics.RADIAL_TEXT_DIRECTION_CLOCKWISE);
        dc.drawRadialText(x, y, Graphics.getVectorFont({ :face => "BionicBold", :size => s/2 }), "NW", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER, 135, r*0.95, Graphics.RADIAL_TEXT_DIRECTION_CLOCKWISE);
        dc.drawRadialText(x, y, Graphics.getVectorFont({ :face => "BionicBold", :size => s/2 }), "SW", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER, 225, r*0.95, Graphics.RADIAL_TEXT_DIRECTION_CLOCKWISE);
        dc.drawRadialText(x, y, Graphics.getVectorFont({ :face => "BionicBold", :size => s/2 }), "SE", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER, 315, r*0.95, Graphics.RADIAL_TEXT_DIRECTION_CLOCKWISE);
    }

    function drawClockGauge(dc as Dc, x as Lang.Number, y as Lang.Number, r as Lang.Number, s as Lang.Number, digits as Array) as Void {
        dc.setColor(Toybox.Graphics.COLOR_WHITE, Toybox.Graphics.COLOR_BLACK);

        var parts = 12;
        var angle = 270; // bottom
        var angle_inc = 360 / parts;
        var number = 6;
        var number_inc = 1;

        for (var i = 0; i < 12; i++) {
            angle -= angle_inc;
            number += number_inc;
            if (number > 12) {
                number -= 12;
            }
            dc.drawRadialText(x, y, Graphics.getVectorFont({ :face => "BionicBold", :size => s }), number.toString(), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER, angle, r*0.95, Graphics.RADIAL_TEXT_DIRECTION_CLOCKWISE);
        }
    }

    function drawSpeedGauge(dc as Dc, x as Lang.Number, y as Lang.Number, r as Lang.Number, s as Lang.Number) as Void {
        dc.setColor(Toybox.Graphics.COLOR_WHITE, Toybox.Graphics.COLOR_BLACK);

        var parts = 10;
        var angle = 270; // bottom
        var angle_inc = 360 / parts;
        var number = 0;
        var number_inc = 10;

        for (var i = 0; i < 9; i++)
        {
            angle -= angle_inc;
            number += number_inc;
            dc.drawRadialText(x, y, Graphics.getVectorFont({ :face => "BionicBold", :size => s }), number.toString(), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER, angle, r*0.95, Graphics.RADIAL_TEXT_DIRECTION_CLOCKWISE);
        }
    }
}
