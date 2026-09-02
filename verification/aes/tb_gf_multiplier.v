`timescale 1ns/1ps
`default_nettype none

module tb_gf_multiplier;

reg  [7:0] data_in;

wire [7:0] mul2;
wire [7:0] mul3;

gf_multiplier dut
(
    .data_in(data_in),
    .mul2(mul2),
    .mul3(mul3)
);

initial begin

    $vcdplusfile("gf_multiplier.vpd");
    $vcdpluson();

    //-------------------------------
    // Test Vector 1
    //-------------------------------
    data_in = 8'h57;
    #10;

    //-------------------------------
    // Test Vector 2
    //-------------------------------
    data_in = 8'hAE;
    #10;

    //-------------------------------
    // Test Vector 3
    //-------------------------------
    data_in = 8'h83;
    #10;

    $finish;

end

initial begin

    $monitor("Time=%0t  IN=%h  MUL2=%h  MUL3=%h",
             $time,
             data_in,
             mul2,
             mul3);

end

endmodule

`default_nettype wire
