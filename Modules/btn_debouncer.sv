module btn_debouncer(input logic btn, input logic clk, output logic debounced_btn);
	// The FPGA buttons are active low
	// This module will throw a single period 1 when button is pressed
	// It uses a counter to debounce the button, basically when it detects the button pressed, it will start a counter

	logic [16:0] counter;
	
	always_comb
		debounced_btn = (counter == 16'hfffe);
	
	always_ff@(posedge clk)
		begin
			if(btn) 
				begin 
					counter <= 16'h0000;
				end
			else 
				begin
					if(counter < 16'hffff) counter <= counter + 1;
				end
		end

endmodule