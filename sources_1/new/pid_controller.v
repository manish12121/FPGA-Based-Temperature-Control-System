module da_pid_controller (
    input clk,
    input reset,
    input signed [15:0] set_temp,
    input signed [15:0] curr_temp,
    output reg signed [15:0] control_out
);
    wire signed [15:0] e0, e1, e2;
    reg signed [15:0] err1 = 0, err2 = 0;
    assign e0 = set_temp - curr_temp;
    assign e1 = err1;
    assign e2 = err2;

    wire signed [31:0] m1, m2, m3;

    da_multiplier #(16'sd4096) mul1 (.clk(clk), .x(e0), .result(m1));  // K1 = 1.0
    da_multiplier #(-16'sd2048) mul2 (.clk(clk), .x(e1), .result(m2)); // K2 = -0.5
    da_multiplier #(16'sd1024) mul3 (.clk(clk), .x(e2), .result(m3));  // K3 = 0.25
    
    reg signed [31:0] acc = 0;
        parameter signed [15:0] U_MAX = 16'sd65535;
        parameter signed [15:0] U_MIN = 16'sd0;
    
        always @(posedge clk or posedge reset) begin
            if (reset) begin
                err1 <= 0; err2 <= 0;
                acc <= 0;
                control_out <= 0;
            end else begin
                err2 <= err1;
                err1 <= e0;
                acc <= acc + m1 + m2 + m3;
    
                if (acc[31:16] > U_MAX)
                    control_out <= U_MAX;
                else if (acc[31:16] < U_MIN)
                    control_out <= U_MIN;
                else
                    control_out <= acc[31:16];
            end
        end
    endmodule
