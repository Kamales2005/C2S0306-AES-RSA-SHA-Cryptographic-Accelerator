`timescale 1ns/1ps
`default_nettype none

module tb_add_round_key;

reg  [127:0] state_in;
reg  [127:0] round_key;
wire [127:0] state_out;

add_round_key dut (
    .state_in(state_in),
    .round_key(round_key),
    .state_out(state_out)
);

initial begin
    $vcdplusfile("add_round_key.vpd");
    $vcdpluson();

    // Test Vector 1
    state_in  = 128'h00112233445566778899AABBCCDDEEFF;
    round_key = 128'h000102030405060708090A0B0C0D0E0F;
    #10;

    // Expected:
    // 00102030405060708090A0B0C0D0E0F0

    // Test Vector 2
    state_in  = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
    round_key = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
    #10;

    // Expected:
    // 00000000000000000000000000000000

    // Test Vector 3
    state_in  = 128'h123456789ABCDEF00123456789ABCDEF;
    round_key = 128'hFEDCBA9876543210FEDCBA9876543210;
    #10;

    $finish;
end

initial begin
    $monitor("Time=%0t state_out=%h", $time, state_out);
end

endmodule

`default_nettype wire
