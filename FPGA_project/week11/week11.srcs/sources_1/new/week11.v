`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/19 15:33:08
// Design Name: 
// Module Name: week11
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


//module week11(
//    input    wire            i_clk,
//    input    wire            i_rst_n,
//    input    wire            i_btn,
//    output   wire    [7:0]   o_seg,
//    output   wire    [7:0]   o_an
//);

//assign o_an = 8'b1111_1110;

////------------------------------------------------------
//// 1) 버튼 입력 동기화 (2플립플롭)
////------------------------------------------------------
//reg r_btn_sync0;
//reg r_btn_sync1;

//always @(posedge i_clk or negedge i_rst_n)
//begin
//    if(~i_rst_n) begin
//        r_btn_sync0 <= 1'b0;
//        r_btn_sync1 <= 1'b0;
//    end
//    else begin
//        r_btn_sync0 <= i_btn;
//        r_btn_sync1 <= r_btn_sync0;
//    end
//end

////------------------------------------------------------
//// 2) 디바운싱 로직
////    r_btn_sync1 이 일정 시간 이상 유지될 때만 r_btn_db 갱신
////------------------------------------------------------
//parameter TIMEOUT = 1_000_000;   // 클럭 주파수에 맞게 조정 (예: 50MHz 기준 약 20ms 정도)

//reg [19:0] r_db_cnt;
//reg        r_btn_db;

//always @(posedge i_clk or negedge i_rst_n)
//begin
//    if(~i_rst_n) begin
//        r_db_cnt  <= 20'd0;
//        r_btn_db  <= 1'b0;
//    end
//    else begin
//        if (r_btn_sync1 == r_btn_db) begin
//            // 입력과 현재 안정 상태가 같으면 카운터 리셋
//            r_db_cnt <= 20'd0;
//        end
//        else begin
//            // 입력과 현재 안정 상태가 다르면 카운터 동작
//            if (r_db_cnt == TIMEOUT-1) begin
//                r_btn_db <= r_btn_sync1;     // 충분히 오래 유지되면 상태 갱신
//                r_db_cnt <= 20'd0;
//            end
//            else begin
//                r_db_cnt <= r_db_cnt + 1'b1;
//            end
//        end
//    end
//end

////------------------------------------------------------
//// 3) 디바운스된 버튼을 한 사이클 지연
////------------------------------------------------------
//reg r_btn_dly; 

//always @(posedge i_clk or negedge i_rst_n)
//begin
//    if(~i_rst_n)
//        r_btn_dly <= 1'b0;
//    else
//        r_btn_dly <= r_btn_db;   // ★ 여기서 이제 i_btn 대신 r_btn_db 사용
//end

////------------------------------------------------------
//// 4) 상승엣지 검출 (디바운스된 버튼 기준)
////------------------------------------------------------
//wire w_btn_posedge;
//assign w_btn_posedge = r_btn_db & ~r_btn_dly;   // 디바운스된 신호의 상승엣지

////------------------------------------------------------
//// 5) 0~9 카운트
////------------------------------------------------------
//reg [3:0] r_cnt;
//always @(posedge i_clk or negedge i_rst_n)
//begin
//    if(~i_rst_n)
//        r_cnt <= 4'd0;
//    else begin
//        if(w_btn_posedge) begin
//            if(r_cnt == 4'd9)
//                r_cnt <= 4'd0;
//            else
//                r_cnt <= r_cnt + 4'd1;
//        end
//    end
//end

////------------------------------------------------------
//// 6) 세그먼트 출력
////------------------------------------------------------
//wire [6:0] w_ca;

//seg_decoder uut(
//    .i_digit    (r_cnt  ),
//    .o_ca       (w_ca   )
//);

//assign o_seg = {1'b1, w_ca};

//endmodule

//////////////////////////////////////////////////////////////////////////

//module week11(
//    input    wire            i_clk,
//    input    wire            i_rst_n,
//    input    wire            i_btn,
//    output   wire    [7:0]   o_seg,
//    output   wire    [7:0]   o_an
//);

//assign o_an = 8'b1111_1110;

////------------------------------------------------------
//// 디바운싱 (동기화 FF 없이 바로 i_btn 사용)
//// 100MHz 기준 50ms → 5,000,000 클럭
////------------------------------------------------------
//parameter integer TIMEOUT = 2_500_000;

//reg [22:0] r_db_cnt;                                        // 디바운스 카운터
//reg        r_btn_db;                                        // 디바운스된 버튼 값

//always @(posedge i_clk or negedge i_rst_n)
//begin
//    if (~i_rst_n) begin
//        r_db_cnt  <= 23'd0;
//        r_btn_db  <= 1'b0;
//    end
//    else begin
//        if (i_btn == r_btn_db) begin                        // 입력과 현재 확정된 값이 같으면 카운터 리셋
//            r_db_cnt <= 23'd0;
//        end
//        else begin                                          // 입력이 바뀐 것처럼 보이면 일정 시간(50ms) 동안 유지되는지 확인
//            if (r_db_cnt == TIMEOUT - 1) begin
//                r_btn_db <= i_btn;                          // 50ms 동안 계속 같으면 새 값으로 확정
//                r_db_cnt <= 23'd0;
//            end
//            else begin
//                r_db_cnt <= r_db_cnt + 1'b1;
//            end
//        end
//    end
//end

////------------------------------------------------------
//// 디바운스된 버튼을 한 클럭 지연
////------------------------------------------------------
//reg     r_btn_dly;

//always @(posedge i_clk or negedge i_rst_n)
//begin
//    if(~i_rst_n)
//        r_btn_dly <= 1'b0;
//    else
//        r_btn_dly <= r_btn_db;                                  // 이제 i_btn 말고 r_btn_db 사용
//end

////------------------------------------------------------
//// 상승 엣지 검출 (디바운스된 버튼 기준)
////------------------------------------------------------
//wire    w_btn_posedge;
//assign  w_btn_posedge = r_btn_db & ~r_btn_dly;

////------------------------------------------------------
//// 0~9까지 카운트
////------------------------------------------------------
//reg     [3:0]   r_cnt;
//always @(posedge i_clk or negedge i_rst_n)
//begin
//    if(~i_rst_n)
//        r_cnt <= 4'd0;
//    else begin
//        if(w_btn_posedge == 1'b1) begin
//            if(r_cnt == 4'd9)
//                r_cnt <= 4'd0;
//            else
//                r_cnt <= r_cnt + 4'd1;
//        end
//    end
//end

////------------------------------------------------------
//// 세그먼트 디코더
////------------------------------------------------------
//wire    [6:0]   w_ca;

//seg_decoder uut(
//    .i_digit    (r_cnt  ),
//    .o_ca       (w_ca   )
//);

//assign  o_seg = {1'b1, w_ca};   // dot 끔 + 7세그

//endmodule

// 버튼 제어하기 3(교수님)
module week11(
    input    wire            i_clk,
    input    wire            i_rst_n,
    input    wire            i_btn,
    output   wire    [7:0]   o_seg,
    output   wire    [7:0]   o_an
);

//지연된 버튼
assign o_an = 8'b1111_1110;

localparam DEBOUNCE_TIMEOUT     = 24'd20;

reg     r_deb_btn;
reg     [23:0]  r_deb_cnt;

always @(posedge i_clk or negedge i_rst_n)
begin
    if(~i_rst_n)
        r_deb_btn <= 0;
    else
    begin
        if(r_deb_cnt >= DEBOUNCE_TIMEOUT)
            r_deb_btn <= i_btn;
    end
end

always @(posedge i_clk or negedge i_rst_n)
begin
    if(~i_rst_n)
        r_deb_cnt <= 0;
    else begin
        if(i_btn != r_deb_btn)
            r_deb_cnt <= r_deb_cnt + 1;
        else
        r_deb_cnt <= 0;
    end
end

reg     r_btn_dly;                                             //지연된 버튼
always @(posedge i_clk or negedge i_rst_n)
begin
    if(~i_rst_n)
        r_btn_dly <= 0;
    else
        r_btn_dly <= r_deb_btn;
end

//버튼 상승엣지(버튼 누른 순간)
wire    w_btn_posedge;
//assign  w_btn__posedge = (r_deb_btn == 1) & r_btn_dly == 0);        // r_deb_btn이 1, r_btn_dly 가 0인 부분만 1로 만듬
assign  w_btn_posedge = r_deb_btn & ~r_btn_dly;                      // 두 코드가 같은 수행을 함

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
