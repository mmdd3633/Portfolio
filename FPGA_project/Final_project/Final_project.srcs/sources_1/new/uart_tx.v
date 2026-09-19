`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/12/10 16:27:03
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

module uart_tx #(
    parameter integer CLK_FREQ  = 100_000_000,
    parameter integer BAUD_RATE = 115200
)(
    input  wire       clk,
    input  wire       rst,
    input  wire       baud_tick,
    input  wire [7:0] data_in,
    input  wire       start,
    output reg        tx,
    output reg        busy
);

    localparam [1:0] S_IDLE  = 2'd0,
                     S_START = 2'd1,
                     S_DATA  = 2'd2,
                     S_STOP  = 2'd3;

    reg [1:0] state;
    reg [2:0] bit_idx;
    reg [7:0] tx_shifter;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state   <= S_IDLE;
            tx      <= 1'b1; // Idle 상태는 High
            busy    <= 1'b0;
            bit_idx <= 3'd0;
            tx_shifter <= 8'd0;
        end else begin
            case (state)
                S_IDLE: begin
                    tx   <= 1'b1;
                    if (start) begin
                        state      <= S_START;
                        tx_shifter <= data_in;
                        busy       <= 1'b1; // 시작하자마자 바쁨 표시
                    end else begin
                        busy       <= 1'b0;
                    end
                end

                S_START: begin
                    busy <= 1'b1;
                    if (baud_tick) begin
                        tx    <= 1'b0; // Start Bit (Low)
                        state <= S_DATA;
                        bit_idx <= 3'd0;
                    end
                end

                S_DATA: begin
                    busy <= 1'b1;
                    if (baud_tick) begin
                        tx <= tx_shifter[0]; // LSB부터 전송
                        tx_shifter <= {1'b0, tx_shifter[7:1]}; // Shift
                        
                        if (bit_idx == 3'd7)
                            state <= S_STOP;
                        else
                            bit_idx <= bit_idx + 1;
                    end
                end

                S_STOP: begin
                    busy <= 1'b1;
                    if (baud_tick) begin
                        tx    <= 1'b1; // Stop Bit (High)
                        state <= S_IDLE;
                    end
                end
            endcase
        end
    end
endmodule