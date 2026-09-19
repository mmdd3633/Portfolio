#include "xparameters.h"
#include "xgpio.h"
#include "sleep.h"
#include "xil_printf.h"

// 채널은 기본적으로 1을 사용한다.
#define LED_CHANNEL 1
#define BTN_CHANNEL 1
#define SW_CHANNEL  1

// xparameters.h에 정의된 Device ID를 매핑한다.
#define GPIO_LED_ID XPAR_AXI_GPIO_0_DEVICE_ID
#define GPIO_BTN_ID XPAR_AXI_GPIO_1_DEVICE_ID
#define GPIO_SW_ID  XPAR_AXI_GPIO_2_DEVICE_ID

// GPIO 인스턴스 선언
XGpio Gpio_Led, Gpio_Btn, Gpio_Sw;

int main() {
    int Status;

    // 1. GPIO 초기화
    Status = XGpio_Initialize(&Gpio_Led, GPIO_LED_ID);
    if (Status != XST_SUCCESS) { xil_printf("LED GPIO Init Failed\r\n"); return XST_FAILURE; }

    Status = XGpio_Initialize(&Gpio_Btn, GPIO_BTN_ID);
    if (Status != XST_SUCCESS) { xil_printf("BTN GPIO Init Failed\r\n"); return XST_FAILURE; }

    Status = XGpio_Initialize(&Gpio_Sw, GPIO_SW_ID);
    if (Status != XST_SUCCESS) { xil_printf("SW GPIO Init Failed\r\n"); return XST_FAILURE; }

    // 2. GPIO 입출력 방향 설정 (0: Output, 1: Input)
    XGpio_SetDataDirection(&Gpio_Led, LED_CHANNEL, 0x0000); // LED는 모두 출력
    XGpio_SetDataDirection(&Gpio_Btn, BTN_CHANNEL, 0xFFFF); // Button은 모두 입력
    XGpio_SetDataDirection(&Gpio_Sw, SW_CHANNEL, 0xFFFF);  // Switch는 모두 입력

    xil_printf("\r\n========================================\r\n");
    xil_printf(" 디지털 시스템 설계: LED 패턴 실습\r\n");
    xil_printf("========================================\r\n");

    int speed_level = 5;       // 초기 속도 단계
    const int max_speed = 10;
    const int min_speed = 1;
    int delay_ms = 300;

    int step = 0;              // 패턴의 현재 단계를 나타내는 카운터
    u32 led_out = 0;           // LED에 출력할 값
    u32 prev_btn = 0;          // 이전 버튼 상태 (엣지 검출용)
    u32 prev_sw_val = 0xFF;    // 이전 스위치 상태 (상태 변경 출력용, 초기값은 더미 데이터)
    int mod_step = 0;          // 각 패턴별 주기 계산용 변수

    // 테트리스 패턴을 위한 상태 저장 변수
    u32 stacked_leds = 0;
    int drop_pos = 9;

    while (1) {
        // 3. 스위치 및 버튼 입력 읽기
        u32 sw_val = XGpio_DiscreteRead(&Gpio_Sw, SW_CHANNEL) & 0x03;
        u32 btn_val = XGpio_DiscreteRead(&Gpio_Btn, BTN_CHANNEL) & 0x03;

        // 버튼 엣지 검출 (Rising Edge)
        u32 btn_pressed = btn_val & ~prev_btn;
        prev_btn = btn_val;

        if (sw_val != prev_sw_val) {
            prev_sw_val = sw_val;
            xil_printf("\r\n[Pattern Changed] ");
            switch(sw_val) {
                case 0: xil_printf("Mode 0 : Police Strobe\r\n"); break;
                case 1: xil_printf("Mode 1 : Criss-Cross\r\n"); break;
                case 2: xil_printf("Mode 2 : 3-LED Worm\r\n"); break;
                case 3: xil_printf("Mode 3 : Tetris Cascade\r\n"); break;
            }
            xil_printf("Current Speed : Level %d\r\n", speed_level);
        }

        // 4. 속도 제어 로직 (버튼 입력 처리)
        if (btn_pressed & 0x01) { // 느리게
            if (speed_level > min_speed) {
                speed_level--;
                xil_printf("[Speed Down] Current Speed : Level %d\r\n", speed_level);
            }
        }
        if (btn_pressed & 0x02) { // 빠르게
            if (speed_level < max_speed) {
                speed_level++;
                xil_printf("[Speed Up] Current Speed : Level %d\r\n", speed_level);
            }
        }

        delay_ms = 520 - (speed_level * 50); // Level 1 (500ms) ~ Level 10 (50ms)

        // 5. 스위치 입력에 따른 화려한 LED 패턴 생성
        switch(sw_val) {
            case 0:
                mod_step = step % 8;
                if (mod_step < 4) {
                    led_out = (mod_step % 2 == 0) ? 0x3E0 : 0x000;
                } else {
                    led_out = (mod_step % 2 == 0) ? 0x01F : 0x000;
                }
                stacked_leds = 0; drop_pos = 9;
                break;

            case 1:
                mod_step = step % 18;
                int pos = (mod_step < 10) ? mod_step : (18 - mod_step);
                led_out = (1 << pos) | (1 << (9 - pos));
                stacked_leds = 0; drop_pos = 9;
                break;

            case 2:
                mod_step = step % 16;
                int worm_pos = (mod_step < 8) ? mod_step : (15 - mod_step);
                led_out = (0x07 << worm_pos) & 0x3FF;
                stacked_leds = 0; drop_pos = 9;
                break;

            case 3:
                led_out = stacked_leds | (1 << drop_pos);
                if (drop_pos == 0 || (stacked_leds & (1 << (drop_pos - 1)))) {
                    stacked_leds |= (1 << drop_pos);
                    drop_pos = 9;
                    if (stacked_leds >= 0x3FF) stacked_leds = 0;
                } else {
                    drop_pos--;
                }
                break;
        }

        XGpio_DiscreteWrite(&Gpio_Led, LED_CHANNEL, led_out);

        // 6. 속도 조절 및 응답성 높은 딜레이
        for (int i = 0; i < delay_ms; i += 10) {
            btn_val = XGpio_DiscreteRead(&Gpio_Btn, BTN_CHANNEL) & 0x03;
            btn_pressed = btn_val & ~prev_btn;
            prev_btn = btn_val;

            if (btn_pressed & 0x01) {
                if (speed_level > min_speed) {
                    speed_level--;
                    xil_printf("[Speed Down] Current Speed : Level %d\r\n", speed_level);
                }
                break; // 상태 변경 시 딜레이 루프 즉시 탈출
            }
            if (btn_pressed & 0x02) {
                if (speed_level < max_speed) {
                    speed_level++;
                    xil_printf("[Speed Up] Current Speed : Level %d\r\n", speed_level);
                }
                break; // 상태 변경 시 딜레이 루프 즉시 탈출
            }
            usleep(10000);
        }

        step++;
    }

    return 0;
}
