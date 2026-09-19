`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/12/10 17:39:05
// Design Name: 
// Module Name: uart_fsm
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module uart_fsm (
    input  wire       clk,
    input  wire       rst,
    input  wire [1:0] sw,       // 스위치 입력
    input  wire [7:0] rx_data,
    input  wire       rx_valid,
    input  wire       tx_busy,
    output reg  [7:0] tx_data,
    output reg        tx_start,
    output reg  [7:0] last_rx
);

    localparam integer MSG_LEN = 7;
    reg [7:0] msg [0:6];
    initial begin
        msg[0] = "H"; msg[1] = "e"; msg[2] = "l"; msg[3] = "l";
        msg[4] = "o"; msg[5] = 8'h0D; msg[6] = 8'h0A; // \r\n
    end

    // 상태 정의
    localparam [3:0] S_HELLO_LOAD   = 4'd0,
                     S_HELLO_START  = 4'd1,
                     S_HELLO_WAIT   = 4'd2,
                     S_STOP_FOREVER = 4'd3,  // TX 모드 정지
                     S_RX_ONLY      = 4'd4,  // RX 모드 대기
                     S_ECHO_IDLE    = 4'd5,  // Echo 모드 대기
                     S_ECHO_START   = 4'd6,
                     S_ECHO_WAIT    = 4'd7;

    reg [3:0] state;
    reg [2:0] idx;

    // 스위치 변경 감지용 (내부 로직용)
    reg [1:0] sw_sync, sw_prev;
    wire sw_changed = (sw_sync != sw_prev);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sw_sync <= sw; 
            sw_prev <= sw;
        end else begin
            sw_sync <= sw;         
            sw_prev <= sw_sync;    
        end
    end

    // Main FSM
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            if (sw == 2'b01) state <= S_RX_ONLY;
            else             state <= S_HELLO_LOAD; 

            idx      <= 0;
            tx_data  <= 0;
            tx_start <= 0;
            last_rx  <= 8'h00; 
        end else begin
            
            if (rx_valid && (sw != 2'b00)) begin
                last_rx <= rx_data;
            end

            // [스위치 변경 동작] - 즉시 모드 전환 (Hello 출력 없음)
            if (sw_changed) begin
                idx <= 0;
                tx_start <= 1'b0;
                case (sw_sync)
                    2'b00: state <= S_STOP_FOREVER; // TX모드: 바로 정지 (세그먼트도 반응 안 함)
                    2'b01: state <= S_RX_ONLY;      // RX모드: 수신 대기
                    2'b10: state <= S_ECHO_IDLE;    // Echo모드: 에코 대기
                    default: state <= S_ECHO_IDLE;
                endcase
            end 
            else begin
                // [기본 동작]
                case (state)
                    // Hello 전송 루틴
                    S_HELLO_LOAD: begin
                        tx_data  <= msg[idx];
                        tx_start <= 1'b1; 
                        state    <= S_HELLO_START;
                    end
                    S_HELLO_START: begin
                        tx_start <= 1'b0;
                        if (tx_busy) state <= S_HELLO_WAIT;
                    end
                    S_HELLO_WAIT: begin
                        if (!tx_busy) begin
                            if (idx == MSG_LEN - 1) begin
                                idx <= 0;
                                if (sw_sync == 2'b10) state <= S_ECHO_IDLE; 
                                else                  state <= S_STOP_FOREVER; 
                            end else begin
                                idx   <= idx + 1;
                                state <= S_HELLO_LOAD;
                            end
                        end
                    end

                    S_STOP_FOREVER: begin tx_start <= 1'b0; end
                    S_RX_ONLY:      begin tx_start <= 1'b0; end

                    S_ECHO_IDLE: begin
                        if (rx_valid) begin
                            tx_data  <= rx_data;
                            tx_start <= 1'b1;
                            state    <= S_ECHO_START;
                        end
                    end
                    S_ECHO_START: begin
                        tx_start <= 1'b0;
                        if (tx_busy) state <= S_ECHO_WAIT;
                    end
                    S_ECHO_WAIT: begin
                        if (!tx_busy) state <= S_ECHO_IDLE;
                    end
                    default: state <= S_ECHO_IDLE;
                endcase
            end
        end
    end
endmodule