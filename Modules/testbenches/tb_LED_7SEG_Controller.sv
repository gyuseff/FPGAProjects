`include "../clk_divider.sv"
`include "../LED_7SEG_Controller.sv"
`timescale 1ns/1ps

typedef enum logic[6:0] {
	ZERO 	= 7'b1000000, 
	ONE 	= 7'b1111001, 
	TWO 	= 7'b0100100, 
	THREE 	= 7'b0110000, 
	FOUR 	= 7'b0011001, 
	FIVE 	= 7'b0010010, 
	SIX 	= 7'b0000010, 
	SEVEN 	= 7'b1111000,
	EIGHT	= 7'b0000000,
	NINE 	= 7'b0010000,
	A 		= 7'b0001000,
	B 		= 7'b0000011,
	C 		= 7'b1000110,
	D 		= 7'b0100001,
	E 		= 7'b0000110,
	F 		= 7'b0001110} LED_7_SEG_VALUES;

module tb_LED_7SEG_Controller;
reg clk, rst, en_w;
reg[1:0] waddr;
reg[7:0] data;

LED_7_SEG_VALUES dig;
reg dot;

reg [3:0] LED_enables;
reg [6:0] LED_7SEG;
reg LED_dot;
 
assign data = {dot, dig};

LED_7SEG_Controller #(.REFRESH_FREQ(1), .FPGA_FREQ(5)) DUT(
    .rst (rst),
    .clk (clk),
    .en_w(en_w),
    .waddr(waddr),
    .data(data),
    .LED_enables(LED_enables),
    .LED_7SEG(LED_7SEG),
    .LED_dot(LED_dot)
);

localparam CLK_PERIOD = 200;
always #(CLK_PERIOD/2) clk=~clk;

initial begin
    $dumpfile("tb_LED_7SEG_Controller.vcd");
    $dumpvars(0, tb_LED_7SEG_Controller);
end

initial begin
    #0 rst<=1'bx; clk<=1'bx; en_w <= 1'bx; waddr <= 2'bxx; dot <= 1'bx;
    #(CLK_PERIOD*3) rst<=1'b1; clk<=1'b0; en_w <= 1'b0; waddr <= 2'b00; dig <= ZERO; dot <= 1'b0;
    #(CLK_PERIOD*3) rst<=0;
    #(CLK_PERIOD*3) en_w <= 1;
    #(CLK_PERIOD*20) rst<=1; dig <= ONE; dot <= 1'b1; waddr <= 2'b00;
    #(CLK_PERIOD*20) dig <= THREE; dot <= 1'b0; waddr <= 2'b01;
    #(CLK_PERIOD*20) dig <= A; dot <= 1'b0; waddr <= 2'b10;
    #(CLK_PERIOD*20) dig <= F; dot <= 1'b1; waddr <= 2'b11;
    #(CLK_PERIOD*10) en_w <= 0;
    #(CLK_PERIOD*140) $finish(0);
end

endmodule
