#include "robot.h"
#include <PRIZM_PRO.h>

PRIZM prizm;

void setup() {
  prizm.PrizmBegin();

  // arm_home(0);  // 모터 1, 2 모두 원점 복귀 (기본값)
  // arm_home(1);  // 모터 1만 원점 복귀
  // arm_home(2);  // 모터 2만 원점 복귀
  arm_home(0);
}

void loop() {
}
