module BCD_increment (
    input logic [11:0] in,
    output logic [11:0] out,
    output logic overflow
);
    BCD_3_digit_sum U(.A(in), .B(12'h001), .out(out), .overflow(overflow));

endmodule

module BCD_3_digit_sum(
    input logic [11:0] A,
    input logic [11:0] B,
    output logic [11:0] out,
    output logic overflow
);

    logic [3:0] sum_digit_0, sum_digit_1, sum_digit_2;
    logic carry_0, carry_1;

    assign out = {sum_digit_2, sum_digit_1, sum_digit_0};

    BCD_1_digit_sum sum_0(.A(A[3:0]), .B(B[3:0]), .carry_in(1'b0), .out(sum_digit_0), .carry_out(carry_0));
    BCD_1_digit_sum sum_1(.A(A[7:4]), .B(B[7:4]), .carry_in(carry_0), .out(sum_digit_1), .carry_out(carry_1));
    BCD_1_digit_sum sum_2(.A(A[11:8]), .B(B[11:8]), .carry_in(carry_1), .out(sum_digit_2), .carry_out(overflow));

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