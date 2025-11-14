module seg_display_controller (
    input wire clk,
    input wire reset,
    input wire [7:0] temp_in, 
    output reg [3:0] an,      
    output reg [6:0] seg,     
    output reg dp             
);

    reg [3:0] digit [3:0];  
    reg [1:0] digit_sel = 0;
    reg [16:0] refresh_cnt = 0;

    wire refresh_tick = (refresh_cnt == 100000);  

    // BCD Conversion
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            digit[0] <= 0;
            digit[1] <= 0;
            digit[2] <= 0;
            digit[3] <= 0;
        end else begin
            digit[3] <= (temp_in / 10) % 10;    // Tens
            digit[2] <= temp_in % 10;      // Ones
            digit[1] <= 0;
            digit[0] <= 0;
        end
    end

    // Refresh counter
    always @(posedge clk) begin
        if (refresh_cnt >= 100000)
            refresh_cnt <= 0;
        else
            refresh_cnt <= refresh_cnt + 1;
    end

    // Digit select cycle
    always @(posedge clk) begin
        if (refresh_tick)
            digit_sel <= digit_sel + 1;
    end

    // Drive segments and anodes
    always @(*) begin
        case (digit_sel)
            2'd3: begin an = 4'b1110; seg = seg_decoder(digit[0]); dp = 1; end  
            2'd2: begin an = 4'b1101; seg = seg_decoder(digit[1]); dp = 1; end
            2'd1: begin an = 4'b1011; seg = seg_decoder(digit[2]); dp = 0; end
            2'd0: begin an = 4'b0111; seg = seg_decoder(digit[3]); dp = 1; end
        endcase
    end

    // 7-segment decoder
    function [6:0] seg_decoder;
        input [3:0] digit;
        case (digit)
            4'd0: seg_decoder = 7'b1000000;
            4'd1: seg_decoder = 7'b1111001;
            4'd2: seg_decoder = 7'b0100100;
            4'd3: seg_decoder = 7'b0110000;
            4'd4: seg_decoder = 7'b0011001;
            4'd5: seg_decoder = 7'b0010010;
            4'd6: seg_decoder = 7'b0000010;
            4'd7: seg_decoder = 7'b1111000;
            4'd8: seg_decoder = 7'b0000000;
            4'd9: seg_decoder = 7'b0010000;
            default: seg_decoder = 7'b1111111;
        endcase
    endfunction

endmodule
