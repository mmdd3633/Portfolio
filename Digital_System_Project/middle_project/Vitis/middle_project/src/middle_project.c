#include <stdio.h>
#include "xparameters.h"
#include "xgpio.h"
#include "xscugic.h"
#include "xuartps.h"
#include "sleep.h"
#include "xil_exception.h"
#include "xil_printf.h"

// [1] 하드웨어 ID 설정
#define GPIO_SEG_ID     XPAR_AXI_GPIO_0_DEVICE_ID
#define GPIO_BTN_ID     XPAR_AXI_GPIO_1_DEVICE_ID
#define INTC_DEVICE_ID  XPAR_SCUGIC_SINGLE_DEVICE_ID
#define UART_BASEADDR   XPAR_PS7_UART_1_BASEADDR
#define BTN_INTR_ID     XPAR_FABRIC_AXI_GPIO_1_IP2INTC_IRPT_INTR

// [2] 전역 변수
XGpio GpioSeg;
XGpio GpioBtn;
XScuGic Intc;
volatile int display_off = 0;
u8 seg_code[10] = {0xC0, 0xF9, 0xA4, 0xB0, 0x99, 0x92, 0x82, 0xF8, 0x80, 0x90};

// [3] 인터럽트 서비스 루틴 (ISR) - 디바운싱 + 중복 출력 방지
void ButtonHandler(void *CallbackRef) {
    XGpio *GpioPtr = (XGpio *)CallbackRef;

    // 하드웨어 인터럽트 잠시 차단 (채터링 노이즈 방지)
    XGpio_InterruptDisable(GpioPtr, 0xF);

    // 물리적 떨림이 멈출 때까지 대기
    usleep(50000);

    // 이미 꺼진 상태면 메시지 중복 출력 안 함
    if (display_off == 0) {
        display_off = 1;
        xil_printf("\r\n\n************************************************\r\n");
        xil_printf(" [WARNING] EXTERNAL INTERRUPT DETECTED!!\r\n");
        xil_printf("  - 7-Segment Display is now OFF.\r\n");
        xil_printf("  - To resume, type numbers and press Enter.\r\n");
        xil_printf("************************************************\r\n\n");
        xil_printf("Press Input Number and Enter: ");
    }

    // 쌓인 가짜 신호 청소 후 다시 인터럽트 활성화
    XGpio_InterruptClear(GpioPtr, 0xF);
    XGpio_InterruptEnable(GpioPtr, 0xF);
}

// 인터럽트 설정 함수
int SetupInterruptSystem() {
    XScuGic_Config *IntcConfig = XScuGic_LookupConfig(INTC_DEVICE_ID);
    XScuGic_CfgInitialize(&Intc, IntcConfig, IntcConfig->CpuBaseAddress);
    Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT, (Xil_ExceptionHandler)XScuGic_InterruptHandler, &Intc);
    Xil_ExceptionEnable();
    XScuGic_Connect(&Intc, BTN_INTR_ID, (Xil_ExceptionHandler)ButtonHandler, &GpioBtn);
    XGpio_InterruptEnable(&GpioBtn, 0xF);
    XGpio_InterruptGlobalEnable(&GpioBtn);
    XScuGic_Enable(&Intc, BTN_INTR_ID);
    return XST_SUCCESS;
}

// [4] 메인 로직
int main() {
    int digits[4] = {0};
    int dp_pos = 4, digit_count = 0, current_digit = 0;
    char input_buffer[10];
    int buf_idx = 0, apply_flag = 0;

    XGpio_Initialize(&GpioSeg, GPIO_SEG_ID);
    XGpio_Initialize(&GpioBtn, GPIO_BTN_ID);
    XGpio_SetDataDirection(&GpioSeg, 1, 0x00); // Cathode Output
    XGpio_SetDataDirection(&GpioSeg, 2, 0x0);  // Anode Output
    XGpio_SetDataDirection(&GpioBtn, 1, 0xF);  // Button Input
    SetupInterruptSystem();

    xil_printf("\r\n\n================================================\r\n");
    xil_printf(" 4-Digit 7-Segment System (All Features Integrated)\r\n");
    xil_printf("================================================\r\n\n");
    xil_printf("Press Input Number and Enter: ");

    XGpio_DiscreteWrite(&GpioSeg, 2, 0xF); // 초기 꺼짐

    while (1) {
        // A. UART 수신 (백스페이스/에코 포함)
        if (XUartPs_IsReceiveData(UART_BASEADDR)) {
            u8 c = XUartPs_ReadReg(UART_BASEADDR, XUARTPS_FIFO_OFFSET);
            if (c == '\r' || c == '\n') {
                if (buf_idx > 0) { apply_flag = 1; xil_printf("\r\n[SUCCESS] Applied.\r\n\nPress Input Number and Enter: "); }
            } else if (c == '\b' || c == 0x7F) {
                if (buf_idx > 0) { buf_idx--; xil_printf("\b \b"); }
            } else if ((c >= '0' && c <= '9') || c == '.') {
                if (buf_idx < 9) { input_buffer[buf_idx++] = c; xil_printf("%c", c); }
            }
        }

        // B. 엔터 시 데이터 적용
        if (apply_flag) {
            digit_count = 0; dp_pos = 4; display_off = 0;
            for(int i=0; i<4; i++) digits[i] = 0;
            for (int i = 0; i < buf_idx; i++) {
                char c = input_buffer[i];
                if (c >= '0' && c <= '9' && digit_count < 4) {
                    digits[3]=digits[2]; digits[2]=digits[1]; digits[1]=digits[0]; digits[0]=c-'0';
                    if (dp_pos < 4) dp_pos++;
                    digit_count++;
                } else if (c == '.') dp_pos = 0;
            }
            buf_idx = 0; apply_flag = 0;
        }

        // C. 7-Segment 시분할 출력
        if (display_off || digit_count == 0) {
            XGpio_DiscreteWrite(&GpioSeg, 2, 0xF);
        } else {
            if (current_digit >= digit_count) current_digit = 0;
            u32 anode = ~(1 << current_digit) & 0xF;
            u8 cathode = seg_code[digits[current_digit]];
            if (dp_pos == current_digit) cathode &= ~0x80;

            XGpio_DiscreteWrite(&GpioSeg, 2, 0xF); // Ghosting 방지
            XGpio_DiscreteWrite(&GpioSeg, 1, cathode);
            XGpio_DiscreteWrite(&GpioSeg, 2, anode);
            current_digit++;
        }
        usleep(2000);
    }
    return 0;
}
