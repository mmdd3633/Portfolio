`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/12/10 17:38:05
// Design Name: 
// Module Name: uart_rx
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
module uart_rx #(
    parameter integer CLK_FREQ  = 100_000_000,
    parameter integer BAUD_RATE = 115200
)(
    input  wire       clk,
    input  wire       rst,
    input  wire       rx,
    output reg [7:0]  data_out,
    output reg        valid
);
    localparam integer DIVISOR      = CLK_FREQ / BAUD_RATE;
    localparam integer HALF_DIVISOR = DIVISOR / 2;

    localparam [1:0] S_IDLE  = 2'd0,
                     S_START = 2'd1,
                     S_DATA  = 2'd2,
                     S_STOP  = 2'd3;

    reg [1:0]  state;
    reg [15:0] cnt;
    reg [2:0]  bit_idx;
    reg [7:0]  shift_reg;

    // RX 신호 노이즈 제거 (Double Flopping)
    reg rx_r1, rx_r2;
    always @(posedge clk) begin
        rx_r1 <= rx;
        rx_r2 <= rx_r1;
    end
    wire rx_sync = rx_r2;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state     <= S_IDLE;
            cnt       <= 0;
            bit_idx   <= 0;
            valid     <= 0;
            data_out  <= 0;
        end else begin
            valid <= 1'b0; // Pulse

            case (state)
                S_IDLE: begin
                    cnt <= 0;
                    if (rx_sync == 1'b0) // Start Bit 감지
                        state <= S_START;
                end

                S_START: begin
                    if (cnt == HALF_DIVISOR - 1) begin
                        cnt <= 0;
                        if (rx_sync == 1'b0) begin
                            bit_idx <= 0;
                            state   <= S_DATA;
                        end else
                            state <= S_IDLE; // 노이즈
                    end else
                        cnt <= cnt + 1;
                end

                S_DATA: begin
                    if (cnt == DIVISOR - 1) begin
                        cnt <= 0;
                        shift_reg <= {rx_sync, shift_reg[7:1]}; // LSB first filling
                        if (bit_idx == 7)
                            state <= S_STOP;
                        else
                            bit_idx <= bit_idx + 1;
                    end else
                        cnt <= cnt + 1;
                end

                S_STOP: begin
                    if (cnt == DIVISOR - 1) begin
                        cnt <= 0;
                        if (rx_sync == 1'b1) begin // Stop bit check
                            data_out <= shift_reg;
                            valid    <= 1'b1;
                        end
                        state <= S_IDLE;
                    end else
                        cnt <= cnt + 1;
                end
            endcase
        end
    end
endmodule