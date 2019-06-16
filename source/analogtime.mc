using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Math;
using Toybox.Application;
using Toybox.Timer;
using Toybox.WatchUi;

using WidgetBarrel.PrimitiveShapes as Shapes;
using WidgetBarrel.AnalogGauges as Gauges;

class AnalogTime extends Gauges.AnalogTime {
	var buffer, theme, secondsHand, timeGauge, distanceGauge, compassGauge, altitudeGauge, speedGauge;
	
    function initialize() {
    	theme = new Gauges.DarkTheme();
    	Gauges.AnalogTime.initialize(120,120,120,theme,4);

		speedGauge = new Gauges.SpeedGauge(0,0,40,theme,2);
		distanceGauge = new Gauges.DistanceGauge(0,0,40,theme,2);
		compassGauge = new Gauges.CompassGauge(0,0,40,theme,2);
		altitudeGauge = new Gauges.DistanceGauge(0,0,40,theme,2);
		
		positionGauge(speedGauge,45);
		positionGauge(distanceGauge,135);
		positionGauge(compassGauge,225);
		positionGauge(altitudeGauge,315);
    }
    
    function onLayout(dc)
    {
    }

	function positionGauge(gauge,angle)
	{
		var radians = 2 * Math.PI * angle / 360.0;
    	var x = position.getX() + (r-54) * Math.sin(radians);
    	var y = position.getY() + (r-54) * Math.cos(radians + Math.PI);
    	gauge.move(x,y);
	}
    
    function onMinutesUpdate(dc)
    {
    	buffer = null;
		var image = WatchUi.loadResource(Rez.Drawables.FacePlate);
		buffer = new Graphics.BufferedBitmap({:bitmapResource=>image});
    	var bufferdc = buffer.getDc();
    	
		bufferdc.clearClip();
		
		var time = System.getClockTime();
    	Gauges.AnalogTime.onUpdate(bufferdc,time);
    			
		dc.setClip(0,0,240,240);
		dc.drawBitmap(0,0,buffer);
    }
    
    function draw(dc)
    {
		var time = System.getClockTime();
		
		var altitude = 0;
		var speed = 0;
		var heading = 0;
		var distance = 0;
		
		var info = Activity.getActivityInfo();
		
		if (info has :altitude) 				
		{ altitude = info.altitude;	}
		
		if (info has :currentSpeed)
		{ speed = info.currentSpeed * 3.6; } // m/s => km/h
		
		if (info has :currentHeading)
		{ heading = info.currentHeading * Math.PI/180; } // radians => degrees
		
		if (info has :distanceToDestination)
		{ distance = info.distanceToDestination; }
		
		speedGauge.onUpdate(dc,speed);
		distanceGauge.onUpdate(dc,distance);
		compassGauge.onUpdate(dc,heading);
		altitudeGauge.onUpdate(dc,altitude);
		
		drawTickMarks(dc,  0, 60, 60, 2,  7, theme.DefaultDimmed);
		drawTickMarks(dc,  0, 12, 12, 4, 12, theme.AccentBright);
		drawNumbers(dc,Graphics.FONT_MEDIUM,t.DefaultBright);
		
		var secondsAngle = 2 * Math.PI * (time.sec-1) / 60.0;
		var topSeconds = new Shapes.Position(position.getX(),position.getY()*0.2);
    	var bottomSeconds = new Shapes.Position(position.getX(),position.getY()+15);
		secondsHand = new Shapes.Line(bottomSeconds,topSeconds,theme.AccentBright,3);
		secondsHand.rotate(120,120,secondsAngle);

		var minutesAngle = 2 * Math.PI * minutes / 60.0;
		var hoursAngle = 2 * Math.PI * hours / 12.0 + minutesAngle/12.0;
		
		drawHoursHand(dc,hoursAngle,t.DefaultBright);
		drawMinutesHand(dc,minutesAngle,t.DefaultBright);
    }
    
    function onSecondsUpdate(dc)
    {
		var clip = secondsHand.getClip();
		if (clip != null)
		{
			dc.setClip(clip[0],clip[1],clip[2],clip[3]);
			dc.drawBitmap(0,0,buffer);
		}
		secondsHand.rotate(120,120,Math.PI/30);
		
		clip = secondsHand.getClip();
		clip = secondsHand.getClip();
		dc.setClip(clip[0],clip[1],clip[2],clip[3]);
		secondsHand.draw(dc);
		
		var x = position.getX();
		var y = position.getY();
		
		dc.setClip(110,110,20,20);
    	dc.setPenWidth(3);
    	dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
		dc.drawCircle(x,y,5);
    	dc.setPenWidth(1);
    	dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
		dc.fillCircle(x,y,4);
    }
 }
