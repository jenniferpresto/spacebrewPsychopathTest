int sensorPin = A0;
int sensorValue = 0;

void setup() {
  digitalWrite(sensorPin, HIGH);
  Serial.begin(9600);
}

void loop() {
  int softpotReading = analogRead(sensorPin);
  Serial.println(softpotReading);
  delay(250);
}
