// Exercise create a multi-function barrel shifter
// Create a shifting circuit that can perform rotate-right or rotate left
// 1. First do it with two separate circuits (one for left and one for right) and a mux
// 2. Then do it with just one rotate circuit with a pre and post inversion of the bits (from in[7:0] to in[0:7])


module BarrelShifter_1 (
    input logic [7:0] in,
    input logic [2:0] amt,
    input logic lr, //Switch to control direction (if 1, then rotate left, else rotate right)
    output logic [7:0] out
);
    
    logic [7:0] out_right [4];
    logic [7:0] out_left [4];

    always_comb begin
        out_left[0] = in;
        out_right[0] = in;
    end

    genvar i;
    generate 
        for(i = 1; i < 4; i=i+1) begin
            assign out_right[i] = amt[i-1] ? {out_right[i-1][2**(i-1):0], out_right[i-1][7:2**(i-1)]} : out_right[i-1];
        end    
    endgenerate

    generate
        for(i = 1; i < 4; i++) begin
            assign out_left[i] = amt[i-1] ?  {out_left[i-1][7-2**(i-1):0], out_left[i-1][7:7-2**(i-1)+1]} : out_left[i-1];
        end    
    endgenerate

    always_comb begin
        out = lr ? out_left[3] : out_right[3];
    end

endmodule

module BarrelShifter_2 (
    input logic [7:0] in,
    input logic [2:0] amt,
    input logic lr, //Switch to control direction (if 1, then rotate left, else rotate right)
    output logic [7:0] out
);
    
    logic [7:0] out_right [4];
    logic [7:0] inverted_in, inverted_out;

    genvar i;
    generate 
        for(i = 1; i < 4; i=i+1) begin
            assign out_right[i] = amt[i-1] ? {out_right[i-1][2**(i-1):0], out_right[i-1][7:2**(i-1)]} : out_right[i-1];
        end    
    endgenerate

    generate
        for(i = 0; i < 8; i++) begin
            assign inverted_in[i] = in[7-i];
            assign inverted_out[i] = out_right[3][7-i];
        end
    endgenerate

    always_comb begin
        out_right[0] = lr ? inverted_in : in;
        out = lr ? inverted_out : out_right[3];
    end

endmodule