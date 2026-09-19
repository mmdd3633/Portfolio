#include "robot.h"
#include <PRIZM_PRO.h>

PRIZM prizm;

void setup() {
  prizm.PrizmBegin();
  z_homing();
}

void loop() {
}

