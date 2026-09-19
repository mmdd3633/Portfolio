//#include <stdio.h>
//#include "xparameters.h"
//#include "xgpio.h"
//#include "xil_printf.h"
//
//#define GPIO_DEVICE_ID  XPAR_AXI_GPIO_0_DEVICE_ID
//#define RGB_CH 1
//
//XGpio Gpio;
//
//int main() {
//    int r_val = 0, g_val = 0, b_val = 0;
//    u32 combined_rgb = 0;
//
//    if (XGpio_Initialize(&Gpio, GPIO_DEVICE_ID) != XST_SUCCESS) return XST_FAILURE;
//    XGpio_SetDataDirection(&Gpio, RGB_CH, 0x0);
//
//    xil_printf("\r\n--- RGB LED Control System ---\r\n");
//
//    while(1) {
//        // Red 입력
//        xil_printf("Enter Red (0-255): ");
//        if (scanf("%d", &r_val) != 1) {
//            while(getchar() != '\n'); // 잘못된 입력 시 버퍼 강제 비우기
//            continue;
//        }
//        while(getchar() != '\n'); // 숫자 뒤의 엔터 키 제거
//
//        // Green 입력
//        xil_printf("Enter Green (0-255): ");
//        scanf("%d", &g_val);
//        while(getchar() != '\n');
//
//        // Blue 입력
//        xil_printf("Enter Blue (0-255): ");
//        scanf("%d", &b_val);
//        while(getchar() != '\n');
//
//        // 범위 제한
//        if(r_val > 255) r_val = 255; else if(r_val < 0) r_val = 0;
//        if(g_val > 255) g_val = 255; else if(g_val < 0) g_val = 0;
//        if(b_val > 255) b_val = 255; else if(b_val < 0) b_val = 0;
//
//        // 비트 결합 및 전송
//        combined_rgb = ((u32)r_val << 16) | ((u32)g_val << 8) | (u32)b_val;
//        XGpio_DiscreteWrite(&Gpio, RGB_CH, combined_rgb);
//
//        xil_printf(">> SET RGB: %d, %d, %d (Hex: 0x%06X)\r\n\n", r_val, g_val, b_val, combined_rgb);
//    }
//    return 0;
//}


#include <stdio.h>
#include "xparameters.h"
#include "xgpio.h"
#include "xil_printf.h"

#define GPIO_DEVICE_ID  XPAR_AXI_GPIO_0_DEVICE_ID
#define RGB_CH 1

XGpio Gpio;

// 정수 연산을 이용한 제곱 방식 감마 보정 (Vout = Vin^2 / 255)
u8 gamma_correct(int value) {
    // 0~255 사이의 값을 제곱하면 최대 65,025이므로 32비트 정수형으로 충분히 계산 가능
    u32 corrected = (u32)value * (u32)value;
    return (u8)(corrected / 255);
}

int main() {
    int r_in = 0, g_in = 0, b_in = 0;
    u8 r_cor, g_cor, b_cor;
    u32 combined_rgb = 0;

    if (XGpio_Initialize(&Gpio, GPIO_DEVICE_ID) != XST_SUCCESS) return XST_FAILURE;
    XGpio_SetDataDirection(&Gpio, RGB_CH, 0x0);

    xil_printf("\r\n--- RGB LED Control (Integer Gamma: V^2/255) ---\r\n");

    while(1) {
        xil_printf("Enter Red (0-255): ");
        if (scanf("%d", &r_in) != 1) { while(getchar() != '\n'); continue; }
        while(getchar() != '\n');

        xil_printf("Enter Green (0-255): ");
        scanf("%d", &g_in);
        while(getchar() != '\n');

        xil_printf("Enter Blue (0-255): ");
        scanf("%d", &b_in);
        while(getchar() != '\n');

        // 범위 제한
        if(r_in > 255) r_in = 255; else if(r_in < 0) r_in = 0;
        if(g_in > 255) g_in = 255; else if(g_in < 0) g_in = 0;
        if(b_in > 255) b_in = 255; else if(b_in < 0) b_in = 0;

        // 제곱 방식 감마 보정 적용
        r_cor = gamma_correct(r_in);
        g_cor = gamma_correct(g_in);
        b_cor = gamma_correct(b_in);

        // 24비트 결합: Red[23:16], Green[15:8], Blue[7:0]
        combined_rgb = ((u32)r_cor << 16) | ((u32)g_cor << 8) | (u32)b_cor;
        XGpio_DiscreteWrite(&Gpio, RGB_CH, combined_rgb);

        xil_printf("\r\n[Gamma Corrected Result]\r\n");
        xil_printf("Input  -> R:%d, G:%d, B:%d\r\n", r_in, g_in, b_in);
        xil_printf("Output -> R:%d, G:%d, B:%d (Hex: 0x%06X)\r\n\n", r_cor, g_cor, b_cor, combined_rgb);
    }
    return 0;
}
