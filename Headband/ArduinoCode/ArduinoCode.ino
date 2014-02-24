#include "LPD8806.h"
#include "SPI.h"

// Number of RGB LEDs in strand:
int nLEDs = 32;

// Chose 2 pins for output; can be any valid output pins:
int dataPin = 4;
int clockPin = 5;

// First parameter is the number of LEDs in the strand.
// Next two parameters are SPI data and clock pins:
LPD8806 strip = LPD8806(nLEDs, dataPin, clockPin);

uint32_t curColor;
uint32_t noColor;
void setup() {
  // Start up the LED strip
  strip.begin();
  Serial.begin(9600);

  curColor = strip.Color(0, 0, 255); // set to blue
  noColor = strip.Color(0, 0, 0); // set to off

  // Update strip to 'off'
  for (int i = 0; i < nLEDs; i++) {
    strip.setPixelColor(i, noColor);
  }
  strip.show();
}
void loop() {
  if (Serial.available()) {
    // read the most recent byte (which will be from 0 to 255):
    byte value = Serial.read();
    setLEDBar(value);
  }
}
// Fill the dots progressively along the strip.
void setLEDBar(byte value) {
  int barHeight = int(map(value, 0, 255, 0, nLEDs));

  int i;
  for (i=0; i < barHeight; i++) {
    strip.setPixelColor(i, curColor);
  }
  for (i = barHeight; i < nLEDs; i++) {
    strip.setPixelColor(i, noColor);
  }

  strip.show(); // update LED strip
}

