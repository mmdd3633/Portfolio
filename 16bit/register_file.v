module register_file (
    input clk,
    input reset,

    // input : alu_result
    input [15:0] alu_result0,  // low_result
    input [15:0] alu_result1,  // high_result
    input        exe_32,       // high or low

    // input_Rd, Rr(address)
    input [6:0]  decoding_signal,
    input [2:0]  rd,            // Rd
    input [2:0]  rr,            // Rr

    // write enable
    input        reg_wr,        // 0 = not update, 1 = Rd update

    // input: from memory
    input [15:0] mem_data,      // memory -> register
    input        mem_reg_sel,   // 0 = ALU result, 1 = mem_data

    // output : op1, op2
    output [15:0] reg_rr,  // Rr
    output [15:0] reg_rd   // Rdx`
);

    // 8? 16?? ????
    reg [15:0] reg_file [7:0];

    // read address
    assign reg_rr = reg_file[rr];
    assign reg_rd = reg_file[rd];

    // ??? ??? (ALU ?? ?? ???)
    wire [15:0] selected_result = (mem_reg_sel) ? mem_data : alu_result0;

    // ???? ?? ??
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            reg_file[0] <= 16'd1;
            reg_file[1] <= 16'd2;
            reg_file[2] <= 16'd3;
            reg_file[3] <= 16'd4;
            reg_file[4] <= 16'd5;
            reg_file[5] <= 16'd6;
            reg_file[6] <= 16'd7;
            reg_file[7] <= 16'd8;
        end 
        else if (reg_wr) begin
            case (decoding_signal)
                8'b10000000: begin // MOV
                    reg_file[rd] <= reg_file[rr];
                end
                8'b10000001: begin // MOVW
                    reg_file[rd] <= reg_file[rr];
                    if (rd < 7)
                        reg_file[rd + 1] <= reg_file[rr + 1];
		    else if (rd == 7)
			reg_file[0] <= reg_file[rr];
                end
                8'b10000011: begin // EXHG
                    reg_file[rd] <= reg_file[rr];
                    reg_file[rr] <= reg_file[rd];
                end
                default: begin
                    if (!exe_32) begin
                        reg_file[rd] <= selected_result;
                    end else begin
                        reg_file[rd] <= alu_result0;
                        if (rd < 7)
                            reg_file[rd + 1] <= alu_result1;
                    end
                end
            endcase
        end
    end

endmodule
