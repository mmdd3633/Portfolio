`timescale 1ns / 1ps

module APB_Button #(
    parameter CLK_FREQ = 100_000_000,
    parameter DEBOUNCE_CNT = 2_000_000 // 20ms
)(
    input  wire        PCLK,
    input  wire        PRESETn,
    input  wire [31:0] PADDR,
    input  wire        PSEL,
    input  wire        PENABLE,
    input  wire        PWRITE,
    input  wire [31:0] PWDATA,
    output wire [31:0] PRDATA,
    output wire        PREADY,
    
    input  wire [3:0]  btn_n_i // Active Low Button Inputs
);

    localparam ADDR_STATUS = 8'h00; // Raw Debounced Status
    localparam ADDR_EVENT  = 8'h04; // Event Flag (W1C)
    
    reg [3:0] btn_sync0, btn_sync1;
    reg [3:0] btn_debounced;
    reg [3:0] prev_state;
    reg [31:0] db_counter [3:0];
    reg [3:0] btn_event_reg;
    
    integer i;
    wire apb_write = PSEL & PENABLE & PWRITE;
    wire apb_read  = PSEL & PENABLE & ~PWRITE;
    
    always @(posedge PCLK) begin
        if (~PRESETn) begin
            btn_sync0 <= 4'hF;
            btn_sync1 <= 4'hF;
            btn_debounced <= 4'hF;
            prev_state <= 4'hF;
            btn_event_reg <= 4'h0;
            for (i=0; i<4; i=i+1) db_counter[i] <= 0;
        end else begin
            // 1. Metastability Sync
            btn_sync0 <= btn_n_i;
            btn_sync1 <= btn_sync0;
            
            // 2. Debounce & Edge Detection
            for (i=0; i<4; i=i+1) begin
                if (btn_sync1[i] != btn_debounced[i]) begin
                    if (db_counter[i] >= DEBOUNCE_CNT) begin
                        btn_debounced[i] <= btn_sync1[i];
                        db_counter[i] <= 0;
                    end else begin
                        db_counter[i] <= db_counter[i] + 1;
                    end
                end else begin
                    db_counter[i] <= 0;
                end
                
                // Falling Edge Detection (1 -> 0 means button pressed)
                prev_state[i] <= btn_debounced[i];
                if ((prev_state[i] == 1'b1) && (btn_debounced[i] == 1'b0)) begin
                    btn_event_reg[i] <= 1'b1; // Set Event
                end
            end
            
            // 3. W1C (Write 1 to Clear) for Event Register
            if (apb_write && (PADDR[7:0] == ADDR_EVENT)) begin
                btn_event_reg <= btn_event_reg & ~PWDATA[3:0];
            end
        end
    end
    
    // Read Logic
    assign PRDATA = (apb_read && (PADDR[7:0] == ADDR_STATUS)) ? {28'b0, btn_debounced} :
                    (apb_read && (PADDR[7:0] == ADDR_EVENT))  ? {28'b0, btn_event_reg} : 32'b0;
                     
    assign PREADY = 1'b1;

endmodule