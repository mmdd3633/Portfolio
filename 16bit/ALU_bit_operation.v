module bitop_unit (
    input  [15:0] reg_rd,
    input  [7:0]  sreg_out,
    input  [6:0]  decoding_signal,
    input  [3:0]  nbit,
    input  [2:0]  sbit,
    input  [2:0]  mbit,

    output [15:0] alu_result0,
    output [7:0]  alu_flag
);

    // ??? one-hot ??? (nbit, mbit, sbit ?? ??)
    wire [15:0] one_hot_bit16_n = 16'b1 << nbit[3:0];
    wire [15:0] one_hot_bit16_m = 16'b1 << mbit[2:0];
    wire [7:0]  one_hot_bit8    = 8'b1  << sbit[2:0];

    // ???? ?? ??
    wire [15:0] r_bset = reg_rd | one_hot_bit16_n;
    wire [15:0] r_bclr = reg_rd & ~one_hot_bit16_n;
    wire [15:0] r_bnot = reg_rd ^ one_hot_bit16_n;

    // SREG ?? ??
    wire [7:0] s_bset = sreg_out | one_hot_bit8;
    wire [7:0] s_bclr = sreg_out & ~one_hot_bit8;

    // BIT ??
    wire sreg_bit_m = sreg_out[mbit];
    wire rd_bit_m   = reg_rd[mbit];

    wire band_bit = rd_bit_m & sreg_bit_m;
    wire bor_bit  = rd_bit_m | sreg_bit_m;
    wire bxor_bit = rd_bit_m ^ sreg_bit_m;

    wire [15:0] band_res = (reg_rd & ~one_hot_bit16_m) | (band_bit ? one_hot_bit16_m : 16'b0);
    wire [15:0] bor_res  = (reg_rd & ~one_hot_bit16_m) | (bor_bit  ? one_hot_bit16_m : 16'b0);
    wire [15:0] bxor_res = (reg_rd & ~one_hot_bit16_m) | (bxor_bit ? one_hot_bit16_m : 16'b0);

    // ?? ??
    assign alu_result0 = (decoding_signal == 7'b0110000) ? r_bset   :
                         (decoding_signal == 7'b0110001) ? r_bclr   :
                         (decoding_signal == 7'b0110010) ? r_bnot   :
                         (decoding_signal == 7'b0110101) ? band_res :
                         (decoding_signal == 7'b0110110) ? bor_res  :
                         (decoding_signal == 7'b0110111) ? bxor_res :
                         reg_rd;

    // ??? ??
    wire zero     = (alu_result0 == 16'b0);
    wire negative = alu_result0[15];
    wire overflow = 1'b0;
    wire sign     = negative ^ overflow;
    wire carry    = 1'b0;

    wire [7:0] bitop_flags;
    assign bitop_flags[0] = carry;
    assign bitop_flags[1] = zero;
    assign bitop_flags[2] = negative;
    assign bitop_flags[3] = overflow;
    assign bitop_flags[4] = sign;
    assign bitop_flags[7:5] = 3'b000;

    // ??? alu_flag ??
    assign alu_flag = (decoding_signal == 7'b0110101 || 
                       decoding_signal == 7'b0110110 || 
                       decoding_signal == 7'b0110111) ? bitop_flags :
                      (decoding_signal == 7'b0110011) ? s_bset :
                      (decoding_signal == 7'b0110100) ? s_bclr :
                      sreg_out;

endmodule
