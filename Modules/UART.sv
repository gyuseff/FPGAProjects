
module UART_TX_RX(
    input logic clk, 
    input logic rst, 
    input logic [7:0] TX_data, 
    input logic TX_start,
    input logic RX_en, 
    input logic RX_in,
    output logic TX_out, 
    output logic TX_EN_L,
    output logic [7:0] RX_data,
    output logic RX_error,
    output logic RX_done
    )

    UART_TX U_TX(.clk(clk), .rst(rst), .data(TX_data), .start(TX_start), .Tx(TX_out), .EN_L(TX_EN_L));

    UART_RX U_RX(.clk(clk), .rst(rst), .Rx(RX_in), .en_r(RX_en), .data(RX_data), .error(RX_error), .done(RX_done));

endmodule

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

*/

typedef enum logic[2:0] { TX_IDLE, TX_START, TX_DATA, TX_PARITY, TX_STOP } TX_STATES;

module UART_TX (
    input logic clk, 
    input logic rst, 
    input logic [7:0] data, 
    input logic start, 
    output logic Tx, 
    output logic EN_L
    );

    logic [8:0] TX_shift_reg; //MSB is the parity bit
    logic [2:0] bit_counter;

    TX_STATES current_state, next_state;

    always_ff @( posedge clk  or negedge rst) begin 
        if (!rst) current_state <= TX_IDLE;
        else current_state <= next_state;
    end

    always_comb begin
        EN_L = (current_state == TX_IDLE);
        //Tx = 1'b1;
        case(next_state)
            TX_IDLE: Tx = 1'b1;
            TX_START: Tx = 1'b1;
            TX_DATA: Tx = (current_state == TX_START) ? 1'b0: TX_shift_reg[0];
            TX_PARITY: Tx = TX_shift_reg[0];
            TX_STOP: Tx = TX_shift_reg[0];
            default: Tx = 1'b1;
        endcase
    end

    always_comb begin
        case(current_state)
            TX_IDLE: next_state = start ? TX_START : TX_IDLE;
            TX_START: next_state = TX_DATA;
            TX_DATA: next_state = (bit_counter == 3'b111) ? TX_PARITY : TX_DATA;
            TX_PARITY: next_state = TX_STOP;
            TX_STOP: next_state = TX_IDLE;
            default: next_state = TX_IDLE;
        endcase
    end

    always_ff@(posedge clk or negedge rst) begin
        if (!rst) begin
            bit_counter <= 3'b000;
            TX_shift_reg <= 8'h00;
        end else begin
            case(current_state)
                TX_IDLE: begin
                    if (start) begin
                        TX_shift_reg <= {^(data), data};
                    end
                end
                //TX_START: 
                TX_DATA: begin
                    TX_shift_reg <= (TX_shift_reg >> 1);
                    bit_counter <= bit_counter + 1;
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

/* 
    UART_RX
    
    For now the UART will only transmit and receive with 8 bits of data, 1 bit of stop and with the parity bit.

    Inputs:
        clk: The clock of the system
        rst: Reset signal (active low)
        Rx: data that is transmitted
        en_r: Enable signal, if it is 1 when the Rx pin transitions to low, then it starts receiving the data.
    
    Outputs:
        data: 8-bit bus with the data that was received
        error: Flag that it is high when the parity bit is different to the parity of the data received
        done: Flag to indicate that the data is ready to be read

*/

typedef enum logic[1:0] { RX_IDLE, RX_DATA, CHECK_PARITY } RX_STATES;

module UART_RX (
    input logic clk,
    input logic rst,
    input logic Rx,
    input logic en_r,
    output logic [7:0] data,
    output logic error,
    output logic done
);

    RX_STATES current_state, next_state;
    logic [8:0] RX_data_reg; //MSB is the parity bit
    logic [3:0] counter;

    always_ff@(posedge clk or negedge rst) begin
        if(!rst) current_state <= RX_IDLE;
        else current_state <= next_state;
    end

    always_comb begin
        case(current_state)
            RX_IDLE: begin
                done = 1'b0;
                error = 1'b0;
                data = 8'h00;
            end
            RX_DATA: begin
                done = 1'b0;
                error = 1'b0;
                data = 8'h00;
            end
            CHECK_PARITY: begin
                done = 1'b1;
                error = ^RX_data_reg;
                data = RX_data_reg[7:0];
            end
            default: begin
                done = 1'b0;
                error = 1'b0;
                data = 8'h00;
            end
        endcase
    end

    always_comb begin
        case(current_state)
            RX_IDLE: begin
                if(!Rx & en_r) next_state = RX_DATA;
                else next_state = RX_IDLE;
            end
            RX_DATA: begin
                if(counter == 4'b1000) next_state = CHECK_PARITY;
                else next_state = RX_DATA;
            end
            CHECK_PARITY: begin
                next_state = RX_IDLE;
            end
            default: next_state = RX_IDLE;
        endcase
    end

    always_ff@(posedge clk or negedge rst) begin
        if(!rst) begin
            counter <= 4'b0000;
            RX_data_reg <= 9'b0_0000_0000;
        end else begin
            case(current_state)
                RX_IDLE: begin
                    RX_data_reg <= 9'b0_0000_0000;
                    counter <= 4'b0000;
                end
                RX_DATA: begin
                    RX_data_reg <= {Rx, RX_data_reg[8:1]};
                    counter <= counter + 1;
                end
                CHECK_PARITY:  begin
                    RX_data_reg <= 9'b0_0000_0000;
                    counter <= 4'b0000;
                end
                default: begin
                    RX_data_reg <= 9'b0_0000_0000;
                    counter <= 4'b0000;
                end
            endcase
        end
    end

endmodule