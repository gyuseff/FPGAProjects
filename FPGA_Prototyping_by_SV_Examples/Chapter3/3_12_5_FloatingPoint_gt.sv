// Exercise: Create a circuit that takes 2 numbers in floating point form and outputs if the first one is greater than the second
// The floating point representation uses this form {sign, 4-bit exponent, 8-bit magnitude}
// With that, the number is: (-1)**(sign) * (0.magnitude)**(exponent)

module FloatingPoint_comp (
    input logic [12:0] A,
    input logic [12:0] B,
    output logic gt,
    output logic lt,
    output logic eq
);

    FloatingPoint_gt AgtB(.A(A), .B(B), .gt(gt));
    FloatingPoint_gt BgtA(.A(B), .B(A), .gt(lt));
    
    assign eq = ~gt & ~lt;

endmodule

module FloatingPoint_gt (
    input logic [12:0] A,
    input logic [12:0] B,
    output logic gt
);

    logic sign_a, sign_b;
    logic [3:0] exp_a, exp_b;
    logic [7:0] mag_a, mag_b;

    /* A is bigger than B if: 
        (sign_a == 0 & sign_b == 1) | 
        (sign_a == sign_b == 0) & (exp_a > exp_b) | 
        (sign_a == sign_b == 0) & (exp_a == exp_b) & (mag_a > mag_b) | 
        (sign_a == sign_b == 1) & (exp_a < exp_b) | 
        (sign_a == sign_b == 1) & (exp_a == exp_b) & (mag_a < mag_b)
    */
    always_comb begin
        gt = ((sign_a == 0)&(sign_b == 1)) | 
                ((sign_a == 0)&(sign_b == 0)&(exp_a > exp_b)) |
                ((sign_a == 0)&(sign_b == 0)&(exp_a == exp_b)&(mag_a > mag_b)) |
                ((sign_a == 1)&(sign_b == 1)&(exp_a < exp_b)) |
                ((sign_a == 1)&(sign_b == 1)&(exp_a == exp_b)&(mag_a < mag_b));
        end

    always_comb begin
        sign_a = A[12];
        sign_b = B[12];
        exp_a = A[11:8];
        exp_b = B[11:8];
        mag_a = A[7:0];
        mag_b = B[7:0];
    end
    
endmodule