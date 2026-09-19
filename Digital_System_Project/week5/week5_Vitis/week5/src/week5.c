#include <stdio.h>
#include "xparameters.h"
#include "xgpio.h"
#include "xil_printf.h"

// 하드웨어 주소 및 채널 설정
#define GPIO_DEVICE_ID  XPAR_AXI_GPIO_0_DEVICE_ID
#define RGB_CH 1

XGpio Gpio;

int main() {
    int r_val = 0;
    u32 combined_rgb = 0; // 초기화

    // AXI GPIO 초기화
    if (XGpio_Initialize(&Gpio, GPIO_DEVICE_ID) != XST_SUCCESS) {
        return XST_FAILURE;
    }

    // GPIO 방향 설정 (출력: 0)
    XGpio_SetDataDirection(&Gpio, RGB_CH, 0x0);

    xil_printf("\r\n==========================================\r\n");
    xil_printf("   LD10 RED LED Intensity Control (0-255)   \r\n");
    xil_printf("==========================================\r\n");

    while(1) {
        xil_printf("Enter Red Value: ");

        // 1. 숫자 입력 받기
        if (scanf("%d", &r_val) == 1) {

            // 2. 입력 범위 제한 (0~255)
            if(r_val > 255) r_val = 255;
            if(r_val < 0) r_val = 0;

            // 3. 시프트 없이 값 그대로 대입 (비트 정렬 제거)
            combined_rgb = (u32)r_val;

            // 4. AXI GPIO 출력 쓰기
            XGpio_DiscreteWrite(&Gpio, RGB_CH, combined_rgb);

            xil_printf(">> Set Red to: %d (Hex: 0x%08X)\r\n", r_val, combined_rgb);
        }

        // 5. Tera Term 입력 버퍼(엔터 키 등) 초기화
        getchar();
    }

    return 0;
}
