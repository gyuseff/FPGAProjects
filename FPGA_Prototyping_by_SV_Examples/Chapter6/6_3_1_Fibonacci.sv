
// Exercise: This is a circuit to obtain the Fibonacci sequence of the input number "n"

/*

    The maximum widths for the inputs and outputs are these:

    Input width    | max_input      | Output width   | max_output    
    0              | 0              | 1              | 1
    1              | 1              | 1              | 1
    2              | 3              | 2              | 2
    3              | 7              | 4              | 13
    4              | 15             | 10             | 610
    5              | 31             | 21             | 1346269 
    6              | 47             | 32             | 2.97E9 
    6              | 63             | 43             | 6.55E12

    Notice that for input decimal "47" we can get a number with up to 32-bit.
    We'll define f(0) = 0, f(1) = 1, f(2) = 1, f(n) = f(n-1) + f(n-2) for n > 2
*/


module Fibonacci #(parameter MAX_WIDTH_OUT = 21, MAX_WIDTH_IN = 5) (
    input logic rst,
    input logic clk,
    input logic start_op,
    input logic [MAX_WIDTH_IN-1:0] N,
    output logic [MAX_WIDTH_OUT-1:0] out,
    output logic done
);

    enum logic {IDLE, OP} state_reg, next_state;
    logic [MAX_WIDTH_IN-1:0] load_reg, next_load;
    logic [MAX_WIDTH_OUT-1:0] out_reg, next_out, prev_reg, next_prev;
    logic done_reg, next_done;

    assign done = done_reg;
    assign out = out_reg;

    always_ff @( posedge clk, negedge rst ) begin
        if(!rst) begin
            state_reg <= IDLE;
            load_reg <= 'b0;
            out_reg <= 'b0;
            prev_reg <= 'b0;
            done_reg <= 1'b0;
        end 
        else begin
            state_reg <= next_state;
            load_reg <= next_load;
            out_reg <= next_out;
            prev_reg <= next_prev;
            done_reg <= next_done;
        end
    end

    always_comb begin
        next_state = IDLE;
        next_load = 'b0;
        next_out = out_reg;
        next_done = 1'b0;

        case(state_reg)
            IDLE : begin
                if(start_op) begin
                    if(N == 'b0) begin
                        next_state = IDLE;
                        next_out = 'b0;
                        next_done = 1'b1;
                    end
                    else if(N < 2) begin
                        next_state = IDLE;
                        next_out = 'b1;
                        next_done = 1'b1;
                    end
                    else begin
                        next_state = OP;
                        next_load = N - 2'b10;
                        next_prev = 'b1;
                        next_out = 'b1;
                    end
                end
            end

            OP : begin
                next_prev = out_reg;
                next_out = out_reg + prev_reg;
                if (load_reg == 'b1) begin
                    next_state = IDLE;
                    next_done = 1'b1;
                end
                else begin
                    next_load = load_reg - 1'b1;
                    next_state = OP;
                end
            end
            default : begin
                next_state = IDLE;
                next_load = 'b0;
                next_out = out_reg;
                next_done = 1'b0;
            end
            
        endcase
    end
endmodule