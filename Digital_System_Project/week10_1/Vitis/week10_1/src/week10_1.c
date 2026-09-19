#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "xparameters.h"
#include "xgpio.h"
#include "xscugic.h"
#include "xil_exception.h"
#include "xil_io.h"

// 1. 주소 및 ID 정의 (이미지 주소 맵 기준)
#define SEG_BASE_ADDR   0x43C00000  // APB 7-Seg 주소
#define BTN_GPIO_ID     XPAR_AXI_GPIO_0_DEVICE_ID
#define INTC_DEVICE_ID  XPAR_SCUGIC_SINGLE_DEVICE_ID
#define BTN_INTR_ID     XPAR_FABRIC_AXI_GPIO_0_IP2INTC_IRPT_INTR

XGpio BtnInstance;
XScuGic IntcInstance;

// 2. 버튼 인터럽트 핸들러 (버튼 클릭 시 즉시 7-Segment 끄기)
void BtnHandler(void *CallbackRef) {
    XGpio_InterruptClear(&BtnInstance, 1);
    Xil_Out32(SEG_BASE_ADDR, 0x00000000); // EN 비트를 모두 0으로 하여 끔
    printf("\r\n[Interrupt] Button Pressed! Display Cleared.\r\n");
}

// 3. 7-Segment 제어 함수 (문자열 분석 로직)
void Update7Seg(char *str) {
    u32 data = 0, dp = 0, en = 0;
    int seg_idx = 0;     // 0: AN0(우측 끝), 1: AN1, 2: AN2, 3: AN3(좌측 끝)
    int len = strlen(str);
    int dp_pending = 0;  // 소수점 발견 플래그

    // [핵심] 문자열을 뒤에서부터 거꾸로 읽습니다. (len-1부터 0까지)
    for (int i = len - 1; i >= 0 && seg_idx < 4; i--) {

        // 1. 소수점을 발견하면 플래그만 세우고 다음 문자로 넘어감
        if (str[i] == '.') {
            dp_pending = 1;
            continue;
        }

        // 2. 숫자인 경우 처리
        if (str[i] >= '0' && str[i] <= '9') {
            u32 val = str[i] - '0';

            // 해당 위치(seg_idx)에 숫자 배치 (4비트씩 shift)
            data |= (val << (seg_idx * 4));

            // 해당 자리 활성화
            en |= (1 << seg_idx);

            // 소수점 플래그가 서 있었다면, 현재 숫자에 소수점 적용
            if (dp_pending) {
                dp |= (1 << seg_idx);
                dp_pending = 0; // 플래그 초기화
            }

            seg_idx++; // 다음 세그먼트 위치로 이동
        }
    }

    // [23:20] En, [19:16] DP, [15:0] Data 포맷으로 전송
    u32 final_reg = (en << 20) | (dp << 16) | (data & 0xFFFF);
    Xil_Out32(SEG_BASE_ADDR, final_reg);
}

// 4. 인터럽트 시스템 설정 함수
int SetupInterruptSystem() {
    XScuGic_Config *IntcConfig = XScuGic_LookupConfig(INTC_DEVICE_ID);
    XScuGic_CfgInitialize(&IntcInstance, IntcConfig, IntcConfig->CpuBaseAddress);

    Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT, (Xil_ExceptionHandler)XScuGic_InterruptHandler, &IntcInstance);
    Xil_ExceptionEnable();

    XScuGic_Connect(&IntcInstance, BTN_INTR_ID, (Xil_ExceptionHandler)BtnHandler, &BtnInstance);
    XScuGic_Enable(&IntcInstance, BTN_INTR_ID);

    XGpio_InterruptEnable(&BtnInstance, 1);
    XGpio_InterruptGlobalEnable(&BtnInstance);

    return 0;
}

int main() {
    char input_buf[20];

    printf("--- APB 7-Segment Controller Started ---\r\n");

    // 초기화
    XGpio_Initialize(&BtnInstance, BTN_GPIO_ID);
    SetupInterruptSystem();

    while (1) {
		// 1. 출력 앞에 \r\n을 두 번 정도 넣어 이전 출력과 확실히 분리합니다.
		printf("\r\n\r\nEnter Number (Max 4 digits): ");

		// 2. 입력을 받습니다.
		if (scanf("%s", input_buf) == 1) {
		// 입력을 받자마자 터미널 커서를 다음 줄로 강제 이동
			printf("\r\n");

			Update7Seg(input_buf);

			// 3. 입력 성공 후 확인 메시지를 출력하여 커서 위치를 정리합니다.
			printf(">> Displaying: %s\r\n", input_buf);
		}

		// 4. [중요] 입력 버퍼 비우기
		// scanf 후에 남아있는 잔여 문자나 엔터키를 청소하여 다음 입력 시 꼬임을 방지합니다.
		fflush(stdin);
        }

    return 0;
}
