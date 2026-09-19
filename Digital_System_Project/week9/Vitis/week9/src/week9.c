#include <stdio.h>
#include "xparameters.h"
#include "xil_io.h"
#include "sleep.h"

// Vivado Address Editor에서 할당한 APB_LED의 Base Address
#define APB_LED_BASE_ADDR 0x43C00000

// 제어할 레지스터 주소 (Base Address + Offset 0x00)
#define APB_LED_REG       (APB_LED_BASE_ADDR + 0x00)

int main() {
    u32 read_val = 0;

    xil_printf("\r\n=======================================\r\n");
    xil_printf("   APB LED Controller Verification\r\n");
    xil_printf("=======================================\r\n");

    // ----------------------------------------------------
    // Test 1: 전체 LED 켜기 (Write & Read 검증)
    // ----------------------------------------------------
    xil_printf("[Test 1] Turn ON All LEDs (0x3FF)...\r\n");
    Xil_Out32(APB_LED_REG, 0x3FF);     // 10비트 모두 1 (0011 1111 1111)

    // 방금 쓴 값을 다시 읽어와서 하드웨어 Read 로직 검증
    read_val = Xil_In32(APB_LED_REG);
    xil_printf(" -> Written: 0x3FF, Read Back: 0x%03X\r\n", read_val & 0x3FF);

    if ((read_val & 0x3FF) == 0x3FF) {
        xil_printf(" -> Read/Write TEST PASS!\r\n");
    } else {
        xil_printf(" -> Read/Write TEST FAIL!\r\n");
    }
    sleep(2); // 2초 대기

    // ----------------------------------------------------
    // Test 2: 전체 LED 끄기
    // ----------------------------------------------------
    xil_printf("\r\n[Test 2] Turn OFF All LEDs (0x000)...\r\n");
    Xil_Out32(APB_LED_REG, 0x000);
    read_val = Xil_In32(APB_LED_REG);
    xil_printf(" -> Written: 0x000, Read Back: 0x%03X\r\n", read_val & 0x3FF);
    sleep(1);

    // ----------------------------------------------------
    // Test 3: LED 시프트 패턴 (Visual Test)
    // ----------------------------------------------------
    xil_printf("\r\n[Test 3] Starting LED Shift Pattern...\r\n");

    for (int i = 0; i < 10; i++) {
        u32 pattern = (1 << i); // 0번째부터 9번째 LED까지 순차적으로 1을 시프트

        Xil_Out32(APB_LED_REG, pattern);
        read_val = Xil_In32(APB_LED_REG);

        xil_printf(" Shift [%d] - Write: 0x%03X / Read: 0x%03X\r\n", i, pattern, read_val & 0x3FF);

        // 0.2초 (200,000 마이크로초) 대기하여 눈으로 흐름을 확인할 수 있게 함
        usleep(200000);
    }

    // 테스트 종료 후 LED 소등
    Xil_Out32(APB_LED_REG, 0x000);
    xil_printf("\r\nVerification Complete.\r\n");

    return 0;
}
