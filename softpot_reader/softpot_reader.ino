/************
Arduino inputs for Crazy Test:

Attach membrane potentiometer to analog input A1,
and pressure resistor to analog input A2. I also used
a 10K resistor with the pressure resistor (but not
the membrane potentiometer).

Spacebrew, Parsons MFA-DT
February 25, 2014

Susan Lin, Anthony Marefat, Jennifer Presto

**************/

int softpotPin = A1;
int softpotValue = 0;

int pressurePin = A2;
int pressureValue = 0;

void setup() {
  Serial.begin(9600);
}

void loop() {
  // We send the information in one line, with each
  // piece separated by a comma.
  // We'll parse this on the Processing side.
  Serial.print(analogRead(softpotPin));
  Serial.print(',');
  Serial.println(analogRead(pressurePin));
  delay(200);
}
