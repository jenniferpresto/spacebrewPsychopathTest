import spacebrew.*;
import processing.serial.*;

String server = "sandbox.spacebrew.cc";
String name = "JGP Processing forwarder";
String description = "Sends information from softpot; app one of three";

Spacebrew sb;
Serial myPort;

JSONObject json;
int value = 0; // will hold arduino data

int[] serialInArray = new int[2];

void setup() {
  size(400, 200);

  json = new JSONObject();
  json.setString("name", name);
  json.setInt("value", value);

  // instantiate the spacebrew object
  sb = new Spacebrew( this );

  // add each thing you publish to
  sb.addPublish( "graph_me", "graphable", json.toString() );
  sb.addPublish ( "softpot_info", "range", 0 );

  // connect to spacebrew
  sb.connect(server, name, description );

  // print list of serial devices to console
  println(Serial.list());
  myPort = new Serial(this, Serial.list()[(Serial.list().length-1)], 9600); // CONFIRM the port that your arduino is connect to
  myPort.bufferUntil('\n');
}

// draws the information in the app window
void draw() {
  // set backgroun color based on valueness
  background( value / 4, value / 4, value / 4 );

  // if background is light then make text black
  if (value < 512) { fill(225, 225, 225); }

  // otherwise make text white
  else { fill(25, 25, 25); }

  // set text alignment and font size
  textAlign(CENTER);
  textSize(16);

  if (sb.connected()) {
    // print client name to screen
    text("Connected as: " + name, width/2, 25 );  

    // print current value value to screen
    textSize(60);
    text(value, width/2, height/2 + 20);  
  }
  else {
    text("Not Connected to Spacebrew", width/2, 25 );      
  }
}

// when receive messages from Arduino
void serialEvent (Serial myPort) {
  
  println("serial Event function called");
  // read ASCII string
  String inString = myPort.readStringUntil('\n');
  println(inString);
  if (inString != null) {
    // take care of whitespace
//    inString = trim(inString);
//    println ("Frame number: " + frameCount + "  Arduino data: " + inString);
//    println(inString);
//    int sensors[] = int(split(inString, ','));
    
//    for (int sensorNum = 0; sensorNum < sensors.length; sensorNum++) {
//      print("Sensor " + sensorNum + ": " + sensors[sensorNum] + "\t");
//    }
    
//    value = int(inString);
//    println("value" + value);
    
    sb.send( "softpot_info", value );
  }
}
