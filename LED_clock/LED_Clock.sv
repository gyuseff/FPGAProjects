// This is a template to start working on the Dev Board
// It contains mapping to the IO parts of the board
// It is not complete!
// It maps to the: rst button, FPGA clock (50MHz), S1-4 buttons, dipswitch, LED1-4, 7 segments LEDs, 7 segments enables (DIG pins in board)

// The rst button is active low
// Buttons, dipswitch and leds are pull-up (active low) and are shorted
// 7Seg Enables are active low
// 7Seg leds are active low


// 7 segments display model
//
//     aaa
//   fff bbb
//     ggg
//   eee ccc
//     ddd
//        dp

// enum to set the 7segments numbers
// The mapping of the logic is 7'b{gfedcba}
// The first value of LED_7seg is the dot 
typedef enum logic[6:0] {
	ZERO 	= 7'b1000000, 
	ONE 	= 7'b1111001, 
	TWO 	= 7'b0100100, 
	THREE = 7'b0110000, 
	FOUR 	= 7'b0011001, 
	FIVE 	= 7'b0010010, 
	SIX 	= 7'b0000010, 
	SEVEN = 7'b1111000,
	EIGHT	= 7'b0000000,
	NINE 	= 7'b0010000,
	A 		= 7'b0001000,
	B 		= 7'b0000011,
	C 		= 7'b1000110,
	D 		= 7'b0100001,
	E 		= 7'b0000110,
	F 		= 7'b0001110} LED_7_SEG_VALUES;

module LED_Clock(input logic rst, FPGA_clk, output logic [7:0] LED_7Seg, output logic [3:0] EN_LED_7Seg);

	logic clk_div_1;
	
	logic [3:0] counter;

	clk_divider #(.TARGET_FREQ(2)) clk_divisor_1(.clk(FPGA_clk), .rst(rst), .clk_div(clk_div1));
	from_BCD_to_7SEG(.bin(counter), .LED_7(LED_7Seg[6:0]));
	
	always_ff@(posedge clk_div1, negedge rst) begin
		if(!rst) counter <= 4'h0;
		else begin
				if (counter == 4'hf) counter <= 4'h0;
				else counter <= counter + 1;
			end
		end
	
	always_comb begin
		EN_LED_7Seg = 4'b1110;
		LED_7Seg[7] = 1'b1;
		end
		

endmodule

module from_BCD_to_7SEG(input logic [3:0] bin, output logic [7:0] LED_7);
	
	LED_7_SEG_VALUES aux;
	assign LED_7 = aux;
	
	always_comb
		begin
			aux = ZERO;
			case(bin)
				4'h0: 	aux = ZERO;
				4'h1: 	aux = ONE;
				4'h2: 	aux = TWO;
				4'h3: 	aux = THREE;
				4'h4: 	aux = FOUR;
				4'h5: 	aux = FIVE;
				4'h6: 	aux = SIX;
				4'h7: 	aux = SEVEN;
				4'h8: 	aux = EIGHT;
				4'h9: 	aux = NINE;
				4'ha: 	aux = A;
				4'hb: 	aux = B;
				4'hc: 	aux = C;
				4'hd: 	aux = D;
				4'he: 	aux = E;
				4'hf: 	aux = F;
			endcase
		end
endmodule

// This module divides the FPGA_CLK
// For the LED refresing rate, use 50Hz
module clk_divider #(parameter TARGET_FREQ = 25_000_000, FPGA_CLK = 50_000_000) (input logic clk, rst, output logic clk_div);

	int target_counter = FPGA_CLK/(2*TARGET_FREQ); //This calculates the target value to the counter to toggle
 
	logic [31:0] counter;
	
	always_ff@(posedge clk, negedge rst)
		begin
			if (!rst) begin 
				counter <= 32'b0;
				clk_div <= 1'b0;
			end
			else begin
				counter <= counter + 1;
				if (counter >= target_counter-1) begin
					clk_div <= !clk_div;
					counter <= 32'b0;
				end
			end
		end
endmodule