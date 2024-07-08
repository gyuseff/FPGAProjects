`include "../UART.sv"
`timescale 1ns/1ps

module tb_UART_RX;
reg clk;
reg rst;
reg Rx;
reg en_r;
reg [7:0] data;
reg error;
reg done;

UART_RX DUT
(
    .rst(rst),
    .clk(clk),
    .Rx(Rx),
    .en_r(en_r),
    .data(data),
    .error(error),
    .done(done)
);

reg [7:0] data_in;
reg start_tx;
reg EN_L;

UART_TX UART_driver
(
    .rst (rst),
    .clk (clk),
    .data(data_in),
    .start(start_tx),
    .Tx(Rx),
    .EN_L(EN_L)
);

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

initial begin
    $dumpfile("tb_UART_RX.vcd");
    $dumpvars(0, tb_UART_RX);
end

initial begin
    #(CLK_PERIOD*1) rst<=1'b1;clk<=1'b0;start_tx <= 1'b0; en_r <= 1'b1;
    #(CLK_PERIOD*1) rst<=1'b0;data_in<=8'b1000_1010;
    #(CLK_PERIOD*1) rst<=1'b1;
    #(CLK_PERIOD*1) start_tx <= 1'b1;
    #(CLK_PERIOD*1) start_tx <= 1'b0; 
    #(CLK_PERIOD*40)
    $finish(2);
end

endmodule
