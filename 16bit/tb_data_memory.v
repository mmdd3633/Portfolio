`timescale 1ns/1ps

module tb_data_memory;

    // ?? ??
    reg clk;
    reg mem_rd;
    reg mem_wr;
    reg [11:0] mem_addr;
    reg [15:0] mem_data;

    // ?? ??
    wire [15:0] mem_dataout;

    // ?????
    data_memory uut (
        .clk(clk),
        .mem_rd(mem_rd),
        .mem_wr(mem_wr),
        .mem_addr(mem_addr),
        .mem_data(mem_data),
        .mem_dataout(mem_dataout)
    );

    // Clock ?? (10ns ??)
    always #5 clk = ~clk;

    // ??? ????
    initial begin
        $display("=== Data Memory Testbench Start ===");
        clk = 0;
        mem_rd = 0;
        mem_wr = 0;
        mem_addr = 0;
        mem_data = 0;

        // [1] ??? ??
        #10;

        // [2] ?? 12'h005? 16'hABCD ??
        mem_addr = 12'h005;
        mem_data = 16'hABCD;
        mem_wr = 1;
        #10;  // clk ?????? ??

        mem_wr = 0;

        // [3] ?? 12'h005?? ??
        #10;
        mem_rd = 1;
        #5;

        $display("[READ] Address = 0x%03h, Output = 0x%04h", mem_addr, mem_dataout);

        // [4] ?? 12'h005 ? 16'hABCD ??
        #10;
        mem_rd = 0;

        // [5] ?? 12'h010? 16'h1234 ??
        mem_addr = 12'h010;
        mem_data = 16'h1234;
        mem_wr = 1;
        #10;

        mem_wr = 0;

        // [6] ?? ?? ??
        #10;
        mem_rd = 1;
        #5;

        $display("[READ] Address = 0x%03h, Output = 0x%04h", mem_addr, mem_dataout);

        #10;
        mem_rd = 0;

        // ????? ??
        #20;
        $display("=== Testbench Done ===");
        $stop;
    end

endmodule

