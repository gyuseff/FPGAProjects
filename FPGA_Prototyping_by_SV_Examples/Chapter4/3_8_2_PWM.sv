// Exercise: Make a PWM with a 4-bit input that controls the duty cycle

module PWM_generator(
    input logic [3:0] sw_in,
    input logic clk,
    input logic rst,
    output logic out
);

    // First, let's make a clock with a frequency of 16 kHz
    // With this, we can make the PWM frequncy of 1kHz
    wire clk_div_16k;
    clk_divider #(.FPGA_FREQ(50_000_000), .TARGET_FREQ(25_000_000)) U_clk_div(.rst(rst), .clk(clk), .clk_div(clk_div_16k));


    // Now, we use a 4-bits counter and make the output equal to 1 while the counter is less than the input

    logic [3:0] pwm_counter;

    always_ff@(posedge clk_div_16k, negedge rst) begin
        if (~rst | (pwm_counter == 4'b1111)) pwm_counter <= 4'b0000;
        else pwm_counter <= pwm_counter + 1'b1;
    end

    assign out = (pwm_counter < sw_in);


endmodule

//First let's create a clock divider to determine the cycle of the PWM

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