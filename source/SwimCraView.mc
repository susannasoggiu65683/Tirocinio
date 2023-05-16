import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Sensor;
import Toybox.SensorHistory;
import Toybox.SensorLogging;
import Toybox.System;
import Toybox.Timer;
import Toybox.Activity;
import Toybox.ActivityRecording;
import Toybox.FitContributor;

class SwimCraView extends WatchUi.View { // prima watchui.WatchFace
    private var _message as String = "Press menu or\nselect button";
    //private var _message2 as String = ""+cazz;
    private var _labelCount as Text?;
    private var _labelSamples as Text?;
    private var _labelPeriod as Text?;
    private var _labelBestTime as Text?;
    private var sensorsCounter as SwimCraProcess;
    var sensorIter = getIterator();
	var hrData;


    

    function initialize() {
        //WatchFace.initialize();
        WatchUi.View.initialize();
        Sensor.setEnabledSensors( [Sensor.SENSOR_HEARTRATE, Sensor.SENSOR_TEMPERATURE] );
    	Sensor.enableSensorEvents( method( :onSensor ) );
        sensorsCounter = new $.SwimCraProcess();
        _labelBestTime = "pino";
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
        _labelCount = View.findDrawableById("id_pitch_count") as Text;
        _labelSamples = View.findDrawableById("id_pitch_samples") as Text;
        _labelPeriod = View.findDrawableById("id_pitch_period") as Text;
        _labelBestTime = View.findDrawableById("id_best_time") as Text;
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
        //dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2+50, Graphics.FONT_SMALL, _message2, Graphics.TEXT_JUSTIFY_CENTER);
        
        var labelCount = _labelCount;
        if (labelCount != null) {
            labelCount.setText("Accel: " + sensorsCounter.getCount());
        }
        
        var labelSamples = _labelSamples;
        if (labelSamples != null) {
            labelSamples.setText("Vasche: " + sensorsCounter.getSamples());
        }
        
        var labelPeriod = _labelPeriod;
        if (labelPeriod != null) {
            labelPeriod.setText("Tempo: " + sensorsCounter.getPeriod());
        }
        
        var labelBestTime = _labelBestTime;
        if (labelBestTime != null)
        {
            labelBestTime.setText("Migliore: " + _message);
        }
        
    
        
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
        //sensorsCounter.onStop();
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
