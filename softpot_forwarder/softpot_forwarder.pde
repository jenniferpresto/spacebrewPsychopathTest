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

int petCounter = 0;
int petTimer = 0; // amount of time (in millis) each pet takes
int petRate = 0; // number of pets per 10-second period
int petStartTime = 0;
boolean petStart = false;
boolean petHalf = false;

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

  // set text alignment and font size
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
    if (petTimer != 0) {
      petRate = 10000/petTimer;
    } else {
      petRate = 0;
    }

    // print current value value to screen
    text("Info from potentiometer0: " + sensorIn[0], width/2, height/2 - 40 );  
    text("Info from pressure sensor: " + sensorIn[1], width/2, height/2);
    text("Num of pets every 10 seconds: " + petRate, width/2, height/2 + 40);
  }
  else {
    text("Not Connected to Spacebrew", width/2, 25 );
  }

  if (sensorIn[1] != 0) {
    countPetting();
  }

  if (sb.connected() && sensorIn[1] != 0) {
    sensorInfo.setInt("petting", petRate);
    sensorInfo.setInt("pressure", sensorIn[1]);

    sb.send("sensorinfo", "brainwaves", sensorInfo.toString());
  }
}

// when receive messages from Arduino
void serialEvent (Serial myPort) {
  // read ASCII string
  String inString = myPort.readStringUntil('\n');
  //  println(inString); // take a look at everything that comes in from Arduino
  if (inString != null) {
    // take care of whitespace
    inString = trim(inString);
    int sensors[] = int(split(inString, ','));

    // save the information to Processing global variables
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
    petCounter++;
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

