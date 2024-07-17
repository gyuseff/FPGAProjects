module PWM_LedDimmer (

	input logic FPGA_clk,
	input logic incr_btn,
	input logic decr_btn,
	input logic rst,
	output logic dimmed_LED,
	output logic [6:0] LED_SEG,
	output logic LED_dot,
	output [3:0] LED_en
);
 
	logic incr_deb, decr_deb;

	btn_debouncer incr_debouncer(.btn(incr_btn), .clk(FPGA_clk), .debounced_btn(incr_deb));
	btn_debouncer decr_debouncer(.btn(decr_btn), .clk(FPGA_clk), .debounced_btn(decr_deb));
	
	logic [3:0] duty_cycle;
	PWM_generator U_PWM( .sw_in(duty_cycle), .clk(FPGA_clk), .rst(rst), .out(dimmed_LED));
 
	always_ff@(posedge FPGA_clk) begin
		if(~rst) duty_cycle <= 4'b0000;
		else begin
			if(incr_deb) duty_cycle <= duty_cycle + 1;
			else if(decr_deb) duty_cycle <= duty_cycle - 1;
			else duty_cycle <= duty_cycle;
		end
	end
 
	logic [3:0] BCD_digit_0, BCD_digit_1;
	logic [6:0] LED_digit_0, LED_digit_1;
	
	logic carry_out;
	
	bin_2_BCD dig_0(.Bin(duty_cycle), .BCDout(BCD_digit_0), .carry_out(carry_out));
	assign BCD_digit_1 = {3'b000, carry_out};
	
	bin_2_LED U_LED_0(.bin(BCD_digit_0), .LED_7(LED_digit_0));
	bin_2_LED U_LED_1(.bin(BCD_digit_1), .LED_7(LED_digit_1));
 
	LED_7SEG_Controller U_LED_Controller(.en(1'b1), .data_3(8'h00), .data_2(8'hff), .data_1({1'b1, LED_digit_1}), .data_0({1'b0, LED_digit_0}), .clk(FPGA_clk), .rst(rst), .LED_enables(LED_en), .LED_7SEG(LED_SEG), .LED_dot(LED_dot)); 
	
endmodule