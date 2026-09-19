`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/22 16:35:29
// Design Name: 
// Module Name: week8_tb
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


module week8_tb();
// 클락신호 만드는 코드
reg     r_clk;
initial
begin
    r_clk = 0;
    forever                                             // 5ns라는 시간이 지날때마다 값이 반전
        #5  r_clk = ~r_clk;
end

reg     r_rst_n;
initial
begin
    r_rst_n = 1;
    #1000 r_rst_n = 0;
    #500  r_rst_n = 1;
end

reg        r_sw;
initial
begin
    r_sw = 0;
    #200 r_sw = 1;
    #255 r_sw = 0;
    #955 r_sw = 1;
    

end

week8   week8_tb
(
    .i_rst_n    (r_rst_n        ),
    .i_clk      (r_clk          ),
    .i_sw       (r_sw           )
);

endmodule