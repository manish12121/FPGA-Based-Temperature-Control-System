module user_interface (
    input wire clk,
    input wire btn_up,
    input wire btn_down,
    output reg [7:0] setpoint,
    output reg led,
    output reg buzzer
);
    reg [3:0] debounce_up, debounce_down;
    
    always @(posedge clk) begin
        if (btn_up && debounce_up == 4'b1111) begin
            setpoint <= setpoint + 1;
            debounce_up <= 0;
        end else if (btn_up) begin
            debounce_up <= debounce_up + 1;
        end

        if (btn_down && debounce_down == 4'b1111) begin
            setpoint <= setpoint - 1;
            debounce_down <= 0;
        end else if (btn_down) begin
            debounce_down <= debounce_down + 1;
        end

        // LED and Buzzer logic
        if (setpoint >= 50) begin
            led <= 1;
            buzzer <= 1;
        end else begin
            led <= 0;
            buzzer <= 0;
        end
    end
endmodule