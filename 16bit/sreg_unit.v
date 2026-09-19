module sreg_module (
    input        clk,
    input        reset,
    input        sreg_we,       // Control Unit?? ?? (write enable)
    input        sreg_rd,       // Control Unit?? ?? (optional read enable)
    input  [7:0] alu_flag,      // ALU? ??? ?? ???
    output [7:0] sreg_out       // ?? ?? ? ALU 
);

    reg [7:0] sreg;

    always @(posedge clk or posedge reset) begin
        if (reset)
            sreg <= 8'b0;
        else if (sreg_we)
            sreg <= alu_flag;
    end

    
    assign sreg_out = sreg_rd ? sreg : 8'bz;  
endmodule

