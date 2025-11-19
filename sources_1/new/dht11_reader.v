module DHT11 (
    input clk_i,
    inout w1_o,
    output reg done_o,
    output reg [7:0] temp_o,
    output reg [7:0] hum_o,
    output w1_d
);

    reg enw1 = 1'b1;
    reg w1 = 1'b0;
    assign w1_o = enw1 ? w1 : 1'bZ;
    assign w1_d = ~w1;

    // Clock Divider to approx 1MHz for ~1?s tick (100MHz / 100)
    reg [6:0] clk_div = 0;
    reg tick_1us = 0;
    always @(posedge clk_i) begin
        if (clk_div == 99) begin
            clk_div <= 0;
            tick_1us <= 1;
        end else begin
            clk_div <= clk_div + 1;
            tick_1us <= 0;
        end
    end

    // Delay counter
    reg [19:0] delay_cnt = 0;
    wire delay_done = (delay_cnt == 0);
    always @(posedge clk_i) begin
        if (~delay_done)
            delay_cnt <= delay_cnt - 1;
    end

    task delay_us(input [19:0] us);
        begin
            delay_cnt <= us;
        end
    endtask

    // FSM State
    reg [3:0] state = 0;
    reg [5:0] bit_cnt = 0;
    reg [39:0] data = 0;
    reg [7:0] temp_sample = 0;
    reg [7:0] hum_sample = 0;
    reg last_w1 = 1;

    always @(posedge clk_i) begin
        if (tick_1us) begin
            last_w1 <= w1_o;

            case (state)
                0: begin // Start signal (pull low for at least 18ms)
                    enw1 <= 1;
                    w1 <= 0;
                    delay_us(18000); // 18ms
                    state <= 1;
                end

                1: begin // Release the line and wait for response
                    enw1 <= 0;
                    delay_us(40); // wait 40us
                    state <= 2;
                end

                2: begin // Wait for DHT response low
                    if (~w1_o) begin
                        delay_us(80); // 80us low
                        state <= 3;
                    end
                end

                3: begin // Wait for DHT response high
                    if (w1_o) begin
                        delay_us(80); // 80us high
                        state <= 4;
                        bit_cnt <= 0;
                    end
                end

                4: begin // Start reading 40 bits
                    if (~w1_o) begin
                        delay_us(50); // wait 50us, start of bit
                        state <= 5;
                    end
                end

                5: begin // Sample bit value after 30us
                    delay_us(30); // mid of HIGH pulse
                    state <= 6;
                end

                6: begin
                    data <= {data[38:0], w1_o}; // shift in bit
                    bit_cnt <= bit_cnt + 1;
                    if (bit_cnt == 39) begin
                        state <= 7;
                    end else begin
                        state <= 4;
                    end
                end

                7: begin // Done receiving
                    temp_sample <= data[23:16];
                    hum_sample <= data[39:32];
                    done_o <= 1;
                    delay_us(1000000); // 1s delay between reads
                    state <= 8;
                end

                8: begin
                    done_o <= 0;
                    state <= 0;
                end
            endcase
        end
    end

    always @(posedge clk_i) begin
        temp_o <= temp_sample;
        hum_o <= hum_sample;
    end
endmodule
