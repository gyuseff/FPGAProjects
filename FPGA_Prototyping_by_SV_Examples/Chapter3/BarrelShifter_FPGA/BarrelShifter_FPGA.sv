module BarrelShifter_FPGA(
	input logic [7:0] in,
	input logic [2:0] amt,
	input logic lr,
	output logic [7:0] out
);

	BarrelShifter_2 DUT (.in(in), .amt(amt), .lr(lr), .out(out));

endmodule