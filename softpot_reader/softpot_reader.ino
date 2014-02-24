int softpotPin = A0;
int softpotValue = 0;

int pressurePin = A1;
int pressureValue = 0;

void setup() {
//  pinMode(softpotPin, input);
//  pinMode(pressurePin, input);
//  digitalWrite(softpotPin, HIGH);
//  digitalWrite(pressurePin, HIGH);
  Serial.begin(9600);
}

void loop() {
  int softpotReading = analogRead(softpotPin);
  int pressureReading = analogRead(pressurePin);
  Serial.print(softpotReading);
  Serial.print(',');
  Serial.println(pressureReading);
  delay(2500);
}
