`timescale 1ns/1ps

module tb_round_counter;

reg clk;
reg rst_n;
reg load;
reg enable;

wire [3:0] round;
wire last_round;

round_counter dut
(
    .clk(clk),
    .rst_n(rst_n),
    .load(load),
    .enable(enable),
    .round(round),
    .last_round(last_round)
);

always #5 clk = ~clk;

initial
begin
    clk = 0;
    rst_n = 0;
    load = 0;
    enable = 0;

    #20;
    rst_n = 1;

    // Initialize counter
    load = 1;
    #10;
    load = 0;

    // Count rounds
    enable = 1;
    #120;

    enable = 0;

    #20;
    $finish;
end
initial begin
    $vcdplusfile("round_counter.vpd");
    $vcdpluson(0, tb_round_counter);
end

endmodule
