module Heartbeat (
    input logic en,
    input logic FPGA_clk,
    input logic rst,
    output logic [3:0] LED_enables,
    output logic [6:0] LED_7,
    output logic LED_dot
);

    logic [6:0] LED_out_0, LED_out_1, LED_out_2, LED_out_3;

    LED_7SEG_Controller #(.REFRESH_FREQ(150), .FPGA_FREQ(50_000_000)) U_LED(.en(en), .clk(FPGA_clk), .rst(rst), .data_0({1'b1, LED_out_0}), .data_1({1'b1, LED_out_1}), .data_2({1'b1, LED_out_2}), .data_3({1'b1, LED_out_3}), .LED_enables(LED_enables), .LED_dot(LED_dot), .LED_7SEG(LED_7));

    logic clk_div;

    clk_divider #(.TARGET_FREQ(2), .FPGA_FREQ(50_000_000)) U_clk_div (.clk(FPGA_clk), .rst(rst), .clk_div(clk_div));

    logic [1:0] state, next_state;

    always_ff@(posedge clk_div, negedge rst) begin
        if(!rst) state <= 2'b00;
        else state <= next_state;
    end

    always_comb begin
        case(state)
            2'b00:      begin
                            LED_out_0 = 7'b111_1111;
                            LED_out_1 = 7'b100_1111;
                            LED_out_2 = 7'b111_1001;
                            LED_out_3 = 7'b111_1111;
                            next_state = 2'b01;
                        end
            2'b01:      begin
                            LED_out_0 = 7'b111_1111;
                            LED_out_1 = 7'b111_1001;
                            LED_out_2 = 7'b100_1111;
                            LED_out_3 = 7'b111_1111;
                            next_state = 2'b10;
                        end
            2'b10:      begin
                            LED_out_0 = 7'b111_1001;
                            LED_out_1 = 7'b111_1111;
                            LED_out_2 = 7'b111_1111;
                            LED_out_3 = 7'b100_1111;
                            next_state = 2'b00;
                        end
            default:    begin
                            LED_out_0 = 7'b111_1111;
                            LED_out_1 = 7'b111_1111;
                            LED_out_2 = 7'b111_1111;
                            LED_out_3 = 7'b111_1111;
                            next_state = 2'b00;
                        end
        endcase
    end


endmodule