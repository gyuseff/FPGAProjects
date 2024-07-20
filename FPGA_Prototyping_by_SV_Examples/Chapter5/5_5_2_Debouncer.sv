// Exercise: Use a FSM to create an early-button debouncer. This should catch the rising and falling edges of the button.
// So when the button is pushed, the input will be "blocked" for about 20ms, so any glitching will be avoided. The same when the button is freed.

module btn_debouncer (
    input logic rst,
    input logic btn,
    input logic clk,
    output logic dev_btn,
    output logic rising_edge
);

    // Let's use a slower 10ms clock for the debouncer
    logic slow_clk, muxed_clk;
    clk_divider #(.TARGET_FREQ(25_000_000), .FPGA_FREQ(50_000_000)) U_clk_div (.clk(clk), .rst(rst), .clk_div(slow_clk));

    // State machine that tracks the state of the register
    enum logic [2:0] { zero, one_wait_1, one_wait_2, one, zero_wait_1, zero_wait_2 } state_reg, next_state;

    always_ff@(posedge muxed_clk, negedge rst) begin
        if(!rst) state_reg <= zero;
        else state_reg <= next_state;
    end

    assign muxed_clk = (state_reg == zero | state_reg == one) ? clk : slow_clk; 

    always_comb begin
        dev_btn = 1'b0;
        case (state_reg)
            zero : begin
                next_state = btn ? one_wait_1 : zero;
            end
            one_wait_1 : begin
                next_state = one_wait_2;
                dev_btn = 1'b1;
            end
            one_wait_2 : begin
                next_state = one;
                dev_btn = 1'b1;
            end
            one : begin
                next_state = btn ? one : zero_wait_1;
                dev_btn = 1'b1;
            end
            zero_wait_1 : begin
                next_state = zero_wait_2;
            end
            zero_wait_2 : begin
                next_state = zero;
            end
            default: next_state = zero;
        endcase
    end

    // To generate a single pulse, we use an edge detector

    enum logic[1:0] {zero_edge, rising_state, one_edge} edge_state_reg, edge_next_state;

    always_ff@(posedge clk, negedge rst) begin
        if(!rst) edge_state_reg <= zero_edge;
        else edge_state_reg <= edge_next_state;
    end

    always_comb begin
        rising_edge = 1'b0;
        case (edge_state_reg)
            zero_edge : begin 
                edge_next_state = (next_state == one_wait_1) ? rising_state : zero_edge;
            end
            rising_state : begin
                edge_next_state = one_edge;
                rising_edge = 1'b1; 
            end
            one_edge : begin
                edge_next_state = (next_state == zero_wait_1) ? one_edge : zero_edge;
            end
            default: edge_next_state = zero_edge;
        endcase
    end
    
endmodule

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