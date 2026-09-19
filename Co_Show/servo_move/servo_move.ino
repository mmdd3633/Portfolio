#include <PRIZM_PRO.h>
PRIZM prizm;

void setup() {

  prizm.PrizmBegin();
  prizm.setServoSpeed(1, 25);
}

void loop() {
  prizm.setServoPosition(1, 180); // 300도
  delay(3000);
  prizm.setServoPosition(1, 90); // 150도
  delay(3000);
  prizm.setServoPosition(1, 0);  // 0도
  delay(3000);
}
