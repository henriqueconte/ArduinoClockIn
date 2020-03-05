#include <Servo.h>

Servo doorServo;
int servoVCC = 13;
int servoController = 10;

void setup() {
  // put your setup code here, to run once:
  doorServo.attach(servoController);
  doorServo.write(90);
  openDoor();
}

void loop() {
  // put your main code here, to run repeatedly:
  //digitalWrite(servoVCC, OUTPUT);
}

void openDoor() {
  doorServo.attach(servoController);
  doorServo.write(180);
  delay(5000);
  closeDoor();
}

void closeDoor() {
  doorServo.write(90);
  delay(1000);
  doorServo.detach();
}
