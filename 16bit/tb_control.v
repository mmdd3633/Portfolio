`timescale 1ns / 1ps

module tb_control_unit;

    reg clk;
    reg reset;
    reg [15:0] instr;

    wire [6:0] decoding_signal;
    wire [2:0] rd, rr;
    wire [2:0] mbit;
    wire [11:0] imm;
    wire [11:0] kbit;
    wire [3:0] nbit;
    wire [2:0] sbit;
    wire reg_wr;
    wire sreg_wr;
    wire [1:0] pc_wr;
    wire mem_wr;
    wire mem_rd;
    wire imm_sel;
    wire addr_sel;
    wire mem_reg_sel;
    wire exe_32;

    // UUT
    control_unit uut (
        .clk(clk), .reset(reset), .instr(instr),
        .decoding_signal(decoding_signal),
        .rd(rd), .rr(rr), .mbit(mbit),
        .imm(imm), .kbit(kbit), .nbit(nbit),
        .sbit(sbit), .reg_wr(reg_wr), .sreg_wr(sreg_wr),
        .pc_wr(pc_wr), .mem_wr(mem_wr), .mem_rd(mem_rd),
        .imm_sel(imm_sel), .addr_sel(addr_sel),
        .mem_reg_sel(mem_reg_sel), .exe_32(exe_32)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        instr = 16'h0000;
        #10;

        reset = 0;

        // Arithmetic
        instr = 16'b0000_0000_001_010_000; // ADDBL
        #10;
        instr = 16'b0000_0010_011_100_000; // SUBBL
        #10;

        // Logical
        instr = 16'b0001_0000_001_010_000; // AND
        #10;
        instr = 16'b0001_0110_010_000_000; // NOT
        #10;

        // Compare
        instr = 16'b0010_0000_011_100_000; // EQ
        #10;
        instr = 16'b0010_0100_001_010_000; // GT
        #10;

        // Bit Operation
        instr = 16'b0011_0000_0101_1010; // BSETR
        #10;
        instr = 16'b0011_0011_0110_0000; // BCLR
        #10;

        // Shift
        instr = 16'b0100_0000_001_000_000; // LSL
        #10;
        instr = 16'b0100_0011_010_000_000; // ROR
        #10;

        // Move/NOP
        instr = 16'b0101_0000_001_010_000; // MOV
        #10;
        instr = 16'b0101_0001_011_100_000; // MOVW
        #10;

        // Immediate Move
        instr = 16'b01101000_10101010; // MOVLI
        #10;
        instr = 16'b01101100_11001100; // MOVHI
        #10;

        // Branch
        instr = 16'b1001_0000_11110000; // JMPI
        #10;
        instr = 16'b1001_10_1_011_010_000; // BRBC
        #10;

        // Load
        instr = 16'b1010_0000_11001100; // LDI
        #10;
        instr = 16'b1011_0001_00110011; // LDR
        #10;

        // Store
        instr = 16'b1100_0000_01010101; // STI
        #10;
        instr = 16'b1101_001_00001111;  // STR
        #10;

        // ????? ??
        $stop;
    end

endmodule

