`timescale 1ns / 1ps

module apb_7seg (
    input  wire        i_clk,
    input  wire        i_rst_n,
    input  wire [31:0] i_apb_paddr,
    input  wire        i_apb_penable,
    input  wire        i_apb_psel,
    input  wire        i_apb_pwrite,
    input  wire [31:0] i_apb_pwdata,
    output wire [31:0] o_apb_prdata,
    output wire        o_apb_pready,
    output wire        o_apb_pslverr,
    output reg  [3:0]  o_seg_an,
    output wire [7:0]  o_seg_cat   // wire로 변경
);
    reg [31:0] r_control; 
    reg [7:0]  r_seg_pattern; // 내부 중간 값을 저장할 변수

    assign o_apb_pready  = 1'b1;
    assign o_apb_pslverr = 1'b0;
    assign o_apb_prdata  = r_control;

    always @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) r_control <= 32'h0;
        else if (i_apb_psel && i_apb_penable && i_apb_pwrite) r_control <= i_apb_pwdata;
    end

    reg [16:0] r_cnt;
    always @(posedge i_clk) r_cnt <= r_cnt + 1;
    
    wire [1:0] sel = r_cnt[16:15];
    reg [3:0] hex;
    reg dp;

    always @(*) begin
        case(sel)
            2'b00: begin o_seg_an = r_control[20] ? 4'b1110 : 4'b1111; hex = r_control[3:0];   dp = r_control[16]; end
            2'b01: begin o_seg_an = r_control[21] ? 4'b1101 : 4'b1111; hex = r_control[7:4];   dp = r_control[17]; end
            2'b10: begin o_seg_an = r_control[22] ? 4'b1011 : 4'b1111; hex = r_control[11:8];  dp = r_control[18]; end
            2'b11: begin o_seg_an = r_control[23] ? 4'b0111 : 4'b1111; hex = r_control[15:12]; dp = r_control[19]; end
        endcase
    end

    always @(*) begin
        case(hex)
            4'h0: r_seg_pattern[6:0] = 7'h3F; 4'h1: r_seg_pattern[6:0] = 7'h06; 
            4'h2: r_seg_pattern[6:0] = 7'h5B; 4'h3: r_seg_pattern[6:0] = 7'h4F; 
            4'h4: r_seg_pattern[6:0] = 7'h66; 4'h5: r_seg_pattern[6:0] = 7'h6D; 
            4'h6: r_seg_pattern[6:0] = 7'h7D; 4'h7: r_seg_pattern[6:0] = 7'h07; 
            4'h8: r_seg_pattern[6:0] = 7'h7F; 4'h9: r_seg_pattern[6:0] = 7'h6F; 
            default: r_seg_pattern[6:0] = 7'h00;
        endcase
        r_seg_pattern[7] = dp; 
    end

    // 마지막에 한 번만 반전하여 출력
    assign o_seg_cat = ~r_seg_pattern;

endmodule