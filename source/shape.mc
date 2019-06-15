using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Math;
using Toybox.Application;
using Toybox.Timer;
using Toybox.WatchUi;

class Shape {
	var _x, _y, _shape;

    function initialize(x, y, shape) {
    	_x = x;
    	_y = y;
    	_shape = shape;
    }

    function rotate(xr,yr,angle)
    {
    	var result = [];
    	for (var i = 0; i<_shape.size(); i++)
    	{
    		result.add(rotateElement(_shape[i],xr,yr,angle));
		}   
		return new Shape(_x,_y,result);
    }
    
    hidden function rotateElement(element,xr,yr,angle)
    {
    	var type = element[0];
    	var width = element[1];
    	var color = element[2];

		var result = [ type, width, color ];    	
    	switch (type)
    	{
    		case :Point:
    		{
    			var rotated = rotatePoint(element[3], xr, yr, angle);
    			result.add(rotated);
    		}
    		case :Polygon:
    		{
    			var rotated = rotatePolygon(element[3], xr, yr, angle);
    			result.add(rotated);
    			break;
    		}
    		default:
    			break;
    	}
    	return result;
    }
    
    hidden function rotatePolygon(polygon,xr,yr,angle)
    {
    	var radians = angle.toDouble() * Math.PI/180.0;
    	var result = [];
    	for (var i=0; i < polygon.size(); i++)
    	{
    		var rotatedPoint = rotatePoint(polygon[i],xr,yr,angle);
    		result.add(rotatedPoint);
    	}
    	return result;
    }
    
    hidden function rotatePoint(point,xr,yr,angle)
    {
    	var radians = angle.toDouble() * Math.PI/180.0;
    	
		var x = point[0].toDouble();
		var y = point[1].toDouble();
		
		var xn = xr + (x-xr) * Math.cos(radians) - (y - yr) * Math.sin(radians); 
		var yn = yr + (x-xr) * Math.sin(radians) + (y - yr) * Math.cos(radians);
		
		return [xn,yn];
    }
    
    function draw(dc)
    {
    	for (var i = 0; i<_shape.size(); i++)
    	{
    		drawElement(dc, _shape[i]);
		}   
    }
    
    hidden function drawElement(dc, element)
    {
    	var type = element[0];
    	var width = element[1];
    	var color = element[2];
    	
    	dc.setPenWidth(width);
    	dc.setColor(color, Graphics.COLOR_TRANSPARENT);
    	switch (type)
    	{
    		case :Point:
    		{
    			var x = element[3][0];
    			var y = element[3][1];
    			dc.drawPoint(x,y);
				break;
    		}
    		case :Polygon:
    		{
    			dc.fillPolygon(element[3]);
				break;
    		}
    		default:
    			break;
    	}
    }
 }
