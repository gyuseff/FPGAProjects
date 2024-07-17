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

module bin_2_LED(input logic [3:0] bin, output logic [6:0] LED_7);
	
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