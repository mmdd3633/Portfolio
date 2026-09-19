#include "robot.h"
#include <PRIZM_PRO.h>

PRIZM prizm;

////////////////////////////////////////////////////////////////////////////////////////////
// Change only these values, then upload.
// Positive/negative direction follows the existing motor direction.
const bool RUN_Z_HOME_FIRST = true;
const bool RUN_ARM_HOME_FIRST = true;

const uint32_t Z_STEP_FREQ_HZ = 5000;
const int Z_TARGET_LENGTH = -100;

const float AXIS1_TARGET_DEG = 45.0f;
const int32_t AXIS1_SPEED = 10;

const float AXIS2_TARGET_DEG = -45.0f;
const int32_t AXIS2_SPEED = 10;

const bool ARM_HOME_DOUBLE_CHECK = true;
const int32_t ARM_HOME_CHECK_POSITION = 500;
const int32_t ARM_HOME_CHECK_SPEED = 3;
const unsigned long ARM_HOME_TIMEOUT_MS = 10000;
const unsigned long ARM_HOME_CHECK_MOVE_TIMEOUT_MS = 4000;
const unsigned long Z_HOME_TIMEOUT_MS = 5000;

// PRIZM servo command range is 0 to 180.
// For the 300 degree servo: 0 = about 0 deg, 90 = about 150 deg, 180 = about 300 deg.
const uint8_t SERVO_CHANNEL = 1;
const uint8_t SERVO_SPEED = 15;
const uint8_t SERVO_TARGET_POSITION = 180;
const uint8_t SERVO_HOME_POSITION = 90;

const unsigned long MOVE_PAUSE_MS = 1000;
const unsigned long SERVO_HOLD_MS = 3000;
////////////////////////////////////////////////////////////////////////////////////////////

// Existing examples use 12500 counts as about 45 degrees.
const float COUNTS_PER_DEGREE = 12500.0f / 45.0f;

int32_t angleToCounts(float degrees) {
  return (int32_t)(degrees >= 0.0f
                   ? degrees * COUNTS_PER_DEGREE + 0.5f
                   : degrees * COUNTS_PER_DEGREE - 0.5f);
}

bool waitArmHomeReached(uint8_t motorId, unsigned long timeoutMs) {
  if (motorId < 1 || motorId > AServo_Number) return false;

  uint8_t index = motorId - 1;
  unsigned long startMs = millis();

  while (millis() - startMs < timeoutMs) {
    if (drive[index].IsHommingReached()) return true;
    delay(1);
  }

  drive[index].Stop();
  Serial.print(F("Arm homing timeout ID "));
  Serial.println(motorId);
  return false;
}

bool waitAllArmHomeReached(unsigned long timeoutMs) {
  unsigned long startMs = millis();

  while (millis() - startMs < timeoutMs) {
    bool allReached = true;
    for (uint8_t i = 0; i < AServo_Number; i++) {
      allReached &= drive[i].IsHommingReached();
    }

    if (allReached) return true;
    delay(1);
  }

  arm_moves_stop();
  Serial.println(F("Arm homing timeout ID 1/2"));
  return false;
}

bool waitArmTargetReached(uint8_t motorId, unsigned long timeoutMs) {
  if (motorId < 1 || motorId > AServo_Number) return false;

  uint8_t index = motorId - 1;
  unsigned long startMs = millis();

  while (millis() - startMs < timeoutMs) {
    if (drive[index].IsTargetReached()) return true;
    delay(1);
  }

  drive[index].Stop();
  Serial.print(F("Arm check move timeout ID "));
  Serial.println(motorId);
  return false;
}

bool safeZHome() {
  z_go_home_start();
  unsigned long startMs = millis();

  while (millis() - startMs < Z_HOME_TIMEOUT_MS) {
    if (z_go_home_update()) return true;
    delay(1);
  }

  z_stop();
  Serial.println(F("Z homing timeout"));
  return false;
}

bool safeArmHomeOne(uint8_t motorId) {
  if (motorId < 1 || motorId > AServo_Number) return false;

  uint8_t index = motorId - 1;

  if (!Set_Mode(motorId, robowell::AServoMode::Homing)) return false;
  delay(300);

  if (!drive[index].MoveHomming()) {
    Serial.print(F("MoveHomming failed ID "));
    Serial.println(motorId);
    return false;
  }

  return waitArmHomeReached(motorId, ARM_HOME_TIMEOUT_MS);
}

bool moveArmCheckPosition(uint8_t motorId, int32_t position) {
  if (motorId < 1 || motorId > AServo_Number) return false;

  uint8_t index = motorId - 1;

  if (!Set_Mode(motorId, robowell::AServoMode::Position)) return false;
  delay(200);

  if (!drive[index].MoveAbs(position, ARM_HOME_CHECK_SPEED)) {
    Serial.print(F("Arm check MoveAbs failed ID "));
    Serial.println(motorId);
    return false;
  }

  return waitArmTargetReached(motorId, ARM_HOME_CHECK_MOVE_TIMEOUT_MS);
}

bool checkArmHomeBothSides(uint8_t motorId) {
  if (!ARM_HOME_DOUBLE_CHECK || ARM_HOME_CHECK_POSITION == 0) return true;

  Serial.print(F("Arm home double check ID "));
  Serial.println(motorId);

  if (!moveArmCheckPosition(motorId, ARM_HOME_CHECK_POSITION)) return false;
  if (!safeArmHomeOne(motorId)) return false;

  if (!moveArmCheckPosition(motorId, -ARM_HOME_CHECK_POSITION)) return false;
  if (!safeArmHomeOne(motorId)) return false;

  return true;
}

bool safeArmHomeAll() {
  Serial.println(F("Safe arm homing start."));

  for (uint8_t i = 0; i < AServo_Number; i++) {
    if (!Set_Mode(i + 1, robowell::AServoMode::Homing)) return false;
  }

  delay(1000);

  for (uint8_t i = 0; i < AServo_Number; i++) {
    if (!drive[i].MoveHomming()) {
      Serial.print(F("MoveHomming failed ID "));
      Serial.println(i + 1);
      return false;
    }
  }

  if (!waitAllArmHomeReached(ARM_HOME_TIMEOUT_MS)) return false;

  for (uint8_t i = 0; i < AServo_Number; i++) {
    if (!checkArmHomeBothSides(i + 1)) return false;
  }

  for (uint8_t i = 0; i < AServo_Number; i++) {
    if (!Set_Mode(i + 1, robowell::AServoMode::Position)) return false;
  }

  Serial.println(F("Safe arm homing complete."));
  return true;
}

void setup() {
  Serial.begin(115200);
  prizm.PrizmBegin();

  FREQ = Z_STEP_FREQ_HZ;
  system_init();

  prizm.setServoSpeed(SERVO_CHANNEL, SERVO_SPEED);
  prizm.setServoPosition(SERVO_CHANNEL, SERVO_HOME_POSITION);

  if (RUN_Z_HOME_FIRST) {
    if (!safeZHome()) {
      Serial.println(F("Setup stopped: Z homing failed."));
      z_stop();
      return;
    }
    delay(MOVE_PAUSE_MS);
  }

  if (RUN_ARM_HOME_FIRST) {
    if (!safeArmHomeAll()) {
      Serial.println(F("Setup stopped: arm homing failed."));
      arm_moves_stop();
      z_stop();
      return;
    }
    delay(MOVE_PAUSE_MS);
  } else {
    Set_Mode(1, robowell::AServoMode::Position);
    Set_Mode(2, robowell::AServoMode::Position);
  }

  int32_t axis1Position = angleToCounts(AXIS1_TARGET_DEG);
  int32_t axis2Position = angleToCounts(AXIS2_TARGET_DEG);

  z_axle_move(Z_TARGET_LENGTH);
  delay(MOVE_PAUSE_MS);

  arm_moves(axis1Position, AXIS1_SPEED, axis2Position, AXIS2_SPEED);
  delay(MOVE_PAUSE_MS);

  prizm.setServoPosition(SERVO_CHANNEL, SERVO_TARGET_POSITION);
  delay(SERVO_HOLD_MS);

  prizm.setServoPosition(SERVO_CHANNEL, SERVO_HOME_POSITION);
  delay(SERVO_HOLD_MS);

  arm_moves(0, AXIS1_SPEED, 0, AXIS2_SPEED);
  delay(MOVE_PAUSE_MS);

  z_stop();
}

void loop() {
}
