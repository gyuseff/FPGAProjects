/*
    This module is to be used with a 4 x 7-LED Segments display
    It will take 4 8-bit inputs that will we showed in the LED Display 
    Inputs
        en -> Enables the LED display
        clk -> Master (fast) clock used to update the digits registers. And be divided by the internal clock divider
        rst -> Asyncronous reset for the display
        data_0 -> 8-bit input for digit 0 of the display (The MSB is the dot)
        data_1 -> 8-bit input for digit 1 of the display (The MSB is the dot)
        data_2 -> 8-bit input for digit 2 of the display (The MSB is the dot)
        data_3 -> 8-bit input for digit 3 of the display (The MSB is the dot)
    Outputs
        LED_enables -> 4-bit bus that enables the specified registers
        LED_7SEG -> 7-bit bus that has to be turned on in each individual display
        LED_dot -> Bit that specified if the dot of the current display should be turned on

    Note: The Display in my FPGA is active_low for the segments, the dot and the enable pins


*/

//`include "./clk_divider.sv"

module LED_7SEG_Controller #(parameter REFRESH_FREQ=150, FPGA_FREQ=50_000_000) (
    input logic en, 
    input logic [7:0] data_0, 
    input logic [7:0] data_1, 
    input logic [7:0] data_2, 
    input logic [7:0] data_3, 
    input logic clk, 
    input logic rst,  
    output logic [3:0] LED_enables, 
    output logic [6:0] LED_7SEG, 
    output logic LED_dot
    );

    // First, let's create a clk divider for the refresh rate of the led display
    wire refresh_clk;
        
    clk_divider #(.TARGET_FREQ (REFRESH_FREQ), .FPGA_FREQ(FPGA_FREQ)) U_clk_div (.clk(clk), .rst(rst), .clk_div(refresh_clk));

    logic [1:0] counter;

    always_ff @( posedge refresh_clk, negedge rst ) begin
        if(!rst) counter <= 2'b00;
        else counter <= counter + 1'b1;
    end

    always_comb begin
        if(~en) begin
            LED_dot = 1'b1;
            LED_7SEG = 7'b1111_111;
            LED_enables = 4'b1111;
        end
        else begin
            case(counter)
                2'b00:  begin
                            LED_dot = data_0[7];
                            LED_7SEG = data_0[6:0];
                            LED_enables = 4'b1110;
                        end
                2'b01:  begin
                            LED_dot = data_1[7];
                            LED_7SEG = data_1[6:0];
                            LED_enables = 4'b1101;
                        end
                2'b10:  begin
                            LED_dot = data_2[7];
                            LED_7SEG = data_2[6:0];
                            LED_enables = 4'b1011;
                        end
                2'b11:  begin
                            LED_dot = data_3[7];
                            LED_7SEG = data_3[6:0];
                            LED_enables = 4'b0111;
                        end
                default: begin
                            LED_dot = 1'b1;
                            LED_7SEG = 7'b1111_111;
                            LED_enables = 4'b1111;
                        end
            endcase
        end
    end


endmodule