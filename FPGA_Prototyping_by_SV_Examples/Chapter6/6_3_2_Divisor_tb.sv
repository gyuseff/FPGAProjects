`include "6_3_2_Divisor.sv"

module tb_LongDivisor;

localparam MAX_WIDTH = 16;

reg rst;
reg clk;
reg start_op;
reg[MAX_WIDTH-1:0] dividend;
reg[MAX_WIDTH-1:0] divisor;
wire[MAX_WIDTH-1:0] quotient;
wire[MAX_WIDTH-1:0] remainder;
wire done;

LongDivisor #(.MAX_WIDTH(MAX_WIDTH)) DUT(.*);

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

initial begin
    $dumpfile("tb_LongDivisor.vcd");
    $dumpvars(0, tb_LongDivisor);
end

initial begin
    #1 rst <= 1'b1; clk <= 1'b0; start_op <= 1'b0; dividend <= 'd0; divisor <= 'd0;
    @(negedge clk) rst <= 1'b0;
    @(negedge clk) rst <= 1'b1;
    for(int i = 0; i < 10; i=i+1) begin
        dividend = $urandom();
        divisor = $urandom();
        @(negedge clk) start_op <= 1'b1;
        @(negedge clk) start_op <= 1'b0;
        repeat(MAX_WIDTH+4) @(posedge clk);
        $display("dividend = %d, divisor = %d, quotient = %d, remainder = %d, expected = (%d, %d)", dividend, divisor, quotient, remainder, dividend/divisor, dividend%divisor);
    end
    $finish(2);
end

endmodule
