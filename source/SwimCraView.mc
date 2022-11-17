import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Sensor;
import Toybox.System;
import Toybox.Timer;
import Toybox.Activity;
import Toybox.ActivityRecording;
import Toybox.FitContributor;


using Toybox.Application.Storage;

class SwimCraView extends WatchUi.WatchFace {
	var bananasEarnedField = null;
    var totalBananas = 0.0;

    const CALORIES_PER_BANANA = 105.0;
    const BANANAS_FIELD_ID = 0;

	var hrData;

    function initialize() {
        WatchFace.initialize();
        Sensor.setEnabledSensors( [Sensor.SENSOR_HEARTRATE, Sensor.SENSOR_TEMPERATURE] );
    	Sensor.enableSensorEvents( method( :onSensor ) );

        
        // Create the custom FIT data field we want to record.
        bananasEarnedField = WatchUi.SimpleDataField.createField(
            "bananas_earned",
            BANANAS_FIELD_ID,
            FitContributor.DATA_TYPE_FLOAT,
            {:mesgType=>FitContributor.MESG_TYPE_RECORD, :units=>"B"}
        ) as FitContributor.Field;

        bananasEarnedField.setData(0.0);
    }
    
    function onSensor(sensorInfo as Sensor.Info) as Void {
    
    	hrData = sensorInfo.heartRate;
        /**+
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
        */
    	WatchUi.requestUpdate();
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
    	var infoString = "" + hrData;
    	var view = View.findDrawableById("TimeLabel") as Text;
        view.setText(infoString);
        
		/*
		var heartRateAverage = Sensor.Info.heartRate;
		var heartRate = 0; // valore iniziale
        var heartRateActivity = Activity.Info.currentHeartRate;
        Storage.setValue("battito", heartRateAverage);
        System.println("Storage heart rate: " + Storage.getValue("battito"));
        
        System.println("HR avg: " + heartRateAverage);
        System.println("HR activity: " + heartRateActivity);

*/
		Storage.setValue("battito", hrData);
        System.println("Storage heart rate: " + Storage.getValue("battito"));
        System.println(totalBananas);

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }



    function compute(info) {
        if (info != null && info.calories != null) {
            // Calculate and set data to be written to the Field
            totalBananas = (info.calories / CALORIES_PER_BANANA).toFloat();
            bananasEarnedField.setData(totalBananas);
        }
        // Display the data on the screen of the device
        return totalBananas;
    }

}
