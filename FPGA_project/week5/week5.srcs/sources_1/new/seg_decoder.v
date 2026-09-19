`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/01 17:48:37
// Design Name: 
// Module Name: seg_decoder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module seg_decoder(
    input   wire    [3:0]   i_digit,
    output  reg     [6:0]   o_ca
);

always @(*) begin
    case(i_digit)
        4'd0 : o_ca = 7'b1000000;
        4'd1 : o_ca = 7'b1111001;
        4'd2 : o_ca = 7'b0100100;
        4'd3 : o_ca = 7'b0110000;
        4'd4 : o_ca = 7'b0011001;
        4'd5 : o_ca = 7'b0010010;
        4'd6 : o_ca = 7'b0000010;
        4'd7 : o_ca = 7'b1111000;
        4'd8 : o_ca = 7'b0000000;
        4'd9 : o_ca = 7'b0010000;
        //default : o_ca = 7'b1111111;
    endcase
end
endmodule
