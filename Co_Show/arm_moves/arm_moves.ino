#include "robot.h"
#include <PRIZM_PRO.h>

PRIZM prizm;

void setup() {
  prizm.PrizmBegin();

  arm_home(0);   // 팔 모터 1, 2 원점 복귀
}

void loop() {
  // 순차 이동 (한 모터씩)
  arm_move(1, 12500, 160);       // 1번 모터를 45도 위치로 80 RPM으로 이동합니다.
  delay(1000);
  arm_move(2, -12500, 140);       // 2번 모터를 -45도의 위치로 70 RPM으로 이동합니다.
  delay(1000);

  arm_move(1, 0, 160);           // 1번 모터를 원점 위치로 80 RPM으로 이동합니다.
  delay(1000);
  arm_move(2, 0, 140);           // 2번 모터를 원점 위치로 70 RPM으로 이동합니다.
  delay(1000);

  // 동시 이동 (모터 1, 2를 같이 움직임)
  arm_moves(12500, 160, -12500, 140);  // 둘 다 동시에 45, -45 위치로 이동
  delay(1000);
  arm_moves(0, 160, 0, 140);          // 둘 다 동시에 원점 위치로 복귀
  delay(1000);
}
