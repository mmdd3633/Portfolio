`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/22 15:44:53
// Design Name: 
// Module Name: week8
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


//module week8(
//    input   wire        i_rst_n,                        // active low - 0일때 동작함
//    input   wire        i_clk,
//    input   wire  [1:0] i_sw,
//    output  reg         o_led
//    );

//wire    [27:0]  w_cnt_max;
//assign  w_cnt_max = (i_sw[1] == 1)? 28'd5 : 28'd10;                     // 주기를 변수로 만들어 설정함

//reg     [27:0]  r_cnt;                                                  // 플립플랍이 필요한데 이건 리셋신호가 필요함

//always @(posedge i_clk or negedge i_rst_n)
//begin
//    if(i_rst_n == 1'b0)
//        r_cnt <= 28'd0;                                                 // 좌측 우측의 비트수가 다르면 써줘야함
//    else
//    begin
//        if (i_sw[0] == 28'd1)
//        begin
//            if (r_cnt >= w_cnt_max)   
//                r_cnt <= 0;
//            else
//                r_cnt <= r_cnt + 1;
//        end
//        else
//            r_cnt <= 0;                                             // 클락이 들어가는 것에는 화살표 연산자 사용
//    end
//end

//// led 제어부분
//always @(posedge i_clk or negedge i_rst_n)
//begin
//    if (~i_rst_n)                                                   // (i_rst_n == 1'b0) 과 같은 형태 축약 형태임
//        o_led <= 0;
//    else
//    begin
//        if (i_sw[0] == 1'b1)
//        begin
//            if (r_cnt == 28'd0)
//                o_led <= ~o_led;
//        end
//        else
//            o_led <= 0;
//    end
//end
//endmodule


module week8(
    input   wire        i_rst_n,                                  // active low - 0일때 동작함
    input   wire        i_clk,
    input   wire        i_sw,
    output  reg  [7:0]  o_led
    );
reg     [27:0]  r_cnt;                                            // 플립플랍이 필요한데 이건 리셋신호가 필요함

always @(posedge i_clk or negedge i_rst_n)
begin
    if(i_rst_n == 1'b0)
        r_cnt <= 28'd0;                                           // 좌측 우측의 비트수가 다르면 써줘야함
    else
    begin
        if (i_sw == 1'b1)
        begin
            if (r_cnt == 10)   
                r_cnt <= 0;
            else
                r_cnt <= r_cnt + 1;
        end
        else
            r_cnt <= 0;                                           // 클락이 들어가는 것에는 화살표 연산자 사용
    end
end


reg     [2:0]   r_8s_cnt;
always @(posedge i_clk or negedge i_rst_n)
begin
    if(~i_rst_n)
        r_8s_cnt <= 0;
    else
    begin
        if(i_sw)
        begin
            if(r_cnt == 10)
                r_8s_cnt <= r_8s_cnt + 1;                         // r_8s_cnt로 0초 ~ 7초까지 셀수 있음
        end
        else
            r_8s_cnt <= 0;
    end
end

// led 제어부분
always @(*)
begin
    if (i_sw)                                                     // (i_rst_n == 1'b0) 과 같은 형태 축약 형태임
    begin
        case (r_8s_cnt)
                4'd0:    o_led <= 8'b0000_0001; 
                4'd1:    o_led <= 8'b0000_0010; 
                4'd2:    o_led <= 8'b0000_0100; 
                4'd3:    o_led <= 8'b0000_1000; 
                4'd4:    o_led <= 8'b0001_0000; 
                4'd5:    o_led <= 8'b0010_0000; 
                4'd6:    o_led <= 8'b0100_0000; 
                4'd7:    o_led <= 8'b1000_0000; 
                default: o_led <= 8'b0000_0000; 
            endcase
    end
    else
        o_led <= 0;
end
endmodule