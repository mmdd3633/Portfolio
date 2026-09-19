`timescale 1ns / 1ps

module APB_7Seg #(
    parameter CLK_FREQ = 100_000_000
)(
    input  wire        PCLK,
    input  wire        PRESETn,
    input  wire [31:0] PADDR,
    input  wire        PSEL,
    input  wire        PENABLE,
    input  wire        PWRITE,
    input  wire [31:0] PWDATA,
    output wire [31:0] PRDATA,
    output wire        PREADY,
    
    output reg [7:0]   seg_o,
    output reg [3:0]   an_o
);

    localparam ADDR_CTRL = 8'h00; 
    localparam ADDR_DATA = 8'h04; 
    
    reg        display_en;
    reg [15:0] bcd_data;
    
    // [버그 수정 완료] 16비트 -> 32비트로 확장하여 오버플로우 방지
    reg [31:0] scan_cnt;
    reg [1:0]  digit_sel;
    
    wire apb_write = PSEL & PENABLE & PWRITE;
    wire apb_read  = PSEL & PENABLE & ~PWRITE;
    
    function [6:0] dec2seg (input [3:0] bcd);
        case (bcd)
            4'h0: dec2seg = 7'b1000000;
            4'h1: dec2seg = 7'b1111001;
            4'h2: dec2seg = 7'b0100100;
            4'h3: dec2seg = 7'b0110000;
            4'h4: dec2seg = 7'b0011001;
            4'h5: dec2seg = 7'b0010010;
            4'h6: dec2seg = 7'b0000010;
            4'h7: dec2seg = 7'b1111000;
            4'h8: dec2seg = 7'b0000000;
            4'h9: dec2seg = 7'b0010000;
            default: dec2seg = 7'b1111111;
        endcase
    endfunction
    
    always @(posedge PCLK) begin
        if (~PRESETn) begin
            display_en <= 1'b0;
            bcd_data <= 16'h0000;
        end else if (apb_write) begin
            if (PADDR[7:0] == ADDR_CTRL) display_en <= PWDATA[0];
            if (PADDR[7:0] == ADDR_DATA) bcd_data <= PWDATA[15:0];
        end
    end
    
    always @(posedge PCLK) begin
        if (~PRESETn) begin
            scan_cnt <= 0;
            digit_sel <= 0;
        end else begin
            if (scan_cnt >= (CLK_FREQ / 1000) - 1) begin
                scan_cnt <= 0;
                digit_sel <= digit_sel + 1;
            end else begin
                scan_cnt <= scan_cnt + 1;
            end
        end
    end
    
    always @(*) begin
        an_o = 4'b1111; 
        seg_o = 8'hFF;  
        
        if (display_en) begin
            case (digit_sel)
                2'b00: begin // 1/100초 자리
                    an_o = 4'b1110;
                    seg_o = {1'b1, dec2seg(bcd_data[3:0])}; 
                end
                2'b01: begin // 1/10초 자리
                    an_o = 4'b1101;
                    seg_o = {1'b1, dec2seg(bcd_data[7:4])}; 
                end
                2'b10: begin // 1초 자리 (소수점 점등)
                    an_o = 4'b1011;
                    seg_o = {1'b0, dec2seg(bcd_data[11:8])}; 
                end
                2'b11: begin // 10초 자리
                    an_o = 4'b0111;
                    seg_o = {1'b1, dec2seg(bcd_data[15:12])}; 
                end
            endcase
        end
    end
    
    assign PRDATA = (apb_read && (PADDR[7:0] == ADDR_CTRL)) ? {31'b0, display_en} :
                    (apb_read && (PADDR[7:0] == ADDR_DATA)) ? {16'b0, bcd_data}   : 32'b0;
                     
    assign PREADY = 1'b1;

endmodule