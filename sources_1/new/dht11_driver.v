module uart_receiver(
    input wire clk,              
    input wire reset,
    input wire rx,               
    output reg [7:0] data_out,   
    output reg data_valid        
);

    // Constants
    parameter CLK_PER_BIT = 10416;  
    reg [13:0] clk_cnt = 0;         
    reg [3:0] bit_index = 0;        
    reg [7:0] rx_data = 0;          
    reg rx_d1 = 1'b1, rx_d2 = 1'b1; 
    reg [1:0] state = 0;            
    reg [1:0] next_state = 0;       
    reg [7:0] debug_bits = 0;       

    // FSM states
    localparam IDLE      = 2'b00;
    localparam START_BIT = 2'b01;
    localparam DATA_BITS = 2'b10;
    localparam STOP_BIT  = 2'b11;

    // Synchronize rx input to FPGA clock
    always @(posedge clk) begin
        rx_d1 <= rx;
        rx_d2 <= rx_d1;
    end

    // FSM for UART reception
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            clk_cnt <= 0;
            bit_index <= 0;
            data_out <= 0;
            data_valid <= 0;
            debug_bits <= 0;  
        end else begin
            
            data_valid <= 0;  

            
            case (state)
                IDLE: begin
                    if (rx_d2 == 0) begin  
                        state <= START_BIT;
                        clk_cnt <= CLK_PER_BIT / 2; 
                    end
                end

                START_BIT: begin
                    if (clk_cnt == CLK_PER_BIT - 1) begin
                        clk_cnt <= 0;
                        bit_index <= 0;
                        state <= DATA_BITS;
                    end else begin
                        clk_cnt <= clk_cnt + 1;
                    end
                end

                DATA_BITS: begin
                    if (clk_cnt == CLK_PER_BIT - 1) begin
                        clk_cnt <= 0;
                        rx_data[bit_index] <= rx_d2;  
                        debug_bits[bit_index] <= rx_d2;  
                        bit_index <= bit_index + 1;
                        if (bit_index == 7) begin
                            state <= STOP_BIT;
                        end
                    end else begin
                        clk_cnt <= clk_cnt + 1;
                    end
                end

                STOP_BIT: begin
                    if (clk_cnt == CLK_PER_BIT - 1) begin
                        
                        data_out <= rx_data;
                        data_valid <= 1;
                        state <= IDLE;  
                        clk_cnt <= 0;
                    end else begin
                        clk_cnt <= clk_cnt + 1;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

    

endmodule
