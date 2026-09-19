#pragma once

#include <Arduino.h>
#include <HardwareSerial.h>
#include <PRIZM_PRO.h> // include PRIZM Pro library

#include "ArduinoCANBus.hpp"
#include "AservoDrive.hpp"

#define AServo_Number 2
#define SW1 3
#define SW2 4

// ---- Global objects ----
extern HardwareSerial mySerial;      // defined in robot.cpp
extern PRIZM prizm;                  // defined in the .ino file
extern robowell::ArduinoCANBus bus;  // defined in robot.cpp
extern robowell::AservoDrive drive[AServo_Number]; // defined in robot.cpp

extern uint8_t SW_read_value[3];

// Z-Axle variables
extern const int PULSE_PIN;
extern uint32_t FREQ;
extern const uint8_t RESOLUTION;
extern int detect;

// ---- Functions (defined in robot.cpp) ----

// Serial, CAN버스, Z축 핀/PWM 등 공통 초기화. z_homing()/arm_home()이 내부에서 호출함.
void system_init();

// Z축만 원점 복귀. z_home.ino의 setup()에서 이것만 호출하면 됨.
void z_homing();

// 스카라 팔 원점 복귀만 수행 (Z축은 건드리지 않음). a_servo_home.ino의 setup()에서 이것만 호출하면 됨.
// motor_id: 0 = 모터 1, 2 모두 (기본값) / 1 또는 2 = 해당 모터만
void arm_home(uint8_t motor_id = 0);

void z_axle_move(int langth);
void z_go_home(void);
void sendpulses(int count);

uint8_t Homing_Moves();                 // 모터 1, 2 전체 원점 복귀 대기
uint8_t Homing_Move(uint8_t drive_Id);  // 지정한 모터 1개만 원점 복귀 대기

uint8_t Pogition_Move(uint8_t drive_Id, int32_t drive_position, int32_t drive_velocity);
uint8_t Pogition_Moves(int32_t drive_position1, int32_t drive_velocity1, int32_t drive_position2, int32_t drive_velocity2);
uint8_t Set_Mode(uint8_t node_Id, robowell::AServoMode mode);
bool SetReadyCheck(uint8_t node_Id, robowell::AServoMode mode);

// arm_home()과 같은 네이밍으로 맞춘 래퍼 함수 (블로킹 버전 - 끝날 때까지 대기)
// arm_move : 모터 1개만 목표 위치로 이동
// arm_moves: 모터 1, 2를 동시에 각자의 목표 위치로 이동 (둘 다 도달할 때까지 대기)
uint8_t arm_move(uint8_t motor_id, int32_t position, int32_t velocity);
uint8_t arm_moves(int32_t position1, int32_t velocity1, int32_t position2, int32_t velocity2);

void arm_position_Reads(void);

// ================== 논블로킹(Non-blocking) API ==================
// 아래 함수들은 "명령만 보내고 즉시 리턴"하는 _start() 와,
// loop()에서 매 반복마다 호출해서 진행 상태를 확인하는 _update() 쌍으로 되어 있습니다.
// 이 방식을 쓰면 Z축, 팔 모터, 300도 서보를 동시에 움직일 수 있습니다.

// ---- Z축 상하 이동 (논블로킹) ----
void z_move_start(int langth);        // 이동 명령을 보내고 즉시 리턴
bool z_move_update();                 // loop()에서 계속 호출. 이동이 끝나면 true 리턴 (그 전엔 false)

// ---- Z축 원점 복귀 (논블로킹) ----
void z_go_home_start();               // 원점 복귀 시작, 즉시 리턴
bool z_go_home_update();              // loop()에서 계속 호출. 원점에 도달하면 true 리턴 (그 전엔 false)

// 진행 중인 Z축 동작(상하 이동 또는 원점 복귀)을 즉시 정지 (펄스 출력 OFF)
void z_stop();

// ---- 팔 모터 위치 이동 (논블로킹) ----
void arm_move_start(uint8_t motor_id, int32_t position, int32_t velocity);   // 모터 1개, 명령만 전송
bool arm_move_update(uint8_t motor_id);                                      // 목표 도달 여부 확인 (true = 도달)
void arm_move_stop(uint8_t motor_id);                                        // 모터 1개 즉시 정지 (CiA-402 Halt bit)

void arm_moves_start(int32_t position1, int32_t velocity1, int32_t position2, int32_t velocity2); // 모터 1,2 동시 명령 전송
bool arm_moves_update();              // 두 모터 모두 도달했는지 확인 (true = 둘 다 도달)
void arm_moves_stop();                // 모터 1, 2 모두 즉시 정지 (CiA-402 Halt bit)
void arm_moves_off();