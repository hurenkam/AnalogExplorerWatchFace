using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Math;
using Toybox.Application;
using Toybox.Timer;
using Toybox.WatchUi;
using Toybox.Activity;

class CompassGauge {
	var posX, posY, centerX, centerY, radius, buffer, clip, needle;
	
    function initialize(dc, x,y,radius) {
    	self.posX = x - radius;
    	self.posY = y - radius;
        self.centerX = x;
        self.centerY = y;
		self.radius = radius;
		
        self.needle = new CompassNeedle(centerX, centerY, 8, 70, 0);
        
        self.clip = [ self.centerX, self.centerY, self.centerX, self.centerY ];
    }
    
    function onMinutesUpdate(dc, buffer)
    {
		drawFace(dc);
		
		needle.onUpdate(dc,buffer,Activity.getActivityInfo().currentHeading);
    }
    
    function drawFace(dc)
    {
		dc.setClip(posX, posY, radius*2, radius*2);
		dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
		dc.fillCircle(centerX,centerY,45);

		drawTickMarks(dc, 36, 1, Graphics.COLOR_LT_GRAY);
		
		//dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
		//dc.drawText(centerX,centerY-35,Graphics.FONT_SYSTEM_XTINY,"N", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		//dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
		//dc.drawText(centerX,centerY+35,Graphics.FONT_SYSTEM_XTINY,"S", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		//dc.drawText(centerX-35,centerY,Graphics.FONT_SYSTEM_XTINY,"W", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		//dc.drawText(centerX+35,centerY,Graphics.FONT_SYSTEM_XTINY,"E", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }
    
    function drawTickMarks(dc, count, size, color)
    {
    	for (var tick = 0; tick < count; tick++)
    	{
    		var angle = 2 * Math.PI * tick / count;
			drawTickMark(dc,angle,size,color);
    	}
    }
    
    function drawTickMark(dc,angle,size,color)
    {
    	var x = centerX + (radius-3) * Math.sin(angle);
    	var y = centerY + (radius-3) * Math.cos(angle + Math.PI);
	    	
    	dc.setPenWidth(size);
    	dc.setColor(color, Graphics.COLOR_TRANSPARENT);
		dc.drawPoint(x,y);
    }
    
    function onClear(dc,buffer)
    {
    }
    
    function onSecondsUpdate(dc, buffer)
    {
    }
 }
