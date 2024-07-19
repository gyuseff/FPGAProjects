module Stopwatch (
    input logic en,
    input logic up,
    input logic FPGA_clk,
    input logic rst,
    output logic [3:0] LED_enables,
    output logic [6:0] LED_7,
    output logic LED_dot
);

    logic [6:0] LED_out_0, LED_out_1, LED_out_2, LED_out_3;
    logic [3:0] bin_0, bin_1, bin_2, bin_3;
    logic [3:0] next_bin_0, next_bin_1, next_bin_2, next_bin_3;
    logic clk_div;

    bin_2_LED U0(.bin(bin_0), .LED_7(LED_out_0));
    bin_2_LED U1(.bin(bin_1), .LED_7(LED_out_1));
    bin_2_LED U2(.bin(bin_2), .LED_7(LED_out_2));
    bin_2_LED U3(.bin(bin_3), .LED_7(LED_out_3));

    LED_7SEG_Controller U_LED(.en(en), .clk(FPGA_clk), .rst(rst), .data_0({1'b1, LED_out_0}), .data_1({1'b0, LED_out_1}), .data_2({1'b1, LED_out_2}), .data_3({1'b0, LED_out_3}), .LED_enables(LED_enables), .LED_dot(LED_dot), .LED_7SEG(LED_7));

    clk_divider #(.TARGET_FREQ(20), .FPGA_FREQ(50_000_000)) U_clk_div (.clk(FPGA_clk), .rst(rst), .clk_div(clk_div));

    always_ff @( posedge clk_div, negedge rst ) begin
        if(!rst) begin
            bin_0 <= 4'b0000;
            bin_1 <= 4'b0000;
            bin_2 <= 4'b0000;
            bin_3 <= 4'b0000;
        end else begin
            bin_0 <= next_bin_0;
            bin_1 <= next_bin_1;
            bin_2 <= next_bin_2;
            bin_3 <= next_bin_3;
        end
    end

    // Logic when going up

    logic c_0, c_1, c_2;
    logic [3:0] aux_next_sum_2;
    logic [3:0] next_sum_0, next_sum_1, next_sum_2, next_sum_3;

    BCD_1_digit_sum U_sum_0(.A(bin_0), .B(4'b0000), .carry_in(1'b1), .out(next_sum_0), .carry_out(c_0));
    BCD_1_digit_sum U_sum_1(.A(bin_1), .B(4'b0000), .carry_in(c_0), .out(next_sum_1), .carry_out(c_1));
    BCD_1_digit_sum U_sum_2(.A(bin_2), .B(4'b0000), .carry_in(c_1), .out(aux_next_sum_2), .carry_out());
    BCD_1_digit_sum U_sum_3(.A(bin_3), .B(4'b0000), .carry_in(c_2), .out(next_sum_3), .carry_out());

    always_comb begin
        next_sum_2 = (aux_next_sum_2 == 4'b0110) ? 4'b0000 : aux_next_sum_2;
        c_2 = (aux_next_sum_2 == 4'b0110) ? 1'b1 : 1'b0;
    end

    // Logic when going down

    logic [3:0] next_neg_0, next_neg_1, next_neg_2, next_neg_3;
    logic negative_0, negative_1, negative_2, negative_3;

    always_comb begin
        negative_0 = (bin_0 == 4'b0000);
        next_neg_0 = negative_0 ? 4'b1001 : bin_0 - 1'b1;
        negative_1 = (bin_1 == 4'b0000);
        next_neg_1 = (negative_1 & negative_0) ? 4'b1001 : bin_1 - negative_0;
        negative_2 = (bin_2 == 4'b0000);
        next_neg_2 = (negative_2 & negative_1 & negative_0) ? 4'b0101 : bin_2 - (negative_1 & negative_0);
        negative_3 = (bin_3 == 4'b0000);
        next_neg_3 = (negative_3 & negative_2 & negative_1 & negative_0) ? 4'b1001 : bin_3 - (negative_2 & negative_1 & negative_0);
    end

    //BCD_1_digit_sub U_sub_0(.A(bin_0), .B(4'b0001), .out(next_neg_0), .negative(negative_0));
    //BCD_1_digit_sub U_sub_1(.A(bin_1), .B({3'b000, negative_0}), .out(next_neg_1), .negative(negative_1));
    //BCD_1_digit_sub U_sub_2(.A(bin_2), .B({3'b000, negative_1}), .out(next_neg_2), .negative(negative_2));
    //BCD_1_digit_sub U_sub_3(.A(bin_3), .B({3'b000, negative_2}), .out(next_neg_3), .negative());

    always_comb begin
        next_bin_0 = up ? next_sum_0 : next_neg_0;
        next_bin_1 = up ? next_sum_1 : next_neg_1;
        next_bin_2 = up ? next_sum_2 : next_neg_2;
        next_bin_3 = up ? next_sum_3 : next_neg_3;
    end

endmodule

module bin_2_BCD(
    input logic [3:0] Bin,
    output logic [3:0] BCDout,
    output logic carry_out
);

    always_comb begin
        BCDout[3] = Bin[3]&~Bin[2]&~Bin[1];
        BCDout[2] = (~Bin[3]&Bin[2]) | (Bin[2]&Bin[1]);
        BCDout[1] = (Bin[3]&Bin[2]&~Bin[1]) | (~Bin[3]&Bin[1]);
        BCDout[0] = Bin[0];
        carry_out = (Bin[3]&Bin[2]) | (Bin[3]&Bin[1]);
    end

endmodule

module BCD_1_digit_sum(
    input logic [3:0] A,
    input logic [3:0] B,
    input logic carry_in,
    output logic [3:0] out,
    output logic carry_out
);

    logic [3:0] raw_sum;

    bin_2_BCD U(.Bin(raw_sum), .BCDout(out), .carry_out(carry_out));

    always_comb begin
        raw_sum = A + B + carry_in;
    end

endmodule

module BCD_1_digit_sub(
    input logic [3:0] A,
    input logic [3:0] B,
    output logic [3:0] out,
    output logic negative
);

    logic [3:0] raw_sub;

    always_comb begin
        negative = (A < B);
        raw_sub = A - B;
        out = negative ? ~(raw_sub) + 1'b1 : raw_sub;
    end

endmodule