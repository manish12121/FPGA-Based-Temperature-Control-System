module top_module (
    input wire clk,
    input wire reset,
    input wire rx,
    input wire mode_switch,         
    input wire btn_up,
    input wire btn_down,
    output wire pwm_fan,            
    output wire in1,                // IN for bulb
    output wire in2,                // Fan control pin 1 
    output wire in3,                // Fan control pin 2 
    output wire [3:0] an,
    output wire [6:0] seg,
    output wire dp
);

    wire [7:0] temp_data;
    wire data_valid;
    reg [7:0] temp_data_filtered = 0;
    reg [7:0] user_setpoint = 8'd24;
    wire [7:0] current_setpoint = mode_switch ? user_setpoint : 8'd24;
    reg [27:0] count = 0;

    uart_receiver uart_inst (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .data_out(temp_data),
        .data_valid(data_valid)
    );

    always @(posedge clk) begin
        if (data_valid) begin
            temp_data_filtered <= temp_data;
        end
    end

    // Setpoint adjustment
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            user_setpoint <= 8'd24;
            count <= 0;
        end else if (mode_switch) begin
            if (btn_up && user_setpoint < 8'd99) begin
                if (count >= 100_000_00) begin
                    user_setpoint <= user_setpoint + 1;
                    count <= 0;
                end else begin
                    count <= count + 1;
                end
            end else if (btn_down && user_setpoint > 8'd0) begin
                if (count >= 100_000_00) begin
                    user_setpoint <= user_setpoint - 1;
                    count <= 0;
                end else begin
                    count <= count + 1;
                end
            end else begin
                count <= 0;
            end
        end else begin
            count <= 0;
        end
    end

    wire [15:0] set_temp_fixed = {current_setpoint, 8'd0};
    wire [15:0] curr_temp_fixed = {temp_data_filtered, 8'd0};
    wire [15:0] control_out;

    // PID controller for fan speed
    da_pid_controller pid_inst (
        .clk(clk),
        .reset(reset),
        .set_temp(set_temp_fixed),
        .curr_temp(curr_temp_fixed),
        .control_out(control_out)
    );

    // 7-segment display
    seg_display_controller display_inst (
        .clk(clk),
        .reset(reset),
        .temp_in(mode_switch ? user_setpoint : temp_data_filtered),
        .an(an),
        .seg(seg),
        .dp(dp)
    );

    // PWM generator
    wire raw_pwm;
    pwm_generator fan_pwm (
        .clk(clk),
        .reset(reset),
        .duty(control_out),
        .pwm_out(raw_pwm)
    );

    wire fan_enable = (temp_data_filtered > current_setpoint);
    assign pwm_fan = fan_enable ? raw_pwm : 1'b0;

    // Relay IN1: Lamp ON if temp < setpoint
    assign in1 = (temp_data_filtered < user_setpoint) ? 1'b0 : 1'b1;  // Active HIGH

    // Fan direction control
    assign in2 = (temp_data_filtered > user_setpoint);  // IN2 high when fan runs
    assign in3 = ~in2;                     // Fixed low for forward direction

endmodule
