#include "robot.h"
#include <PRIZM_PRO.h>
#include <math.h>

PRIZM prizm;

// ============================================================
// 웨이퍼 이송로봇: HOME -> 1단계 -> 2단계
//
// 모든 ARM 각도는 호밍으로 설정된 0도를 기준으로 하는 절대좌표입니다.
//
// 예:
//   1단계 ARM1 = -48.1도
//   2단계 ARM1 = -51.9도
//
// 실제 이동:
//   HOME 0도 -> -48.1도 -> -51.9도
//
// -48.1도에 -51.9도를 더해 -100도가 되는 방식이 아닙니다.
//
// ARM 위치 환산 기준:
//   12500 count = 45도
//
// ARM 속도는 변환하지 않고 기존 드라이브 원시값을 그대로 사용합니다.
// ============================================================


// ------------------------------------------------------------
// 공통 설정
// ------------------------------------------------------------
const uint8_t SUB_SERVO_CHANNEL = 1;

const float SUB_MIN_DEG = 0.0f;
const float SUB_MAX_DEG = 300.0f;

// 서브모터 소프트웨어 HOME 위치
const float SUB_HOME_DEG = 0.0f;

// ARM 위치 변환 기준
const float ARM_COUNTS_PER_DEGREE = 12500.0f / 45.0f;

// ARM 실제 방향 기준
// 중요: 현재 배선에서는 drive[1], 즉 목표각 표의 두 번째 값이 실제 ARM 1입니다.
// 코드 내부에서는 혼동을 막기 위해 drive[0]/drive[1] 기준으로 출력합니다.
//
// ARM 1: 음수(-) = 목표 방향
// ARM 2: 음수(-) = 목표 방향
//
// ARM 물리 회전 한계
// 실제 구동 제한은 STAGE 2 설정부의
// DRIVE0_MIN/MAX_DEG, DRIVE1_MIN/MAX_DEG를 사용합니다.


// ------------------------------------------------------------
// Z축 HOME 후 추가 이동 설정
//
// z_go_home()은 방향핀 LOW로 홈 센서를 찾습니다.
// robot.cpp 기준:
//   양수 이동 = LOW  = 홈 방향
//   음수 이동 = HIGH = 홈 반대 방향
//
// 따라서 홈 센서에 닿은 뒤 아래쪽/센서 반대 방향으로
// 조금 더 이동하려면 음수 값을 사용합니다.
//
// 현재는 -2 unit으로 설정했습니다.
// 더 이동: -3, -4
// 덜 이동: -1
// 추가 이동 없음: 0
// ------------------------------------------------------------
const int Z_AFTER_HOME_EXTRA_UNITS = -30;
const unsigned long Z_AFTER_HOME_SETTLE_MS = 500;

// Z축 원점 센서를 찾지 못할 때 무한 이동하지 않도록 제한
const uint8_t Z_HOME_SENSOR_PIN = 9;
const unsigned long Z_HOME_TIMEOUT_MS = 15000;

// 기존 드라이브 원시 속도값
// 절대로 각도 환산값을 곱하지 않습니다.
const int32_t ARM_MOVE_SPEED_RAW = 10;


// ------------------------------------------------------------
// ARM 안전 호밍 설정
//
// 기존 arm_home(0)은 두 ARM을 동시에 시작하고,
// 센서를 찾을 때까지 제한 없이 기다립니다.
//
// 수정 방식:
//   ARM 1을 먼저 호밍
//   완료 후 ARM 2 호밍
//   제한시간, 최대 이동거리, 비정상 급가속을 감시
//
// 주의:
// 실제 Homing 탐색속도 자체는 서보 드라이브 내부 설정입니다.
// 아래 코드는 비정상적으로 빨라지거나 센서를 못 찾을 때
// 즉시 정지시키기 위한 안전장치입니다.
// ------------------------------------------------------------
const unsigned long ARM_HOME_TIMEOUT_MS = 18000;
const unsigned long ARM_HOME_MODE_SETTLE_MS = 500;
const unsigned long ARM_HOME_BETWEEN_MOTORS_MS = 1000;
const unsigned long ARM_HOME_MONITOR_INTERVAL_MS = 10;
const unsigned long ARM_HOME_PRINT_INTERVAL_MS = 500;

// 12500 count = 45도 기준
// drive[0]: 약 198도 이상 이동하면 강제 정지
// drive[1](실제 ARM1): 약 270도 이상 이동하면 강제 정지
const int32_t DRIVE0_HOME_MAX_TRAVEL_COUNT = 55000;
const int32_t DRIVE1_HOME_MAX_TRAVEL_COUNT = 75000;

// 비정상 급가속 감지 기준
// 100000 count/s는 약 360도/s입니다.
// 이 값을 넘으면 센서 오검출 또는 드라이브 이상으로 보고 정지합니다.
const int32_t ARM_HOME_MAX_SPEED_COUNT_PER_SEC = 100000;

// 통신 한 번의 튐을 실제 급가속으로 오판하지 않도록 연속 확인
const uint8_t ARM_HOME_OVERSPEED_CONFIRM_COUNT = 3;
const uint8_t ARM_HOME_CAN_FAIL_LIMIT = 10;

// 호밍 시작 직후 엔코더값이 크게 갱신되는 구간은 속도검사에서 제외
const unsigned long ARM_HOME_SPEED_CHECK_GRACE_MS = 250;


// ============================================================
// 위치 설정부
//
// 나중에 위치를 수정할 때 아래 두 블록의 값만 바꾸면 됩니다.
// 입력값은 모두 HOME 0도 기준 절대좌표입니다.
// ============================================================

// ------------------------------------------------------------
// 1단계 위치
// HOME -> 이 위치로 이동
// ------------------------------------------------------------
// 1단계는 트레이 앞 대기 자세
// 첫 번째 값은 drive[0], 두 번째 값은 drive[1](실제 ARM1)
const float STAGE1_DRIVE0_TARGET_DEG = -48.1f;
const float STAGE1_DRIVE1_ARM1_TARGET_DEG = -116.7f;
const float STAGE1_SUB_TARGET_DEG  = 68.6f;

// 서브모터 속도
const uint8_t STAGE1_SUB_SPEED = 15;

// 서브모터 최소 이동시간 및 전체 제한시간
const unsigned long STAGE1_SUB_MIN_MOVE_MS = 2200;
const unsigned long STAGE1_TIMEOUT_MS = 45000;
const unsigned long STAGE1_SETTLE_MS = 500;


// ------------------------------------------------------------
// 2단계: 실제 모터 명령값으로 직선 전진 후 복귀
//
// 아래 값들은 링크 길이와 포크 직선 조건을 이용해 미리 계산한
// ARM1, ARM2, SUB의 실제 목표각입니다.
//
// 실행 중에는 X/Y 좌표나 역기구학 계산을 사용하지 않습니다.
// 컨트롤러는 시작 목표와 최종 목표를 모터에 직접 명령합니다.
// 중간 목표값은 사용하지 않으며, 전진과 복귀 모두 연속 이동합니다.
// ------------------------------------------------------------

struct StraightMotorPose
{
  // 첫 번째 값: drive[0]에 전달되는 축
  float drive0Deg;

  // 두 번째 값: 실제 ARM 1, drive[1]에 전달되는 축
  float drive1Arm1Deg;

  // 흰색 웨이퍼 받침대 서브모터
  float subDeg;
};

// 현재 STAGE 2는 중간 목표에서 멈추지 않고
// 시작 자세에서 끝 자세까지 한 번에 연속 이동합니다.
// 따라서 실제로 사용하는 값은 시작점과 끝점 두 개뿐입니다.
const StraightMotorPose STAGE2_START_POSE =
{
  -48.1000f, -116.7000f, 68.6000f
};

const StraightMotorPose STAGE2_END_POSE =
{
  -58.6822f, -95.0000f, 78.4000f
};


// 두 CAN 드라이브의 허용범위
// drive[0]은 첫 번째 값, drive[1]은 두 번째 값(실제 ARM1)
const float DRIVE0_MIN_DEG = -90.0f;
const float DRIVE0_MAX_DEG =  90.0f;

const float DRIVE1_MIN_DEG = -120.0f;
const float DRIVE1_MAX_DEG =  120.0f;


// 두 드라이브 속도 자동 계산 범위
const int32_t ARM_SYNC_MAX_SPEED_RAW = 10;
const int32_t ARM_SYNC_MIN_SPEED_RAW = 2;

// 가장 앞으로 편 뒤 정지시간과 최종 복귀 후 안정시간
const unsigned long STRAIGHT_FRONT_HOLD_MS = 700;
const unsigned long STRAIGHT_END_SETTLE_MS = 400;

// 실제 엔코더 위치 허용 오차
const int32_t STAGE1_POSITION_TOLERANCE_COUNT = 300;
const int32_t STAGE2_END_TOLERANCE_COUNT = 100;


// ------------------------------------------------------------
// STAGE 2 연속 이동 설정
//
// drive[0]과 drive[1]의 속도는 시작각과 끝각의 변화량으로
// 실행할 때 자동 계산합니다.
//
// 서브모터:
//   68.6 software degree -> PRIZM 약 41
//   86.4 software degree -> PRIZM 약 52
// ------------------------------------------------------------
const uint8_t STAGE2_SUB_SPEED = 3;

// 서브모터는 위치 피드백이 없으므로 최소 이동시간을 확보
const unsigned long STAGE2_SUB_MIN_MOVE_MS = 5000;
const unsigned long STAGE2_CONTINUOUS_TIMEOUT_MS = 20000;


// ------------------------------------------------------------
// STAGE 2 전진 완료 후 Z축 상승 설정
//
// 동작 순서:
//   ARM 전진 완료
//   -> Z축 +5 상대이동
//   -> Z축 이동 완료 및 안정화
//   -> ARM 복귀
//
// z_axle_move()는 블로킹 함수이므로 +5 이동이 끝난 뒤
// 다음 ARM 복귀 동작으로 넘어갑니다.
// ------------------------------------------------------------
const int STAGE2_Z_LIFT_UNITS = 5;
const unsigned long STAGE2_Z_BEFORE_LIFT_MS = 300;
const unsigned long STAGE2_Z_AFTER_LIFT_SETTLE_MS = 500;


// 서브모터를 먼저 명령한 뒤 ARM 명령을 보낼 때까지의 시간
const unsigned long SUB_LEAD_TIME_MS = 50;


// ============================================================
// 유틸리티
// ============================================================

void set_status_led(uint8_t red, uint8_t green, uint8_t blue)
{
  prizm.setPixelColor(
    1,
    prizm.packPixelColor(red, green, blue)
  );
}


// ARM 목표각(deg)을 드라이브 count로 변환
int32_t arm_degree_to_count(float degree)
{
  const float rawCount =
    degree * ARM_COUNTS_PER_DEGREE;

  if (rawCount >= 0.0f)
  {
    return (int32_t)(rawCount + 0.5f);
  }

  return (int32_t)(rawCount - 0.5f);
}


// 0~300도 소프트웨어 각도를 PRIZM 0~180 명령으로 변환
//
// PRIZM 명령은 정수이므로:
//   68.6도 -> 약 41
//   79.7도 -> 약 48
//
// 소수점은 가장 가까운 정수 명령으로 반올림됩니다.
void sub_motor_move_deg300(float targetDegree)
{
  if (targetDegree < SUB_MIN_DEG)
  {
    targetDegree = SUB_MIN_DEG;
  }
  else if (targetDegree > SUB_MAX_DEG)
  {
    targetDegree = SUB_MAX_DEG;
  }

  const float converted =
    targetDegree * 180.0f / 300.0f;

  const int prizmDegree =
    (int)(converted + 0.5f);

  prizm.setServoPosition(
    SUB_SERVO_CHANNEL,
    prizmDegree
  );

  Serial.print(F("[SUB] target="));
  Serial.print(targetDegree, 1);
  Serial.print(F(" deg / PRIZM="));
  Serial.println(prizmDegree);
}


void stop_all_motion()
{
  z_stop();
  arm_moves_stop();

  set_status_led(255, 0, 0);

  Serial.println(
    F("[STOP] Z, ARM 1, ARM 2 stopped")
  );
}



// 드라이브 모드를 안전하게 준비
// ResetFault가 false여도 실제 Fault가 없는 경우가 있으므로
// SetMode -> ServoOn -> 모드/상태 확인까지 진행합니다.
bool prepare_drive_mode_checked(
  uint8_t motorIndex,
  robowell::AServoMode mode)
{
  if (motorIndex >= AServo_Number)
  {
    return false;
  }

  for (uint8_t attempt = 0; attempt < 3; attempt++)
  {
    drive[motorIndex].ResetFault();
    delay(20);

    const bool modeWriteOK =
      drive[motorIndex].SetMode(mode);

    const bool servoOnOK =
      modeWriteOK &&
      drive[motorIndex].ServoOn();

    const bool modeReadOK =
      servoOnOK &&
      (drive[motorIndex].GetMode() == mode);

    int32_t statusWord = 0;
    const bool statusOK =
      modeReadOK &&
      drive[motorIndex].GetStatusword(statusWord);

    const bool operationEnabled =
      statusOK &&
      ((statusWord & CIA_402_STATUS_OPERATION_ENABLED) ==
       CIA_402_STATUS_OPERATION_ENABLED);

    if (modeReadOK && operationEnabled)
    {
      return true;
    }

    Serial.print(F("[MODE RETRY] DRIVE "));
    Serial.print(motorIndex);
    Serial.print(F(" attempt="));
    Serial.println(attempt + 1);

    delay(80);
  }

  return false;
}


// ARM 1, ARM 2 절대위치 명령
bool start_arm_pair_checked(
  float arm1TargetDeg,
  float arm2TargetDeg,
  int32_t speedRaw)
{
  // ARM 1 절대좌표 한계 검사
  if (
    arm1TargetDeg < DRIVE0_MIN_DEG ||
    arm1TargetDeg > DRIVE0_MAX_DEG
  )
  {
    Serial.print(
      F("[DRIVE 0 LIMIT ERROR] target=")
    );
    Serial.print(arm1TargetDeg, 1);
    Serial.print(F(" deg / allowed="));
    Serial.print(DRIVE0_MIN_DEG, 1);
    Serial.print(F(" ~ "));
    Serial.println(DRIVE0_MAX_DEG, 1);

    return false;
  }

  // ARM 2 절대좌표 한계 검사
  if (
    arm2TargetDeg < DRIVE1_MIN_DEG ||
    arm2TargetDeg > DRIVE1_MAX_DEG
  )
  {
    Serial.print(
      F("[DRIVE 1(actual ARM1) LIMIT ERROR] target=")
    );
    Serial.print(arm2TargetDeg, 1);
    Serial.print(F(" deg / allowed="));
    Serial.print(DRIVE1_MIN_DEG, 1);
    Serial.print(F(" ~ "));
    Serial.println(DRIVE1_MAX_DEG, 1);

    return false;
  }

  const int32_t arm1TargetCount =
    arm_degree_to_count(arm1TargetDeg);

  const int32_t arm2TargetCount =
    arm_degree_to_count(arm2TargetDeg);

  Serial.print(F("[DRIVE 0] "));
  Serial.print(arm1TargetDeg, 1);
  Serial.print(F(" deg -> "));
  Serial.print(arm1TargetCount);
  Serial.print(F(" count / speed raw="));
  Serial.println(speedRaw);

  Serial.print(F("[DRIVE 1 / actual ARM1] "));
  Serial.print(arm2TargetDeg, 1);
  Serial.print(F(" deg -> "));
  Serial.print(arm2TargetCount);
  Serial.print(F(" count / speed raw="));
  Serial.println(speedRaw);

  const bool arm1CommandOK =
    drive[0].MoveAbs(
      arm1TargetCount,
      speedRaw
    );

  delay(20);

  const bool arm2CommandOK =
    drive[1].MoveAbs(
      arm2TargetCount,
      speedRaw
    );

  if (!arm1CommandOK || !arm2CommandOK)
  {
    Serial.print(
      F("[DRIVE COMMAND ERROR] DRIVE0=")
    );
    Serial.print(
      arm1CommandOK ? F("OK") : F("FAIL")
    );

    Serial.print(F(" DRIVE1="));
    Serial.println(
      arm2CommandOK ? F("OK") : F("FAIL")
    );

    return false;
  }

  return true;
}


// ARM 1과 ARM 2를 서로 다른 속도로 거의 동시에 이동시킵니다.
// 직선 보간 시 각 모터의 회전량에 비례해 속도를 맞추는 용도입니다.
bool start_arm_pair_checked_sync(
  float arm1TargetDeg,
  float arm2TargetDeg,
  int32_t arm1SpeedRaw,
  int32_t arm2SpeedRaw)
{
  if (
    arm1TargetDeg < DRIVE0_MIN_DEG ||
    arm1TargetDeg > DRIVE0_MAX_DEG
  )
  {
    Serial.println(F("[SYNC ERROR] DRIVE0 target exceeds limit"));
    return false;
  }

  if (
    arm2TargetDeg < DRIVE1_MIN_DEG ||
    arm2TargetDeg > DRIVE1_MAX_DEG
  )
  {
    Serial.println(F("[SYNC ERROR] DRIVE1(actual ARM1) target exceeds limit"));
    return false;
  }

  if (arm1SpeedRaw < ARM_SYNC_MIN_SPEED_RAW)
  {
    arm1SpeedRaw = ARM_SYNC_MIN_SPEED_RAW;
  }
  if (arm1SpeedRaw > ARM_SYNC_MAX_SPEED_RAW)
  {
    arm1SpeedRaw = ARM_SYNC_MAX_SPEED_RAW;
  }

  if (arm2SpeedRaw < ARM_SYNC_MIN_SPEED_RAW)
  {
    arm2SpeedRaw = ARM_SYNC_MIN_SPEED_RAW;
  }
  if (arm2SpeedRaw > ARM_SYNC_MAX_SPEED_RAW)
  {
    arm2SpeedRaw = ARM_SYNC_MAX_SPEED_RAW;
  }

  const int32_t arm1TargetCount =
    arm_degree_to_count(arm1TargetDeg);

  const int32_t arm2TargetCount =
    arm_degree_to_count(arm2TargetDeg);

  const bool arm1OK =
    drive[0].MoveAbs(
      arm1TargetCount,
      arm1SpeedRaw
    );

  // CAN 드라이브가 첫 번째 명령을 안정적으로 받은 뒤
  // 두 번째 명령을 전송합니다. 15 ms 차이는 기구 동작상 거의 동시에 보입니다.
  delay(15);

  const bool arm2OK =
    drive[1].MoveAbs(
      arm2TargetCount,
      arm2SpeedRaw
    );

  if (!arm1OK || !arm2OK)
  {
    Serial.print(F("[SYNC DRIVE COMMAND ERROR] DRIVE0="));
    Serial.print(arm1OK ? F("OK") : F("FAIL"));
    Serial.print(F(" DRIVE1="));
    Serial.println(arm2OK ? F("OK") : F("FAIL"));
    return false;
  }

  return true;
}


// 회전량에 비례해 속도를 계산합니다.
int32_t calculate_sync_arm_speed(
  float jointDeltaDeg,
  float maximumDeltaDeg)
{
  if (maximumDeltaDeg <= 0.0001f)
  {
    return ARM_SYNC_MIN_SPEED_RAW;
  }

  const float ratio =
    fabsf(jointDeltaDeg) / maximumDeltaDeg;

  int32_t speedRaw =
    (int32_t)(
      ARM_SYNC_MAX_SPEED_RAW * ratio + 0.5f
    );

  if (speedRaw < ARM_SYNC_MIN_SPEED_RAW)
  {
    speedRaw = ARM_SYNC_MIN_SPEED_RAW;
  }

  if (speedRaw > ARM_SYNC_MAX_SPEED_RAW)
  {
    speedRaw = ARM_SYNC_MAX_SPEED_RAW;
  }

  return speedRaw;
}




// 두 ARM 목표 도달 + 서브모터 최소시간 대기
bool wait_arm_pair_and_sub(
  unsigned long motionStartMs,
  unsigned long minimumSubMoveMs,
  unsigned long timeoutMs)
{
  bool arm1Reached = false;
  bool arm2Reached = false;

  while (true)
  {
    const unsigned long elapsedMs =
      millis() - motionStartMs;

    if (!arm1Reached)
    {
      arm1Reached =
        drive[0].IsTargetReached();
    }

    if (!arm2Reached)
    {
      arm2Reached =
        drive[1].IsTargetReached();
    }

    const bool subTimePassed =
      elapsedMs >= minimumSubMoveMs;

    if (
      arm1Reached &&
      arm2Reached &&
      subTimePassed
    )
    {
      return true;
    }

    if (elapsedMs >= timeoutMs)
    {
      Serial.print(
        F("[MOVE TIMEOUT] ARM1=")
      );
      Serial.print(
        arm1Reached
          ? F("REACHED")
          : F("WAIT")
      );

      Serial.print(F(" DRIVE1="));
      Serial.println(
        arm2Reached
          ? F("REACHED")
          : F("WAIT")
      );

      return false;
    }

    delay(2);
  }
}



// 반복되는 짧은 보간 이동용 대기 함수
// IsTargetReached() 상태비트 대신 실제 엔코더 위치를 읽어 판정합니다.
bool wait_arm_pair_by_actual_position(
  float arm1TargetDeg,
  float arm2TargetDeg,
  unsigned long motionStartMs,
  unsigned long minimumSubMoveMs,
  unsigned long timeoutMs,
  int32_t toleranceCount,
  unsigned long settleAfterReachMs)
{
  const int32_t arm1TargetCount =
    arm_degree_to_count(arm1TargetDeg);

  const int32_t arm2TargetCount =
    arm_degree_to_count(arm2TargetDeg);

  unsigned long lastPrintMs = 0;

  while (true)
  {
    const unsigned long elapsedMs =
      millis() - motionStartMs;

    int32_t arm1ActualCount = 0;
    int32_t arm2ActualCount = 0;

    const bool arm1ReadOK =
      drive[0].GetActualPosition(arm1ActualCount);

    const bool arm2ReadOK =
      drive[1].GetActualPosition(arm2ActualCount);

    const int32_t arm1Error =
      arm1ActualCount - arm1TargetCount;

    const int32_t arm2Error =
      arm2ActualCount - arm2TargetCount;

    const bool arm1Reached =
      arm1ReadOK &&
      (arm1Error >= -toleranceCount) &&
      (arm1Error <=  toleranceCount);

    const bool arm2Reached =
      arm2ReadOK &&
      (arm2Error >= -toleranceCount) &&
      (arm2Error <=  toleranceCount);

    const bool subTimePassed =
      elapsedMs >= minimumSubMoveMs;

    if (
      arm1Reached &&
      arm2Reached &&
      subTimePassed
    )
    {
      if (settleAfterReachMs > 0)
      {
        delay(settleAfterReachMs);
      }

      return true;
    }

    // 0.5초마다 현재 위치와 오차 출력
    if (elapsedMs - lastPrintMs >= 500)
    {
      lastPrintMs = elapsedMs;

      Serial.print(F("[ACTUAL WAIT] ARM1="));
      Serial.print(arm1ActualCount);
      Serial.print(F(" target="));
      Serial.print(arm1TargetCount);
      Serial.print(F(" error="));
      Serial.print(arm1Error);

      Serial.print(F(" / DRIVE1="));
      Serial.print(arm2ActualCount);
      Serial.print(F(" target="));
      Serial.print(arm2TargetCount);
      Serial.print(F(" error="));
      Serial.println(arm2Error);
    }

    if (elapsedMs >= timeoutMs)
    {
      Serial.println(
        F("[ACTUAL POSITION TIMEOUT] interpolation point failed")
      );
      return false;
    }

    delay(5);
  }
}


// Z축 HOME 후 지정한 상대 unit만큼 추가 이동
bool move_z_after_home_checked(int relativeUnits)
{
  if (relativeUnits == 0)
  {
    Serial.println(F("[Z] Additional movement disabled"));
    return true;
  }

  Serial.print(F("[Z] Additional move after HOME="));
  Serial.println(relativeUnits);

  // robot.cpp의 블로킹 상대이동 함수 사용
  z_axle_move(relativeUnits);

  delay(Z_AFTER_HOME_SETTLE_MS);

  Serial.println(F("[Z] Additional move complete"));
  return true;
}



// ============================================================
// STAGE 2 부드러운 연속 이동
//
// 중간 목표마다 정지하지 않고 세 모터에 최종값을 한 번씩 명령합니다.
//
// 값 매핑:
//   첫 번째 값  -> drive[0]
//   두 번째 값  -> drive[1], 실제 ARM 1
//   세 번째 값  -> 서브모터
// ============================================================
bool run_straight_motor_motion(
  const char* motionName,
  bool forward)
{
  Serial.println();
  Serial.print(F("========== "));
  Serial.print(motionName);
  Serial.println(F(" START =========="));

  const StraightMotorPose& startPose =
    forward
      ? STAGE2_START_POSE
      : STAGE2_END_POSE;

  const StraightMotorPose& targetPose =
    forward
      ? STAGE2_END_POSE
      : STAGE2_START_POSE;

  const float drive0Delta =
    targetPose.drive0Deg -
    startPose.drive0Deg;

  const float drive1Delta =
    targetPose.drive1Arm1Deg -
    startPose.drive1Arm1Deg;

  float maximumDelta =
    fabsf(drive0Delta);

  if (fabsf(drive1Delta) > maximumDelta)
  {
    maximumDelta = fabsf(drive1Delta);
  }

  const int32_t drive0Speed =
    calculate_sync_arm_speed(
      drive0Delta,
      maximumDelta
    );

  const int32_t drive1Speed =
    calculate_sync_arm_speed(
      drive1Delta,
      maximumDelta
    );

  Serial.print(F("[START] DRIVE0="));
  Serial.print(startPose.drive0Deg, 3);
  Serial.print(F(" / DRIVE1(actual ARM1)="));
  Serial.print(startPose.drive1Arm1Deg, 3);
  Serial.print(F(" / SUB="));
  Serial.println(startPose.subDeg, 3);

  Serial.print(F("[TARGET] DRIVE0="));
  Serial.print(targetPose.drive0Deg, 3);
  Serial.print(F(" speed="));
  Serial.print(drive0Speed);

  Serial.print(F(" / DRIVE1(actual ARM1)="));
  Serial.print(targetPose.drive1Arm1Deg, 3);
  Serial.print(F(" speed="));
  Serial.print(drive1Speed);

  Serial.print(F(" / SUB="));
  Serial.print(targetPose.subDeg, 3);
  Serial.print(F(" speed="));
  Serial.println(STAGE2_SUB_SPEED);

  const unsigned long motionStartMs =
    millis();

  // 1) 서브모터 최종 위치를 한 번에 명령
  prizm.setServoSpeed(
    SUB_SERVO_CHANNEL,
    STAGE2_SUB_SPEED
  );

  sub_motor_move_deg300(
    targetPose.subDeg
  );

  delay(20);

  // 2) 두 CAN 드라이브도 최종 위치를 한 번에 명령
  if (!start_arm_pair_checked_sync(
        targetPose.drive0Deg,
        targetPose.drive1Arm1Deg,
        drive0Speed,
        drive1Speed))
  {
    Serial.println(
      F("[STAGE 2 ERROR] MoveAbs command rejected")
    );

    stop_all_motion();
    return false;
  }

  // 3) 최종 위치에서만 도착 판정
  if (!wait_arm_pair_by_actual_position(
        targetPose.drive0Deg,
        targetPose.drive1Arm1Deg,
        motionStartMs,
        STAGE2_SUB_MIN_MOVE_MS,
        STAGE2_CONTINUOUS_TIMEOUT_MS,
        STAGE2_END_TOLERANCE_COUNT,
        0))
  {
    Serial.println(
      F("[STAGE 2 ERROR] final-position timeout")
    );

    stop_all_motion();
    return false;
  }

  delay(STRAIGHT_END_SETTLE_MS);

  Serial.print(motionName);
  Serial.println(F(" COMPLETE"));
  Serial.println(
    F("========================================")
  );

  return true;
}


// 공통 위치 이동 함수
bool move_to_absolute_pose(
  const char* stageName,
  float arm1TargetDeg,
  float arm2TargetDeg,
  float subTargetDeg,
  uint8_t subSpeed,
  unsigned long minimumSubMoveMs,
  unsigned long timeoutMs,
  unsigned long settleMs)
{
  Serial.println();
  Serial.print(F("========== "));
  Serial.print(stageName);
  Serial.println(F(" START =========="));

  Serial.println(
    F("[MODE] All targets are absolute positions from HOME")
  );

  prizm.setServoSpeed(
    SUB_SERVO_CHANNEL,
    subSpeed
  );

  const unsigned long motionStartMs =
    millis();

  // 서브모터를 먼저 출발시킨 후 ARM CAN 명령 전송
  sub_motor_move_deg300(subTargetDeg);

  delay(SUB_LEAD_TIME_MS);

  if (!start_arm_pair_checked(
        arm1TargetDeg,
        arm2TargetDeg,
        ARM_MOVE_SPEED_RAW))
  {
    stop_all_motion();
    return false;
  }

  Serial.println(
    F("[WAIT] Checking actual encoder positions")
  );

  if (!wait_arm_pair_by_actual_position(
        arm1TargetDeg,
        arm2TargetDeg,
        motionStartMs,
        minimumSubMoveMs,
        timeoutMs,
        STAGE1_POSITION_TOLERANCE_COUNT,
        0))
  {
    Serial.print(F("[STAGE FAILED] "));
    Serial.print(stageName);
    Serial.println(F(" actual-position timeout"));

    stop_all_motion();
    return false;
  }

  delay(settleMs);

  Serial.print(stageName);
  Serial.println(F(" COMPLETE"));

  arm_position_Reads();

  Serial.println(
    F("========================================")
  );

  return true;
}



// ============================================================
// ARM 한 축 안전 호밍
//
// motorId:
//   1 = drive[0]
//   2 = drive[1] = 실제 ARM 1
//
// 개선사항:
//   - 한 축씩 순차 호밍
//   - Homing attained 이전 값이 남아 즉시 완료되는 현상 방지
//   - 상태/위치 CAN 연속 실패 감지
//   - 급가속은 3회 연속 확인 후 정지
//   - 시작 직후 250ms는 속도검사 유예
// ============================================================
int32_t absolute_count_value(int32_t value)
{
  return (value >= 0) ? value : -value;
}


bool restore_position_mode_checked(
  uint8_t motorIndex)
{
  if (!prepare_drive_mode_checked(
        motorIndex,
        robowell::AServoMode::Position))
  {
    Serial.print(F("[DRIVE "));
    Serial.print(motorIndex);
    Serial.println(F("] Position mode restore failed"));
    return false;
  }

  return true;
}


bool home_one_arm_safely(
  uint8_t motorId,
  int32_t maximumTravelCount)
{
  if (motorId < 1 || motorId > 2)
  {
    Serial.println(F("[SAFE HOME] Invalid motor ID"));
    return false;
  }

  const uint8_t index = motorId - 1;

  Serial.println();
  Serial.print(F("========== DRIVE "));
  Serial.print(index);
  if (index == 1)
  {
    Serial.print(F(" (actual ARM1)"));
  }
  Serial.println(F(" SAFE HOME START =========="));

  drive[index].Stop();
  delay(100);

  if (!prepare_drive_mode_checked(
        index,
        robowell::AServoMode::Homing))
  {
    Serial.println(F("[SAFE HOME] Homing mode setup failed"));
    drive[index].Stop();
    return false;
  }

  delay(ARM_HOME_MODE_SETTLE_MS);

  int32_t startPosition = 0;

  if (!drive[index].GetActualPosition(startPosition))
  {
    Serial.println(F("[SAFE HOME] Initial position read failed"));
    drive[index].Stop();
    return false;
  }

  // 이전 호밍의 attained 비트가 남아 있는지 확인
  int32_t statusBeforeStart = 0;
  bool attainedWasSetBeforeStart = false;

  if (drive[index].GetStatusword(statusBeforeStart))
  {
    attainedWasSetBeforeStart =
      (statusBeforeStart & CIA_402_STATUS_HOMING_ATTAINED) ==
      CIA_402_STATUS_HOMING_ATTAINED;
  }

  if (!drive[index].MoveHomming())
  {
    Serial.println(F("[SAFE HOME] Homing command failed"));
    drive[index].Stop();
    restore_position_mode_checked(index);
    return false;
  }

  const unsigned long homingStartMs = millis();
  unsigned long lastPrintMs = homingStartMs;
  unsigned long lastPositionMs = homingStartMs;

  int32_t lastPosition = startPosition;

  bool attainedBitCleared =
    !attainedWasSetBeforeStart;

  uint8_t statusReadFailCount = 0;
  uint8_t positionReadFailCount = 0;
  uint8_t overspeedCount = 0;

  while (
    millis() - homingStartMs <
    ARM_HOME_TIMEOUT_MS
  )
  {
    const unsigned long nowMs = millis();
    const unsigned long elapsedMs =
      nowMs - homingStartMs;

    int32_t statusWord = 0;

    // 상태워드는 한 번만 읽어 오류와 완료를 동시에 판정
    if (!drive[index].GetStatusword(statusWord))
    {
      statusReadFailCount++;

      if (statusReadFailCount >= ARM_HOME_CAN_FAIL_LIMIT)
      {
        drive[index].Stop();
        Serial.println(
          F("[SAFE HOME] Status CAN failures -> STOP")
        );
        restore_position_mode_checked(index);
        return false;
      }

      delay(ARM_HOME_MONITOR_INTERVAL_MS);
      continue;
    }

    statusReadFailCount = 0;

    const bool homingError =
      (statusWord & CIA_402_STATUS_HOMING_ERROR) ==
      CIA_402_STATUS_HOMING_ERROR;

    const bool homingAttained =
      (statusWord & CIA_402_STATUS_HOMING_ATTAINED) ==
      CIA_402_STATUS_HOMING_ATTAINED;

    if (homingError)
    {
      drive[index].Stop();
      Serial.println(F("[SAFE HOME] HOMING ERROR -> STOP"));
      restore_position_mode_checked(index);
      return false;
    }

    // 새 호밍 명령 후 attained 비트가 한 번 내려간 것을 확인
    if (!homingAttained)
    {
      attainedBitCleared = true;
    }

    // 이전 attained 비트를 새 완료로 오판하지 않음
    if (homingAttained && attainedBitCleared)
    {
      drive[index].Stop();
      delay(100);

      if (!restore_position_mode_checked(index))
      {
        return false;
      }

      int32_t homePosition = 0;

      if (drive[index].GetActualPosition(homePosition))
      {
        Serial.print(F("[SAFE HOME] completed position="));
        Serial.println(homePosition);
      }

      Serial.println(F("[SAFE HOME] COMPLETE"));
      Serial.println(
        F("========================================")
      );

      return true;
    }

    int32_t currentPosition = 0;

    if (!drive[index].GetActualPosition(currentPosition))
    {
      positionReadFailCount++;

      if (positionReadFailCount >= ARM_HOME_CAN_FAIL_LIMIT)
      {
        drive[index].Stop();
        Serial.println(
          F("[SAFE HOME] Position CAN failures -> STOP")
        );
        restore_position_mode_checked(index);
        return false;
      }

      delay(ARM_HOME_MONITOR_INTERVAL_MS);
      continue;
    }

    positionReadFailCount = 0;

    const int32_t totalTravel =
      absolute_count_value(
        currentPosition - startPosition
      );

    if (totalTravel > maximumTravelCount)
    {
      drive[index].Stop();

      Serial.print(F("[SAFE HOME] EXCESS TRAVEL="));
      Serial.print(totalTravel);
      Serial.println(F(" count -> STOP"));

      restore_position_mode_checked(index);
      return false;
    }

    const unsigned long positionDeltaMs =
      nowMs - lastPositionMs;

    if (
      elapsedMs >= ARM_HOME_SPEED_CHECK_GRACE_MS &&
      positionDeltaMs > 0
    )
    {
      const int32_t positionDelta =
        absolute_count_value(
          currentPosition - lastPosition
        );

      const int64_t speedCountPerSec =
        ((int64_t)positionDelta * 1000LL) /
        (int64_t)positionDeltaMs;

      if (
        speedCountPerSec >
        ARM_HOME_MAX_SPEED_COUNT_PER_SEC
      )
      {
        overspeedCount++;
      }
      else
      {
        overspeedCount = 0;
      }

      if (
        overspeedCount >=
        ARM_HOME_OVERSPEED_CONFIRM_COUNT
      )
      {
        drive[index].Stop();

        Serial.print(F("[SAFE HOME] OVERSPEED="));
        Serial.print((long)speedCountPerSec);
        Serial.println(F(" count/s -> STOP"));

        restore_position_mode_checked(index);
        return false;
      }
    }

    lastPosition = currentPosition;
    lastPositionMs = nowMs;

    if (
      nowMs - lastPrintMs >=
      ARM_HOME_PRINT_INTERVAL_MS
    )
    {
      lastPrintMs = nowMs;

      Serial.print(F("[SAFE HOME] position="));
      Serial.print(currentPosition);
      Serial.print(F(" travel="));
      Serial.print(totalTravel);
      Serial.print(F(" attained="));
      Serial.println(homingAttained ? 1 : 0);
    }

    delay(ARM_HOME_MONITOR_INTERVAL_MS);
  }

  drive[index].Stop();

  Serial.println(
    F("[SAFE HOME] TIMEOUT -> STOP")
  );

  restore_position_mode_checked(index);
  return false;
}


bool home_both_arms_safely()
{
  if (!home_one_arm_safely(
        1,
        DRIVE0_HOME_MAX_TRAVEL_COUNT))
  {
    arm_moves_stop();
    set_status_led(255, 0, 0);
    Serial.println(F("[SAFE HOME] drive[0] failed"));
    return false;
  }

  delay(ARM_HOME_BETWEEN_MOTORS_MS);

  if (!home_one_arm_safely(
        2,
        DRIVE1_HOME_MAX_TRAVEL_COUNT))
  {
    arm_moves_stop();
    set_status_led(255, 0, 0);
    Serial.println(
      F("[SAFE HOME] drive[1] actual ARM1 failed")
    );
    return false;
  }

  return true;
}



// Z축 원점 센서를 찾지 못할 때 무한히 움직이지 않도록 제한
bool home_z_safely()
{
  Serial.println(F("[Z] safe home start"));

  if (digitalRead(Z_HOME_SENSOR_PIN) == LOW)
  {
    z_stop();
    Serial.println(
      F("[Z] sensor already active -> home complete")
    );
    return true;
  }

  z_go_home_start();

  const unsigned long startMs =
    millis();

  while (
    millis() - startMs <
    Z_HOME_TIMEOUT_MS
  )
  {
    if (z_go_home_update())
    {
      Serial.println(F("[Z] safe home complete"));
      return true;
    }

    delay(2);
  }

  z_stop();
  Serial.println(F("[Z] HOME TIMEOUT -> STOP"));
  return false;
}


// ============================================================
// HOME
//
// setup()에서 system_init()을 먼저 실행한 뒤 이 함수로 들어옵니다.
// ARM 호밍을 가장 먼저 수행하고, 그 다음 서브모터와 Z축을 홈으로 보냅니다.
// ============================================================
bool run_home()
{
  Serial.println();
  Serial.println(
    F("========== HOME START ==========")
  );

  // HOME 진행 표시: 파란불
  set_status_led(0, 0, 255);

  // CAN/UART 초기화 안정화 시간
  delay(500);

  // ----------------------------------------------------------
  // 1) ARM 1, ARM 2 안전 순차 HOME
  //
  // 기존 arm_home(0)은 사용하지 않습니다.
  // ARM 1 완료 후 ARM 2를 실행하며,
  // 급가속/과도 이동/시간초과/Homing Error를 감시합니다.
  // ----------------------------------------------------------
  Serial.println(
    F("[ARM] SAFE SEQUENTIAL HOMING START")
  );

  if (!home_both_arms_safely())
  {
    stop_all_motion();

    Serial.println(
      F("[ARM] SAFE HOMING FAILED")
    );

    return false;
  }

  Serial.println(
    F("[ARM] SAFE SEQUENTIAL HOMING COMPLETE")
  );

  set_status_led(0, 0, 255);
  delay(500);

  // ----------------------------------------------------------
  // 2) 서브모터 소프트웨어 HOME
  // ----------------------------------------------------------
  Serial.println(
    F("[SUB] HOME START")
  );

  prizm.setServoSpeed(
    SUB_SERVO_CHANNEL,
    10
  );

  sub_motor_move_deg300(
    SUB_HOME_DEG
  );

  delay(1500);

  Serial.println(
    F("[SUB] HOME COMPLETE")
  );

  // ----------------------------------------------------------
  // 3) Z축 HOME
  // ----------------------------------------------------------
  Serial.println(
    F("[Z] safe homing START")
  );

  if (!home_z_safely())
  {
    stop_all_motion();
    return false;
  }

  Serial.println(
    F("[Z] safe homing COMPLETE")
  );

  // 홈 센서에 닿은 뒤 센서 반대 방향으로 조금 더 이동
  if (!move_z_after_home_checked(
        Z_AFTER_HOME_EXTRA_UNITS))
  {
    return false;
  }

  Serial.println(
    F("HOME COMPLETE")
  );
  Serial.println(
    F("================================")
  );

  return true;
}


// ============================================================
// 1단계
// HOME -> ARM1 -48.1 / ARM2 -116.7 / SUB 68.6
// ============================================================
bool run_stage1()
{
  return move_to_absolute_pose(
    "STAGE 1",
    STAGE1_DRIVE0_TARGET_DEG,
    STAGE1_DRIVE1_ARM1_TARGET_DEG,
    STAGE1_SUB_TARGET_DEG,
    STAGE1_SUB_SPEED,
    STAGE1_SUB_MIN_MOVE_MS,
    STAGE1_TIMEOUT_MS,
    STAGE1_SETTLE_MS
  );
}


// ============================================================
// STAGE 2 전진 완료 후 Z축 +5 상승
//
// z_axle_move()가 완료될 때까지 함수 내부에서 기다리므로
// Z축이 움직이는 동안 ARM 복귀 명령은 실행되지 않습니다.
// ============================================================
bool lift_z_after_stage2_forward()
{
  Serial.println();
  Serial.println(
    F("========== STAGE 2 Z LIFT START ==========")
  );

  Serial.print(F("[Z] Relative lift units=+"));
  Serial.println(STAGE2_Z_LIFT_UNITS);

  delay(STAGE2_Z_BEFORE_LIFT_MS);

  // 상대좌표 +5 이동
  z_axle_move(STAGE2_Z_LIFT_UNITS);

  delay(STAGE2_Z_AFTER_LIFT_SETTLE_MS);

  Serial.println(
    F("[Z] STAGE 2 lift complete")
  );
  Serial.println(
    F("==========================================")
  );

  return true;
}


// ============================================================
// 2단계: 실제 3모터 동기 동작
//
// 1) 미리 계산된 모터 각도값을 순서대로 직접 명령하여 전진
// 2) 가장 앞에서 잠시 정지
// 3) 같은 모터 각도값을 역순으로 직접 명령하여 복귀
//
// 실행 중 좌표 계산은 하지 않습니다.
// ============================================================
bool run_stage2()
{
  // ----------------------------------------------------------
  // 1) ARM과 서브모터 전진
  // ----------------------------------------------------------
  if (!run_straight_motor_motion(
        "STAGE 2A - ACTUAL MOTOR FORWARD",
        true))
  {
    return false;
  }

  Serial.println(
    F("[FRONT] Actual motor extension complete")
  );

  delay(STRAIGHT_FRONT_HOLD_MS);

  // ----------------------------------------------------------
  // 2) 전진 자세를 유지한 상태에서 Z축 +5 상승
  // ----------------------------------------------------------
  if (!lift_z_after_stage2_forward())
  {
    stop_all_motion();

    Serial.println(
      F("[STAGE 2 ERROR] Z lift failed")
    );

    return false;
  }

  // ----------------------------------------------------------
  // 3) Z축 상승이 끝난 다음 ARM과 서브모터 복귀
  // ----------------------------------------------------------
  if (!run_straight_motor_motion(
        "STAGE 2B - ACTUAL MOTOR RETURN",
        false))
  {
    return false;
  }

  Serial.println(
    F("[RETURN] Actual motor return complete after Z lift")
  );

  return true;
}



bool validate_motion_configuration()
{
  const bool stage1OK =
    STAGE1_DRIVE0_TARGET_DEG >= DRIVE0_MIN_DEG &&
    STAGE1_DRIVE0_TARGET_DEG <= DRIVE0_MAX_DEG &&
    STAGE1_DRIVE1_ARM1_TARGET_DEG >= DRIVE1_MIN_DEG &&
    STAGE1_DRIVE1_ARM1_TARGET_DEG <= DRIVE1_MAX_DEG;

  const bool stage2StartOK =
    STAGE2_START_POSE.drive0Deg >= DRIVE0_MIN_DEG &&
    STAGE2_START_POSE.drive0Deg <= DRIVE0_MAX_DEG &&
    STAGE2_START_POSE.drive1Arm1Deg >= DRIVE1_MIN_DEG &&
    STAGE2_START_POSE.drive1Arm1Deg <= DRIVE1_MAX_DEG &&
    STAGE2_START_POSE.subDeg >= SUB_MIN_DEG &&
    STAGE2_START_POSE.subDeg <= SUB_MAX_DEG;

  const bool stage2EndOK =
    STAGE2_END_POSE.drive0Deg >= DRIVE0_MIN_DEG &&
    STAGE2_END_POSE.drive0Deg <= DRIVE0_MAX_DEG &&
    STAGE2_END_POSE.drive1Arm1Deg >= DRIVE1_MIN_DEG &&
    STAGE2_END_POSE.drive1Arm1Deg <= DRIVE1_MAX_DEG &&
    STAGE2_END_POSE.subDeg >= SUB_MIN_DEG &&
    STAGE2_END_POSE.subDeg <= SUB_MAX_DEG;

  if (!stage1OK || !stage2StartOK || !stage2EndOK)
  {
    Serial.println(F("[CONFIG ERROR] target exceeds limit"));
    return false;
  }

  return true;
}


// ============================================================
// Arduino
// ============================================================
void setup()
{
  Serial.begin(115200);
  delay(300);

  prizm.PrizmBegin();
  delay(300);

  // 이전에 실제로 호밍되던 코드와 동일하게
  // ARM CAN/UART 및 Z축 핀을 먼저 초기화합니다.
  system_init();
  delay(500);

  Serial.println();
  Serial.println(
    F("WAFER ROBOT: STAGE2 FORWARD-Z+5-RETURN")
  );

  if (!validate_motion_configuration())
  {
    stop_all_motion();
    Serial.println(F("PROGRAM STOP: CONFIGURATION ERROR"));
    return;
  }

  // ----------------------------------------------------------
  // HOME
  // ----------------------------------------------------------
  if (!run_home())
  {
    stop_all_motion();

    Serial.println(
      F("PROGRAM STOP: HOME FAILED")
    );
    return;
  }

  delay(300);

  // ----------------------------------------------------------
  // 1단계
  // ----------------------------------------------------------
  if (!run_stage1())
  {
    stop_all_motion();

    Serial.println(
      F("PROGRAM STOP: STAGE 1 FAILED")
    );
    return;
  }

  delay(1000);

  // ----------------------------------------------------------
  // 2단계
  // ----------------------------------------------------------
  if (!run_stage2())
  {
    stop_all_motion();

    Serial.println(
      F("PROGRAM STOP: STAGE 2 FAILED")
    );
    return;
  }

  // 전체 완료: 초록불
  set_status_led(0, 255, 0);

  Serial.println();
  Serial.println(
    F("HOME + STAGE 1 + STRAIGHT FORWARD/RETURN COMPLETE")
  );
}


void loop()
{
  // 자동 반복하지 않습니다.
  // 다시 실행하려면 보드 리셋 버튼을 누릅니다.
}
