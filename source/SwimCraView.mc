import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Sensor;
import Toybox.SensorHistory;
import Toybox.SensorLogging;
import Toybox.System;
import Toybox.Application.Storage;
import Toybox.Activity;
import Toybox.ActivityRecording;

class SwimCraView extends WatchUi.View { // prima watchui.WatchFace
    private var _message as String = "Press menu button";
    private var _recordMessage as String = "Press select button";
    private var _labelRecord as Text?;
    private var _labelLap as Text?;
    private var _labelConnection as Text?;
    private var sensorsCounter as SwimCraProcess;
    var sensorIter = getIterator();
	var hrData;


    

    function initialize() {
        //WatchFace.initialize();
        WatchUi.View.initialize();
        Sensor.setEnabledSensors( [Sensor.SENSOR_HEARTRATE, Sensor.SENSOR_TEMPERATURE] );
    	Sensor.enableSensorEvents( method( :onSensor ) );
        sensorsCounter = new $.SwimCraProcess();
        _labelConnection = "";
    }
    
    function onSensor(sensorInfo as Sensor.Info) as Void {
        
    	hrData = sensorInfo.heartRate;
        // Print out the next entry in the iterator
        if (sensorIter != null) {
            //System.println("Elevation: " + sensorIter.next().data);
        }

        WatchUi.requestUpdate();
	}
	
	    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
        _labelRecord = View.findDrawableById("id_record") as Text;
        _labelLap = View.findDrawableById("id_lap") as Text;
        _labelConnection = View.findDrawableById("id_connection") as Text;
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        //sensorsCounter.onStart();
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_MEDIUM, _message, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        var selectPressed = Storage.getValue("select");
        var labelRecord = _labelRecord;
        if (labelRecord != null) {
            if(selectPressed){
                _recordMessage = "FIT file saved";
            } else {
                _recordMessage = "Yes";
            }
            labelRecord.setText("Recording:\n" + _recordMessage);
        }
        /**
        var labelLap = _labelLap;
        if (labelLap != null) {
            labelLap.setText("Vasche: " + sensorsCounter.getSamples());
        }
        */
        var labelConnection = _labelConnection;
        if (labelConnection != null)
        {
            labelConnection.setText("Connection:\n" + _message);
        }
        
    
        
        View.onUpdate(dc);
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
