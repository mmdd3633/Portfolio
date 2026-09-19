`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/01 15:34:55
// Design Name: 
// Module Name: week5
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


//module week5(
//    input wire  [15:0] i_sw,
//    output wire [15:0] o_led
//    );
    
//assign o_led = (i_sw == 1) ? 16'b1010_1010_1010_1010
//                          : 16'b0101_0101_0101_0101;
//endmodule

//// sw 2개로 4가지 패던의 LED제어하기
//module week5(
//    input wire [1:0] i_sw, 
//    output reg [15:0] o_led
//);
//// if 문을 사용하려면 always문이 필요함 여기서 신호타입은 reg가 사용됨
//// wire -> assign = 
//// reg -> alwats = i_sw에 의해 o_led가 정해지기떄문에 reg
//// verilog 에서는 블럭정의할떄 begin ~ end를 사용한다. -> if 밑에도 두줄 이상 들어간다면 begin ~ end가 필요함(한줄은 필요없음)
//always @(*) begin
//    if (i_sw == 2'b00)
//        o_led = 16'b1111_1111_1111_1111;
//    else if ( i_sw == 2'b01 )
//        o_led = 16'b1010_1010_1010_1010;
//    else if ( i_sw == 2'b10 )
//        o_led = 16'b1111_0000_1111_0000;
//    else 
//        o_led = 16'b0000_1111_0000_1111;
//end

//endmodule

//// case문
//module week5(
//    input wire [1:0] i_sw, 
//    output reg [15:0] o_led
//);

//// case를 사용할 수 있는 경우가 따로 있음
//always @(*) begin
//    case ( i_sw )
//        2'b00 : o_led = 16'b1111_1111_1111_1111;
//        2'b01 : o_led = 16'b1010_1010_1010_1010;
//        2'b10 : o_led = 16'b1111_0000_1111_0000;
//        2'b11 : o_led = 16'b0000_1111_0000_1111;
//    endcase
//end
//endmodule

// 7-segment 제어
module week5(
    input wire [3:0] i_digit,
    input wire [7:0] i_an,
    output wire [7:0] o_ca,
    output wire [7:0] o_an
);

assign o_an = i_an;
assign o_ca[7] = 1'b1;

seg_decoder u__seg_dec(
// 선이 어떻게 연결되어야 하는지 적어 줌
// .다음은 하위모듈의 포트이름 그대로 ()안에는 연결되어야 하는것 = top모듈에서의 포트이름
    .i_digit        (i_digit    ), 
    .o_ca           (o_ca[6:0]  )
);

endmodule