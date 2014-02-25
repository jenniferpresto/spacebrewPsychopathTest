#include "LPD8806.h"
#include "SPI.h"

// Number of RGB LEDs in strand:
int nLEDs = 32;

// Chose 2 pins for output; can be any valid output pins:
int dataPin = 4;
int clockPin = 5;

int i = 0;
unsigned long lastTime=0;
unsigned long timeBetween = 500;

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

  if (Serial.available()) {
    int r = Serial.parseInt();
    int b = Serial.parseInt();
    int tb = Serial.parseInt();
    setLEDBar(b, r, tb);
  }
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
  
}
// Fill the dots progressively along the strip.
void setLEDBar(byte _b, byte _r, byte tb) {
  curColor = strip.Color(_r,0,_b);
  timeBetween = tb;
}




