import spacebrew.*;
import processing.serial.*;

String server = "sandbox.spacebrew.cc";
String name = "JGP Sensor Info";
String description = "Sends information from two sensors; app one of three";

Spacebrew sb;
Serial myPort;

JSONObject sensorInfo;

int[] serialInArray = new int[2];
int[] sensorIn = new int[2]; // [0] will be petting frequency (per 10 seconds); [1] will be pressure

void setup() {
  size(400, 200);

  for (int i = 0; i < 2; i++) {
    serialInArray[i] = 0;
    sensorIn[i] = 0;
  }

  sensorInfo = new JSONObject();
  sensorInfo.setInt("petting", sensorIn[0]);
  sensorInfo.setInt("pressure", sensorIn[1]);

  // instantiate the spacebrew object
  sb = new Spacebrew( this );

  // add each thing you publish to
  sb.addPublish( "sensorinfo", "brainwaves", sensorInfo.toString() );

  // connect to spacebrew
  sb.connect(server, name, description );

  // print list of serial devices to console
  // so can make sure using same port as Arduino
  println(Serial.list());
  myPort = new Serial(this, Serial.list()[(Serial.list().length-1)], 9600); // CONFIRM the port that your arduino is connect to
  myPort.bufferUntil('\n');
}

// draws the information in the app window
void draw() {
  background(255);
  fill(0);
  // set background color based on valueness
  // background( value / 4, value / 4, value / 4 );

  // if background is light then make text black
  // if (value < 512) { fill(225, 225, 225); }

  // otherwise make text white
  // else { fill(25, 25, 25); }

  // set text alignment and font size
  textAlign(CENTER);
  textSize(16);

  if (sb.connected()) {
    // print client name to screen
    text("Connected as: " + name, width/2, 25 );  

    // print current value value to screen
    textSize(60);
    text(sensorIn[0], width/2, height/2 );  
    text(sensorIn[1], width/2, height/2 + 50);  
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
    inString = trim(inString);
    int sensors[] = int(split(inString, ','));
    
    // save the information to Processing global variables
    for (int sensorNum = 0; sensorNum < sensors.length; sensorNum++) {
      println("Sensor " + sensorNum + ": " + sensors[sensorNum]);
      sensorIn[sensorNum] = sensors[sensorNum];
    }
  }
}
