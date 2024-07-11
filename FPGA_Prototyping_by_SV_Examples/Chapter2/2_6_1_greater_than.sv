// Exercise: Create a 2 bit greater than comparator, then use it to create a 4 bit greater than comparator

module GT_2bits (
    input logic [1:0] A,
    input logic [1:0] B,
    output logic Y
);
    
    assign Y = (A[1]&~B[1]) | (A[0]&~B[1]&~B[0]) | (A[1]&A[0]*~B[0]);

endmodule

module GT_4bits(
    input logic [3:0] A,
    input logic [3:0] B,
    output logic Y
);

    logic MSB_comparator, LSB_comparator, MSB_equality;

    assign MSB_equality = ~(A[3] ^ B[3]) & ~(A[2] ^ B[2]);
    assign Y = MSB_comparator | (LSB_comparator & MSB_equality);

    GT_2bits U_MSB(.A(A[3:2]), .B(B[3:2]), .Y(MSB_comparator));
    GT_2bits U_LSB(.A(A[1:0]), .B(B[1:0]), .Y(LSB_comparator));

endmodule