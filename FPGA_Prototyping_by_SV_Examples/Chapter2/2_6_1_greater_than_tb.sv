`include "2_6_1_greater_than.sv"

module tb_GT_4bits;
reg [4:0] A,B;
reg Y;
wire expected;

GT_4bits DUT
(
    .A(A[3:0]),
    .B(B[3:0]),
    .Y(Y)
);

initial begin
    $dumpfile("tb_GT_4bits.vcd");
    $dumpvars(0, tb_GT_4bits);
end

assign expected = A > B;
assign passed = expected == Y;

initial begin
    #0; A = 0; B = 0;
    #10;
    for (A = 0; A < 16 ; A=A+1) begin
        #10;
        for (B = 0 ; B < 16 ; B=B+1) begin
            #10; $display("A = %d, B = %d, Y = %b, expected = %b, result = %b", A, B, Y, expected, passed);
        end
    end
    $finish;
end

endmodule
