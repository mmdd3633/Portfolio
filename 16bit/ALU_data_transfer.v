module ALU_data_transfer (
    input [6:0] decode_signal,
    input [11:0] imm,
    input [15:0] reg_rd,     // Rd
    input [15:0] reg_rr,     // Rr, R0
    output reg [11:0] mem_addr,
    output reg [15:0] mem_data
);

    reg [15:0] temp_addr;

    always @(*) begin
        mem_addr = 13'd0;
        mem_data = 16'd0;
        temp_addr = 16'd0;

        case (decode_signal)
            7'b1010000: begin // LDI
                mem_addr = imm[11:0];
            end
            7'b1010001: begin // LDR (zero-extend)
                temp_addr = reg_rr + {8'd0, imm[7:0]};
                mem_addr = temp_addr[11:0];
            end
            7'b1010010: begin // LDR (sign-extend)
                temp_addr = reg_rr + {{8{imm[7]}}, imm[7:0]};
                mem_addr = temp_addr[11:0];
            end
            7'b1010011: begin // STI
                mem_addr = imm[11:0];
                mem_data = reg_rr;
            end
            7'b1010100: begin // STR (offset)
                temp_addr = reg_rr + {8'd0, imm[7:0]};
                mem_addr = temp_addr[11:0];
                mem_data = reg_rd;
            end
            7'b1010101: begin // STR (direct)
                mem_addr = reg_rr[11:0];
                mem_data = reg_rd;
            end
        endcase
    end
endmodule

