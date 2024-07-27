// This module takes a 14 bit number a converts it into a 4-digits BCD representation

module BinToBCD (
    input logic clk,
    input logic rst,
    input logic start_op,
    input logic [13:0] bin,
    output logic [15:0] out_BCD,
    output logic done
);

    enum logic[1:0] {IDLE, OP, DONE} state_reg, next_state;
    logic[3:0] counter_reg, next_counter;

    logic [3:0] BCD_0_reg, next_BCD_0, BCD_1_reg, next_BCD_1, BCD_2_reg, next_BCD_2, BCD_3_reg, next_BCD_3;
    logic [3:0] next_BCD_0_temp, next_BCD_1_temp, next_BCD_2_temp, next_BCD_3_temp;

    assign out_BCD = {BCD_3_reg, BCD_2_reg, BCD_1_reg, BCD_0_reg};

    always_ff @(posedge clk, negedge rst) begin
        if(!rst) begin
            state_reg <= IDLE;
            counter_reg <= 4'd0;
            BCD_0_reg <= 4'd0;
            BCD_1_reg <= 4'd0;
            BCD_2_reg <= 4'd0;
            BCD_3_reg <= 4'd0;
        end
        else begin
            state_reg <= next_state;
            counter_reg <= next_counter;
            BCD_0_reg <= next_BCD_0;
            BCD_1_reg <= next_BCD_1;
            BCD_2_reg <= next_BCD_2;
            BCD_3_reg <= next_BCD_3;
        end
    end

    always_comb begin
        next_BCD_0 = BCD_0_reg;
        next_BCD_1 = BCD_1_reg;
        next_BCD_2 = BCD_2_reg;
        next_BCD_3 = BCD_3_reg;
        next_state = IDLE;
        next_counter = 4'h0;
        done = 1'b0;
        case (state_reg)
            IDLE : begin
                if(start_op) begin
                    next_state = OP;
                    next_BCD_0 = 4'h0;
                    next_BCD_1 = 4'h0;
                    next_BCD_2 = 4'h0;
                    next_BCD_3 = 4'h0;
                    next_state = OP;
                    next_counter = 4'd13;
                end
            end
            OP : begin
                if(counter_reg == 4'd0) next_state = DONE;
                else next_state = OP;
                next_counter = counter_reg - 1'b1;
                next_BCD_0_temp = (BCD_0_reg > 4'b0100) ? BCD_0_reg + 4'b0011 : BCD_0_reg;
                next_BCD_1_temp = (BCD_1_reg > 4'b0100) ? BCD_1_reg + 4'b0011 : BCD_1_reg;
                next_BCD_2_temp = (BCD_2_reg > 4'b0100) ? BCD_2_reg + 4'b0011 : BCD_2_reg;
                next_BCD_3_temp = (BCD_3_reg > 4'b0100) ? BCD_3_reg + 4'b0011 : BCD_3_reg; 

                next_BCD_0 = {next_BCD_0_temp[2:0], bin[counter_reg]};
                next_BCD_1 = {next_BCD_1_temp[2:0], next_BCD_0_temp[3]};
                next_BCD_2 = {next_BCD_2_temp[2:0], next_BCD_1_temp[3]};
                next_BCD_3 = {next_BCD_3_temp[2:0], next_BCD_2_temp[3]};
            end
            DONE : begin
                done = 1'b1;
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end
endmodule