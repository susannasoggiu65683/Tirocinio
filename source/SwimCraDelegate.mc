import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Communications;
import Toybox.Sensor;
import Toybox.SensorHistory;
import Toybox.System;

class SwimCraDelegate extends WatchUi.BehaviorDelegate {
    private var _notify as Method(args as Dictionary or String or Null) as Void;

    // Store the iterator info in a variable. The options are 'null' in
    // this case so the entire available history is returned with the
    // newest samples returned first.
    var sensorIter = getIterator();

    //! Set up the callback to the view
    //! @param handler Callback method for when data is received 
    public function initialize(handler as Method(args as Dictionary or String or Null) as Void) {
        WatchUi.BehaviorDelegate.initialize();
        _notify = handler;
    }

    function onMenu() as Boolean {
        makeRequest();
        //WatchUi.pushView(new Rez.Menus.MainMenu(), new SwimCraMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

     //! On a select event, make a web request
    //! @return true if handled, false otherwise
    public function onSelect() as Boolean {
        makeRequest();
        return true;
    }

    //! Make the web request
    private function makeRequest() as Void {
        _notify.invoke("Executing\nRequest");
        
        var myDict = {
            "Elevation" => sensorIter.next().data
            
        };

        var options = {
            :method => Communications.HTTP_REQUEST_METHOD_POST,
            :headers => {
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED
            
            },
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_TEXT_PLAIN
            
        };

        Communications.makeWebRequest(
            "https://1e04-62-11-229-216.ngrok-free.app", // cambia
            myDict, // data
            options,
            method(:onReceive) //responseCallback
        );
        //clearValues();
    }

    //! Receive the data from the web request
    //! @param responseCode The server response code
    //! @param data Content from a successful request
    public function onReceive(responseCode as Number, data as Dictionary?) as Void {
        if (responseCode == 200) {
            _notify.invoke(data);
        } else {
            _notify.invoke("Failed to load\nError: " + responseCode.toString());
        }
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