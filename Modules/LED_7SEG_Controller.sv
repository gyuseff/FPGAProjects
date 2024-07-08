/*
    This module is to be used with a 4 x 7-LED Segments display
    It will take the values of the digits save them in one of 4 8-bit registers to show on the display
    Inputs
        en_w -> Enables writing data in the waddr
        waddr -> Address of the digit of the display (The MSB is the dot)
        data -> It is the data stored display register in the specified address
        clk -> Master (fast) clock used to update the digits registers. And be divided by the internal clock divider
        rst -> Asyncronous reset for the display
    Outputs
        LED_enables -> 4-bit bus that enables the specified registers
        LED_7SEG -> 7-bit bus that has to be turned on in each individual display
        LED_dot -> Bit that specified if the dot of the current display should be turned on

    Note: The Display in my FPGA is active_low for the segments, the dot and the enable pins


*/

//`include "./clk_divider.sv"

module LED_7SEG_Controller #(parameter REFRESH_FREQ=150, FPGA_FREQ=50_000_000) (input logic en_w, input logic [1:0] waddr, input logic [7:0] data, input logic clk, input logic rst,  output logic [3:0] LED_enables, output logic [6:0] LED_7SEG, output logic LED_dot);

    logic [7:0] LED_regs [4];
    logic refresh_clk;
    logic [1:0] raddr; //Auxiliary counter for the Display logic block. It indicates which display is read at the current refresh_cycle
    
    clk_divider #(.TARGET_FREQ (REFRESH_FREQ), .FPGA_FREQ(FPGA_FREQ)) clk_div (.clk(clk), .rst(rst), .clk_div(refresh_clk));

    always_ff@(posedge clk or negedge rst) 
        begin
            if (!rst) begin
                for (int i = 0; i < 4; i++) 
                    begin
                        LED_regs[i] <= 8'hff; //Initialized as 1 because display is active_low
                    end
            end else begin
                if (en_w) LED_regs[waddr] <= data;
            end
        end

    always_ff@(posedge refresh_clk or negedge rst) 
        begin
				if (!rst) 
				begin
					raddr <= 2'b00;
				end
				else 
				begin
					if (raddr == 2'b11) raddr <= 2'b00;
					else raddr <= raddr + 1;
				end
        end

    always_comb 
        begin
            LED_7SEG = rst ? LED_regs[raddr][6:0] : 7'b1111111;
            LED_dot = rst ? LED_regs[raddr][7] : 1'b1;

            //Each led should be turned on if at least one of its segments is 0 or his address is enabled (active low logic)
            LED_enables[0] = (&LED_regs[0]) | !(raddr == 2'b00);
            LED_enables[1] = (&LED_regs[1]) | !(raddr == 2'b01);
            LED_enables[2] = (&LED_regs[2]) | !(raddr == 2'b10);
            LED_enables[3] = (&LED_regs[3]) | !(raddr == 2'b11);
				

        end
endmodule