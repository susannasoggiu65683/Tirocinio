import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Sensor;
import Toybox.System;
import Toybox.Timer;
import Toybox.Timer;
import Toybox.WatchUi;

class sensorsTestView extends WatchUi.View {
	
	var hrData;

    function initialize() {
        View.initialize();
        //Sensor.setEnabledSensors( [Sensor.SENSOR_HEARTRATE, Sensor.SENSOR_TEMPERATURE] );
    	Sensor.enableSensorEvents( method( :onSensor ) );
    }
    
    function onSensor(sensorInfo as Sensor.Info) as Void {
    	hrData = sensorInfo.heartRate;
    	System.println( "Accelerometro: " + sensorInfo.accel);
    	//System.println( "Altitudine: " + sensorInfo.altitude);
    	System.println( "Cadenza: " + sensorInfo.cadence);
    	//System.println( "Nord: " + sensorInfo.heading);
    	System.println( "Heart Rate: " + hrData);
    	System.println( "Magnetometro: " + sensorInfo.mag);
    	//System.println( "Saturazione: " + sensorInfo.oxygenSaturation);
    	System.println( "Potenza: " + sensorInfo.power);
    	System.println( "Pressione: " + sensorInfo.pressure);
    	System.println( "Temperatura: " + sensorInfo.temperature);

    	WatchUi.requestUpdate();
	}
	
	    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
    	var infoString = hrData;
    	var view = View.findDrawableById("TimeLabel") as Text;
        //view.setText(infoString);
		

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

}
