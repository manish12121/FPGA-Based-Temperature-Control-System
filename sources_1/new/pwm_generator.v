module pwm_generator (
    input clk,
    input reset,
    input [15:0] duty,
    output reg pwm_out
);
    reg [15:0] counter = 0;

    always @(posedge clk or posedge reset) begin
        if (reset)
            counter <= 0;
        else
            counter <= counter + 1;
    end

    always @(posedge clk or posedge reset) begin
        if (reset)
            pwm_out <= 0;
        else
            pwm_out <= (counter < duty);
    end
endmodule