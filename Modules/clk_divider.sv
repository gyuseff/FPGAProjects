//Simple clock divider
//It uses a counter for the division
//You can change the parameters to decide on the estimated target frequency

module clk_divider #(parameter TARGET_FREQ = 25_000_000, FPGA_FREQ = 50_000_000) (input logic clk, rst, output logic clk_div);

	int target_counter = FPGA_FREQ/(2*TARGET_FREQ); //This calculates the target value to the counter to toggle
 
	logic [31:0] counter;
	
	always_ff@(posedge clk, negedge rst)
		begin
			if (!rst) begin 
				counter <= 32'b0;
				clk_div <= 1'b0;
			end
			else begin
				counter <= counter + 1;
				if (counter == target_counter) begin
					clk_div <= !clk_div;
					counter <= 32'b0;
				end
			end
		end
endmodule