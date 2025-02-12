`include "../UART.sv"
`timescale 1ns/1ps

module tb_UART_TX;
reg clk;
reg rst;
reg [7:0] data;
reg start;
reg Tx;
reg EN_L;

UART_TX DUT
(
    .rst (rst),
    .clk (clk),
    .data(data),
    .start(start),
    .Tx(Tx),
    .EN_L(EN_L)
);

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

initial begin
    $dumpfile("tb_UART_TX.vcd");
    $dumpvars(0, tb_UART_TX);
end

initial begin
    #(CLK_PERIOD*1) rst<=1'b1;clk<=1'b0;start <= 1'b0;
    #(CLK_PERIOD*1) rst<=1'b0;data<=8'b1000_1010;
    #(CLK_PERIOD*1) rst<=1'b1;
    #(CLK_PERIOD*1) start <= 1'b1;
    #(CLK_PERIOD*1) start <= 1'b0; data<=8'b1111_0101;
    #(CLK_PERIOD*40) start <= 1'b1;
    #(CLK_PERIOD*40) start <= 1'b0;
    #(CLK_PERIOD*40)
    $finish(2);
end

endmodule
