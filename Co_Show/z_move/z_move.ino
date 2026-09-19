#include "robot.h"
#include <PRIZM_PRO.h>

PRIZM prizm;

void setup() {
  prizm.PrizmBegin();

  delay(1000);
}

void loop() { 
  z_move_start(-100);   // 아래 방향
  delay(300); 
  z_stop();
  delay(3000);
}
