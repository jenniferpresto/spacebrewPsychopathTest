int softpotPin = A1;
int softpotValue = 0;

int pressurePin = A2;
int pressureValue = 0;

void setup() {
  Serial.begin(9600);
}

void loop() {
  Serial.print(analogRead(softpotPin));
  Serial.print(',');
  Serial.println(analogRead(pressurePin));
  delay(200);
}
