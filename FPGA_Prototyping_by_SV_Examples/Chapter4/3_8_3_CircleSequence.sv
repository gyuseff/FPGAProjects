// Exercise: Create a circuit that shows a sequence in a 4 x 7-Seg display.
// The sequence shows a circle that traveles through the display clockwise or counter-clockwise, depending on an input switch.

module CircleSequence (
    input logic en,
    input logic cw,
    input logic FPGA_clk,
    input logic rst,
    output logic [3:0] LED_enables,
    output logic [6:0] LED_7,
    output logic LED_dot
);

    logic [6:0] LED_out_0, LED_out_1, LED_out_2, LED_out_3;

    LED_7SEG_Controller U_LED(.en(en), .clk(FPGA_clk), .rst(rst), .data_0({1'b1, LED_out_0}), .data_1({1'b1, LED_out_1}), .data_2({1'b1, LED_out_2}), .data_3({1'b1, LED_out_3}), .LED_enables(LED_enables), .LED_dot(LED_dot), .LED_7SEG(LED_7));

    logic [6:0] up_circle, down_circle, current_circle;
    logic [3:0] current_en, next_en;

    logic clk_2Hz, UP_DOWN, next_UP_DOWN;

    clk_divider #(.TARGET_FREQ(2), .FPGA_FREQ(50_000_000)) (.clk(FPGA_clk), .rst(rst), .clk_div(clk_2Hz));

    assign up_circle    = 7'b0011100;
    assign down_circle  = 7'b0100011;

    always_ff @(posedge clk_2Hz, negedge rst) begin
        if(!rst) begin 
            current_en <= 4'b1110;
            UP_DOWN <= 1'b1;
        end
        else begin 
            current_en <= next_en;
            UP_DOWN <= next_UP_DOWN;
        end
    end
    
    always_comb begin
        next_UP_DOWN = UP_DOWN;
        next_en = current_en;
        if(cw) begin
            //If only changes vertically
            if((~current_en[0] & UP_DOWN) | (~current_en[3] & ~UP_DOWN)) begin
                next_UP_DOWN = ~UP_DOWN;
            end
            else begin
                next_en = UP_DOWN ? {current_en[0], current_en[3:1]} : {current_en[2:0], current_en[3]};
            end
        end
        else begin
            //If only changes vertically
            if((~current_en[0] & ~UP_DOWN) | (~current_en[3] & UP_DOWN)) begin
                next_UP_DOWN = ~UP_DOWN;
            end
            else begin
                next_en = UP_DOWN ? {current_en[2:0], current_en[3]} : {current_en[0], current_en[3:1]};
            end
        end
    end

    always_comb begin
        current_circle = UP_DOWN ? up_circle : down_circle;
        LED_out_0 = current_en[0] ? 7'b111_1111 : current_circle;
        LED_out_1 = current_en[1] ? 7'b111_1111 : current_circle;
        LED_out_2 = current_en[2] ? 7'b111_1111 : current_circle;
        LED_out_3 = current_en[3] ? 7'b111_1111 : current_circle;
    end

endmodule