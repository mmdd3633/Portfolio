#include <stdio.h>
#include "xil_io.h"

// ==============================================================================
// 1. Base Address 정의 (Vivado 64KB 제한 문제 해결)
// AXI APB Bridge의 기본 주소가 0x43C00000일 때, 하위 비트로 쪼개서 사용
// ==============================================================================
#define SYS_BASE        0x43C00000
#define TIMER_BASE      (SYS_BASE + 0x0000)
#define BTN_BASE        (SYS_BASE + 0x1000)
#define LED_BASE        (SYS_BASE + 0x2000)
#define SEG_BASE        (SYS_BASE + 0x3000)

// 레지스터 오프셋
#define ADDR_CTRL       0x00
#define ADDR_DATA       0x04

// ==============================================================================
// 2. 시스템 상태(State) 정의
// ==============================================================================
typedef enum { STOP, RUN } SysState;
typedef enum { NORMAL, LAP } LapState;
typedef enum { DISP_OFF, DISP_ON } DispState;

// ==============================================================================
// 3. Helper 함수: 정수(0~9999)를 16비트 BCD 포맷으로 변환
// ==============================================================================
uint32_t dec2bcd(uint32_t dec) {
    uint32_t d4 = (dec / 1000) % 10;
    uint32_t d3 = (dec / 100) % 10;
    uint32_t d2 = (dec / 10) % 10;
    uint32_t d1 = dec % 10;

    return (d4 << 12) | (d3 << 8) | (d2 << 4) | d1;
}

int main() {
    // 상태 변수 초기화
    SysState sys_state   = STOP;
    LapState lap_state   = NORMAL;
    DispState disp_state = DISP_ON;

    // 시간 측정 변수 (단위: 10ms)
    uint32_t time_val = 0;
    uint32_t lap_val  = 0;

    // 타이머 및 LED 애니메이션 제어 변수
    uint32_t prev_hw_timer = 0;
    uint32_t curr_hw_timer = 0;
    uint32_t blink_counter = 0;

    printf("--- APB Stopwatch System Started (Final Ver) ---\r\n");

    // 초기화: 하드웨어 모듈 Enable
    Xil_Out32(TIMER_BASE + ADDR_CTRL, 0x01);
    Xil_Out32(SEG_BASE + ADDR_CTRL, 0x01);
    Xil_Out32(LED_BASE + ADDR_CTRL, 0x00);

    prev_hw_timer = Xil_In32(TIMER_BASE + ADDR_DATA);

    // ==========================================================================
    // 메인 무한 루프
    // ==========================================================================
    while(1) {
        // ----------------------------------------------------------------------
        // [1] 버튼 입력 처리
        // ----------------------------------------------------------------------
        uint32_t btn_events = Xil_In32(BTN_BASE + ADDR_DATA);

        if (btn_events != 0) {
            // BTN0: Start / Stop Toggle
            if (btn_events & 0x01) {
                sys_state = (sys_state == STOP) ? RUN : STOP;
            }

            // BTN1: Reset
            if (btn_events & 0x02) {
                time_val  = 0;
                lap_val   = 0;
                sys_state = STOP;
                lap_state = NORMAL;
                blink_counter = 0;
            }

            // BTN2: Lap / Hold Toggle
            if (btn_events & 0x04) {
                if (lap_state == NORMAL) {
                    lap_val = time_val;
                    lap_state = LAP;
                } else {
                    lap_state = NORMAL;
                }
            }

            // BTN3: Display On / Off Toggle
            if (btn_events & 0x08) {
                disp_state = (disp_state == DISP_ON) ? DISP_OFF : DISP_ON;
                Xil_Out32(SEG_BASE + ADDR_CTRL, (disp_state == DISP_ON) ? 0x01 : 0x00);
            }

            // 이벤트 클리어
            Xil_Out32(BTN_BASE + ADDR_DATA, btn_events);
        }

        // ----------------------------------------------------------------------
        // [2] 스탑워치 시간 업데이트 로직
        // ----------------------------------------------------------------------
        curr_hw_timer = Xil_In32(TIMER_BASE + ADDR_DATA);

        if (curr_hw_timer != prev_hw_timer) {
            uint32_t delta = curr_hw_timer - prev_hw_timer;

            // 일시정지(STOP) 상태일 때는 시간이 절대 가지 않음!
            if (sys_state == RUN) {
                time_val += delta;
                if (time_val > 9999) {
                    time_val = time_val % 10000;
                }
                blink_counter += delta;
            }
            prev_hw_timer = curr_hw_timer;
        }

        // ----------------------------------------------------------------------
        // [3] 7-Segment 디스플레이 업데이트
        // ----------------------------------------------------------------------
        if (disp_state == DISP_ON) {
            uint32_t display_val = (lap_state == LAP) ? lap_val : time_val;
            Xil_Out32(SEG_BASE + ADDR_DATA, dec2bcd(display_val));
        }

        // ----------------------------------------------------------------------
        // [4] 파도타기 LED 제어 로직
        // ----------------------------------------------------------------------
        uint32_t led_status = 0x00;

        if (sys_state == RUN) {
            // 100ms 간격으로 파도처럼 왔다갔다 함
            int wave_step = (blink_counter / 10) % 6;

            switch (wave_step) {
                case 0: led_status = 0x01; break; // [O X X X]
                case 1: led_status = 0x02; break; // [X O X X]
                case 2: led_status = 0x04; break; // [X X O X]
                case 3: led_status = 0x08; break; // [X X X O]
                case 4: led_status = 0x04; break; // [X X O X]
                case 5: led_status = 0x02; break; // [X O X X]
                default: led_status = 0x00; break;
            }
        }
        else if (sys_state == STOP) {
            led_status = 0x00; // 정지 시 소등
        }

        // LAP 모드일 때는 전체 깜빡임
        if (lap_state == LAP) {
            if ((blink_counter / 25) % 2 == 0) {
                led_status = 0x0F;
            } else {
                led_status = 0x00;
            }
        }

        Xil_Out32(LED_BASE + ADDR_CTRL, led_status);
    }

    return 0;
}
