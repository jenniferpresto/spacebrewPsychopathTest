import spacebrew.*;
import processing.serial.*; 

String server = "sandbox.spacebrew.cc";
String name = "Print!";
String description = "receipt printer";

Spacebrew sb;     // Spacebrew connection object
Serial myPort; // Serial port object 

JSONObject json;  // JSON object that will hold data sent to spacebrew

void setup(){
  size(100, 100);
  background(255);
  
  // initialize json object with name and value attributes 
  json = new JSONObject();
  json.setString("name", name);
  json.setInt("value", value);
  
  // instantiate the spacebrew object
  sb = new Spacebrew( this );
  
  // add each thing you subscribe 
  sb.addPublish( "graph_me", "graphable", json.toString() );
  
  // connect to spacebrew
  sb.connect(server, name, description );
  
  //conect to arduino
  println(Serial.list()); 
  myPort = new Serial(this, Serial.list()[4], 9600); 
  myPort.bufferUntil('\n');
}

void draw(){
 if(mouseX = 0){
   port.write("G");
 }
}

void serialEvent () {

  // read data as an ASCII string:
  String inString = myPort.readStringUntil('\n');

  if (inString != null) {
    // trim off whitespace
    inString = trim(inString);
    println("Received data from Arduino: " + inString);

    // convert value from string to an integer and add to json
    value = int(inString); 
    json.setInt("value", value);

    // publish the value to spacebrew if app is connected to spacebrew
    if (sb.connected()) {
      sb.send( "graph_me", json.toString() );
    }
  }
}
