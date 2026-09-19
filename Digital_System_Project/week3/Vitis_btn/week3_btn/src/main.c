#include "xparameters.h"  // 하드웨어 설정(Vivado)에서 생성된 ID 값들이 정의된 핵심 헤더 파일
#include "xgpio.h"        // Xilinx PL AXI GPIO 제어를 위한 전용 함수 라이브러리
#include "xil_printf.h"   // UART 터미널 출력을 위한 라이브러리

// 하드웨어 디바이스 ID 매크로 설정 - xparameters.h 파일에 정의된 두 개의 개별 AXI GPIO IP의 ID를 각각 매핑합니다.
#define LED_DEVICE_ID   XPAR_AXI_GPIO_0_DEVICE_ID // axi_gpio_0 (LED 10개)
#define BTN_DEVICE_ID   XPAR_AXI_GPIO_1_DEVICE_ID // axi_gpio_1 (버튼 4개)

// 두 IP 모두 각각의 1번 채널(Channel 1)을 사용한다고 가정합니다.
#define CHANNEL_1       1

// 하드웨어 장치를 제어하기 위한 구조체 인스턴스 2개를 개별 선언합니다.
XGpio Gpio_Led; // LED 제어용
XGpio Gpio_Btn; // 버튼 입력용

int main()
{
    int Status;
    u32 btn_data = 0; // 읽어온 버튼의 상태 값을 저장할 변수


     // 1. 프로그램 시작 문구 출력

    xil_printf("PL GPIO TEST PROGRAM\n\r");

     // 2. 첫 번째 AXI GPIO (LED용) 초기화
    Status = XGpio_Initialize(&Gpio_Led, LED_DEVICE_ID);
    if (Status != XST_SUCCESS) {
        xil_printf("LED GPIO Initialization Failed!\n\r");
        return XST_FAILURE;
    }

     // 3. 두 번째 AXI GPIO (버튼용) 초기화
    Status = XGpio_Initialize(&Gpio_Btn, BTN_DEVICE_ID);
    if (Status != XST_SUCCESS) {
        xil_printf("Button GPIO Initialization Failed!\n\r");
        return XST_FAILURE;
    }

     /* 4. GPIO 입출력 방향 설정
     * Gpio_Led는 0x000으로 설정하여 모두 '출력(Output)' 모드로 만듭니다.
     * Gpio_Btn은 0xFFF(또는 0xFFFFFFFF)로 설정하여 모두 '입력(Input)' 모드로 만듭니다. */
    XGpio_SetDataDirection(&Gpio_Led, CHANNEL_1, 0x00000000);
    XGpio_SetDataDirection(&Gpio_Btn, CHANNEL_1, 0xFFFFFFFF);


     /* 5. [초기화 상태 적용]: 모든 LED 소등
     * 무한 루프 진입 전에 모든 LED에 Low(0) 신호를 주어 확실하게 끕니다. */
    XGpio_DiscreteWrite(&Gpio_Led, CHANNEL_1, 0x000);
    xil_printf("Initialization: All LEDs are OFF.\n\r");

     // 6. 무한 루프 제어 흐름
    while (1) {
        // Gpio_Btn 장치에서 현재 버튼 눌림 상태를 읽어옵니다.
        btn_data = XGpio_DiscreteRead(&Gpio_Btn, CHANNEL_1);
         // 버튼 데이터(btn_data) 값에 따라 LED 출력 패턴을 결정합니다.
        if (btn_data == 0x01) {
            // BTN0 누름: 모든 LED 켜짐
            XGpio_DiscreteWrite(&Gpio_Led, CHANNEL_1, 0x3FF);
        } else if (btn_data == 0x02) {
            // BTN1 누름: 짝수 번호 LED만 켜짐 (0x155 = 2진수 01 0101 0101)
            XGpio_DiscreteWrite(&Gpio_Led, CHANNEL_1, 0x155);
        } else if (btn_data == 0x04) {
            // BTN2 누름: 홀수 번호 LED만 켜짐 (0x2AA = 2진수 10 1010 1010)
            XGpio_DiscreteWrite(&Gpio_Led, CHANNEL_1, 0x2AA);
        } else if (btn_data == 0x08) {
            // BTN3 누름: 모든 LED 꺼짐
            XGpio_DiscreteWrite(&Gpio_Led, CHANNEL_1, 0x000);
        } else {
            // 아무 버튼도 누르지 않았을 때는 마지막 상태 유지 (동작 없음)
        }
    }
    return 0;
}
