`timescale 1ns / 1ps

module apb_i2c_master #(
    parameter SYS_CLK_FREQ = 100_000_000, // Zynq 시스템 클럭 100MHz
    parameter I2C_FREQ     = 100_000      // I2C 통신 속도 100kHz
)(
    // 시스템 클럭 및 리셋 (Vivado 인식용 속성 추가)
    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 PCLK CLK" *)
    (* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF APB_S, ASSOCIATED_RESET PRESETn" *)
    input  wire        PCLK,

    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 PRESETn RST" *)
    (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_LOW" *)
    input  wire        PRESETn,

    // APB Bus Interface (Vivado가 하나의 굵은 버스로 묶어주도록 속성 추가)
    (* X_INTERFACE_INFO = "xilinx.com:interface:apb:1.0 APB_S PSEL" *)
    input  wire        PSEL,
    (* X_INTERFACE_INFO = "xilinx.com:interface:apb:1.0 APB_S PENABLE" *)
    input  wire        PENABLE,
    (* X_INTERFACE_INFO = "xilinx.com:interface:apb:1.0 APB_S PWRITE" *)
    input  wire        PWRITE,
    (* X_INTERFACE_INFO = "xilinx.com:interface:apb:1.0 APB_S PADDR" *)
    input  wire [31:0] PADDR,
    (* X_INTERFACE_INFO = "xilinx.com:interface:apb:1.0 APB_S PWDATA" *)
    input  wire [31:0] PWDATA,
    (* X_INTERFACE_INFO = "xilinx.com:interface:apb:1.0 APB_S PRDATA" *)
    output reg  [31:0] PRDATA,
    (* X_INTERFACE_INFO = "xilinx.com:interface:apb:1.0 APB_S PREADY" *)
    output wire        PREADY,
    (* X_INTERFACE_INFO = "xilinx.com:interface:apb:1.0 APB_S PSLVERR" *)
    output wire        PSLVERR, // 에러 핀 추가 (Vivado 경고 방지용)

    // I2C Open-Drain Interface
    inout  wire        io_i2c_scl,
    inout  wire        io_i2c_sda
);

    // APB 에러 신호는 사용하지 않으므로 0으로 고정
    assign PSLVERR = 1'b0; 

    // =====================================================================
    // 1. APB 레지스터 맵 (Register Map) 부터는 기존 코드 그대로 유지!
    // =====================================================================

    // =====================================================================
    // 1. APB 레지스터 맵 (Register Map)
    // =====================================================================
    // 0x00 [CTRL]    : [31] Start, [16] Read(1)/Write(0), [15:9] SlaveAddr, [7:0] RegAddr
    // 0x04 [TX_DATA] : [7:0] 전송할 데이터 (Write 모드 시)
    // 0x08 [STATUS]  : [0] 1=Busy, 0=Idle
    // 0x0C [RX_DATA] : [7:0] 수신한 데이터 (Read 모드 시)
    
    reg [31:0] reg_ctrl;
    reg [31:0] reg_tx_data;
    reg [31:0] reg_rx_data;
    reg        status_busy;

    wire start_cmd = reg_ctrl[31];
    wire is_read   = reg_ctrl[16];
    wire [6:0] slave_addr = reg_ctrl[15:9];
    wire [7:0] reg_addr   = reg_ctrl[7:0];

    // APB Write Logic
    always @(posedge PCLK or negedge PRESETn) begin
        if (!PRESETn) begin
            reg_ctrl    <= 32'd0;
            reg_tx_data <= 32'd0;
        end else begin
            if (PSEL && PENABLE && PWRITE) begin
                case (PADDR[7:0])
                    8'h00: reg_ctrl    <= PWDATA;
                    8'h04: reg_tx_data <= PWDATA;
                endcase
            end else begin
                // Start 비트는 하드웨어 트리거 후 자동 클리어
                if (status_busy) reg_ctrl[31] <= 1'b0; 
            end
        end
    end

    // APB Read Logic
    always @(*) begin
        case (PADDR[7:0])
            8'h00: PRDATA = reg_ctrl;
            8'h04: PRDATA = reg_tx_data;
            8'h08: PRDATA = {31'd0, status_busy};
            8'h0C: PRDATA = reg_rx_data;
            default: PRDATA = 32'd0;
        endcase
    end
    
    assign PREADY = 1'b1; // Wait State 없이 항상 Ready 상태 유지

    // =====================================================================
    // 2. I2C Open-Drain 제어 및 클럭 분주 (Clock Divider) 
    // =====================================================================
    reg scl_out, sda_out;
    wire sda_in;
    
    // Vivado 합성 버그 방지를 위해 물리적 IOBUF 직접 인스턴스화
    IOBUF scl_iobuf (
        .I(1'b0),          // 출력할 값은 항상 0
        .IO(io_i2c_scl),   // 외부 핀 연결
        .O(),              // SCL은 읽지 않으므로 비워둠
        .T(scl_out)        // T=1이면 High-Z(입력모드), T=0이면 0출력
    );
    
    IOBUF sda_iobuf (
        .I(1'b0),          
        .IO(io_i2c_sda),   // SDA 외부 핀 연결
        .O(sda_in),        // 센서가 보내는 실제 값 읽기
        .T(sda_out)        
    );

    // FSM 구동을 위해 1 I2C 클럭을 4등분(Tick)하여 타이밍 제어
    localparam TICK_DIV = (SYS_CLK_FREQ / (I2C_FREQ * 4)) - 1;
    reg [15:0] tick_cnt;
    wire i2c_tick = (tick_cnt == 0);

    always @(posedge PCLK or negedge PRESETn) begin
        if (!PRESETn) tick_cnt <= 0;
        else if (status_busy) begin
            if (tick_cnt == 0) tick_cnt <= TICK_DIV;
            else               tick_cnt <= tick_cnt - 1;
        end else begin
            tick_cnt <= 0;
        end
    end

    // =====================================================================
    // 3. I2C Master FSM (Single Transaction: Read / Write 지원)
    // =====================================================================
    localparam S_IDLE       = 0;
    localparam S_START      = 1;
    localparam S_TX_SLAW    = 2; // Slave Addr + Write(0)
    localparam S_ACK_1      = 3;
    localparam S_TX_REG     = 4; // Register Addr
    localparam S_ACK_2      = 5;
    localparam S_TX_DATA    = 6; // Write 모드일 때 Data 전송
    localparam S_ACK_3      = 7;
    localparam S_REP_START  = 8; // Read 모드일 때 Repeated Start
    localparam S_TX_SLAR    = 9; // Slave Addr + Read(1)
    localparam S_ACK_4      = 10;
    localparam S_RX_DATA    = 11;// Read 모드일 때 Data 수신
    localparam S_NACK       = 12;// Master NACK 생성
    localparam S_STOP       = 13;

    reg [3:0] state;
    reg [1:0] step;      // 0~3 (4 ticks per 1 I2C bit)
    reg [2:0] bit_cnt;   // 0~7 (8 bits)
    reg [7:0] shift_tx;
    reg [7:0] shift_rx;

    always @(posedge PCLK or negedge PRESETn) begin
        if (!PRESETn) begin
            state       <= S_IDLE;
            status_busy <= 1'b0;
            scl_out     <= 1'b1;
            sda_out     <= 1'b1;
            step        <= 0;
            bit_cnt     <= 0;
            reg_rx_data <= 0;
        end else begin
            if (state == S_IDLE) begin
                scl_out <= 1'b1;
                sda_out <= 1'b1;
                if (start_cmd) begin
                    status_busy <= 1'b1;
                    state       <= S_START;
                    step        <= 0;
                end
            end 
            else if (i2c_tick) begin
                case (state)
                    // ---------------------------------------------
                    // START Condition: SCL=High일 때 SDA를 Low로
                    // ---------------------------------------------
                    S_START: begin
                        case (step)
                            0: begin scl_out <= 1'b1; sda_out <= 1'b1; end
                            1: begin scl_out <= 1'b1; sda_out <= 1'b0; end
                            2: begin scl_out <= 1'b0; sda_out <= 1'b0; end
                            3: begin 
                                state <= S_TX_SLAW; 
                                shift_tx <= {slave_addr, 1'b0}; // Addr + W(0)
                                bit_cnt <= 7; 
                                step <= 0; 
                            end
                        endcase
                        if (step != 3) step <= step + 1;
                    end

                    // ---------------------------------------------
                    // 공통 데이터 전송 로직 (SLA+W, REG_ADDR, TX_DATA)
                    // ---------------------------------------------
                    S_TX_SLAW, S_TX_REG, S_TX_DATA, S_TX_SLAR: begin
                        case (step)
                            0: begin scl_out <= 1'b0; sda_out <= shift_tx[7]; end // 데이터 세팅
                            1: begin scl_out <= 1'b1; end // SCL Rising
                            2: begin scl_out <= 1'b1; end // 안정화 대기
                            3: begin 
                                scl_out <= 1'b0; 
                                shift_tx <= {shift_tx[6:0], 1'b0};
                            end
                        endcase
                        
                        if (step == 3) begin
                            step <= 0;
                            if (bit_cnt == 0) begin
                                if (state == S_TX_SLAW) state <= S_ACK_1;
                                else if (state == S_TX_REG) state <= S_ACK_2;
                                else if (state == S_TX_DATA) state <= S_ACK_3;
                                else if (state == S_TX_SLAR) state <= S_ACK_4;
                            end else begin
                                bit_cnt <= bit_cnt - 1;
                            end
                        end else begin
                            step <= step + 1;
                        end
                    end

                    // ---------------------------------------------
                    // Slave ACK 대기 (수신 처리)
                    // ---------------------------------------------
                    S_ACK_1, S_ACK_2, S_ACK_3, S_ACK_4: begin
                        case (step)
                            0: begin scl_out <= 1'b0; sda_out <= 1'b1; end // SDA 개방
                            1: begin scl_out <= 1'b1; end
                            2: begin scl_out <= 1'b1; /* 이 타이밍에 sda_in을 읽어 에러 처리 가능 */ end
                            3: begin scl_out <= 1'b0; end
                        endcase
                        
                        if (step == 3) begin
                            step <= 0;
                            if (state == S_ACK_1) begin
                                state <= S_TX_REG;
                                shift_tx <= reg_addr;
                                bit_cnt <= 7;
                            end else if (state == S_ACK_2) begin
                                if (is_read) state <= S_REP_START;
                                else begin
                                    state <= S_TX_DATA;
                                    shift_tx <= reg_tx_data[7:0];
                                    bit_cnt <= 7;
                                end
                            end else if (state == S_ACK_3) begin
                                state <= S_STOP; // Write 완료
                            end else if (state == S_ACK_4) begin
                                state <= S_RX_DATA;
                                bit_cnt <= 7;
                            end
                        end else begin
                            step <= step + 1;
                        end
                    end

                    // ---------------------------------------------
                    // Repeated START (Read 모드 시 방향 전환)
                    // ---------------------------------------------
                    S_REP_START: begin
                        case (step)
                            0: begin scl_out <= 1'b0; sda_out <= 1'b1; end
                            1: begin scl_out <= 1'b1; sda_out <= 1'b1; end
                            2: begin scl_out <= 1'b1; sda_out <= 1'b0; end
                            3: begin 
                                scl_out <= 1'b0; 
                                state <= S_TX_SLAR; 
                                shift_tx <= {slave_addr, 1'b1}; // Addr + R(1)
                                bit_cnt <= 7;
                                step <= 0;
                            end
                        endcase
                        if (step != 3) step <= step + 1;
                    end

                    // ---------------------------------------------
                    // Data 수신 (Read 모드)
                    // ---------------------------------------------
                    S_RX_DATA: begin
                        case (step)
                            0: begin scl_out <= 1'b0; sda_out <= 1'b1; end // SDA 개방
                            1: begin scl_out <= 1'b1; end
                            2: begin scl_out <= 1'b1; shift_rx <= {shift_rx[6:0], sda_in}; end // 데이터 읽기
                            3: begin scl_out <= 1'b0; end
                        endcase

                        if (step == 3) begin
                            step <= 0;
                            if (bit_cnt == 0) begin
                                state <= S_NACK; // 1바이트 읽고 통신 종료를 위한 NACK
                                reg_rx_data <= {24'd0, shift_rx}; // APB 레지스터에 저장
                            end else begin
                                bit_cnt <= bit_cnt - 1;
                            end
                        end else begin
                            step <= step + 1;
                        end
                    end

                    // ---------------------------------------------
                    // Master NACK 발생 (더 이상 안 읽음)
                    // ---------------------------------------------
                    S_NACK: begin
                        case (step)
                            0: begin scl_out <= 1'b0; sda_out <= 1'b1; end // SDA High = NACK
                            1: begin scl_out <= 1'b1; end
                            2: begin scl_out <= 1'b1; end
                            3: begin scl_out <= 1'b0; end
                        endcase
                        if (step == 3) begin step <= 0; state <= S_STOP; end
                        else step <= step + 1;
                    end

                    // ---------------------------------------------
                    // STOP Condition: SCL=High일 때 SDA를 High로
                    // ---------------------------------------------
                    S_STOP: begin
                        case (step)
                            0: begin scl_out <= 1'b0; sda_out <= 1'b0; end
                            1: begin scl_out <= 1'b1; sda_out <= 1'b0; end
                            2: begin scl_out <= 1'b1; sda_out <= 1'b1; end
                            3: begin 
                                status_busy <= 1'b0; 
                                state <= S_IDLE; 
                                step <= 0; 
                            end
                        endcase
                        if (step != 3) step <= step + 1;
                    end
                endcase
            end
        end
    end

endmodule