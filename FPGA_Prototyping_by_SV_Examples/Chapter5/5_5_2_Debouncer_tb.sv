`include "5_5_2_Debouncer.sv"

module tb_btn_debouncer;
reg clk;
reg rst;
reg btn;
wire dev_btn;
wire rising_edge;
 
btn_debouncer DUT(
    .*
);

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

initial begin
    $dumpfile("tb_btn_debouncer.vcd");
    $dumpvars(0, tb_btn_debouncer);
end

initial begin
    #1 rst <= 1'b0; clk <= 1'b0; btn <= 1'b0;
    #9 rst <= 1'b1;
    @(negedge clk) btn <= 1'b1;
    #9;
    repeat(10) #3 btn <= ~btn;
    #100;
    @(negedge clk) btn <= 1'b0;
    #9;
    repeat(10) #3 btn <= ~btn;
    #100;
    btn <= 1'b1;
    #100;
    $finish();
end

endmodule
