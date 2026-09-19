#include "robot.h"
#include <PRIZM_PRO.h>

PRIZM prizm;

void setup() {
  prizm.PrizmBegin();
  z_homing();  // Z축 원점 복귀 `
}

void loop() {
  delay(3000);                // 1 초 대기
  z_axle_move(-113);          // 100 mm 하강합니다
  delay(2000);
  z_axle_move(-18);
  delay(500);
  z_axle_move(-18);
  delay(500);
  z_axle_move(-18);
  delay(500);
  z_axle_move(-18);
  delay(500);
  z_axle_move(-18);
  delay(500);
  z_axle_move(-18);
  delay(500);
  z_axle_move(-18);
  delay(500);
  z_stop();
}