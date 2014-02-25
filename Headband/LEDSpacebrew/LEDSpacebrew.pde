import spacebrew.*;
import processing.serial.*;

Serial port;
Spacebrew spacebrewConnection;

String server="sandbox.spacebrew.cc";
String name="Brainulator";
String description = "It sees into your very soul.";

float speed;
float pressure;

int bright = 0; // the value of the photocell we will send over spacebrew
int r = 0;
int b = 0;
int tb = 500;

void setup() {
  size(400, 200);

  spacebrewConnection = new Spacebrew( this );
  JSONObject brainWaves = new JSONObject();

  // add each thing you publish to
  spacebrewConnection.addSubscribe( "Brainulator", "brainWaves" );

  // connect!
  spacebrewConnection.connect(server, name, description );
  port = new Serial(this, "/dev/tty.usbserial-A6008e4J", 9600); // make sure port number is correct
  port.bufferUntil('\n');
}

void draw() {
  // nothing to do here...
}

void onRangeMessage( String name, int value ) {
  println("[onRangeMessage] got range message: " + value);
  int new_bright = int(map(value, 0, 1023, 0, 255));

  // update the text on the window
  background(255);
  textAlign(CENTER);
  textSize(60);
  text(value, width/2, height/2 + 20);

  // if value has changed enough then update bar
  if (new_bright != bright) {
    bright = new_bright;
    // send message to arduino
    port.write(bright);
  }
}

void onCustomMessage(String name, String type, String value) {
  if (type.equals("brainWaves")) {
    //parse JSON!
    JSONObject m = JSONObject.parse(value);
    speed = m.getInt("speed");
    pressure = m.getInt("pressure");

    int rVal = int(map(pressure, 0, 1023, 0, 255));
    int bVal = int(map(pressure, 0, 1023, 255, 0));

    // if value has changed enough then update bar
    if (rVal != r || bVal != b || speed!=tb) {
      if(rVal != r){
        r = rVal;
      }
      if(bVal != b){
        b = bVal;
      }
      // send message to arduino
      port.write(r + "," + b + "," + tb);
    }
  }
}

