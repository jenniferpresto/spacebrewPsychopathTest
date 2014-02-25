import spacebrew.*;
import processing.serial.*; 

String server = "sandbox.spacebrew.cc";
String name = "Print!";
String description = "receipt printer";

int petting;
int pressure;

Spacebrew sb;     // Spacebrew connection object
Serial myPort; // Serial port object 

void setup() {
  size(100, 100);
  background(255);

  // instantiate the spacebrew object
  sb = new Spacebrew( this );

  // add each thing you subscribe 
  sb.addSubscribe("infromation", "brainwaves");

  // connect to spacebrew
  sb.connect(server, name, description );

  //conect to arduino
  println(Serial.list()); 
  myPort = new Serial(this, Serial.list()[4], 9600); 
  myPort.bufferUntil('\n');
}

void draw() {
  //  if(mouseX>0){
  //    myPort.write('S');
  //    background(0);
  //  }
}

void onCustomMessage( String name, String type, String value ) {
  if ( type.equals("brainwaves") ) {
    // parse JSON!

    JSONObject m = JSONObject.parse( value );
    //    remotePoint.set( m.getInt("x"), m.getInt("y"));
    petting = m.getInt("petting");
    pressure = m.getInt("pressure");
    println(petting);
    //    myPort.write(petting +"," + pressure);
    myPort.write(petting);
  }
}

