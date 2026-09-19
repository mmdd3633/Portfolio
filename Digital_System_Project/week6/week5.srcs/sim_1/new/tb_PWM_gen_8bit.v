`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/03 14:22:38
// Design Name: 
// Module Name: tb_PWM_gen_8bit
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
module tb_PWM_gen_8bit();
    // 신호 선언
    reg         i_clk;
    reg         i_rst;
    reg  [7:0]  i_duty;
    wire        o_pwm;

    // 테스트할 모듈(UUT) 인스턴스화
    PWM_gen_8bit uut (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_duty(i_duty),
        .o_pwm(o_pwm)
    );

    // 클럭 생성 (100MHz 가정: 주기는 10ns)
    always #5 i_clk = ~i_clk;

    initial begin
        // 초기값 설정
        i_clk  = 0;
        i_rst  = 0;
        i_duty = 8'd0;

        // 리셋 해제
        #20 i_rst = 1;

        // 시나리오 1: Duty 25% (256단계 중 약 64)
        #10 i_duty = 8'd64;
        #3000; // 충분히 파형을 관찰할 시간 (1주기 = 256 * 10ns = 2560ns)

        // 시나리오 2: Duty 50% (128)
        #10 i_duty = 8'd128;
        #3000;

        // 시나리오 3: Duty 90% (약 230)
        #10 i_duty = 8'd230;
        #3000;

        // 시나리오 4: Duty 0% 및 100% 테스트
        #10 i_duty = 8'd0;
        #3000;
        #10 i_duty = 8'd255;
        #3000;

        // 시뮬레이션 종료
        $display("Simulation Finished!");
        $finish;
    end

    // 모니터링 (콘솔 출력)
    initial begin
        $monitor("Time=%0t | Duty=%d | PWM_Out=%b", $time, i_duty, o_pwm);
    end

endmodule
