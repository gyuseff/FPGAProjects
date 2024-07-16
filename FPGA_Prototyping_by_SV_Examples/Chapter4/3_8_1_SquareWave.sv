// The FPGA clock is 50Mhz (20 ns)
// Exercise: Create a custom square logic generator, where the amount of time in high is m*100ns and the amount of time in low is n*100ns

module SquareWaveGenerator (
    input logic [3:0] m,
    input logic [3:0] n,
    input logic rst,
    input logic clk,
    output logic out
);

    logic [2:0] clk_div_count;
    logic clk_div;

    logic [3:0] m_count, n_count;
    logic counting_m;

    assign out = counting_m;

    //First let's make a clk divider to get a period of 100ns (10MHz)

    always_ff@( posedge clk, negedge rst ) begin
        if (!rst | (clk_div_count == 3'b100)) clk_div_count <= 3'b000;
        else clk_div_count <= clk_div_count + 1;
    end

    always_comb begin
        clk_div = (clk_div_count == 3'b100);
    end

    //Now let's make the square wave by using counters

    always_ff@(posedge clk_div, negedge rst) begin
        if(!rst) begin
            m_count <= 4'h0;
            n_count <= 4'h0;
            counting_m <= 1'b0;
        end
        else begin
            if(counting_m) begin
                if(m_count >= m-1) begin
                    m_count <= 4'b0000;
                    counting_m <= 1'b0;
                end 
                else m_count <= m_count + 1'b1;
            end
            else begin
                if(n_count >= n-1) begin
                    n_count <= 4'b0000;
                    counting_m <= 1'b1;
                end
                else n_count <= n_count + 1'b1;
            end
        end
    end


endmodule