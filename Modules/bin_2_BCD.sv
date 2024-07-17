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