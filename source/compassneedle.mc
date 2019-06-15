using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Math;
using Toybox.Application;
using Toybox.Timer;
using Toybox.WatchUi;

class CompassNeedle extends Shape {
	var centerX, centerY, angle, orgshape;
	
	function initialize(x,y,w,h,angle)
	{
		Shape.initialize(x-w/2,y-h/2,[]);
		orgshape = new Shape(x-w/2,y-h/2, [
    			[ :Polygon, 1, Graphics.COLOR_BLUE, 	[[x, y-h/2], [x-w/2, y], [x,     y]] ], 
    			[ :Polygon, 1, Graphics.COLOR_DK_BLUE, 	[[x, y-h/2], [x,     y], [x+w/2, y]] ], 
    			[ :Polygon, 1, Graphics.COLOR_LT_GRAY, 	[[x, y+h/2], [x-2/2, y], [x,     y]] ], 
    			[ :Polygon, 1, Graphics.COLOR_DK_GRAY, 	[[x, y+h/2], [x,     y], [x+w/2, y]] ]
			]);
		
		self.centerX = x;
		self.centerY = y;
		self.angle = angle;
	}
	
    function onUpdate(dc, buffer, angle)
    {
    	self.angle = angle;
		var rotated = orgshape.rotate(centerX,centerY,angle);
		self._shape = rotated._shape;
		
		self.draw(dc);
    }
}
