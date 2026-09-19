`timescale 1ns / 1ps

module APB_Timer #(
    parameter CLK_FREQ = 100_000_000 // 100 MHz System Clock
)(
    input  wire        PCLK,
    input  wire        PRESETn,
    input  wire [31:0] PADDR,
    input  wire        PSEL,
    input  wire        PENABLE,
    input  wire        PWRITE,
    input  wire [31:0] PWDATA,
    output wire [31:0] PRDATA,
    output wire        PREADY
);

    localparam CNT_10MS = CLK_FREQ / 100;

    reg [31:0] clk_counter;
    reg [31:0] timer_val_reg;
    reg        timer_en_reg;
    
    localparam ADDR_CTRL = 8'h00; // Bit 0: Enable, Bit 1: Soft Reset
    localparam ADDR_VAL  = 8'h04; // Read Only: 1/100s Time Value
    
    wire apb_write = PSEL & PENABLE & PWRITE;
    wire apb_read  = PSEL & PENABLE & ~PWRITE;

    always @(posedge PCLK) begin
        if (~PRESETn) begin
            clk_counter <= 0;
            timer_val_reg <= 0;
            timer_en_reg <= 0;
        end else begin
            // Write to CTRL Register
            if (apb_write && (PADDR[7:0] == ADDR_CTRL)) begin
                timer_en_reg <= PWDATA[0];
                if (PWDATA[1]) begin // Soft Reset
                    timer_val_reg <= 0;
                    clk_counter <= 0;
                end
            end 
            // Timer Increment Logic
            else if (timer_en_reg) begin
                if (clk_counter >= (CNT_10MS - 1)) begin
                    clk_counter <= 0;
                    timer_val_reg <= timer_val_reg + 1;
                end else begin
                    clk_counter <= clk_counter + 1;
                end
            end
        end
    end
    
    // Read Logic
    assign PRDATA = (apb_read && (PADDR[7:0] == ADDR_CTRL)) ? {31'b0, timer_en_reg} :
                    (apb_read && (PADDR[7:0] == ADDR_VAL))  ? timer_val_reg : 32'b0;
                     
    assign PREADY = 1'b1;

endmodule