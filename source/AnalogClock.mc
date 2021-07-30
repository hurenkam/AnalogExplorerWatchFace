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

class AnalogClock extends Gauges.AnalogTime {
	var width, buffer, theme, secondsHand, time, timeGauge, distanceGauge, compassGauge, altitudeGauge, speedGauge;
	var settings = System.getDeviceSettings();
	var lowpower = false;
	
    function initialize() {
    	theme = new Gauges.DarkBlueTheme();
    	width = Toybox.System.getDeviceSettings().screenWidth;
    	var bigradius = width / 2;
    	var smallradius = width / 6;
    	
		settings = System.getDeviceSettings();
    	Gauges.AnalogTime.initialize(bigradius,bigradius,bigradius,theme,4);
    	    	
		speedGauge = new Gauges.SpeedGauge(0,0,smallradius,theme,2);
		distanceGauge = new Gauges.DistanceGauge(0,0,smallradius,theme,2);
		compassGauge = new Gauges.CompassGauge(0,0,smallradius,theme,2);
		altitudeGauge = new Gauges.DistanceGauge(0,0,smallradius,theme,2);
		
		var topSeconds = new Shapes.Position(position.getX(),position.getY()*0.2);
    	var bottomSeconds = new Shapes.Position(position.getX(),position.getY()+15);
		secondsHand = new Shapes.Line(bottomSeconds,topSeconds,theme.AccentBright,3);
		
		positionGauge(speedGauge,45);
		positionGauge(distanceGauge,135);
		positionGauge(compassGauge,225);
		positionGauge(altitudeGauge,315);
    }
    
    function onLayout(dc)
    {
    }
    
    function onEnterSleep()
    {
    	lowpower = true;
    }

    function onExitSleep()
    {
    	lowpower = false;
    }

	function positionGauge(gauge,angle)
	{
		var radians = 2 * Math.PI * angle / 360.0;
    	var x = position.getX() + (r-gauge.r-14) * Math.sin(radians);
    	var y = position.getY() + (r-gauge.r-14) * Math.cos(radians + Math.PI);
    	gauge.move(x,y);
	}
    
    function onUpdate(dc)
    {
    	System.println("AnalogClock.onUpdate()");
    	buffer = null;
    	
		if (Graphics has :createBufferedBitmap) {
		    buffer = Graphics.createBufferedBitmap({
				:width=>dc.getWidth(),
            	:height=>dc.getHeight()
        	}).get();
		} else {
		    buffer = new Graphics.BufferedBitmap({
				:width=>dc.getWidth(),
            	:height=>dc.getHeight()
        	});
		}
		
    	var bufferdc = buffer.getDc();
    	if (settings.requiresBurnInProtection and lowpower)
    	{
	        bufferdc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
    	}
    	else
    	{
	        bufferdc.setColor(theme.AccentDark, theme.AccentDark);
        }
        bufferdc.clear();
    	
		bufferdc.clearClip();
		
		time = System.getClockTime();
    	Gauges.AnalogTime.onUpdate(bufferdc,time);
    			
		dc.setClip(0,0,width,width);
		dc.drawBitmap(0,0,buffer);
		
		if (!lowpower)
		{
			drawSecondsHand(dc);
		}
    }
    
    function draw(dc)
    {
    	//System.println("AnalogClock.draw()");
		
		var altitude = 0;
		var speed = 0;
		var heading = 0;
		var distance = 0;
		
		var info = Activity.getActivityInfo();
		var dbg = "";
		
		if (info has :altitude)
		{ 
			altitude = info.altitude;
			dbg += Lang.format("altitude: $1$", [altitude]);
		}
		
		if (info has :currentSpeed)
		{
			// m/s => km/h 
			speed = info.currentSpeed * 3.6; 
			dbg += Lang.format(", speed: $1$", [speed]);
		}
		
		if (info has :currentHeading)
		{
			// radians => degrees 
			heading = info.currentHeading / Math.PI * 180; 
			dbg += Lang.format(", heading: $1$", [heading]);
		}
		
		if (info has :elapsedDistance)
		{ 
			distance = info.elapsedDistance; 
			dbg += Lang.format(", distance: $1$", [distance]);
		}
		
    	System.println("AnalogClock.draw() info: [" + dbg + "]");
		
    	if (!(settings.requiresBurnInProtection and lowpower))
    	{
			speedGauge.onUpdate(dc,speed);
			distanceGauge.onUpdate(dc,distance);
			compassGauge.onUpdate(dc,heading);
			altitudeGauge.onUpdate(dc,altitude);
			
			drawTickMarks(dc,  0, 60, 60, 2,  7, theme.DefaultDimmed);
			drawTickMarks(dc,  0, 12, 12, 4, 12, theme.AccentBright);
			drawNumbers(dc,Graphics.FONT_MEDIUM,t.DefaultBright);
		}
				
		var minutesAngle = 2 * Math.PI * minutes / 60.0;
		var hoursAngle = 2 * Math.PI * hours / 12.0 + minutesAngle/12.0;
		
		drawHoursHand(dc,hoursAngle,t.DefaultBright);
		drawMinutesHand(dc,minutesAngle,t.DefaultBright);
    }
    
    function onPartialUpdate(dc)
    {
    	System.println("AnalogClock.onPartialUpdate()");
		time = System.getClockTime();
		drawSecondsHand(dc);
	}
	
	function drawSecondsHand(dc)
	{
		var clip = secondsHand.getClip();
		if (clip != null)
		{
			dc.setClip(clip[0],clip[1],clip[2],clip[3]);
			dc.drawBitmap(0,0,buffer);
		}

		var topSeconds = new Shapes.Position(position.getX(),position.getY()*0.2);
    	var bottomSeconds = new Shapes.Position(position.getX(),position.getY()+15);
		secondsHand = new Shapes.Line(bottomSeconds,topSeconds,theme.AccentBright,3);
		secondsHand.rotate(width/2,width/2,Math.PI/30 * time.sec);
		
		clip = secondsHand.getClip();
		dc.setClip(clip[0],clip[1],clip[2],clip[3]);
		secondsHand.draw(dc);
		
		var x = position.getX();
		var y = position.getY();
		
		dc.setClip(width/2-10,width/2-10,20,20);
    	dc.setPenWidth(3);
    	dc.setColor(theme.AccentBright, Graphics.COLOR_TRANSPARENT);
		dc.drawCircle(x,y,5);
    	dc.setPenWidth(1);
    	dc.setColor(theme.Background, Graphics.COLOR_TRANSPARENT);
		dc.fillCircle(x,y,4);		
    }
 }
