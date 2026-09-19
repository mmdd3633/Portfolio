`timescale 1ns/1ps

module tb_bitop_from_table;

    reg clk, reset;
    reg sreg_wr, sreg_rd;
    reg [15:0] reg_rd;
    reg [6:0] decoding_signal;
    reg [3:0] nbit;
    reg [2:0] sbit, mbit;

    wire [15:0] alu_result0;
    wire [7:0] alu_flag;
    wire [7:0] sreg_out;

    // DUTs
    bitop_unit uut_bitop (
        .reg_rd(reg_rd),
        .sreg_out(sreg_out),
        .decoding_signal(decoding_signal),
        .nbit(nbit),
        .sbit(sbit),
        .mbit(mbit),
        .alu_result0(alu_result0),
        .alu_flag(alu_flag)
    );
    always #5 clk = ~clk;

    initial begin
        clk = 0; reset = 1; sreg_wr = 0; sreg_rd = 0;
        reg_rd = 0;
	nbit = 0;
	sbit = 0;
	
        #10 reset = 0;

        sreg_wr = 1; sreg_rd = 1;

        // 0: BSETR - reg_rd[3] ? 1
        decoding_signal = 7'b0110000; reg_rd = 16'h0000; nbit = 4'd3; #10;

        // 1: BCLRR - reg_rd[4] ? 0
        decoding_signal = 7'b0110001; reg_rd = 16'hFFFF; nbit = 4'd4; #10;

        // 2: BNOTR - reg_rd[4] ? toggle
        decoding_signal = 7'b0110010; reg_rd = 16'b0000000000010000; nbit = 4'd4; #10;

        // 3: SREG BSET - sreg[2] ? 1
        decoding_signal = 7'b0110011; sbit = 3'd2; #10;

        // 4: SREG BCLR - sreg[2] ? 0
        decoding_signal = 7'b0110100; sbit = 3'd2; #10;

        // 5: BAND - reg_rd[4] &= sreg[4]
        decoding_signal = 7'b0110101;
        reg_rd = 16'b00010000; sreg_wr = 0; mbit = 3'd4; #10;

        // 6: BOR - reg_rd[4] |= sreg[4]
        decoding_signal = 7'b0110110;
        reg_rd = 16'b00000000; mbit = 3'd4; #10;

        // 7: BXOR - reg_rd[4] ^= sreg[4]
        decoding_signal = 7'b0110111;
        reg_rd = 16'b00010000; mbit = 3'd4; #10;

        // Z ?? ???
        sreg_rd = 0; #10;
        sreg_rd = 1; #10;

        $finish;
    end

endmodule
