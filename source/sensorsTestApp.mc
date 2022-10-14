import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.PersistedContent;
import Toybox.System;

class sensorsTestApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
        return [ new sensorsTestView(), new sensorsTestDelegate() ] as Array<Views or InputDelegates>;
    }

}

function getApp() as sensorsTestApp {
    return Application.getApp() as sensorsTestApp;
}

/**
import Toybox.PersistedContent;
import Toybox.System;

function example() as Void {}
    // Get the first waypoint from the device
    var waypoints = PersistedContent.getWaypoints();
    var waypoint = waypoints.next();

    if(waypoint != null) {
        // Launch the waypoint (User will be asked
        // what activity to launch in)
        System.exitTo(waypoint.toIntent());
    }
}*/