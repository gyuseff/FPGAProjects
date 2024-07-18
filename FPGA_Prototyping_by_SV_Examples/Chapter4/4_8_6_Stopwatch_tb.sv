`include "4_8_6_Stopwatch.sv"

module tb_Stopwatch;
logic en;
logic up;
logic FPGA_clk;
logic rst;
logic [3:0] LED_enables;
logic [6:0] LED_7;
logic LED_dot;

Stopwatch DUT(.*);

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) FPGA_clk=~FPGA_clk;

initial begin
    $dumpfile("tb_Stopwatch.vcd");
    $dumpvars(0, tb_Stopwatch);
end

initial begin
    #1 rst <= 1'b0; en <= 1'b1; FPGA_clk <= 1'b0; up <= 1'b1;
    repeat(2) @(negedge FPGA_clk);
    rst <= 1'b1;
    repeat(1000) @(posedge FPGA_clk);
    $finish(2);
end

endmodule
`default_nettype wire