`include "3_8_1_SquareWave.sv"
`timescale 1ps/1ps
module tb_SquareWaveGenerator;
reg clk;
reg rst;
reg [3:0] m;
reg [3:0] n;
reg out;

SquareWaveGenerator DUT 
(
    .m(m),
    .n(n),
    .clk(clk),
    .rst(rst),
    .out(out)
);

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

initial begin
    $dumpfile("tb_SquareWaveGenerator.vcd");
    $dumpvars(0, tb_SquareWaveGenerator);
end

initial begin
    #0; rst <= 1'b0; clk <= 1'b0; m <= 4'b0101; n <= 4'b0101;
    repeat(10) @(negedge clk);
    rst <= 1'b1;
    repeat(100) @(posedge clk);
    m <= 4'b0001;
    repeat(100) @(posedge clk);
    m <= 4'b1010; n <= 4'b1111;
    repeat(200) @(posedge clk);
    $finish(0);
end

endmodule
