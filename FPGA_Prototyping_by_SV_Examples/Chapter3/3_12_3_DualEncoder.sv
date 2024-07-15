// Exercise: Create a Dual Priority Encoder
// This is a circuit that gives two outputs. 
// The first is the output of the priority encoder of the input
// The seconcd output is the output of the priority encoder, not taking the first bit into account
// To achieve this, we need two 16_4 enconder and one 4_16 decoder
// The first one will encode the first bit. This will also be connected to the decoder, so the output of the decoder is the priority bit.
// If we xor the input of the circuit with the outout of the decoder, we will toggle off the priority bit. So if we use that as input to the second encoder, we will have the priority encoder of the second bit.

module DualEncoder_16_4 (
    input logic [15:0] in,
    output logic [3:0] first,
    output logic [3:0] second
);

    logic [15:0] out_decoder, in_sec_encoder;

    assign in_sec_encoder = out_decoder ^ in;

    Encoder_16_4 U1(.in(in), .out(first));
    Decoder_4_16 U2(.in(first), .out(out_decoder));
    Encoder_16_4 U3(.in(in_sec_encoder), .out(second));

endmodule

module Encoder_16_4 (
    input logic [15:0] in,
    output logic [3:0] out
);

    always_comb begin
        casex(in)
            16'b1???_????_????_????: out = 4'hf;
            16'b01??_????_????_????: out = 4'he;
            16'b001?_????_????_????: out = 4'hd;
            16'b0001_????_????_????: out = 4'hc;
            16'b0000_1???_????_????: out = 4'hb;
            16'b0000_01??_????_????: out = 4'ha;
            16'b0000_001?_????_????: out = 4'h9;
            16'b0000_0001_????_????: out = 4'h8;
            16'b0000_0000_1???_????: out = 4'h7;
            16'b0000_0000_01??_????: out = 4'h6;
            16'b0000_0000_001?_????: out = 4'h5;
            16'b0000_0000_0001_????: out = 4'h4;
            16'b0000_0000_0000_1???: out = 4'h3;
            16'b0000_0000_0000_01??: out = 4'h2;
            16'b0000_0000_0000_001?: out = 4'h1;
            16'b0000_0000_0000_0001: out = 4'h0;
            default:                 out = 4'h0;
        endcase
    end
endmodule

module Decoder_4_16(
    input logic [3:0] in,
    output logic [15:0] out
);

    always_comb begin
        case(in)
            4'hf: out = 16'h8000;
            4'he: out = 16'h4000;
            4'hd: out = 16'h2000;
            4'hc: out = 16'h1000;
            4'hb: out = 16'h0800;
            4'ha: out = 16'h0400;
            4'h9: out = 16'h0200;
            4'h8: out = 16'h0100;
            4'h7: out = 16'h0080;
            4'h6: out = 16'h0040;
            4'h5: out = 16'h0020;
            4'h4: out = 16'h0010;
            4'h3: out = 16'h0008;
            4'h2: out = 16'h0004;
            4'h1: out = 16'h0002;
            4'h0: out = 16'h0001;
            default: out = 16'h0000;
        endcase
    end

endmodule