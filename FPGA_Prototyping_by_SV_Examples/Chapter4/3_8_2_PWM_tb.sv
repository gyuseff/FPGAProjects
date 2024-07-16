`include "3_8_2_PWM.sv"
`timescale 1ps/1ps

module tb_PWM_generator;
reg clk;
reg rst;
reg [3:0] sw_in;
reg out;

PWM_generator DUT
(
    .rst (rst),
    .clk (clk),
    .sw_in(sw_in),
    .out(out)
);

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

initial begin
    $dumpfile("tb_PWM_generator.vcd");
    $dumpvars(0, tb_PWM_generator);
end

initial begin
    #1 rst <= 1'b0; clk <= 1'b0; sw_in <= 4'b0111;
    repeat(5) @(posedge clk);
    rst <= 1'b1;
    repeat(100) @(posedge clk);
    sw_in <= 4'b0010;
    repeat(100) @(posedge clk);
    sw_in <= 4'b1100;
    repeat(100) @(posedge clk);
    $finish(2);
end

endmodule
`default_nettype wire