`include "3_12_4_BCD_Increment.sv"

module tb_BCD_increment;
reg [11:0] A;
reg [11:0] out;
reg overflow;

BCD_increment DUT
(
    .in(A),
    .out(out),
    .overflow(overflow)
);

initial begin
    $dumpfile("tb_BCD_increment.vcd");
    $dumpvars(0, tb_BCD_increment);
end

initial begin
    #1; A <= 12'h000;
    #1; $display("in = %h, out = %h, overflow = %b", A, out, overflow);
    #1; A <= 12'h009;
    #1; $display("in = %h, out = %h, overflow = %b", A, out, overflow);
    #1; A <= 12'h010;
    #1; $display("in = %h, out = %h, overflow = %b", A, out, overflow);
    #1; A <= 12'h029;
    #1; $display("in = %h, out = %h, overflow = %b", A, out, overflow);
    #1; A <= 12'h099;
    #1; $display("in = %h, out = %h, overflow = %b", A, out, overflow);
    #1; A <= 12'h100;
    #1; $display("in = %h, out = %h, overflow = %b", A, out, overflow);
    #1; A <= 12'h109;
    #1; $display("in = %h, out = %h, overflow = %b", A, out, overflow);
    #1; A <= 12'h110;
    #1; $display("in = %h, out = %h, overflow = %b", A, out, overflow);
    #1; A <= 12'h199;
    #1; $display("in = %h, out = %h, overflow = %b", A, out, overflow);
    #1; A <= 12'h999;
    #1; $display("in = %h, out = %h, overflow = %b", A, out, overflow);

end

endmodule
