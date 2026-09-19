`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/05/08 14:02:45
// Design Name: 
// Module Name: apb_led
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

module apb_led (
    input  wire        i_clk,
    input  wire        i_rst_n,
    input  wire [31:0] i_apb_paddr,
    input  wire        i_apb_penable,
    input  wire        i_apb_psel,
    input  wire        i_apb_pwrite,
    input  wire [31:0] i_apb_pwdata,
    output reg  [31:0] o_apb_prdata,
    output wire        o_apb_pready,
    output wire        o_apb_pslverr,
    output wire [9:0]  o_led
);

// 주소 매핑
localparam BASE_ADDR = 32'h43C0_0000;
localparam LED_VALUE = BASE_ADDR + 32'h0;

reg [9:0] led_reg;

assign  o_apb_pready = 1;
assign  o_apb_pslverr = 0;

always @(posedge i_clk or negedge i_rst_n)
begin
    if (~i_rst_n)
        led_reg <= 0;
    else
    begin
        if (i_apb_psel && i_apb_penable && i_apb_pwrite)
        begin
            if (i_apb_paddr == LED_VALUE)
                led_reg <= i_apb_pwdata[9:0];
        end
    end
end

always @(posedge i_clk or negedge i_rst_n)
begin
    if (~i_rst_n)
        o_apb_prdata <= 0;
    else
    begin
        if (i_apb_psel && ~i_apb_pwrite)
        begin
            if (i_apb_paddr == LED_VALUE)
                o_apb_prdata <= {22'h0, led_reg};
        end
    end
end

assign  o_led = led_reg;

endmodule
