/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp) -> baud rate
 */

//#include <stdio.h>
//#include "platform.h"
//#include "xil_printf.h"
//
//
//int main()
//{
//    init_platform();
//
//    print("Hello World\n\r");
//    print("Successfully ran Hello World application");
//    cleanup_platform();
//    return 0;
//}

/******************************************************************************
 * Zynq PS MIO GPIO 제어 실습 코드
 * 대상 칩: Zynq-7000S (xc7z007s)
 * 제어 대상: PS MIO 16번 핀 (RGB Blue LED)
 * 설명: MIO 16번 핀을 출력으로 설정하고 High(1) 신호를 주어 파란색 LED를 켭니다.
 ******************************************************************************/

//#include "xparameters.h"  // 하드웨어 파라미터 정보
//#include "xgpiops.h"      // Zynq PS GPIO 제어를 위한 전용 API 헤더
//#include "xil_printf.h"   // 시리얼 터미널 출력용 헤더
//
//// xparameters.h에 정의된 PS GPIO의 Device ID
//#define GPIO_DEVICE_ID      XPAR_XGPIOPS_0_DEVICE_ID
//// 제어하고자 하는 정확한 MIO 핀 번호 지정 (16: Blue, 17: Red, 18: Green - 수정 필요)
//#define MIO_LED_BLUE_PIN    18
//
//XGpioPs Gpio_Inst;
//
//int main(void) {
//    int Status;
//    XGpioPs_Config *ConfigPtr;
//
//    xil_printf("--- PS MIO 16번(Blue LED) 제어 프로그램을 시작합니다 ---\r\n");
//
//    // 1단계: PS GPIO 하드웨어 설정 검색
//    ConfigPtr = XGpioPs_LookupConfig(GPIO_DEVICE_ID);
//    if (ConfigPtr == NULL) {
//        xil_printf("오류: PS GPIO 설정 정보를 찾을 수 없습니다!\r\n");
//        return XST_FAILURE;
//    }
//    // 2단계: PS GPIO 초기화 
//    Status = XGpioPs_CfgInitialize(&Gpio_Inst, ConfigPtr, ConfigPtr->BaseAddr);
//    if (Status != XST_SUCCESS) {
//        xil_printf("오류: PS GPIO 초기화에 실패했습니다!\r\n");
//        return XST_FAILURE;
//    }
//    xil_printf("PS GPIO 초기화 성공.\r\n");
//
//    // 3단계: 핀 입출력 방향 설정
//    XGpioPs_SetDirectionPin(&Gpio_Inst, MIO_LED_BLUE_PIN, 1);
//    // 4단계: 핀 출력 활성화
//    XGpioPs_SetOutputEnablePin(&Gpio_Inst, MIO_LED_BLUE_PIN, 1);
//    xil_printf("MIO 16번 핀 출력 설정 완료.\r\n");
//    // 5단계: 핀에 High 신호 출력
//    xil_printf("MIO 16번 핀에 High(1) 신호를 출력하여 Blue LED를 켭니다.\r\n");
//    XGpioPs_WritePin(&Gpio_Inst, MIO_LED_BLUE_PIN, 1);
//
//    xil_printf("프로그램 동작 완료.\r\n");
//    // 프로그램이 바로 종료되지 않도록 무한 대기
//    while (1) {
//    }
//
//    return XST_SUCCESS;
//}

/******************************************************************************
 * Zynq PS MIO GPIO 제어: RGB LED 주기적 색상 변경 실습
 * 대상 칩: Zynq-7000S (xc7z007s)
 * 제어 대상: PS MIO 핀 (RGB LED)
 * 설명: 무한 루프와 딜레이 함수를 사용하여 여러 색상을 주기적으로 변경합니다.
 ******************************************************************************/

#include "xparameters.h"  // 하드웨어 파라미터 정보
#include "xgpiops.h"      // Zynq PS GPIO 제어를 위한 전용 API 헤더
#include "xil_printf.h"   // 시리얼 터미널 출력용 헤더
#include "sleep.h"        // 주기적인 시간 지연을 주기 위한 헤더

// xparameters.h에 정의된 PS GPIO의 Device ID
#define GPIO_DEVICE_ID      XPAR_XGPIOPS_0_DEVICE_ID

// RGB LED가 연결된 MIO 핀 번호 정의
#define MIO_LED_BLUE_PIN    16
#define MIO_LED_RED_PIN     17
#define MIO_LED_GREEN_PIN   18

// PS GPIO 하드웨어를 제어하기 위한 인스턴스 구조체 선언
XGpioPs Gpio_Inst;

int main(void) {
    int Status;
    XGpioPs_Config *ConfigPtr;

    xil_printf("--- RGB LED 주기적 색상 변경 프로그램을 시작합니다 ---\r\n");

    // 1. PS GPIO 초기화 및 하드웨어 설정
    ConfigPtr = XGpioPs_LookupConfig(GPIO_DEVICE_ID);
    if (ConfigPtr == NULL) {
        xil_printf("오류: PS GPIO 설정 정보를 찾을 수 없습니다!\r\n");
        return XST_FAILURE;
    }

    Status = XGpioPs_CfgInitialize(&Gpio_Inst, ConfigPtr, ConfigPtr->BaseAddr);
    if (Status != XST_SUCCESS) {
        xil_printf("오류: PS GPIO 초기화에 실패했습니다!\r\n");
        return XST_FAILURE;
    }

    // 2. 핀 입출력 방향 및 활성화 설정
    // 3개의 핀을 모두 출력(1) 방향으로 설정
    XGpioPs_SetDirectionPin(&Gpio_Inst, MIO_LED_RED_PIN, 1);
    XGpioPs_SetDirectionPin(&Gpio_Inst, MIO_LED_GREEN_PIN, 1);
    XGpioPs_SetDirectionPin(&Gpio_Inst, MIO_LED_BLUE_PIN, 1);

    // 3개의 핀 모두 출력 활성화(1)
    XGpioPs_SetOutputEnablePin(&Gpio_Inst, MIO_LED_RED_PIN, 1);
    XGpioPs_SetOutputEnablePin(&Gpio_Inst, MIO_LED_GREEN_PIN, 1);
    XGpioPs_SetOutputEnablePin(&Gpio_Inst, MIO_LED_BLUE_PIN, 1);

    xil_printf("MIO 핀 설정 완료. 색상 순환을 시작합니다.\r\n\n");

    // 3. 무한 루프를 이용한 주기적 색상 변경
    while (1) {
        // 빨간색 (Red)
        xil_printf("current color : red\r\n");
        XGpioPs_WritePin(&Gpio_Inst, MIO_LED_RED_PIN, 1);   // Red ON
        XGpioPs_WritePin(&Gpio_Inst, MIO_LED_GREEN_PIN, 0); // Green OFF
        XGpioPs_WritePin(&Gpio_Inst, MIO_LED_BLUE_PIN, 0);  // Blue OFF
        sleep(1); // 1초 동안 현재 상태 유지

        // 녹색 (Green)
        xil_printf("current color : green\r\n");
        XGpioPs_WritePin(&Gpio_Inst, MIO_LED_RED_PIN, 0);
        XGpioPs_WritePin(&Gpio_Inst, MIO_LED_GREEN_PIN, 1);
        XGpioPs_WritePin(&Gpio_Inst, MIO_LED_BLUE_PIN, 0);
        sleep(1);

        // 파란색 (Blue)
        xil_printf("current color : Blue\r\n");
        XGpioPs_WritePin(&Gpio_Inst, MIO_LED_RED_PIN, 0);
        XGpioPs_WritePin(&Gpio_Inst, MIO_LED_GREEN_PIN, 0);
        XGpioPs_WritePin(&Gpio_Inst, MIO_LED_BLUE_PIN, 1);
        sleep(1);
    }

    return XST_SUCCESS;
}
