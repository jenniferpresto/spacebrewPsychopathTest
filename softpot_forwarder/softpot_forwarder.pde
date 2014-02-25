/************
 Processing program for inputs for Crazy Test:
 
 This reads the information coming from the inputs,
 translates the information into crazy-appropriate terms,
 and sends it to Spacebrew so it can be read by the
 output apps.
 
 Spacebrew, Parsons MFA-DT
 February 25, 2014
 
 Susan Lin, Anthony Marefat, Jennifer Presto
 
 **************/

// import the libraries for Spacebrew and Arduino
import spacebrew.*;
import processing.serial.*;

// variables for the Spacebrew server
String server = "sandbox.spacebrew.cc";
String name = "JGP Sensor Info";
String description = "Sends information from two sensors; app one of three";

Spacebrew sb;
Serial myPort;

JSONObject sensorInfo;

// we have two sensors, so create an array with two elements
int[] sensorIn = new int[2]; // [0] will be petting information; [1] will be pressure information

int petTimer = 0; // amount of time (in millis) each pet takes
int petRate = 0; // number of pets per 10-second period; this is what will be sent to Spacebrew
int petStartTime = 0;
boolean petStart = false;
boolean petHalf = false;

void setup() {
  size(400, 200);
  for (int i = 0; i < 2; i++) {
    sensorIn[i] = 0;
  }

  // create JSON object so we can send custom type to Spacebrew
  sensorInfo = new JSONObject();
  sensorInfo.setInt("petting", sensorIn[0]);
  sensorInfo.setInt("pressure", sensorIn[1]);

  // instantiate the spacebrew object
  sb = new Spacebrew( this );

  // add one publisher;
  // we'll be sending one packet with both pieces of information each time
  sb.addPublish( "sensorinfo", "brainwaves", sensorInfo.toString() );

  // connect to spacebrew
  sb.connect(server, name, description );

  // print list of serial devices to console
  // so can make sure using same port as Arduino
  println(Serial.list());
  myPort = new Serial(this, Serial.list()[(Serial.list().length-1)], 9600); // CONFIRM the port that your arduino is connected to
  myPort.bufferUntil('\n');

  // set text alignment and font size
  // this will be used for a very simple Processing monitor of the information
  textAlign(CENTER);
  textSize(14);
}

// draws only basic information in the app window
void draw() {
  // set background color based on pressure
  background( sensorIn[1] / 4, 0, 0 ); // grows redder as apply more pressure
  fill(255);

  if (sb.connected()) {
    // print client name to screen
    text("Connected as: " + name, width/2, 25 );

    // We only calculate petTimer and petRate if there is actually
    // pressure being applied. Therefore, if it's not being calculated --
    // or if it's actually zero -- then just zero it out
    if (petTimer != 0) {
      petRate = 10000/petTimer;
    } 
    else {
      petRate = 0;
    }

    // print current values to screen, just so we can see what's going on
    text("Info from potentiometer0: " + sensorIn[0], width/2, height/2 - 40 );  
    text("Info from pressure sensor: " + sensorIn[1], width/2, height/2);
    text("Num of pets every 10 seconds: " + petRate, width/2, height/2 + 40);
  }
  else {
    text("Not Connected to Spacebrew", width/2, 25 );
  }

  // if we're receiving pressure information -- because pressure is
  // sensorIn[1] -- then we can calculate the petting stuff
  if (sensorIn[1] != 0) {
    countPetting();
  }

  // if we're receiving pressure information, send that sucker to Spacebrew
  if (sb.connected() && sensorIn[1] != 0) {
    sensorInfo.setInt("petting", petRate);
    sensorInfo.setInt("pressure", sensorIn[1]);

    sb.send("sensorinfo", "brainwaves", sensorInfo.toString());
  }
}

// receiving messages from Arduino
void serialEvent (Serial myPort) {
  // read ASCII string
  String inString = myPort.readStringUntil('\n');
  if (inString != null) {
    // take care of whitespace
    inString = trim(inString);
    int sensors[] = int(split(inString, ','));

    // save the information to Processing global variables (the sensorIn array)
    for (int sensorNum = 0; sensorNum < sensors.length; sensorNum++) {
      //      println("Sensor " + sensorNum + ": " + sensors[sensorNum]);
      sensorIn[sensorNum] = sensors[sensorNum];
    }
  }
}

void countPetting() {
  // pet starts when pressure on one end of potentiometer
  if (sensorIn[0] < 100 && !petStart) {
    petStart = true;
    petStartTime = millis();
  }
  // pet is halfway through when reaches other end (around 600)
  if (sensorIn[0] > 450 && petStart && !petHalf) {
    petHalf = true;
  }
  // count one pet when one full lap is complete
  if (sensorIn[0] < 100 && petStart && petHalf) {
    petTimer = millis() - petStartTime;
    petStart = false;
    petHalf = false;
    println("petTimer: " + petTimer);
  }

  // but if a pet isn't complete in 5 seconds, restart
  if ((petStart || petHalf) && millis() - petStartTime > 5000) {
    petTimer = 0;
    petStart = false;
    petHalf = false;
  }
}

