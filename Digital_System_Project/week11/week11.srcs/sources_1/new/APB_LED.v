`timescale 1ns / 1ps

module APB_LED (
    input  wire        PCLK,
    input  wire        PRESETn,
    input  wire [31:0] PADDR,
    input  wire        PSEL,
    input  wire        PENABLE,
    input  wire        PWRITE,
    input  wire [31:0] PWDATA,
    output wire [31:0] PRDATA,
    output wire        PREADY,
    
    output reg [3:0]   led_o
);

    localparam ADDR_CTRL = 8'h00; // Bit [3:0]: LED On/Off
    
    wire apb_write = PSEL & PENABLE & PWRITE;
    wire apb_read  = PSEL & PENABLE & ~PWRITE;
    
    always @(posedge PCLK) begin
        if (~PRESETn) begin
            led_o <= 4'b0;
        end else if (apb_write && (PADDR[7:0] == ADDR_CTRL)) begin
            led_o <= PWDATA[3:0];
        end
    end
    
    assign PRDATA = (apb_read && (PADDR[7:0] == ADDR_CTRL)) ? {28'b0, led_o} : 32'b0;
    assign PREADY = 1'b1;

endmodule