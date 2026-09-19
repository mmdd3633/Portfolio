`timescale 1ns / 1ps                // timescale (시간의 단위 / 소수점 3자리까지 표현할 수 있도록 하겠다)
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/15 16:39:41
// Design Name: 
// Module Name: tb_week7
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


module tb_week7();
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

reg     r_sw;
initial
begin
    r_sw = 0;
    #2000 r_sw = 1;
    #2550 r_sw = 0;
    #9550 r_sw = 1;
end

week7   tb_week7
(
    .i_rst_n    (r_rst_n        ),
    .i_clk      (r_clk          ),
    .i_sw       (r_sw           )
);

endmodule
