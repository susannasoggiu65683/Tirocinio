import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Communications;
import Toybox.Sensor;
import Toybox.SensorHistory;
import Toybox.System;
import Toybox.Application.Storage;

class SwimCraDelegate extends WatchUi.BehaviorDelegate {
    private var _notify as Method(args as Dictionary or String or Null) as Void;
    private var sensorSample as SwimCraProcess;

    // Store the iterator info in a variable. The options are 'null' in
    // this case so the entire available history is returned with the
    // newest samples returned first.
    var sensorIter = getIterator();

    //! Set up the callback to the view
    //! @param handler Callback method for when data is received 
    public function initialize(handler as Method(args as Dictionary or String or Null) as Void) {
        Storage.setValue("id", 0);
        WatchUi.BehaviorDelegate.initialize();
        sensorSample = new $.SwimCraProcess();
        _notify = handler;
        sensorSample.onStart();
        //sensorsCounter.onStop();
    }

    function onMenu() as Boolean {
        makeRequest();
        System.println(responseCode.toString()+"\n"); // debug console
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
        Storage.setValue("id", Storage.getValue("id"+1));
        var _x;
        var _y;
        var _z;
        var myDict ={};
        var options = {
            :method => Communications.HTTP_REQUEST_METHOD_POST,
            :headers => {
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON
            
            },
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_TEXT_PLAIN
            
        };
        
        _x = sensorSample.getAccelX();
        _y = sensorSample.getAccelX();
        _z = sensorSample.getAccelX();

        for (var i = 0; i < _x.size(); ++i) {
            myDict.put("id", Storage.getValue("id"));
            myDict.put("Accelx", _x[i]);
            myDict.put("Accely", _y[i]);
            myDict.put("Accelz", _z[i]);
            myDict.put("Elevation", sensorIter.next().data);
            myDict.put("Pressure", Sensor.Info.pressure);
            myDict.put("Temperature", Sensor.Info.temperature);
            /**

            var payload = [];
            payload.add([ "ClickType", "SerialNumber", "Time" ]);
            payload.add([ "button1", "455664445671", 0 ]);

            params.put("payload", payload);
            myDict = {
                "Accelx" => _x[i], //usare put
                "Accely" => _y[i],
                "Accelz" => _z[i],
                "Elevation" => sensorIter.next().data,
                "Pressure" => Sensor.Info.pressure, // correggere
                "Temperature" => Sensor.Info.temperature, // correggere
                
                //"Array test" => [1,2,3] // bisogna fixare gli array
            };
            */
            //ngrok http http://localhost:5000
            System.println(myDict);
            Communications.makeWebRequest(
            "https://d6d0-84-220-103-210.ngrok-free.app", // cambia
            myDict, // data
            options,
            method(:onReceive) //responseCallback
            );
        }
        

        



        /**
        for (var i = 0; i < _x.size(); ++i) {
            cur_acc_x = _x[i];
            cur_acc_y = _y[i];
            cur_acc_z = _z[i];
        }
        */

       

        
        //clearValues();
    }

    //! Receive the data from the web request
    //! @param responseCode The server response code
    //! @param data Content from a successful request
    public function onReceive(responseCode as Number, data as Dictionary?) as Void {
        if (responseCode == 200) {
            _notify.invoke(data);
            System.println(data);
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

    function onStop(){
        sensorSample.onStop();
    }
    
    
}