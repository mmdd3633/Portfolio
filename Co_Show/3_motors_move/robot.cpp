#include "robot.h"

using namespace robowell;

// ---- Global object definitions ----
// NOTE: `prizm` is defined in the .ino file, not here.
HardwareSerial mySerial(1);

ArduinoCANBus bus;
AservoDrive drive[] = { AservoDrive(bus, 1),
                        AservoDrive(bus, 2) };

uint8_t SW_read_value[3] = {0,};

// Z-Axle variables
const int PULSE_PIN = 6;       // OUT PIN (GPIO 6)
uint32_t FREQ = 4000;          // 1kHz
const uint8_t RESOLUTION = 8;  // 8비트 해상도 (0~255)
int detect = 0;

// Serial, CAN버스, Z축 핀/PWM 등 공통 초기화
void system_init() {
  Serial.begin(115200);

  bus.begin(mySerial, 38400, 15, 16);

  // Z-Axle Setup
  ledcAttach(PULSE_PIN, FREQ, RESOLUTION);
  pinMode(7, OUTPUT);
  pinMode(17, INPUT);
}

// Z축만 원점 복귀
void z_homing() {
  system_init();
  z_go_home();
}

// 스카라 팔 원점 복귀 + Z축 원점 복귀
// motor_id: 0 = 모터 1, 2 모두 / 1 or 2 = 해당 모터만
void arm_home(uint8_t motor_id) {
  system_init();

  Serial.println("Robowell Drive Start Set Mode");

  if (motor_id == 0) {
    // 모터 1, 2 모두 원점 복귀
    for (uint8_t i = 0; i < AServo_Number; i++)
    {
      Set_Mode(i + 1, AServoMode::Homing);
    }
    delay(1000);
    if (Homing_Moves()) Serial.println(F("Drive completed Homming"));

    for (uint8_t i = 0; i < AServo_Number; i++)
    {
      Set_Mode(i + 1, AServoMode::Position);
    }
  }
  else if (motor_id == 1 || motor_id == 2) {
    // 지정된 모터 1개만 원점 복귀
    Set_Mode(motor_id, AServoMode::Homing);
    delay(1000);
    if (Homing_Move(motor_id)) Serial.println(F("Drive completed Homming"));

    Set_Mode(motor_id, AServoMode::Position);
  }
  else {
    Serial.println(F("arm_home: invalid motor_id (use 0, 1, or 2)"));
    return;
  }

  Serial.println(F("AServo to start!"));
  prizm.setPixelColor(1, prizm.packPixelColor(255, 0, 0));
}

void z_axle_move(int langth) {
  if (langth == 0) return;
  int taget_length_pulse = langth * 200;
  if (langth < 0) {
    digitalWrite(7, HIGH);
    sendpulses(-taget_length_pulse);
    return;
  }
  if (langth > 0) {
    digitalWrite(7, LOW);
    sendpulses(taget_length_pulse);
    return;
  }
  return;
}

void z_go_home(void) {
  digitalWrite(7, LOW);
  ledcWrite(PULSE_PIN, 128);

  while (1) {
    detect = digitalRead(9);
    if (detect == 0) break;
    delay(1);
  }

  ledcWrite(PULSE_PIN, 0);
  Serial.println("END");
  return;
}

void sendpulses(int count) {
  ledcWrite(PULSE_PIN, 128);
  float durationMs = (1000.0 / FREQ) * count;
  delay(durationMs);
  ledcWrite(PULSE_PIN, 0);
}

uint8_t Homing_Moves()
{
  bool allHommingReached = true;
  for (uint8_t i = 0; i < AServo_Number; i++)
  {
    drive[i].MoveHomming();
  }
  do
  {
    allHommingReached = true;
    for (uint8_t i = 0; i < AServo_Number; i++)
    {
      allHommingReached &= drive[i].IsHommingReached();
    }
  } while (!allHommingReached);
  return allHommingReached;
}

uint8_t Homing_Move(uint8_t drive_Id)
{
  uint8_t Id = drive_Id - 1;
  bool hommingReached = false;

  drive[Id].MoveHomming();
  do
  {
    hommingReached = drive[Id].IsHommingReached();
  } while (!hommingReached);
  return hommingReached;
}

uint8_t Pogition_Move(uint8_t drive_Id, int32_t drive_position, int32_t drive_velocity)
{
  bool allTargetReached = true;
  uint8_t Id = drive_Id - 1;
  drive[Id].MoveAbs(drive_position, drive_velocity);

  do
  {
    allTargetReached = true;
    allTargetReached &= drive[Id].IsTargetReached();
  } while (!allTargetReached);
  return allTargetReached;
}

uint8_t Pogition_Moves(int32_t drive_position1, int32_t drive_velocity1, int32_t drive_position2, int32_t drive_velocity2)
{
  bool allTargetReached = true;

  int32_t drive_position[2] = {drive_position1, drive_position2};
  int32_t drive_velocity[2] = {drive_velocity1, drive_velocity2};

  for (uint8_t i = 0; i < AServo_Number; i++)
  {
    drive[i].MoveAbs(drive_position[i], drive_velocity[i]);
  }
  do
  {
    allTargetReached = true;
    for (uint8_t i = 0; i < AServo_Number; i++)
    {
      allTargetReached &= drive[i].IsTargetReached();
    }
  } while (!allTargetReached);
  return allTargetReached;
}

uint8_t Set_Mode(uint8_t node_Id, AServoMode mode)
{
  bool allReady = false;
  uint8_t try_cnt = 0;
  node_Id -= 1;
  while (try_cnt < 3)
  {
    if (drive[node_Id].ResetFault())
    {
      Serial.print(node_Id + 1); Serial.println(" Reset Fault oK");
      if (drive[node_Id].SetMode(mode))
      {
        Serial.print(node_Id + 1); Serial.println(" Mode oK");
        if (drive[node_Id].ServoOn())
        {
          Serial.print(node_Id + 1); Serial.println(" Servo On oK");
          allReady = SetReadyCheck(node_Id, mode);
          if (allReady)
          {
            Serial.println("OK");
            return true;
          }
        }
      }
      else allReady &= (drive[node_Id].GetMode() == mode);
    }
    else
    {
      Serial.println("ResetFault Fail");
      if (drive[node_Id].SetMode(mode))
      {
        Serial.println("##1 SET Servo Mode");
        if (drive[node_Id].ServoOn())
        {
          Serial.println("##2 Servo ON");
          if (drive[node_Id].ServoOff())
          {
            Serial.println("##3 Servo OFF");
            if (drive[node_Id].ServoOn())
            {
              Serial.println("##4 Servo ON");
              allReady &= (drive[node_Id].GetMode() == mode);
            }
          }
        }
      }
    }
    try_cnt++;
    Serial.println("Mode ReTry");
  }
  return false;
}

bool SetReadyCheck(uint8_t node_Id, AServoMode mode)
{
  int32_t value = 0;
  if (!((uint8_t)drive[node_Id].GetMode()) == (uint8_t)mode) return false;
  if (!drive[node_Id].GetStatusword(value)) return false;
  if (value & CIA_402_STATUS_OPERATION_ENABLED != CIA_402_STATUS_OPERATION_ENABLED) return false;
  return true;
}

// arm_home()과 같은 네이밍으로 맞춘 래퍼 함수 (내부적으로 Pogition_Move/Pogition_Moves 재사용)

// 모터 1개만 목표 위치로 이동
uint8_t arm_move(uint8_t motor_id, int32_t position, int32_t velocity)
{
  return Pogition_Move(motor_id, position, velocity);
}

// 모터 1, 2를 동시에 각자의 목표 위치로 이동 (두 모터 모두 도달할 때까지 대기)
uint8_t arm_moves(int32_t position1, int32_t velocity1, int32_t position2, int32_t velocity2)
{
  return Pogition_Moves(position1, velocity1, position2, velocity2);
}

void arm_position_Reads(void)
{
  int32_t actualPosition1 =0, actualPosition2 =0;
  drive[0].GetActualPosition(actualPosition1);
  drive[1].GetActualPosition(actualPosition2);
  Serial.print("GetActualPosition ID 1: "); Serial.print(actualPosition1);
  Serial.print(" GetActualPosition ID 2: ");Serial.println(actualPosition2);
}
// ================== 논블로킹(Non-blocking) API 구현 ==================

// ---- Z축 상하 이동 ----
static bool zAxleMoving = false;
static unsigned long zAxleStartMs = 0;
static unsigned long zAxleDurationMs = 0;

void z_move_start(int langth) {
  if (langth == 0) { zAxleMoving = false; return; }

  int32_t taget_length_pulse = (int32_t)langth * 200;
  if (langth < 0) {
    digitalWrite(7, HIGH);
    taget_length_pulse = -taget_length_pulse;
  } else {
    digitalWrite(7, LOW);
  }

  zAxleDurationMs = (unsigned long)((1000.0 / FREQ) * taget_length_pulse);
  zAxleStartMs = millis();
  ledcWrite(PULSE_PIN, 128);   // 펄스 출력 시작
  zAxleMoving = true;
}

bool z_move_update() {
  if (!zAxleMoving) return true;             // 움직이는 중이 아니면 이미 완료된 것으로 간주

  if (millis() - zAxleStartMs >= zAxleDurationMs) {
    ledcWrite(PULSE_PIN, 0);                 // 펄스 출력 정지
    zAxleMoving = false;
    return true;                             // 이동 완료
  }
  return false;                              // 아직 이동 중
}

// ---- Z축 원점 복귀 ----
static bool zHoming = false;

void z_go_home_start() {
  digitalWrite(7, LOW);
  ledcWrite(PULSE_PIN, 128);
  zHoming = true;
}

bool z_go_home_update() {
  if (!zHoming) return true;

  detect = digitalRead(9);
  if (detect == 0) {
    ledcWrite(PULSE_PIN, 0);
    Serial.println("END");
    zHoming = false;
    return true;                             // 원점 도달
  }
  return false;                              // 아직 이동 중
}

// 진행 중인 Z축 동작(상하 이동 또는 원점 복귀)을 즉시 정지
void z_stop() {
  ledcWrite(PULSE_PIN, 0);   // 펄스 출력 즉시 정지
  zAxleMoving = false;
  zHoming = false;
}

// ---- 팔 모터 위치 이동 ----
void arm_move_start(uint8_t motor_id, int32_t position, int32_t velocity) {
  uint8_t Id = motor_id - 1;
  drive[Id].MoveAbs(position, velocity);     // 명령만 보내고 즉시 리턴 (대기 없음)
}

bool arm_move_update(uint8_t motor_id) {
  uint8_t Id = motor_id - 1;
  return drive[Id].IsTargetReached();        // 도달했으면 true
}

// 모터 1개 즉시 정지
// AservoDrive::Stop()은 CiA-402 Halt bit(0x0100)를 세워 감속 정지시키는
// 정식 정지 명령이라, 토크를 끊는 ServoOff()보다 안전합니다 (서보 On 상태 유지).
void arm_move_stop(uint8_t motor_id) {
  uint8_t Id = motor_id - 1;
  drive[Id].Stop();
}

void arm_moves_start(int32_t position1, int32_t velocity1, int32_t position2, int32_t velocity2) {
  drive[0].MoveAbs(position1, velocity1);    // 두 모터 모두 명령만 보내고 즉시 리턴
  drive[1].MoveAbs(position2, velocity2);
}

bool arm_moves_update() {
  bool r1 = drive[0].IsTargetReached();
  bool r2 = drive[1].IsTargetReached();
  return r1 && r2;                           // 둘 다 도달했으면 true
}

// 모터 1, 2 모두 즉시 정지 (Halt bit 사용, arm_move_stop과 동일)
void arm_moves_stop() {
  drive[0].Stop();
  drive[1].Stop();
}

void arm_moves_off() {
  drive[0].ServoOff();
  drive[1].ServoOff();
}