`include "../Modules/clk_divider.sv"
`include "../Modules/LED_7SEG_Controller.sv"
`include "../Modules/btn_debouncer.sv"

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

	
module SEG7_Controller_testbench(input logic FPGA_clk, input logic incr_btn, input logic decr_btn, input logic rst, output logic [6:0] LED_segments, output logic LED_dot, output logic [3:0] LED_en);


	logic deb_incr_btn, deb_decr_btn;
	
	btn_debouncer debouncer_incr(.btn(incr_btn), .clk(FPGA_clk), .debounced_btn(deb_incr_btn));
	btn_debouncer debouncer_decr(.btn(decr_btn), .clk(FPGA_clk), .debounced_btn(deb_decr_btn));

	logic [3:0] max_val;
	
	logic [3:0] digit [4];
	logic [1:0] addr;
	logic [6:0] led_seg;
	
	logic [3:0] overflow;
	logic [3:0] underflow;

	//logic [3:0] hardcoded_digits [4];
	
	from_BCD_to_7SEG bcd_to_7seg(.bin(digit[addr]), .LED_7(led_seg));
	LED_7SEG_Controller U_controller(.en_w(1'b1), .waddr(addr), .data({1'b1, led_seg}), .clk(FPGA_clk), .rst(rst), .LED_enables(LED_en), .LED_7SEG(LED_segments), .LED_dot(LED_dot));

	
	//always_comb
	//	begin
	//		hardcoded_digits[0] = 4'b0001;
	//		hardcoded_digits[1] = 4'b0010;
	//		hardcoded_digits[2] = 4'b0011;
	//		hardcoded_digits[3] = 4'b0100;
	//	end
	
	always_comb
		begin
			max_val = 4'b0010;
			overflow[3] = (digit[3] == max_val);
			overflow[2] = (digit[2] == max_val);
			overflow[1] = (digit[1] == max_val);
			overflow[0] = (digit[0] == max_val);
			
			underflow[3] = (digit[3] == 'b0);
			underflow[2] = (digit[2] == 'b0);
			underflow[1] = (digit[1] == 'b0);
			underflow[0] = (digit[0] == 'b0);
		end

	always_ff@(posedge FPGA_clk or negedge rst)
		begin
			if(!rst)
				begin
					addr <= 2'b11;
				end
			else
				begin
					if(addr == 2'b11) addr <= 2'b00;
					else addr <= addr + 1;
				end
		end
		
	always_ff@(posedge FPGA_clk or negedge rst)
		begin
			if(!rst)
				begin
					for(int i = 0; i < 4; i++) digit[i] <= 4'b0000;
				end
			else
				begin
					if(deb_incr_btn)
						begin
							casex(overflow)
								4'b1111:	begin for(int i = 0; i < 4; i++) digit[i] <= 4'b0000; end
								4'bx111:	begin for(int i = 0; i < 3; i++) digit[i] <= 4'b0000; digit[3] = digit[3] + 1; end
								4'bxx11:	begin for(int i = 0; i < 2; i++) digit[i] <= 4'b0000; digit[2] = digit[2] + 1; end
								4'bxxx1:	begin for(int i = 0; i < 1; i++) digit[i] <= 4'b0000; digit[1] = digit[1] + 1; end
								default:	digit[0] = digit[0] + 1;
							endcase
						end
					else if(deb_decr_btn) 
						begin
							casex(underflow)
								4'b1111:	begin for(int i = 0; i < 4; i++) digit[i] <= max_val; end
								4'bx111:	begin for(int i = 0; i < 3; i++) digit[i] <= max_val; digit[3] = digit[3] - 1; end
								4'bxx11:	begin for(int i = 0; i < 2; i++) digit[i] <= max_val; digit[2] = digit[2] - 1; end
								4'bxxx1:	begin for(int i = 0; i < 1; i++) digit[i] <= max_val; digit[1] = digit[1] - 1; end
								default:	digit[0] = digit[0] - 1;
							endcase
						end
				end
		end

endmodule

module from_BCD_to_7SEG(input logic [3:0] bin, output logic [6:0] LED_7);
	
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