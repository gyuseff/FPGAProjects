`include "3_12_5_FloatingPoint_gt.sv"

module tb_FloatingPoint_gt;
reg [12:0] A;
reg [12:0] B;
wire gt;

 
FloatingPoint_gt DUT(
    .A(A),
    .B(B),
    .gt(gt)
);

initial begin
    $dumpfile("tb_FloatingPoint_gt.vcd");
    $dumpvars(0, tb_FloatingPoint_gt);
end

initial begin
    #0; A <= 0; B <= 0;
    #1; $display("A = %b_%b_%b, B = %b_%b_%b, gt = %b", A[12], A[11:8], A[7:0], B[12], B[11:8], B[7:0], gt);
    #10; A <= $random(); B <= $random();
    #1; $display("A = %b_%b_%b, B = %b_%b_%b, gt = %b", A[12], A[11:8], A[7:0], B[12], B[11:8], B[7:0], gt);
    #10; A <= $random(); B <= $random();
    #1; $display("A = %b_%b_%b, B = %b_%b_%b, gt = %b", A[12], A[11:8], A[7:0], B[12], B[11:8], B[7:0], gt);
    #10; A <= $random(); B <= $random();
    #1; $display("A = %b_%b_%b, B = %b_%b_%b, gt = %b", A[12], A[11:8], A[7:0], B[12], B[11:8], B[7:0], gt);
    #10; A <= $random(); B <= $random();
    #1; $display("A = %b_%b_%b, B = %b_%b_%b, gt = %b", A[12], A[11:8], A[7:0], B[12], B[11:8], B[7:0], gt);
    #10; A <= $random(); B <= $random();
    #1; $display("A = %b_%b_%b, B = %b_%b_%b, gt = %b", A[12], A[11:8], A[7:0], B[12], B[11:8], B[7:0], gt);
end

endmodule
