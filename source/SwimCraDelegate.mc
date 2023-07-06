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
    var temperatureData;
    var pressureData;
    var elevationData;
    var _x;
    var _y;
    var _z;

    // Store the iterator info in a variable. The options are 'null' in
    // this case so the entire available history is returned with the
    // newest samples returned first.
    var sensorIter = getIterator();

    //! Set up the callback to the view
    //! @param handler Callback method for when data is received 
    public function initialize(handler as Method(args as Dictionary or String or Null) as Void) {
        Sensor.setEnabledSensors( [Sensor.SENSOR_TEMPERATURE] );
        Sensor.enableSensorEvents( method( :onSensor ) );
        Storage.setValue("id", 0);
        WatchUi.BehaviorDelegate.initialize();
        sensorSample = new $.SwimCraProcess();
        _notify = handler;
        
        sensorSample.onStart();
        _x = sensorSample.getAccelX();
        _y = sensorSample.getAccelY();
        _z = sensorSample.getAccelZ();
    }

    function onSensor(sensorInfo as Sensor.Info) as Void {
        _x.addAll(sensorSample.getAccelX());
        _y.addAll(sensorSample.getAccelY());
        _z.addAll(sensorSample.getAccelZ());
    	temperatureData = sensorInfo.temperature;
        pressureData = sensorInfo.pressure;
        elevationData = sensorInfo.altitude;

        // Print out the next entry in the iterator
        if (sensorIter != null) {
            //System.println("Elevation: " + sensorIter.next().data);
        }
	}

    function onMenu() as Boolean {
        if(connessione a posto){
            makeRequest();
        } else {
            _notify.invoke("Connect your device");
        }
        
        //System.println(responseCode.toString()+"\n"); // debug console
        //WatchUi.pushView(new Rez.Menus.MainMenu(), new SwimCraMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

     //! On a select event, make a web request
    //! @return true if handled, false otherwise
    public function onSelect() as Boolean {
        sensorSample.onStop();
        return true;
    }

    //! Make the web request
    private function makeRequest() as Void {
        _notify.invoke("Executing\nRequest");
        Storage.setValue("id", Storage.getValue("id"+1));
        //var di tempo per regolare la comunicazione e il corretto invio dei dati
        
        
        var myDict ={};
        var options = {
            :method => Communications.HTTP_REQUEST_METHOD_POST,
            :headers => {
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON
            
            },
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_TEXT_PLAIN
            
        };
        
        
        
        

        for (var i = 0; i < _x.size(); ++i) {
            myDict.put("id", Storage.getValue("id"));
            myDict.put("Accelx", _x[i]);
            System.println(_x[i]);
            myDict.put("Accely", _y[i]);
            myDict.put("Accelz", _z[i]);
            myDict.put("Elevation", elevationData);
            myDict.put("Pressure", pressureData);
            myDict.put("Temperature", temperatureData);
            /**

            var payload = [];
            payload.add([ "ClickType", "SerialNumber", "Time" ]);
            payload.add([ "button1", "455664445671", 0 ]);

            params.put("payload", payload);
            */
            //ngrok http http://localhost:5000
            //System.println(myDict);
            Communications.makeWebRequest(
            "https://6baa-62-11-225-72.ngrok-free.app", // cambia
            myDict, // data
            options,
            method(:onReceive) //responseCallback
            );
        }
        
    }

    //! Receive the data from the web request
    //! @param responseCode The server response code
    //! @param data Content from a successful request
    public function onReceive(responseCode as Number, data as Dictionary?) as Void {
        if (responseCode == 200) {
            _notify.invoke(data);
        } else if(responseCode == -101){
            _notify.invoke("Too many requests\nerror -101");
        } else if(responseCode == -400){
            _notify.invoke("Invalid response\nerror -400");
        } else if(responseCode == -1001){
            _notify.invoke("HTTP connection required\nerror -1001");
        } else if(responseCode == 404){
            _notify.invoke("Not found!\nerror 404");
        } else {
            _notify.invoke("Error: " + responseCode.toString());
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
        
    }
    
    
}