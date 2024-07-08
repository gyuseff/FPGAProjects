
/* 
    UART_TX
    
    For now the UART will only transmit and receive with 8 bits of data, 1 bit of stop and with the parity bit.

    Inputs:
        clk: The clock of the system
        rst: Reset signal (active low)
        data: 8-bit bus that is the data to be transmitted
        start: Signal that when transitions from low to high, start the transmission process
    
    Outputs:
        Tx: The data that is transmitted
        EN_L: Flag that points if the UART TX is able to load a new data packet (high) or it is currently transmitting (low)

    The transmissor will work as follows depending on the state:
        IDLE: When idle, the output will be set to active high. When the start signal is given, it will load the data into the shift register, determine the parity bit and signal that the transmission will start; then it will  

*/

typedef enum logic[2:0] { IDLE, TX_START, TX_DATA, TX_PARITY, TX_STOP } TX_STATES;

module UART_TX (input logic clk, input logic rst, input logic [7:0] data, input logic start, output logic Tx, output logic EN_L);

    logic [8:0] TX_shift_reg; //MSB is the parity bit
    logic [2:0] bit_counter;

    TX_STATES current_state, next_state;

    always_ff @( posedge clk  or negedge rst) begin 
        if (!rst) current_state <= IDLE;
        else current_state <= next_state;
    end

    always_comb begin
        EN_L = (current_state == IDLE);
        //Tx = 1'b1;
        case(next_state)
            IDLE: Tx = 1'b1;
            TX_START: Tx = 1'b1;
            TX_DATA: Tx = (current_state == TX_START) ? 1'b0: TX_shift_reg[0];
            TX_PARITY: Tx = TX_shift_reg[0];
            TX_STOP: Tx = TX_shift_reg[0];
            default: Tx = 1'b1;
        endcase
    end

    always_comb begin
        case(current_state)
            IDLE: next_state = start ? TX_START : IDLE;
            TX_START: next_state = TX_DATA;
            TX_DATA: next_state = (bit_counter == 3'b111) ? TX_PARITY : TX_DATA;
            TX_PARITY: next_state = TX_STOP;
            TX_STOP: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    always_ff@(posedge clk or negedge rst) begin
        if (!rst) begin
            bit_counter <= 3'b000;
            TX_shift_reg <= 8'h00;
        end else begin
            case(current_state)
                IDLE: begin
                    if (start) begin
                        TX_shift_reg <= {^(data), data};
                    end
                end
                //TX_START: 
                TX_DATA: begin
                    TX_shift_reg <= (TX_shift_reg >> 1);
                    bit_counter <= (bit_counter != 3'b111) ? bit_counter + 1 : bit_counter;
                end
                TX_PARITY: TX_shift_reg <= (TX_shift_reg >> 1);
                TX_STOP: begin
                    bit_counter <= 3'b000;
                end
                default: begin
                    bit_counter <= 3'b000;
                end
            endcase
        end
    end
endmodule
