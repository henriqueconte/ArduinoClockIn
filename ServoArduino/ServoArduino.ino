#include <Servo.h>

Servo doorServo;
byte byteRead = 0; 
int servoVCC = 13;
int servoController = 10;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  Serial.println("Lendo dados do sensor...");
  digitalWrite(servoVCC, OUTPUT);
  doorServo.attach(servoController);
  Serial.println("Inicializando porta...");
}

void loop() {
   
   if( Serial.available() > 0 ) {
      byteRead = Serial.read();
      Serial.println(byteRead);
      if( byteRead == 'A') {
        openDoor();
      }
   }
  delay(1000);
}

void openDoor() {
  Serial.println("opened");
  doorServo.write(90);
  delay(5000);
  closeDoor();
}

void closeDoor() {
  Serial.println("closed");
  doorServo.write(180);
}
