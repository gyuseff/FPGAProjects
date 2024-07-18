module NumberSequence (
    input logic en,
    input logic FPGA_clk,
    input logic rst,
    output logic [3:0] LED_enables,
    output logic [6:0] LED_7,
    output logic LED_dot
);

    logic [6:0] LED_out_0, LED_out_1, LED_out_2, LED_out_3;
    logic clk_div;
    logic [3:0] bin_0, bin_1, bin_2, bin_3;
    logic [3:0] next_bin_0, next_bin_1, next_bin_2, next_bin_3;

    bin_2_LED U0(.bin(bin_0), .LED_7(LED_out_0));
    bin_2_LED U1(.bin(bin_1), .LED_7(LED_out_1));
    bin_2_LED U2(.bin(bin_2), .LED_7(LED_out_2));
    bin_2_LED U3(.bin(bin_3), .LED_7(LED_out_3));

    LED_7SEG_Controller U_LED(.en(en), .clk(FPGA_clk), .rst(rst), .data_0({1'b1, LED_out_0}), .data_1({1'b1, LED_out_1}), .data_2({1'b1, LED_out_2}), .data_3({1'b1, LED_out_3}), .LED_enables(LED_enables), .LED_dot(LED_dot), .LED_7SEG(LED_7));

    clk_divider #(.TARGET_FREQ(2), .FPGA_FREQ(50_000_000)) (.clk(FPGA_clk), .rst(rst), .clk_div(clk_div));

    always_ff@(posedge clk_div, negedge rst) begin
        if(!rst) begin
            bin_0 <= 4'b0011;
            bin_1 <= 4'b0010;
            bin_2 <= 4'b0001;
            bin_3 <= 4'b0000;
        end else begin
            bin_0 <= next_bin_0;
            bin_1 <= next_bin_1;
            bin_2 <= next_bin_2;
            bin_3 <= next_bin_3;
        end
    end

    always_comb begin
        next_bin_0 = (bin_0 == 4'b1001) ? 4'b0000 : (bin_0 + 1'b1);
        next_bin_1 = (bin_1 == 4'b1001) ? 4'b0000 : (bin_1 + 1'b1);
        next_bin_2 = (bin_2 == 4'b1001) ? 4'b0000 : (bin_2 + 1'b1);
        next_bin_3 = (bin_3 == 4'b1001) ? 4'b0000 : (bin_3 + 1'b1);
    end
endmodule