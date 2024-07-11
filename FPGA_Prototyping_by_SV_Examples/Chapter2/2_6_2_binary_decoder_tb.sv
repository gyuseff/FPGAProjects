`include "2_6_2_binary_decoder.sv"

function automatic int power(int base, int exponent);
    int out;
    int i;
    begin
        out = 1;
        for (i = 0; i < exponent; i = i + 1) begin
            out = out*base;
        end
        power = out;
    end
endfunction

module tb_DECODERS;
reg [1:0] in_1;
reg [2:0] in_2;
reg [3:0] in_3;

reg [3:0] out_1;
reg [7:0] out_2;
reg [15:0] out_3;

reg [4:0] i;

int result; 
reg en;

DECODER_2_4 DUT1(.in(in_1), .out(out_1), .en(en));
DECODER_3_8 DUT2(.in(in_2), .out(out_2), .en(en));
DECODER_4_16 DUT3(.in(in_3), .out(out_3), .en(en));

initial begin
    $dumpfile("tb_DECODERS.vcd");
    $dumpvars(0, tb_DECODERS);
end

initial begin
    #10; in_1 = 0; in_2 = 0; in_3 = 0; en = 0;
    #10;
    $display("Enable off: out_1 = %d, out_2 = %d, out_3 = %d", out_1, out_2, out_3);
    #10; en = 1;
    #10;
    $display("Enable on: out_1 = %d, out_2 = %d, out_3 = %d", out_1, out_2, out_3);
    #10;
    for ( i = 0; i < 4; i++) begin
        in_1 = i[1:0];
        #10;
        result = power(2, i);
        #10;
        $display("in_1 = %d, out_1 = %d, expected = %d, pass = %d", in_1, out_1, result, (result == out_1));
    end

    for ( i = 0; i < 8; i++) begin
        in_2 = i[2:0];
        #10;
        result = power(2, i);
        #10;
        $display("in_2 = %d, out_2 = %d, expected = %d, pass = %d", in_2, out_2, result, (result == out_2));
    end

    for ( i = 0; i < 16; i++) begin
        in_3 = i[3:0];
        #10;
        result = power(2, i);
        #10;
        $display("in_3 = %d, out_3 = %d, expected = %d, pass = %d", in_3, out_3, result, (result == out_3));
    end

end

endmodule
