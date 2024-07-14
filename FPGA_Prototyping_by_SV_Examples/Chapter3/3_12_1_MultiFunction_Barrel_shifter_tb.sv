`include "3_12_1_MultiFunction_Barrel_shifter.sv"

module BarrelShifter_1_tb;

reg [7:0] in;
wire [2:0] amt;
reg lr;
reg [7:0] out;
reg [7:0] expected;
reg result;

int i;

BarrelShifter_1 DUT 
(
    .in(in),
    .amt(amt),
    .lr(lr),
    .out(out)
);


initial begin
    $dumpfile("BarrelShifter_1.vcd");
    $dumpvars(0, BarrelShifter_1_tb);
end

assign result = (out == expected);
assign amt = i[2:0];

initial begin
    #0; in <= 8'hed; lr <= 0; i <= 0;
    #1; expected <= in;
    #10;
    for(i = 0; i < 8; i++) begin
        #10;
        expected <= {expected[0], expected[7:1]};
    end
    #20; lr <= 1'b1; i <= 0;
    #1; expected <= in;
    #10;
    for(i = 0; i < 8; i++) begin
        #10;
        expected <= {expected[6:0], expected[7]};
    end
    $stop;
end

endmodule
