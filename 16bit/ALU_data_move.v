module ALU_data_move (
    input [15:0] reg_rd,         // Rd
    input [15:0] reg_rr,         // Rr
    input [11:0] imm,        // immediate
    input [6:0] decode_signal,

    output reg [15:0] alu_result0 // Rd
);

    always @(*) begin
        alu_result0 = 16'd0;

        case (decode_signal)
            7'b1000010: begin // SWAP
                alu_result0 = {reg_rd[7:0], reg_rd[15:8]}; // nibble swap (low byte)
            end

            7'b1000100: begin // MOVLI
                alu_result0 = {reg_rd[15:8], imm[7:0]};
            end

            7'b1000101: begin // MOVHI
                alu_result0 = {imm[7:0], reg_rd[7:0]};
            end

            7'b1000110: begin // NOP
                alu_result0 = 16'd0;
            end
        endcase
    end

endmodule

