module alu_arithmetic (
    input  [15:0] reg_rd,
    input  [15:0] reg_rr,
    input  [6:0]  decoding_signal,
    input         cin,
    output reg [15:0] alu_result0,
    output reg [15:0] alu_result1,
    output [7:0]  alu_flag 
);

    wire [15:0] add_result, adc_result, sub_result, sbc_result;
    wire [31:0] mul_result;
    wire [15:0] div_result, mod_result;
    wire cout_add, cout_adc, cout_sbc;

    wire [7:0] add8_result, adc8_result, sub8_result, sbc8_result;
    wire [7:0] mul8_result, div8_result, mod8_result;

    wire [7:0] add8_lo_result, adc8_lo_result, sub8_lo_result, sbc8_lo_result;
    wire [7:0] mul8_lo_result, div8_lo_result, mod8_lo_result;
    
    adder_16bit add16 (.A(reg_rd), .B(reg_rr), .cin(1'b0), .sum(add_result), .cout(cout_add));
    adder_16bit adc16 (.A(reg_rd), .B(reg_rr), .cin(cin),  .sum(adc_result), .cout(cout_adc));
    subtractor_16bit sub16 (.A(reg_rd), .B(reg_rr), .Y(sub_result));
    sbc_16bit sbc16 (.A(reg_rd), .B(reg_rr), .cin(~cin), .sum(sbc_result), .cout(cout_sbc));
    multiplier_16x16 mul16 (.A(reg_rd), .B(reg_rr), .result(mul_result));
    divider_16bit div16 (.A(reg_rd), .B(reg_rr), .Q(div_result), .R(mod_result));

    adder_8bit add8 (.A(reg_rd[15:8]), .B(reg_rr[15:8]), .cin(1'b0), .sum(add8_result), .cout());
    adder_8bit adc8 (.A(reg_rd[15:8]), .B(reg_rr[15:8]), .cin(cin),  .sum(adc8_result), .cout());
    subtractor_8bit sub8 (.A(reg_rd[15:8]), .B(reg_rr[15:8]), .S(sub8_result));
    sbc_8bit sbc8 (.A(reg_rd[15:8]), .B(reg_rr[15:8]), .cin(~cin), .S(sbc8_result));
    multiplier_8bit mul8 (.A(reg_rd[15:8]), .B(reg_rr[15:8]), .Y(mul8_result));
    divider_8bit    div8 (.A(reg_rd[15:8]), .B(reg_rr[15:8]), .Q(div8_result), .R());
    modulo_8bit     mod8 (.A(reg_rd[15:8]), .B(reg_rr[15:8]), .R(mod8_result));

    adder_8bit add8_lo (.A(reg_rd[7:0]), .B(reg_rr[7:0]), .cin(1'b0), .sum(add8_lo_result), .cout());
    adder_8bit adc8_lo (.A(reg_rd[7:0]), .B(reg_rr[7:0]), .cin(cin),  .sum(adc8_lo_result), .cout());
    subtractor_8bit sub8_lo (.A(reg_rd[7:0]), .B(reg_rr[7:0]), .S(sub8_lo_result));
    sbc_8bit sbc8_lo (.A(reg_rd[7:0]), .B(reg_rr[7:0]), .cin(~cin), .S(sbc8_lo_result));
    multiplier_8bit mul8_lo (.A(reg_rd[7:0]), .B(reg_rr[7:0]), .Y(mul8_lo_result));
    divider_8bit    div8_lo (.A(reg_rd[7:0]), .B(reg_rr[7:0]), .Q(div8_lo_result), .R());
    modulo_8bit     mod8_lo (.A(reg_rd[7:0]), .B(reg_rr[7:0]), .R(mod8_lo_result));
    
    always @(*) begin
        case (decoding_signal)
            7'b0000000: begin alu_result0 = {8'b0, add8_lo_result}; alu_result1 = 16'b0; end
            7'b0000001: begin alu_result0 = {8'b0, adc8_lo_result}; alu_result1 = 16'b0; end
            7'b0000010: begin alu_result0 = {8'b0, sub8_lo_result}; alu_result1 = 16'b0; end
            7'b0000011: begin alu_result0 = {8'b0, sbc8_lo_result}; alu_result1 = 16'b0; end
            7'b0000100: begin alu_result0 = {8'b0, mul8_lo_result}; alu_result1 = 16'b0; end
            7'b0000101: begin alu_result0 = {8'b0, div8_lo_result}; alu_result1 = 16'b0; end
            7'b0000110: begin alu_result0 = {8'b0, mod8_lo_result}; alu_result1 = 16'b0; end

            7'b0001000: begin alu_result0 = {add8_result, 8'b0}; alu_result1 = 16'b0; end
            7'b0001001: begin alu_result0 = {adc8_result, 8'b0}; alu_result1 = 16'b0; end
            7'b0001010: begin alu_result0 = {sub8_result, 8'b0}; alu_result1 = 16'b0; end
            7'b0001011: begin alu_result0 = {sbc8_result, 8'b0}; alu_result1 = 16'b0; end
            7'b0001100: begin alu_result0 = {mul8_result, 8'b0}; alu_result1 = 16'b0; end
            7'b0001101: begin alu_result0 = {div8_result, 8'b0}; alu_result1 = 16'b0; end
            7'b0001110: begin alu_result0 = {mod8_result, 8'b0}; alu_result1 = 16'b0; end

            7'b0010000: begin alu_result0 = add_result;       alu_result1 = 16'b0; end
            7'b0010001: begin alu_result0 = adc_result;       alu_result1 = 16'b0; end
            7'b0010010: begin alu_result0 = sub_result;       alu_result1 = 16'b0; end
            7'b0010011: begin alu_result0 = sbc_result;       alu_result1 = 16'b0; end
            7'b0010100: begin alu_result0 = mul_result[15:0]; alu_result1 = mul_result[31:16]; end
            7'b0010101: begin alu_result0 = div_result;       alu_result1 = 16'b0; end
            7'b0010110: begin alu_result0 = mod_result;       alu_result1 = 16'b0; end

            default: begin alu_result0 = 16'b0; alu_result1 = 16'b0; end
        endcase
    end

    wire n_flag, z_flag, c_flag, v_flag, s_flag, h_flag;

    assign n_flag = alu_result0[15];

    wire [15:0] nor_result_lo;
    generate
        genvar i;
        for (i = 0; i < 16; i = i + 1)
            nor (nor_result_lo[i], alu_result0[i], alu_result0[i]);
    endgenerate

    and (z_flag,
        nor_result_lo[0],  nor_result_lo[1],  nor_result_lo[2],  nor_result_lo[3],
        nor_result_lo[4],  nor_result_lo[5],  nor_result_lo[6],  nor_result_lo[7],
        nor_result_lo[8],  nor_result_lo[9],  nor_result_lo[10], nor_result_lo[11],
        nor_result_lo[12], nor_result_lo[13], nor_result_lo[14], nor_result_lo[15]
    );

    assign c_flag = cout_add;

    wire v_tmp;
    xor (v_tmp, reg_rd[15], reg_rr[15]);
    xor (v_flag, v_tmp, alu_result0[15]);

    xor (s_flag, n_flag, v_flag);

    wire not_res3, and_r3_rr3, and_r3_nres3, and_rr3_nres3;
    not (not_res3, alu_result0[3]);
    and (and_r3_rr3, reg_rd[3], reg_rr[3]);
    and (and_r3_nres3, reg_rd[3], not_res3);
    and (and_rr3_nres3, reg_rr[3], not_res3);
    or  (h_flag, and_r3_rr3, and_r3_nres3, and_rr3_nres3);

    always @(*) begin
        if (decoding_signal == 7'b0010101 || decoding_signal == 7'b0010110) begin
            $display("[ARITH] decoding = %b", decoding_signal);
            $display("[ARITH] reg_rd = %0d, reg_rr = %0d", reg_rd, reg_rr);
            $display("[ARITH] div_result = %0d", div_result);
            $display("[ARITH] mod_result = %0d", mod_result);
            $display("[ARITH] alu_result0 = %0d", alu_result0);
        end
    end

    assign alu_flag = {2'b00, h_flag, s_flag, v_flag, n_flag, z_flag, c_flag};

endmodule