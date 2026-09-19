module sevenseg_mux (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [15:0] value,
    output reg  [3:0]  seg_an,
    output reg  [7:0]  seg_cat
);
    reg [16:0] refresh_counter;
    reg [3:0] nibble;

    always @(posedge clk) begin
        if (!rst_n)
            refresh_counter <= 17'd0;
        else
            refresh_counter <= refresh_counter + 1'b1;
    end

    always @(*) begin
        case (refresh_counter[16:15])
            2'd0: begin seg_an = 4'b1110; nibble = value[3:0];   end
            2'd1: begin seg_an = 4'b1101; nibble = value[7:4];   end
            2'd2: begin seg_an = 4'b1011; nibble = value[11:8];  end
            default: begin seg_an = 4'b0111; nibble = value[15:12]; end
        endcase

        seg_cat[7] = 1'b1;             // decimal point off
        seg_cat[6:0] = hex_to_7seg(nibble);
    end

    function [6:0] hex_to_7seg;
        input [3:0] hex;
        begin
            // seg_cat[6:0] = G F E D C B A, active-low
            case (hex)
                4'h0: hex_to_7seg = 7'b1000000;
                4'h1: hex_to_7seg = 7'b1111001;
                4'h2: hex_to_7seg = 7'b0100100;
                4'h3: hex_to_7seg = 7'b0110000;
                4'h4: hex_to_7seg = 7'b0011001;
                4'h5: hex_to_7seg = 7'b0010010;
                4'h6: hex_to_7seg = 7'b0000010;
                4'h7: hex_to_7seg = 7'b1111000;
                4'h8: hex_to_7seg = 7'b0000000;
                4'h9: hex_to_7seg = 7'b0010000;
                4'hA: hex_to_7seg = 7'b0001000;
                4'hB: hex_to_7seg = 7'b0000011;
                4'hC: hex_to_7seg = 7'b1000110;
                4'hD: hex_to_7seg = 7'b0100001;
                4'hE: hex_to_7seg = 7'b0000110;
                default: hex_to_7seg = 7'b0001110;
            endcase
        end
    endfunction
endmodule
