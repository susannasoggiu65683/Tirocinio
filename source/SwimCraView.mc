import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Sensor;
import Toybox.SensorHistory;
import Toybox.System;
import Toybox.Timer;
import Toybox.Activity;
import Toybox.ActivityRecording;
import Toybox.FitContributor;

using Toybox.Application.Storage;

class SwimCraView extends WatchUi.View { // prima watchui.WatchFace
    private var _message as String = "Press menu or\nselect button";
	var heartRateField = null;
    var avgHeartRate = 0;
    var count = 0;

    // Store the iterator info in a variable. The options are 'null' in
    // this case so the entire available history is returned with the
    // newest samples returned first.
    var sensorIter = getIterator();

    const HR_FIELD_ID = 0;

	var hrData;

    function initialize() {
        //WatchFace.initialize();
        WatchUi.View.initialize();
        Sensor.setEnabledSensors( [Sensor.SENSOR_HEARTRATE, Sensor.SENSOR_TEMPERATURE] );
    	Sensor.enableSensorEvents( method( :onSensor ) );

        /**
        // Create the custom FIT data field we want to record.
        heartRateField = WatchUi.SimpleDataField.createField(
            "average_heart_rate",
            HR_FIELD_ID,
            FitContributor.DATA_TYPE_UINT8,
            {:mesgType=>FitContributor.MESG_TYPE_RECORD, :units=>"B"}
        ) as FitContributor.Field;

        heartRateField.setData(0);
        */
    }
    
    function onSensor(sensorInfo as Sensor.Info) as Void {
        
    	hrData = sensorInfo.heartRate;
        // Print out the next entry in the iterator
        if (sensorIter != null) {
            System.println("Elevation: " + sensorIter.next().data);
        }
        System.println("Magnetometer: " + sensorInfo.mag);
        System.println("Pressure: " + sensorInfo.pressure);
        System.println("Altitude: " + sensorInfo.altitude);
        System.println("Accelerometer: " + sensorInfo.accel);
        count = count + 1;
        System.println(count);
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
        
        /**
    	var infoString = "" + hrData;
    	var view = View.findDrawableById("TimeLabel") as Text;
        view.setText(infoString);

        //avgHeartRate = Toybox.SensorHistory.getHeartRateHistory();
        avgHeartRate+=2;
        heartRateField.setData(avgHeartRate);

		//Storage.setValue("battito", hrData);
        //System.println("Storage heart rate: " + Storage.getValue("battito"));

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        */
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_MEDIUM, _message, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }


    //! Show the result or status of the web request
    //! @param args Data from the web request, or error message
    public function onReceive(args as Dictionary or String or Null) as Void {
        if (args instanceof String) {
            _message = args;
        } else if (args instanceof Dictionary) {
            // Print the arguments duplicated and returned by jsonplaceholder.typicode.com
            var keys = args.keys();
            _message = "";
            for (var i = 0; i < keys.size(); i++) {
                _message += Lang.format("$1$: $2$\n", [keys[i], args[keys[i]]]);
            }
        }
        WatchUi.requestUpdate();
    }

    // Create a method to get the SensorHistoryIterator object
    function getIterator() {
        // Check device for SensorHistory compatibility
        if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getElevationHistory)) {
            return Toybox.SensorHistory.getElevationHistory({});
        }
        return null;
    }

}
