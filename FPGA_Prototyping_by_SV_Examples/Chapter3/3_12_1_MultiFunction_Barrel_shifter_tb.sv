`include "3_12_1_MultiFunction_Barrel_shifter.sv"

module BarrelShifter_2_param_tb;

localparam DATA_WIDTH = 16;
localparam SEL_WIDTH = $clog2(DATA_WIDTH);

wire [DATA_WIDTH-1:0] in;
wire [SEL_WIDTH-1:0] amt;
reg lr;
reg [DATA_WIDTH-1:0] out;
reg [DATA_WIDTH-1:0] expected;
reg result;

int i;



BarrelShifter_2_param #(.DATA_WIDTH(DATA_WIDTH), .SEL_WIDTH(SEL_WIDTH)) DUT 
(
    .in(in),
    .amt(amt),
    .lr(lr),
    .out(out)
);


initial begin
    $dumpfile("BarrelShifter_2_param.vcd");
    $dumpvars(0, BarrelShifter_2_param_tb);
end

assign result = (out == expected);
assign amt = i[SEL_WIDTH:0];
assign in = $urandom();

initial begin
    #0; lr <= 0; i <= 0;
    #1; expected <= in;
    #10;
    for(i = 0; i < 2**(SEL_WIDTH)-1; i++) begin
        #10;
        expected <= {expected[0], expected[DATA_WIDTH-1:1]};
    end
    #20; lr <= 1'b1; i <= 0;
    #1; expected <= in;
    #10;
    for(i = 0; i < 2**(SEL_WIDTH)-1; i++) begin
        #10;
        expected <= {expected[DATA_WIDTH-2:0], expected[DATA_WIDTH-1]};
    end
    $stop;
end

endmodule
