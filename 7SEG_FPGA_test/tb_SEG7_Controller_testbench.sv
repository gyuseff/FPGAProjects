`include "SEG7_Controller_testbench.sv"

module tb_SEG7_Controller_testbench;
reg FPGA_clk, incr_btn, decr_btn, rst;
reg [6:0] LED_segments;
reg LED_dot;
reg [3:0] LED_en;

SEG7_Controller_testbench DUT
(
    .rst(rst),
    .FPGA_clk(FPGA_clk),
    .incr_btn(incr_btn),
    .decr_btn(decr_btn),
    .LED_segments(LED_segments),
    .LED_dot(LED_dot),
    .LED_en(LED_en)
);

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) FPGA_clk=~FPGA_clk;

initial begin
    $dumpfile("tb_SEG7_Controller_testbench.vcd");
    $dumpvars(0, tb_SEG7_Controller_testbench);
end

initial begin
    #1 rst<=1'b0;FPGA_clk<=1'b0;
    #(CLK_PERIOD*3) rst<=1;
    #(CLK_PERIOD*1000000)
    $finish(2);
end

endmodule
