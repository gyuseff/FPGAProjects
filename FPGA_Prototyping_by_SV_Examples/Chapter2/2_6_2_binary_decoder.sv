// Exercise: Create a 2 to 4 Decoder. Then use it to create a 3 to 8 and a 4 to 16 decoders.


module DECODER_4_16(
    input logic en,
    input logic [3:0] in,
    output logic [15:0] out
);

    logic [3:0] deco_out;
    DECODER_2_4 U(.in(in[1:0]), .out(deco_out), .en(en));

    assign out[15:12]   = {4{en & in[3] & in[2]}} & deco_out;
    assign out[11:8]    = {4{en & in[3] & ~in[2]}} & deco_out;
    assign out[7:4]     = {4{en & ~in[3] & in[2]}} & deco_out;
    assign out[3:0]     = {4{en & ~in[3] & ~in[2]}} & deco_out;
 
endmodule

module DECODER_3_8 (
    input logic en,
    input logic [2:0] in,
    output logic [7:0] out
);

    logic [3:0] deco_out;

    DECODER_2_4 U(.in(in[1:0]), .out(deco_out), .en(en));

    assign out[7:4] = en ? (in[2] ? deco_out : 4'b0000) : 4'b0000;
    assign out[3:0] = en ? (in[2] ? 4'b0000 : deco_out) : 4'b0000;

endmodule

module DECODER_2_4 (
    input logic en,
    input logic [1:0] in,
    output logic [3:0] out
);
       
    assign out[0] = en & ~in[1] & ~in[0];
    assign out[1] = en & ~in[1] & in[0];
    assign out[2] = en & in[1] & ~in[0];
    assign out[3] = en & in[1] & in[0];

endmodule