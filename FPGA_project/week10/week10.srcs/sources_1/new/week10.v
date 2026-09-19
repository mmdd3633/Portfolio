`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/12 15:30:45
// Design Name: 
// Module Name: week10
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

////버튼 제어하기 1
//module week10(
//    input   wire    i_clk,
//    input   wire    i_rst_n,
//    input   wire    i_btn,
//    output  reg     o_led
//    );
    
//// --- 내부 레지스터 선언 ---
//    reg [1:0]  r_btn_sync;       // 1. 동기화를 위한 레지스터
//    reg        r_btn_prev;       // 2. 이전 상태 저장 (엣지 검출용)
//    reg        r_btn_posedge;    // 2. "버튼을 누른 순간" (1-clk 펄스)

//    // --- 버튼 신호 처리 (동기화 + 엣지 검출) ---
//    // 디바운싱(시간 측정) 로직이 빠져있습니다.
//    always @(posedge i_clk or negedge i_rst_n)
//    begin
//        if (i_rst_n == 1'b0) // 리셋
//        begin
//            r_btn_sync    <= 2'b00;
//            r_btn_prev    <= 1'b0;
//            r_btn_posedge <= 1'b0;
//        end
//        else // 클럭 상승 시
//        begin
//            // 1. 동기화: 외부 i_btn 입력을 2단 플립플랍으로 받음
//            r_btn_sync <= {r_btn_sync[0], i_btn};
            
//            // 2. 엣지 검출 (이전 상태 저장)
//            // '디바운싱'된 신호가 아닌 '동기화만 된' 신호(r_btn_sync[1])를 바로 사용
//            r_btn_prev <= r_btn_sync[1]; 
            
//            // 3. 엣지 검출 (펄스 생성)
//            // 이전 상태(r_btn_prev)는 0이고, 현재 상태(r_btn_sync[1])는 1인 순간 감지
//            if (r_btn_sync[1] == 1'b1 && r_btn_prev == 1'b0)
//            begin
//                r_btn_posedge <= 1'b1; // 1클럭 동안 펄스 발생
//            end
//            else
//            begin
//                r_btn_posedge <= 1'b0;
//            end
//        end
//    end
    
//// LED 제어
//always @(posedge i_clk or negedge i_rst_n)
//begin
//    if (i_rst_n == 1'b0)
//        o_led <= 0;
//    else
//    begin
//        if(r_btn_posedge == 1'b1)
//            o_led <= ~o_led;
//    end
//end
//endmodule

//// 버튼 제어하기 1(교수님)
//module week10(
//    input   wire    i_clk,
//    input   wire    i_rst_n,
//    input   wire    i_btn,
//    output  wire     o_led
//);

//// 지연된 버튼 입력
//reg     r_btn_dly;                                             //지연된 버튼
//always @(posedge i_clk or negedge i_rst_n)
//begin
//    if(~i_rst_n)
//        r_btn_dly <= 0;
//    else
//        r_btn_dly <= i_btn;
//end

//// 버튼을 누른 순간
//wire    w_btn_posedge;
////assign  w_btn_posedge = (i_btn == 1) & r_btn_dly == 0);        // i_btn이 1, r_btn_dly 가 0인 부분만 1로 만듬
//assign  w_btn_posedge = i_btn & ~r_btn_dly;                      // 두 코드가 같은 수행을 함

//// LED제어
//reg     r_led;
//always @(posedge i_clk or negedge i_rst_n)
//begin
//    if(~i_rst_n)
//        r_led <= 0;
//    else
//    begin
//        if(w_btn_posedge)
//            r_led <= ~r_led;
//    end
//end
//assign  o_led = r_led;
//endmodule

////버튼 제어하기 2
//module week10(
//    input   wire         i_clk,
//    input   wire         i_rst_n,
//    input   wire         i_btn,
//    output  reg  [6:0]   o_seg,
//    output  wire [7:0]   o_an                                 //segment하나만 사용할때는 따로 선언해주지 않아도됨
//);

//assign o_an = 8'b1111_1110;
//reg     r_btn_dly;                                             //지연된 버튼
//always @(posedge i_clk or negedge i_rst_n)
//begin
//    if(~i_rst_n)
//        r_btn_dly <= 0;
//    else
//        r_btn_dly <= i_btn;
//end

//wire    w_btn_posedge;
////assign  w_btn__posedge = (i_btn == 1) & r_btn_dly == 0);        // i_btn이 1, r_btn_dly 가 0인 부분만 1로 만듬
//assign  w_btn_posedge = i_btn & ~r_btn_dly;                      // 두 코드가 같은 수행을 함

//reg     [3:0]     r_count;
//// 7-segment 제어
//always @(posedge i_clk or negedge i_rst_n)
//begin
//    if (i_rst_n == 0)
//        r_count <= 0;
//    else
//    begin
//        if (w_btn_posedge == 1)
//            if(r_count == 4'd9)
//                r_count <= 4'd0;
//            else
//                r_count <= r_count + 1;
//    end
//end

//// 7-segment 변화제어
//always @(*)
//begin
//    case(r_count)
//        4'd0:    o_seg = 7'b1000000; // '0'
//        4'd1:    o_seg = 7'b1111001; // '1'
//        4'd2:    o_seg = 7'b0100100; // '2'
//        4'd3:    o_seg = 7'b0110000; // '3'
//        4'd4:    o_seg = 7'b0011001; // '4'
//        4'd5:    o_seg = 7'b0010010; // '5'
//        4'd6:    o_seg = 7'b0000010; // '6'
//        4'd7:    o_seg = 7'b1111000; // '7'
//        4'd8:    o_seg = 7'b0000000; // '8'
//        4'd9:    o_seg = 7'b0010000; // '9'
//        default: o_seg = 7'b1111111; // 9보다 큰 값이면 LED를 모두 끔
//    endcase
//end
//endmodule

// 버튼 제어하기 2(교수님)
module week10(
    input    wire            i_clk,
    input    wire            i_rst_n,
    input    wire            i_btn,
    output   wire    [7:0]   o_seg,
    output   wire    [7:0]   o_an
);

//지연된 버튼
assign o_an = 8'b1111_1110;
reg     r_btn_dly;                                             //지연된 버튼
always @(posedge i_clk or negedge i_rst_n)
begin
    if(~i_rst_n)
        r_btn_dly <= 0;
    else
        r_btn_dly <= i_btn;
end

//버튼 상승엣지(버튼 누른 순간)
wire    w_btn_posedge;
//assign  w_btn__posedge = (i_btn == 1) & r_btn_dly == 0);        // i_btn이 1, r_btn_dly 가 0인 부분만 1로 만듬
assign  w_btn_posedge = i_btn & ~r_btn_dly;                      // 두 코드가 같은 수행을 함

// 0~9까지 카운트
reg     [3:0]   r_cnt;
always @(posedge i_clk or negedge i_rst_n)
begin
    if(~i_rst_n)
        r_cnt <= 0;
    else
    begin
        if(w_btn_posedge == 1)
        begin
            if(r_cnt == 9)
                r_cnt <= 0;
            else
                r_cnt <= r_cnt + 1;
        end
    end
end

// 카운트 된 값 seg_decoder에서 결과 가져옴
wire        [6:0]   w_ca;
seg_decoder uut(
    .i_digit    (r_cnt      ),
    .o_ca       (w_ca       )
);
assign  o_seg = {1'b1, w_ca};                               // w_ca의 7비트와 dot을 끄는 1비트를 합쳐 8비트로 만들어 출력
endmodule