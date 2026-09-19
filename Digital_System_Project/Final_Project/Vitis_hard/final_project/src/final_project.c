#include <stdio.h>
#include "xparameters.h"
#include "xil_printf.h"
#include "sleep.h"
#include "xgpio.h"
#include "xstatus.h"
#include "xil_io.h" // 하드웨어 레지스터 원시(Raw) 접근을 위해 필수 추가!

// ==============================================================================
// 1. 하드웨어 주소 및 디바이스 ID 매크로 정의
// ==============================================================================
// [수정됨] Address Editor에서 확인한 커스텀 APB-I2C Master의 정확한 Base Address
#define APB_IIC_BASE_ADDR   0x43C00000

#define GPIO_7SEG_ID        XPAR_AXI_GPIO_0_DEVICE_ID
#define GPIO_LED_BTN_ID     XPAR_AXI_GPIO_1_DEVICE_ID

// 커스텀 APB-I2C 내부 레지스터 Offset (하드웨어 Verilog 설계와 1:1 매칭)
#define IIC_CTRL_REG        0x00 // [31]Start, [16]R/W, [15:9]SlaveAddr, [7:0]RegAddr
#define IIC_TX_DATA_REG     0x04 // 보낼 데이터
#define IIC_STATUS_REG      0x08 // [0] Busy 상태 (1=동작중, 0=완료)
#define IIC_RX_DATA_REG     0x0C // 받은 데이터

// LSM9DS1 가속도/자이로 센서 I2C 주소
#define LSM9DS1_AG_ADDR_1   0x6B
#define LSM9DS1_AG_ADDR_2   0x6A

// LSM9DS1 주요 레지스터 주소
#define REG_WHO_AM_I_XG     0x0F
#define REG_CTRL_REG6_XL    0x20
#define REG_OUT_X_L_XL      0x28

// ==============================================================================
// 2. 전역 변수 (GPIO 인스턴스)
// ==============================================================================
XGpio Gpio_7Seg;
XGpio Gpio_LedBtn;

// ==============================================================================
// 3. 커스텀 APB-I2C 통신 함수 (레지스터 직접 제어 방식으로 재작성)
// ==============================================================================

// 1바이트 쓰기 함수 (Single Write Transaction)
int I2C_WriteReg(u8 SlaveAddr, u8 RegAddr, u8 Data) {
    Xil_Out32(APB_IIC_BASE_ADDR + IIC_TX_DATA_REG, Data);

    // Start(비트31)=1, Read/Write(비트16)=0, SlaveAddr, RegAddr 세팅
    u32 ctrl_val = 0x80000000 | (0 << 16) | (SlaveAddr << 9) | RegAddr;
    Xil_Out32(APB_IIC_BASE_ADDR + IIC_CTRL_REG, ctrl_val);

    // [해결책] 하드웨어가 상태를 업데이트할 아주 짧은 시간을 부여합니다!
    usleep(10);

    while ((Xil_In32(APB_IIC_BASE_ADDR + IIC_STATUS_REG) & 0x01) == 1);

    return XST_SUCCESS;
}

// 1바이트 연속 읽기 함수 (Software Burst Emulation)
int I2C_ReadReg(u8 SlaveAddr, u8 RegAddr, u8 *DataBuffer, unsigned ByteCount) {
    for (unsigned i = 0; i < ByteCount; i++) {
        u8 current_reg = RegAddr + i;

        // Start(비트31)=1, Read/Write(비트16)=1, SlaveAddr, RegAddr 세팅
        u32 ctrl_val = 0x80000000 | (1 << 16) | (SlaveAddr << 9) | current_reg;
        Xil_Out32(APB_IIC_BASE_ADDR + IIC_CTRL_REG, ctrl_val);

        // [해결책] 하드웨어가 상태를 업데이트할 아주 짧은 시간을 부여합니다!
        usleep(10);

        while ((Xil_In32(APB_IIC_BASE_ADDR + IIC_STATUS_REG) & 0x01) == 1);

        DataBuffer[i] = (u8)(Xil_In32(APB_IIC_BASE_ADDR + IIC_RX_DATA_REG) & 0xFF);
    }
    return XST_SUCCESS;
}

// ==============================================================================
// 4. 메인 함수 (응용 시스템 제어 루프)
// ==============================================================================
int main()
{
    int Status;
    u8 Target_Addr = LSM9DS1_AG_ADDR_1;
    u8 who_am_i = 0;
    u8 rx_data[6];

    // Tera Term 창이 정상적으로 열릴 수 있도록 초기 2초 대기
    sleep(2);

    xil_printf("\n\r======================================\n\r");
    xil_printf("  DEBUG MODE: System Initialization...\n\r");
    xil_printf("  [CUSTOM APB-I2C MASTER DRIVER]\n\r");
    xil_printf("======================================\n\r");

    // ---------------------------------------------------------
    // [단계 A] GPIO 초기화 확인 영역
    // ---------------------------------------------------------
    xil_printf("[DEBUG 1] Initializing 7-Segment GPIO...\n\r");
    Status = XGpio_Initialize(&Gpio_7Seg, GPIO_7SEG_ID);
    if (Status != XST_SUCCESS) {
        xil_printf("[ERROR] 7-Segment GPIO Initialization Failed!\n\r");
        return XST_FAILURE;
    }
    XGpio_SetDataDirection(&Gpio_7Seg, 1, 0x00000000);
    xil_printf("[DEBUG 1] 7-Segment GPIO Success!\n\r");

    xil_printf("[DEBUG 2] Initializing LED/BTN GPIO...\n\r");
    Status = XGpio_Initialize(&Gpio_LedBtn, GPIO_LED_BTN_ID);
    if (Status != XST_SUCCESS) {
        xil_printf("[ERROR] LED/BTN GPIO Initialization Failed!\n\r");
        return XST_FAILURE;
    }
    XGpio_SetDataDirection(&Gpio_LedBtn, 1, 0x00000000); // LED (Output)
    XGpio_SetDataDirection(&Gpio_LedBtn, 2, 0xFFFFFFFF); // BTN (Input)
    xil_printf("[DEBUG 2] LED/BTN GPIO Success!\n\r");

    // ---------------------------------------------------------
    // [단계 B] 커스텀 I2C 컨트롤러 준비 (리셋은 하드웨어가 알아서 수행함)
    // ---------------------------------------------------------
    xil_printf("[DEBUG 3] Custom APB I2C Controller is Ready.\n\r");

    // ---------------------------------------------------------
    // [단계 C] 센서 탐색 영역
    // ---------------------------------------------------------
    xil_printf("[DEBUG 4] Attempting to read WHO_AM_I from Sensor (Addr: 0x6B)...\n\r");
    I2C_ReadReg(Target_Addr, REG_WHO_AM_I_XG, &who_am_i, 1);

    if (who_am_i != 0x68) {
        xil_printf("[DEBUG 5] Failed at 0x6B. Retrying with Addr 0x6A...\n\r");
        Target_Addr = LSM9DS1_AG_ADDR_2;
        I2C_ReadReg(Target_Addr, REG_WHO_AM_I_XG, &who_am_i, 1);
    }

    if (who_am_i == 0x68) {
        xil_printf("[DEBUG 6] LSM9DS1 Sensor Successfully Found! (Address: 0x%02X)\n\r", Target_Addr);
    } else {
        xil_printf("[CRITICAL ERROR] Sensor Not Found! Read Value: 0x%02X (Expected: 0x68)\n\r", who_am_i);
        return XST_FAILURE;
    }

    // ---------------------------------------------------------
    // [단계 D] 센서 제어 설정 활성화
    // ---------------------------------------------------------
    xil_printf("[DEBUG 7] Activating Accelerometer Sensor (CTRL_REG6_XL)...\n\r");
    I2C_WriteReg(Target_Addr, REG_CTRL_REG6_XL, 0x60);
    usleep(100000);
    xil_printf("[DEBUG 7] Sensor Activation Done!\n\r");

    // ---------------------------------------------------------
    // [단계 E] 메인 데이터 수집 루프 진입
    // ---------------------------------------------------------
    xil_printf("[DEBUG 8] Entering Main Infinite Loop. System Operational.\n\r");

    int display_mode = 0;
    short offset_x = 0, offset_y = 0, offset_z = 0;
    int is_paused = 0;
    u32 prev_btn = 0;

    short filtered_x = 0, filtered_y = 0, filtered_z = 0;

    xil_printf("\n\r");

    while (1) {
        // 1. 센서 데이터 6바이트 읽기 (커스텀 I2C 함수 호출)
        I2C_ReadReg(Target_Addr, REG_OUT_X_L_XL, rx_data, 6);

        // 2. 비트 결합 및 부호 확장
        short accel_x = (short)((rx_data[1] << 8) | rx_data[0]);
        short accel_y = (short)((rx_data[3] << 8) | rx_data[2]);
        short accel_z = (short)((rx_data[5] << 8) | rx_data[4]);

        // 3. 이동평균 필터 적용 (노이즈 억제)
        filtered_x = (filtered_x * 7 + accel_x) / 8;
        filtered_y = (filtered_y * 7 + accel_y) / 8;
        filtered_z = (filtered_z * 7 + accel_z) / 8;

        // 4. 버튼 입력 처리 (엣지 검출)
        u32 btn_state = XGpio_DiscreteRead(&Gpio_LedBtn, 2);
        u32 btn_press = btn_state & ~prev_btn;
        prev_btn = btn_state;

        if (btn_press & 0x01) {
            display_mode = (display_mode + 1) % 3;
            xil_printf("\r[EVENT] Mode Changed to: %d                                      ", display_mode);
            usleep(500000);
        }
        if (btn_press & 0x02) {
            offset_x = filtered_x; offset_y = filtered_y; offset_z = filtered_z;
            xil_printf("\r[EVENT] Calibration Set!                                         ");
            usleep(500000);
        }
        if (btn_press & 0x04) {
            offset_x = 0; offset_y = 0; offset_z = 0;
            xil_printf("\r[EVENT] Calibration Reset!                                       ");
            usleep(500000);
        }
        if (btn_press & 0x08) {
            is_paused = !is_paused;
            xil_printf("\r[EVENT] Display Pause State: %d                                  ", is_paused);
            usleep(500000);
        }

        // 5. UI 출력 처리 (화면 일시정지가 아닐 때만)
        if (!is_paused) {
            short calib_x = filtered_x - offset_x;
            short calib_y = filtered_y - offset_y;
            short calib_z = filtered_z - offset_z;

            // 디스플레이 모드에 따른 타겟 값 선정
            short target_val = 0;
            if (display_mode == 0)      target_val = calib_x;
            else if (display_mode == 1) target_val = calib_y;
            else                        target_val = calib_z;

            int abs_val = target_val;
            if (abs_val < 0) abs_val = -abs_val;

            // 7-Segment 출력
            XGpio_DiscreteWrite(&Gpio_7Seg, 1, (u32)abs_val);

            // LED & RGB 출력 연산
            u32 led_out = 0x0000;
            int threshold = 8000;

            int level = abs_val / 1500;
            if (level > 10) level = 10;
            u32 bar_graph = (1 << level) - 1;
            led_out |= (bar_graph & 0x03FF);

            // 축 표시 (RGB 1번)
            if (display_mode == 0)      led_out |= (1 << 10);
            else if (display_mode == 1) led_out |= (1 << 11);
            else                        led_out |= (1 << 12);

            // 위험 경고등 표시 (RGB 2번)
            if (abs_val > threshold) led_out |= (1 << 13);
            else                     led_out |= (1 << 14);

            XGpio_DiscreteWrite(&Gpio_LedBtn, 1, led_out);

            // UART 모니터링 출력
            xil_printf("\rMode: %d | Calib_X: %6d, Y: %6d, Z: %6d       ", display_mode, calib_x, calib_y, calib_z);
        }

        usleep(100000); // 10Hz 갱신
    }

    return 0;
}
