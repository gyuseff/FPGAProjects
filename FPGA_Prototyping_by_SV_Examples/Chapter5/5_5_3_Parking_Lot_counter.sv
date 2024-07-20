// Exercise: Design a circuit that counts the occupancy of a parking lot.
// To count, we have two sensor, A and B.
// When a car enters the sequence of AB will be: 00 -> 10 -> 11 -> 01 -> 00
// When a car leaves the sequence of AB will be: 00 -> 01 -> 11 -> 10 -> 00
// We'll assume a max capacity of 255

module Parking_lot_counter #(parameter MAX_CAP = 8) (
    input logic clk,
    input logic rst,
    input logic A,
    input logic B,
    output logic car_enter,
    output logic car_exit,
    output logic [MAX_CAP-1:0] current_count 
);

    enum logic[3:0] {IDLE, A_BLOCKED_ENTER, AB_BLOCKED_ENTER, B_BLOCKED_ENTER, CAR_ENTERED, A_BLOCKED_EXIT, AB_BLOCKED_EXIT, B_BLOCKED_EXIT, CAR_EXITED} state_reg, next_state;
	 
	 logic [MAX_CAP-1:0] count_reg, next_count;
	
    always_ff @( posedge clk, negedge rst ) begin
        if(!rst) begin
            state_reg <= IDLE;
            count_reg <= 0;
        end
        else begin 
            state_reg <= next_state;
            count_reg <= next_count;
        end
    end

	 assign current_count = count_reg;
	 
    always_comb begin
        next_state = IDLE;
        next_count = count_reg;
		  car_enter = 1'b0;
		  car_exit = 1'b0;
        case (state_reg)
            IDLE :  begin
                        next_state   = A ? A_BLOCKED_ENTER : 
                                       B ? B_BLOCKED_EXIT : IDLE;
                    end
            A_BLOCKED_ENTER : begin
                        // AB  ->  AB_BLOCKED_ENTER
                        // A~B ->  A_BLOCKED_ENTER
                        //~A~B ->  IDLE
                        next_state  = A ? (B ? AB_BLOCKED_ENTER : A_BLOCKED_ENTER) : IDLE;
            end
            AB_BLOCKED_ENTER : begin
                        // AB  ->  AB_BLOCKED_ENTER
                        // A~B ->  A_BLOCKED_ENTER
                        // ~AB ->  B_BLOCKED_ENTER
                        next_state = B ? (A ? AB_BLOCKED_ENTER : B_BLOCKED_ENTER) : A_BLOCKED_ENTER;
            end
            B_BLOCKED_ENTER : begin
                        // AB  ->  AB_BLOCKED_ENTER
                        // ~AB ->  B_BLOCKED_ENTER
                        // ~A~B ->  IDLE or CAR_ENTERED

                        // Mealy machine
                        //next_state = B ? (A ? AB_BLOCKED_ENTER : B_BLOCKED_ENTER) : IDLE;
                        //next_count = (next_state == IDLE) ? count_reg + 1 : count_reg;
                        //car_enter = (next_state == IDLE);

                        // Moore machine
                        next_state = B ? (A ? AB_BLOCKED_ENTER : B_BLOCKED_ENTER) : CAR_ENTERED;
            end 
            CAR_ENTERED : begin
                        next_state = IDLE;
                        car_enter = 1'b1;
                        next_count = count_reg + 1'b1;
            end 
            B_BLOCKED_EXIT : begin
                        // AB  ->  AB_BLOCKED_EXIT
                        // ~AB ->  B_BLOCKED_EXIT
                        // ~A~B ->  IDLE
                        next_state = B ? (A ? AB_BLOCKED_EXIT : B_BLOCKED_EXIT) : IDLE;
            end 
            AB_BLOCKED_EXIT : begin
                        // AB  ->  AB_BLOCKED_EXIT
                        // A~B ->  A_BLOCKED_EXIT
                        // ~AB ->  B_BLOCKED_EXIT
                        next_state = A ? (B ? AB_BLOCKED_EXIT : A_BLOCKED_EXIT) : B_BLOCKED_EXIT;
            end
            A_BLOCKED_EXIT : begin
                        // AB  ->  AB_BLOCKED_EXIT
                        // A~B ->  A_BLOCKED_EXIT
                        //~A~B ->  IDLE or CAR_EXITED
                        
                        // Mealy machine
                        //next_state = B ? (A ? AB_BLOCKED_EXIT : B_BLOCKED_EXIT) : IDLE;
                        //next_count = (next_state == IDLE) ? count_reg - 1 : count_reg;
                        //car_exit = (next_state == IDLE);

                        // Moore machine
                        next_state = A ? (B ? AB_BLOCKED_EXIT : A_BLOCKED_EXIT) : CAR_EXITED;
            end
            CAR_EXITED : begin
                        next_state = IDLE;
                        car_exit = 1'b1;
                        next_count = count_reg - 1'b1;
            end 
            default: next_state = IDLE;
        endcase
    end
    
endmodule
