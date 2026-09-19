`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/15 15:38:47
// Design Name: 
// Module Name: week7
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


//module week7(
//    input   wire        i_rst_n,                        // active low - 0일때 동작함
//    input   wire        i_clk
//    );
    
//reg     [27:0]  r_cnt;                                  // 플립플랍이 필요한데 이건 리셋신호가 필요함
 
//always @(posedge i_clk or negedge i_rst_n)
//begin
//    if(i_rst_n == 1'b0)
//        r_cnt <= 28'd0;                                 // 좌측 우측의 비트수가 다르면 써줘야함
//    else
//    begin
//        if (r_cnt == 28'd99)
//            r_cnt <= 0;                                 // 클락이 들어가는 것에는 화살표 연산자 사용
//        else
//            r_cnt <= r_cnt + 1;
//    end
//end
//endmodule

module week7(
    input   wire        i_rst_n,                        // active low - 0일때 동작함
    input   wire        i_clk,
    input   wire        i_sw,
    output  reg         o_led
    );
    
reg     [27:0]  r_cnt;                                  // 플립플랍이 필요한데 이건 리셋신호가 필요함

always @(posedge i_clk or negedge i_rst_n)
begin
    if(i_rst_n == 1'b0)
        r_cnt <= 28'd0;                                 // 좌측 우측의 비트수가 다르면 써줘야함
    else
    begin
        if (i_sw == 28'd1)
        begin
            if (r_cnt == 28'd99)
                r_cnt <= 0;
            else
                r_cnt <= r_cnt + 1;
        end
        else
            r_cnt <= 0;                                 // 클락이 들어가는 것에는 화살표 연산자 사용
    end
end

// led 제어부분
always @(posedge i_clk or negedge i_rst_n)
begin
    if (~i_rst_n)                                       // (i_rst_n == 1'b0) 과 같은 형태 축약 형태임
        o_led <= 0;
    else
    begin
        if (i_sw == 1'b1)
        begin
            if (r_cnt == 28'd0)
                o_led <= ~o_led;
        end
        else
            o_led <= 0;
    end
end
endmodule
