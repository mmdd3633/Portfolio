#include "robot.h"
#include <PRIZM_PRO.h>

PRIZM prizm;

void setup() {
  prizm.PrizmBegin();

  arm_home();   // 팔 모터 1, 2 원점 복귀
}

void loop() {
  Pogition_Move(1, 25000, 80);       // 1번 모터를 25000의 위치로 80 RPM으로 이동합니다.
  delay(1000);
  Pogition_Move(2, 25000, 70);       // 2번 모터를 25000의 위치로 70 RPM으로 이동합니다.
  delay(1000);

  Pogition_Move(1, 0, 80);           // 1번 모터를 0의 위치로 80 RPM으로 이동합니다.
  delay(1000);
  Pogition_Move(2, 0, 70);           // 2번 모터를 0의 위치로 70 RPM으로 이동합니다.
  delay(1000);
}
