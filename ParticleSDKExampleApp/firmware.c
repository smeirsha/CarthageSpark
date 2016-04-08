//
//  firmware.c
//  ParticleSDKExampleApp-Carthage
//
//  Created by Ido Kleinman on 4/8/16.
//  Copyright © 2016 Particle. All rights reserved.
//
//  This is the firmware that is programmed to the test Photon for this example app to function
//
int LED = D7;
int testVariable=64;

int testFunction(String command) {
    for (int i=0;i<5;i++) {
        digitalWrite(D7, HIGH);
        delay(100);
        digitalWrite(D7, LOW);
        delay(100);
    }
    Particle.publish("test-func-called");
}

void setup() {
    pinMode(D7, OUTPUT);
    Particle.function("testFunc",testFunction);
    Particle.variable("testVar", &testVariable, INT);
    
}

void loop() {
    digitalWrite(D7, HIGH);
    delay(1000);
    digitalWrite(D7, LOW);
    delay(1000);
    Particle.publish("test-event");
}
