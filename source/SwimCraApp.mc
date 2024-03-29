import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.FitContributor;
import Toybox.Application.Storage;
import Toybox.PersistedContent;
import Toybox.ActivityRecording;
import Toybox.System;



class SwimCraApp extends Application.AppBase {
    function initialize() {
        AppBase.initialize();
        //Sensor.setEnabledSensors( [Sensor.SENSOR_HEARTRATE, Sensor.SENSOR_TEMPERATURE] );
        //Sensor.enableSensorEvents( method( :onSensor ) );
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    	//var key = "KEY"; 
        //System.println(Storage.getValue(key));
        //Storage.setValue(key, "OK");
        //ActivityRecording.createSession(); //create a session object
    	//var session = createSession();
        //onAppUpdate()
        //example();
    }
    
    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    	//example();
    }

    // Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
        var view = new $.SwimCraView();
        var delegate = new $.SwimCraDelegate(view.method(:onReceive));
        return [view, delegate] as Array<Views or InputDelegates>;
    }

}

	
	
	function example() as Void {
	    // Get the first waypoint from the device
	    var waypoints = PersistedContent.getWaypoints();
	    var waypoint = waypoints.next(); //iterator
	
	    if(waypoint != null) {
	        // Launch the waypoint (User will be asked
	        // what activity to launch in)
	        System.exitTo(waypoint.toIntent());
	    }
	}
    /**
    function createSession() {
        var session = ActivityRecording.createSession({     // set up recording session
            :name=>"Rana",                                // set session name
            //:sport=>ActivityRecording.SPORT_GENERIC,        // set sport type
            //:subSport=>ActivityRecording.SUB_SPORT_GENERIC, // set sub sport type
            :poolLength=> 50,
            //:autoLap=>{                                     // auto lap configuration
            //  :type=>:lines,                              // auto lap using entry/exit lines
                //:exit=>[loc1, loc2],                        // set exit of auto lap staging box (typically the finish line)
                //:entry=>[loc3, loc4],                       // set entrance of auto lap staging box (typically before the finish line)
                //:autoStart=>true                            // auto start using the entry/exit lines
            //}
        });
        return session;
    }
    */