`include "3_12_3_DualEncoder.sv"

module tb_DualEncoder_16_4;
wire [15:0] in;
reg [3:0] first;
reg [3:0] second;

int i;

assign in = i[15:0];

 DualEncoder_16_4 DUT
(
    .in (in),
    .first (first),
    .second(second)
);

initial begin
    $dumpfile("tb_DualEncoder_16_4.vcd");
    $dumpvars(0, tb_DualEncoder_16_4);
end

initial begin
    #0; i <= 0;
    for (i = 0; i < 2**(16); i++) begin
        #10;
        $display("in = %b, first = %d, second = %d", in, first, second);
        #10;
    end
end

endmodule
