`include "6_3_3_BinToBCD.sv"

module tb_BinToBCD;
reg clk;
reg rst;
reg start_op;
reg [13:0] bin;
wire [15:0] out_BCD;
reg done;

BinToBCD DUT(.*);

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

initial begin
    $dumpfile("tb_BinToBCD.vcd");
    $dumpvars(0, tb_BinToBCD);
end

initial begin
    #1 rst <= 1'b1; clk <= 1'b0; start_op <= 1'b0; bin <= 14'd2251;
    @(negedge clk) rst <=1'b0;
    @(negedge clk) rst <=1'b1;
    @(negedge clk) start_op <= 1'b1;
    @(negedge clk) start_op <= 1'b0;
    repeat(20) @(negedge clk);
    $finish(2);
end

endmodule
