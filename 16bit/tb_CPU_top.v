`timescale 1ns / 1ps

module tb_cpu_top;

    // Inputs
    reg clk;
    reg reset;
    reg [7:0]  sreg_out;

    // Outputs
    wire [7:0]  alu_flag;
    wire [1:0]  cmp_result;
    // Instantiate the cpu_top
    
     cpu_top uut (
        .clk(clk),
        .reset(reset),
        .sreg_out(sreg_out),
        .alu_flag(alu_flag),
        .cmp_result(cmp_result)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // ???
        reset = 1;
        sreg_out = 8'b00000000;

        #10;
        reset = 0;
        sreg_out = 8'b00000000;

        #100;

        $stop;
    end

endmodule
