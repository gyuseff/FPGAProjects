module LongDivisor #(MAX_WIDTH = 16) (
    input logic rst,
    input logic clk,
    input logic start_op,
    input logic [MAX_WIDTH-1:0] dividend,
    input logic [MAX_WIDTH-1:0] divisor,
    output logic [MAX_WIDTH-1:0] quotient,
    output logic [MAX_WIDTH-1:0] remainder,
    output logic done
);
    
    enum logic[1:0] {IDLE, OP, LAST, DONE} current_state, next_state;

    logic [MAX_WIDTH-1:0] rh, rh_next, rl, rl_next;
    logic [MAX_WIDTH-1:0] rh_temp;
    logic [MAX_WIDTH*2-1:0] shifted_result;
    logic [$clog2(MAX_WIDTH)-1:0] counter, next_counter;

    logic q_bit;

    assign quotient = rl;
    assign remainder = rh;

    assign shifted_result = {rh_temp[MAX_WIDTH-2:0], rl, q_bit};

    always_ff @( posedge clk, negedge rst ) begin
        if(!rst) begin
            current_state <= IDLE;
            rh <= '0;
            rl <= '0;
            counter <= '0;
        end
        else begin
            current_state <= next_state;
            rh <= rh_next;
            rl <= rl_next;
            counter <= next_counter;
        end
    end

    always_comb begin
        rh_next = rh;
        rl_next = rl;
        next_state = IDLE;
        q_bit = 1'b0;
        next_counter = '0;
        done = 1'b0;
        case (current_state)
            IDLE: begin
                if(start_op) begin
                    rh_next = {{(MAX_WIDTH-1){1'b0}}, dividend[MAX_WIDTH-1]};
                    rl_next = {dividend[MAX_WIDTH-2:0], 1'b0};
                    next_state = OP;
                    next_counter = {$clog2(MAX_WIDTH){1'b1}};
                end
            end 
            OP: begin
                if(rh >= divisor) begin
                    rh_temp = rh - divisor;
                    q_bit = 1'b1;
                end
                else begin
                    rh_temp = rh;
                    q_bit = 1'b0;
                end
                rh_next = shifted_result[MAX_WIDTH*2-1:MAX_WIDTH];
                rl_next = shifted_result[MAX_WIDTH-1:0];

                if(counter > 1) begin
                    next_counter = counter - 1'b1;
                    next_state = OP;
                end 
                else begin
                    next_state = LAST;
                end
            end
            LAST: begin
                if(rh >= divisor) begin
                    rh_temp = rh - divisor;
                    q_bit = 1'b1;
                end
                else begin
                    rh_temp = rh;
                    q_bit = 1'b0;
                end
                rh_next = rh_temp;
                rl_next = {rl[MAX_WIDTH-2:0], q_bit};
                next_state = DONE;
            end
            DONE: begin
                done = 1'b1;
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
        
    end


endmodule