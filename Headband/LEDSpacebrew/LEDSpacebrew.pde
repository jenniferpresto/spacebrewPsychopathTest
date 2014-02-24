import spacebrew.*;
import processing.serial.*;
 
Serial port;
Spacebrew spacebrewConnection;
 
String server="sandbox.spacebrew.cc";
String name="Headband";
String description = "Very description";
 
int bright = 0; // the value of the photocell we will send over spacebrew
 
void setup() {
size(400, 200);
 
spacebrewConnection = new Spacebrew( this );
 
// add each thing you publish to
spacebrewConnection.addSubscribe( "bar height", "range" );
 
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
