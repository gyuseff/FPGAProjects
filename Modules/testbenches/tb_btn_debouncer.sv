`include "../btn_debouncer.sv"

module tb_btn_debouncer;
reg clk;
reg btn;
reg debounced_btn;

btn_debouncer DUT
(
    .btn (btn),
    .clk (clk),
    .debounced_btn(debounced_btn)
);

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

initial begin
    $dumpfile("tb_btn_debouncer.vcd");
    $dumpvars(0, tb_btn_debouncer);
end

initial begin
    #1 btn<=1'b1;clk<=1'b0;
    #(CLK_PERIOD*3) btn<=0;
    #(CLK_PERIOD*100000) btn <= 1;
    #(CLK_PERIOD*100000) btn <= 0; 
    #(CLK_PERIOD*100000) btn <= 1;
    #(CLK_PERIOD*100) $finish();
end

endmodule
