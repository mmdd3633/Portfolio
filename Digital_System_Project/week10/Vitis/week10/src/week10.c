#include <stdio.h>
#include "xparameters.h"
#include "xil_printf.h"
#include "xil_io.h"

// Vivado Address Editor에서 확인된 주소 (0x43C0_0000)
#define APB_BASE_ADDR   0x43C00000
#define MONO_LED_REG    (APB_BASE_ADDR + 0x00)
#define COLOR_LED_0_REG (APB_BASE_ADDR + 0x04)
#define COLOR_LED_1_REG (APB_BASE_ADDR + 0x08)
#define SW_STATUS_REG   (APB_BASE_ADDR + 0x0C)

int main() {
    int menu_choice;
    int led_num, color_num, op_mode;
    u32 current_val;

    // 초기화: 모든 LED 끄기
    Xil_Out32(MONO_LED_REG, 0x0);
    Xil_Out32(COLOR_LED_0_REG, 0x0);
    Xil_Out32(COLOR_LED_1_REG, 0x0);

    while (1) {
        // 메인 메뉴 출력
        xil_printf("\r\n===== APB Peripheral Test Menu =====\r\n");
        xil_printf("1. Mono LED Control\r\n");
        xil_printf("2. Color LED 0 Control\r\n");
        xil_printf("3. Color LED 1 Control\r\n");
        xil_printf("4. Switch Status Read\r\n");
        xil_printf("Select Menu : ");

        // 숫자가 아닌 입력 시 예외 처리
        if (scanf("%d", &menu_choice) != 1) {
            char c;
            while ((c = getchar()) != '\n' && c != '\r' && c != EOF);
            continue;
        }
        xil_printf("\r\n"); // 입력 후 줄바꿈만 수행 (숫자 중복 출력 제거)

        switch (menu_choice) {
            case 1: // 단색 LED 제어
                xil_printf("Select Mono LED Number (0~9) : ");
                if (scanf("%d", &led_num) != 1) break;
                xil_printf("\r\nSelect Operation (1: ON, 0: OFF) : ");
                if (scanf("%d", &op_mode) != 1) break;
                xil_printf("\r\n");

                if (led_num >= 0 && led_num <= 9) {
                    current_val = Xil_In32(MONO_LED_REG); // 기존 상태 유지
                    if (op_mode == 1) current_val |= (1 << led_num);
                    else current_val &= ~(1 << led_num);
                    Xil_Out32(MONO_LED_REG, current_val);
                }
                break;

            case 2: // 컬러 LED 0 제어
                xil_printf("Select Color (0: Red, 1: Green, 2: Blue) : ");
                if (scanf("%d", &color_num) != 1) break;
                xil_printf("\r\nSelect Operation (1: ON, 0: OFF) : ");
                if (scanf("%d", &op_mode) != 1) break;
                xil_printf("\r\n");

                if (color_num >= 0 && color_num <= 2) {
                    current_val = Xil_In32(COLOR_LED_0_REG); // 기존 상태 유지
                    if (op_mode == 1) current_val |= (1 << color_num);
                    else current_val &= ~(1 << color_num);
                    Xil_Out32(COLOR_LED_0_REG, current_val);
                }
                break;

            case 3: // 컬러 LED 1 제어
                xil_printf("Select Color (0: Red, 1: Green, 2: Blue) : ");
                if (scanf("%d", &color_num) != 1) break;
                xil_printf("\r\nSelect Operation (1: ON, 0: OFF) : ");
                if (scanf("%d", &op_mode) != 1) break;
                xil_printf("\r\n");

                if (color_num >= 0 && color_num <= 2) {
                    current_val = Xil_In32(COLOR_LED_1_REG); // 기존 상태 유지
                    if (op_mode == 1) current_val |= (1 << color_num);
                    else current_val &= ~(1 << color_num);
                    Xil_Out32(COLOR_LED_1_REG, current_val);
                }
                break;

            case 4: // 스위치 상태 읽기
                current_val = Xil_In32(SW_STATUS_REG);
                xil_printf("SW_STATUS = 0x%03X\r\n", current_val);
                break;

            default:
                xil_printf("Invalid Selection!\r\n");
                break;
        }
    }
    return 0;
}
