`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/05/15 13:58:28
// Design Name: 
// Module Name: tb_apb_test
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

`timescale 1ns/1ps

module tb_apb_test;

// Clock & Reset
reg r_clk;
reg r_rst_n;

// APB signals
reg  [31:0] PADDR;
reg  [31:0] PWDATA;
reg         PWRITE;
reg         PSEL;
reg         PENABLE;
wire [31:0] PRDATA;
wire        PREADY;

// Clock generation: 100MHz (10ns period)
initial begin
  r_clk = 0;
  forever #5 r_clk = ~r_clk;  
end

// Reset generation
initial begin
  r_rst_n = 0;
  #100;               
  r_rst_n = 1;      
end

// APB Write Task
task apb_write;
  input [31:0] addr;
  input [31:0] data;
  begin
    @(posedge r_clk);
    PADDR   <= addr;
    PWDATA  <= data;
    PWRITE  <= 1'b1;
    PSEL    <= 1'b1;
    PENABLE <= 1'b0;

    @(posedge r_clk);
    PENABLE <= 1'b1;

    wait (PREADY == 1'b1);

    @(posedge r_clk);
    PSEL    <= 1'b0;
    PENABLE <= 1'b0;
    PWRITE  <= 1'b0;
  end
endtask

// APB Read Task
task apb_read;
  input  [31:0] addr;
  begin
    @(posedge r_clk);
    PADDR   <= addr;
    PWRITE  <= 1'b0;
    PSEL    <= 1'b1;
    PENABLE <= 1'b0;

    @(posedge r_clk);
    PENABLE <= 1'b1;

    wait (PREADY == 1'b1);

    @(posedge r_clk);

    PSEL    <= 1'b0;
    PENABLE <= 1'b0;
  end
endtask

apb_led dut 
(
    .i_clk        (r_clk),
    .i_rst_n      (r_rst_n),
    .i_apb_paddr  (PADDR),
    .i_apb_penable(PENABLE),
    .i_apb_psel   (PSEL),
    .i_apb_pwrite (PWRITE),
    .i_apb_pwdata (PWDATA),
    .o_apb_prdata (PRDATA),
    .o_apb_pready (PREADY),
    .o_apb_pslverr(w_pslverr),
    .o_led        (w_led)
);

initial begin
  @(posedge r_rst_n);

  repeat(10) @(posedge r_clk);
  apb_write(32'h43C0_0000, 32'h2AA);
  apb_read(32'h43C0_0000);

  #1000 $finish;
end

endmodule
