#include "robot.h"
#include <PRIZM_PRO.h>

PRIZM prizm;

// ================== Test parameters ==================

// Run only one full check cycle. Set false to repeat forever.
const bool RUN_ONCE = true;

// AServo absolute moves need homing first. Keep true for a full check.
const bool RUN_ARM_HOME_ON_START = true;
const unsigned long ARM_HOME_TIMEOUT_MS = 20000;
const unsigned long ARM_MOVE_TIMEOUT_MS = 15000;

// Z homing runs once during setup before the motion check.
const bool RUN_Z_HOME_ON_START = true;
const unsigned long Z_HOME_TIMEOUT_MS = 10000;

// Z stepper pulse frequency. Higher value is faster, but too high can cause missed steps.
const uint32_t Z_STEP_FREQ_HZ = 5000;

// Z homing uses the + direction in robot.cpp, so the away test uses - direction.
const int Z_AWAY_FROM_HOME_COMMAND = -1;
const unsigned long Z_AWAY_RUN_MS = 3000;
const unsigned long Z_PAUSE_MS = 1000;

// Existing arm_moves example uses 12500 as about 45 degrees.
// That is about 278 position counts per degree.
// Fold test: axis 2 folds first, then axis 1 follows.
const int32_t ARM1_FOLD_POSITION = 19400;          // about +70 deg
const int32_t ARM2_FOLD_POSITION = -33300;         // about -120 deg
const int32_t ARM1_FOLD_OPPOSITE_POSITION = -19400; // about -70 deg
const int32_t ARM2_FOLD_OPPOSITE_POSITION = 33300;  // about +120 deg
const int32_t ARM1_HOME_POSITION = 0;
const int32_t ARM2_HOME_POSITION = 0;
const int32_t ARM1_VELOCITY = 80;
const int32_t ARM2_VELOCITY = 70;
const unsigned long ARM_SETTLE_MS = 1000;

// PRIZM servo command range is 0 to 180.
// For the 300 degree servo used in the example:
// 0 = about 0 deg, 90 = about 150 deg, 180 = about 300 deg.
const uint8_t SERVO_CHANNEL = 1;
const uint8_t SERVO_SPEED = 25;
const uint8_t SERVO_POS_MIN = 0;
const uint8_t SERVO_POS_CENTER = 90;
const uint8_t SERVO_POS_MAX = 180;
const uint8_t SERVO_HOME_POSITION = SERVO_POS_CENTER;
const unsigned long SERVO_HOLD_MS = 3000;

const unsigned long CYCLE_PAUSE_MS = 2000;

bool armReadyForMoves = false;

// ================== Helper functions ==================

void runZAxisCheck();
bool runZHomeCheck();
bool runArmHomeCheck();
void runArmCheck();
void runArmFoldSequence(int32_t arm1Target, int32_t arm2Target);
bool runArmMoveCheck(int32_t position1, int32_t velocity1,
                     int32_t position2, int32_t velocity2);
void runPrizmServoCheck();
void setupPrizmServo();

void setup() {
  Serial.begin(115200);
  Serial.println("Press the green PRIZM start button if setup is waiting.");
  prizm.PrizmBegin();

  // Set before system_init() or arm_home(), because system_init() attaches Z PWM.
  FREQ = Z_STEP_FREQ_HZ;
  system_init();

  setupPrizmServo();

  if (RUN_Z_HOME_ON_START) {
    Serial.println("0) Z axis homing check");
    runZHomeCheck();
    delay(Z_PAUSE_MS);
  }

  if (RUN_ARM_HOME_ON_START) {
    Serial.println("0) Arm axis 1/2 homing check");
    armReadyForMoves = runArmHomeCheck();
  } else {
    armReadyForMoves = true;
  }

  Serial.println("Full system check ready");
  delay(1000);
}

void loop() {
  static bool ranCheck = false;

  if (RUN_ONCE && ranCheck) {
    z_stop();
    return;
  }

  Serial.println("1) Z axis away from home and back home check");
  runZAxisCheck();

  Serial.println("2) Arm axis 1/2 fold and home check");
  if (armReadyForMoves) {
    runArmCheck();
  } else {
    Serial.println("Arm check skipped because homing did not complete");
  }

  Serial.println("3) PRIZM servo away from home and back home check");
  runPrizmServoCheck();

  Serial.println("Full system check complete");
  ranCheck = true;
  delay(CYCLE_PAUSE_MS);
}

void setupPrizmServo() {
  prizm.setServoSpeed(SERVO_CHANNEL, SERVO_SPEED);
}

bool runZHomeCheck() {
  unsigned long startMs = millis();

  z_go_home_start();
  while (!z_go_home_update()) {
    if (millis() - startMs >= Z_HOME_TIMEOUT_MS) {
      z_stop();
      Serial.println("Z homing timeout");
      return false;
    }
    delay(1);
  }

  Serial.println("Z homing complete");
  return true;
}

void runZAxisCheck() {
  z_move_start(Z_AWAY_FROM_HOME_COMMAND);
  delay(Z_AWAY_RUN_MS);
  z_stop();
  delay(Z_PAUSE_MS);

  runZHomeCheck();
  delay(Z_PAUSE_MS);
}

void runArmCheck() {
  runArmFoldSequence(ARM1_FOLD_POSITION, ARM2_FOLD_POSITION);
  runArmFoldSequence(ARM1_FOLD_OPPOSITE_POSITION, ARM2_FOLD_OPPOSITE_POSITION);
}

void runArmFoldSequence(int32_t arm1Target, int32_t arm2Target) {
  // Axis 2 folds first while axis 1 stays at home.
  runArmMoveCheck(ARM1_HOME_POSITION, ARM1_VELOCITY,
                  arm2Target, ARM2_VELOCITY);
  delay(ARM_SETTLE_MS);

  // Axis 1 folds after axis 2 has cleared the front area.
  runArmMoveCheck(arm1Target, ARM1_VELOCITY,
                  arm2Target, ARM2_VELOCITY);
  delay(ARM_SETTLE_MS);

  // Return in reverse order: axis 1 home first, then axis 2 home.
  runArmMoveCheck(ARM1_HOME_POSITION, ARM1_VELOCITY,
                  arm2Target, ARM2_VELOCITY);
  delay(ARM_SETTLE_MS);

  runArmMoveCheck(ARM1_HOME_POSITION, ARM1_VELOCITY,
                  ARM2_HOME_POSITION, ARM2_VELOCITY);
  delay(ARM_SETTLE_MS);
}

bool runArmHomeCheck() {
  unsigned long startMs = millis();

  for (uint8_t i = 0; i < AServo_Number; i++) {
    Set_Mode(i + 1, robowell::AServoMode::Homing);
  }

  delay(1000);

  for (uint8_t i = 0; i < AServo_Number; i++) {
    drive[i].MoveHomming();
  }

  while (true) {
    bool allReached = true;
    for (uint8_t i = 0; i < AServo_Number; i++) {
      allReached &= drive[i].IsHommingReached();
    }

    if (allReached) {
      Serial.println("Arm homing complete");
      for (uint8_t i = 0; i < AServo_Number; i++) {
        Set_Mode(i + 1, robowell::AServoMode::Position);
      }
      return true;
    }

    if (millis() - startMs >= ARM_HOME_TIMEOUT_MS) {
      arm_moves_stop();
      Serial.println("Arm homing timeout");
      return false;
    }

    delay(1);
  }
}

bool runArmMoveCheck(int32_t position1, int32_t velocity1,
                     int32_t position2, int32_t velocity2) {
  unsigned long startMs = millis();

  arm_moves_start(position1, velocity1, position2, velocity2);
  while (!arm_moves_update()) {
    if (millis() - startMs >= ARM_MOVE_TIMEOUT_MS) {
      arm_moves_stop();
      Serial.println("Arm move timeout");
      return false;
    }
    delay(1);
  }

  Serial.println("Arm move complete");
  return true;
}

void runPrizmServoCheck() {
  setupPrizmServo();

  prizm.setServoPosition(SERVO_CHANNEL, SERVO_POS_MAX);
  delay(SERVO_HOLD_MS);

  prizm.setServoPosition(SERVO_CHANNEL, SERVO_HOME_POSITION);
  delay(SERVO_HOLD_MS);

  prizm.setServoPosition(SERVO_CHANNEL, SERVO_POS_MIN);
  delay(SERVO_HOLD_MS);

  prizm.setServoPosition(SERVO_CHANNEL, SERVO_HOME_POSITION);
  delay(SERVO_HOLD_MS);
}
