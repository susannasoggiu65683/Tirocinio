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
    var _x;
    var _y;
    var _z;
    var temperatureData;
    var pressureData;
    var elevationData;
    var recorded as Boolean;
    var pause as Boolean;
    var pressed as Boolean;
    var errorFound as Boolean;
    var myDict as Dictionary;
    var url;
    var sendSamples;

    // Store the iterator info in a variable. The options are 'null' in
    // this case so the entire available history is returned with the
    // newest samples returned first.
    var sensorIter = getIterator();

    //! Set up the callback to the view
    //! @param handler Callback method for when data is received 
    public function initialize(handler as Method(args as Dictionary or String or Null) as Void) {
        Sensor.setEnabledSensors( [Sensor.SENSOR_TEMPERATURE] );
        Sensor.enableSensorEvents( method( :onSensor ));
        Storage.setValue("id", 0);
        WatchUi.BehaviorDelegate.initialize();
        sensorSample = new $.SwimCraProcess();
        _notify = handler;
        
        _x = sensorSample.getAccelX();
        _y = sensorSample.getAccelY();
        _z = sensorSample.getAccelZ();
        temperatureData = [];
        pressureData = [];
        elevationData = [];
        recorded = false;
        Storage.setValue("select", recorded);
        pressed = false;
        errorFound = false;
        sendSamples = 200;
        myDict = {};
        //Storage.setValue("id", 0);
        sensorSample.onStart();
    }

    function onSensor(sensorInfo as Sensor.Info) as Void {
        var i;
        // about 2650 values each array
        if(System.getSystemStats().usedMemory < System.getSystemStats().totalMemory/2){
            _x.addAll(sensorSample.getAccelX());
            _y.addAll(sensorSample.getAccelY());
            _z.addAll(sensorSample.getAccelZ());
            temperatureData = temperatureData.add(sensorInfo.temperature);
            pressureData = pressureData.add(sensorInfo.pressure);
            elevationData = elevationData.add(sensorInfo.altitude);

        } else {
            if (_x.size() >= 25){
                // empty first samples every time half memory is used
                for(i=0; i < 25 ; i++){
                    _x.remove(_x[0]);
                    _y.remove(_y[0]);
                    _z.remove(_z[0]);
                }
                if(temperatureData.size() > 0){
                    temperatureData = temperatureData.remove(temperatureData[0]);
                }
                if(pressureData.size() > 0){
                    pressureData = pressureData.remove(pressureData[0]);
                }
                if(elevationData.size() > 0){
                    elevationData = elevationData.remove(elevationData[0]);
                }
                
            }
        }
    	
        

        // 200 samples to avoid too many requests error
        if(pressed && _x.size() > sendSamples) {
            //makeUrlRequest();
            myDict.put("id", Storage.getValue("id"));
            myDict.put("Accelx", _x);
            myDict.put("Accely", _y);
            myDict.put("Accelz", _z);
            myDict.put("Elevation", elevationData);
            myDict.put("Pressure", pressureData);
            myDict.put("Temperature", temperatureData);
            Storage.setValue("id", Storage.getValue("id"+1));
            
            makeRequest();
            
            if (!errorFound){
                _x = [];
                _y = [];
                _z = [];
                temperatureData = [];
                pressureData = [];
                elevationData = [];
            }
            
            
            
        }

        // Print out the next entry in the iterator
        /**
        if (sensorIter != null) {
            System.println("Elevation: " + sensorIter.next().data);
        }
        */
	}

    function onMenu() as Boolean {
        // connectionAvailable
        if(System.getDeviceSettings().phoneConnected && !pressed) {
            pressed = true;
            _notify.invoke("Sending 200 samples");
        } else if (!System.getDeviceSettings().phoneConnected && !pressed) {
            _notify.invoke("Connect your device");
        } else if (pressed) {
            pressed = false;
            _notify.invoke("Press menu button");
        }
        return true;
    }

     //! On a select event, make a web request
    //! @return true if handled, false otherwise
    public function onSelect() as Boolean {
        if(!recorded){
            sensorSample.onStop();
            recorded = true;
            Storage.setValue("select", recorded);
        }
        
        /**
        if(recording){
            sensorSample.onStop();
            recording = false;
        } else {
            sensorSample.onStart();
            recording = true;
        }
        */
        return true;
    }


    //! Make the web request
    private function makeUrlRequest() as Void {
        //url = "https://github.com/susannasoggiu65683/Tirocinio/blob/main/sito/url.txt";
        
        _notify.invoke("Executing\nRequest");
        
        var options = {
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON,
            :headers => {
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON
            }
        };

        Communications.makeWebRequest(
            "https://raw.githubusercontent.com/susannasoggiu65683/Tirocinio/main/sito/url.txt",
            {}, // data
            options,
            method(:onReceiveUrl) //responseCallback
            );
               
       
    }

    //! Receive the data from the web request
    //! @param responseCode The server response code
    //! @param data Content from a successful request
    public function onReceiveUrl(responseCode as Number, data as String) as Void {
        if (responseCode == 200) {
            url = data;
            System.println("ao" + data);
            System.println("eo" + url);
        } else if(responseCode == -101){
            _notify.invoke("Too many requests\nerror -101");
            errorFound = true;
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

    //! Make the web request
    private function makeRequest() as Void {
        _notify.invoke("Executing\nRequest");
        
        var options = {
            :method => Communications.HTTP_REQUEST_METHOD_POST,
            :headers => {
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON
            },
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_TEXT_PLAIN
            
        };

        Communications.makeWebRequest(
            //url, // it changes
            "https://13a4-84-220-196-199.ngrok-free.app",
            myDict, // data
            options,
            method(:onReceive) //responseCallback
        );
        
        
       
    }

    
    //! Receive the data from the web request
    //! @param responseCode The server response code
    //! @param data Content from a successful request
    public function onReceive(responseCode as Number, data as Dictionary?) as Void {
        if (responseCode == 200) {
            _notify.invoke(data);
            errorFound = false;
        } else if(responseCode == -101){
            _notify.invoke("Too many requests\nerror -101");
            errorFound = true;
        } else if(responseCode == -400){
            _notify.invoke("Invalid response\nerror -400");
            errorFound = true;
        } else if(responseCode == -1001){
            _notify.invoke("HTTP connection required\nerror -1001");
            errorFound = true;
        } else if(responseCode == 404){
            _notify.invoke("Not found!\nerror 404");
            errorFound = true;
        } else {
            _notify.invoke("Error: " + responseCode.toString());
            errorFound = true;
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