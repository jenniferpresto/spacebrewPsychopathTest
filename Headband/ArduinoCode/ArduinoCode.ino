#include "LPD8806.h"
#include "SPI.h"

// Number of RGB LEDs in strand:
int nLEDs = 32;

// Chose 2 pins for output; can be any valid output pins:
int dataPin = 4;
int clockPin = 5;
boolean go = false;

int i = 0; //For our cycling loop
int j = 0; //For our fading intro
int fade=5;
unsigned long lastTime=0;
unsigned long timeBetween = 500;
unsigned long lastRec=0;
unsigned long abortTime=2000;

// First parameter is the number of LEDs in the strand.
// Next two parameters are SPI data and clock pins:
LPD8806 strip = LPD8806(nLEDs, dataPin, clockPin);

uint32_t curColor;
uint32_t noColor;
void setup() {
  // Start up the LED strip
  strip.begin();
  Serial.begin(9600);

  curColor = strip.Color(0, 255, 0); // set to blue
  noColor = strip.Color(0, 0, 0); // set to off

  // Update strip to 'off'
  for (int i = 0; i < nLEDs; i++) {
    strip.setPixelColor(i, noColor);
  }
  strip.show();
}
void loop() {

  if(!go){

    curColor=strip.Color(0,j,0);  
    for (int i = 0; i < nLEDs; i++) {
      strip.setPixelColor(i, curColor);
    } 
    strip.show(); 
    j += fade;
    // reverse the direction of the fading at the ends of the fade: 
    if (j == 0 || j == 100) {
      fade*=-1 ;

    }   
    delay(30);  
  } 
  else if(go){
    if(millis()>=timeBetween+lastTime){
      Serial.println(i);
      strip.setPixelColor(i, noColor);
      i++;
      lastTime=millis();
      if(i>=nLEDs){
        i=0;
      }
      strip.setPixelColor(i, curColor);
      strip.show();
    }
    if(millis()>lastRec+abortTime){
      go=false;
      setup(); 
    }
  }

  if (Serial.available()) {
    go=true;
    lastRec=millis();
    int r = Serial.parseInt();
    int b = Serial.parseInt();
    int tb = Serial.parseInt();
    setLEDBar(r, b, tb);
  }
}
// Fill the dots progressively along the strip.
void setLEDBar(int _r, int _b, int tb) {
  curColor = strip.Color(_r,0,_b);
  timeBetween = tb;
}

