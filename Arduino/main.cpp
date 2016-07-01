#include <Arduino.h>
#include <Wire.h>

#include <Adafruit_MotorShield.h>
#include "utility/Adafruit_MS_PWMServoDriver.h"

const String STR_SINGLE = "single";
const String STR_DOUBLE = "double";
const String STR_INTERLEAVE = "interleave";
const String STR_MICROSTEP = "microstep";

// Create the motor shield object with the default I2C address
Adafruit_MotorShield AFMS = Adafruit_MotorShield();
// Or, create it with a different I2C address (say for stacking)
// Adafruit_MotorShield AFMS = Adafruit_MotorShield(0x61);

// Connect a stepper motor with 200 steps per revolution (1.8 degree)
// to motor port #2 (M3 and M4)
Adafruit_StepperMotor *myMotor = AFMS.getStepper(200, 2);

void setup() {
	Serial.begin(9600);           // set up Serial library at 9600 bps

	AFMS.begin();  // create with the default frequency 1.6KHz
	//AFMS.begin(1000);  // OR with a different frequency, say 1KHz

	myMotor->setSpeed(10);  // 10 rpm
}

int stringStepToIntStep(String stepType) {
	if (stepType == STR_SINGLE) {
		return SINGLE;
	} else if (stepType == STR_DOUBLE) {
		return DOUBLE;
	} else if (stepType == STR_INTERLEAVE) {
		return INTERLEAVE;
	} else if (stepType == STR_MICROSTEP) {
		return MICROSTEP;
	} else {
		Serial.println("I don't know command: " + stepType);
		return -1;
	}
}

void step(int update, int dir, const String& stepType, int steps, long time) {

	int loopAmnt = steps / update;

	int intStepType = stringStepToIntStep(stepType);
	int timePerStep = time / steps;
	for (int i = 1; i <= loopAmnt; i++) {

		for (int j = 0; j < update; j++) {
			delay(timePerStep);
			myMotor->onestep(dir, intStepType);
		}

		Serial.println(update * i);
	}


	for (int j = 0; j < steps - loopAmnt * update; j++) {
		delay(timePerStep);
		myMotor->onestep(dir, intStepType);
	}
	Serial.println(steps); // All steps done!
}

void loop() {

//Wire.setClock(400000L);


	while (!Serial.available())
		; // wait for data to arrive

	String stepType = Serial.readStringUntil('\n');
	long time = Serial.readStringUntil('\n').toInt();
	int steps = Serial.readStringUntil('\n').toInt();
	int update = Serial.readStringUntil('\n').toInt();
	int direction = Serial.readStringUntil('\n').toInt();

	Serial.println("Executing " + stepType + " " + time + " " + steps);

	long startMillis = millis();

	step(update, direction, stepType, steps, time);

	Serial.println("done");
	Serial.println(millis() - startMillis);
}
