#include "robot.h"
#include <PRIZM_PRO.h>

PRIZM prizm;
////////////////////////////////////////////////////////////////////////////////////////////
// Change only these values, then upload.
// Positive/negative direction follows the existing motor direction.
const float AXIS1_TARGET_DEG = 45.0f;
const int32_t AXIS1_SPEED = 10;

const float AXIS2_TARGET_DEG = -45.0f;
const int32_t AXIS2_SPEED = 20;
const bool RUN_ARM_HOME_FIRST = true;
////////////////////////////////////////////////////////////////////////////////////////////
// Existing examples use 12500 counts as about 45 degrees.
const float COUNTS_PER_DEGREE = 12500.0f / 45.0f;

int32_t angleToCounts(float degrees) {
  return (int32_t)(degrees >= 0.0f
                   ? degrees * COUNTS_PER_DEGREE + 0.5f
                   : degrees * COUNTS_PER_DEGREE - 0.5f);
}

void setup() {
  Serial.begin(115200);
  prizm.PrizmBegin();

  Serial.println(F("Arm angle-only sketch start."));

  if (RUN_ARM_HOME_FIRST) {
    Serial.println(F("Arm homing start."));
    arm_home(0);
    Serial.println(F("Arm homing complete."));
    delay(1000);
  } else {
    Serial.println(F("Arm homing skipped. Setting position mode only."));
    Set_Mode(1, robowell::AServoMode::Position);
    Set_Mode(2, robowell::AServoMode::Position);
  }

  int32_t axis1Position = angleToCounts(AXIS1_TARGET_DEG);
  int32_t axis2Position = angleToCounts(AXIS2_TARGET_DEG);

  Serial.print(F("Axis 1 target deg/counts: "));
  Serial.print(AXIS1_TARGET_DEG);
  Serial.print(F(" / "));
  Serial.println(axis1Position);

  Serial.print(F("Axis 2 target deg/counts: "));
  Serial.print(AXIS2_TARGET_DEG);
  Serial.print(F(" / "));
  Serial.println(axis2Position);

  Serial.println(F("Sending arm move command."));
  bool axis1Started = drive[0].MoveAbs(axis1Position, AXIS1_SPEED);
  bool axis2Started = drive[1].MoveAbs(axis2Position, AXIS2_SPEED);

  Serial.print(F("Move command result axis1/axis2: "));
  Serial.print(axis1Started ? F("OK") : F("FAIL"));
  Serial.print(F(" / "));
  Serial.println(axis2Started ? F("OK") : F("FAIL"));

  if (!axis1Started || !axis2Started) {
    Serial.println(F("Arm move command failed. Check CAN communication and drive power."));
    return;
  }

  while (!arm_moves_update()) {
    delay(1);
  }

  Serial.println(F("Arm angle move complete."));
}

void loop() {
}
