`timescale 1ns/1ps
`default_nettype none

module tb_shift_rows;

reg  [127:0] state_in;
wire [127:0] state_out;

shift_rows dut (
    .state_in(state_in),
    .state_out(state_out)
);

initial begin
    $vcdplusfile("shift_rows.vpd");
    $vcdpluson();

    // Test pattern with incrementing bytes
    state_in = 128'h00112233445566778899AABBCCDDEEFF;
    #10;

    $display("Input : %h", state_in);
    $display("Output: %h", state_out);

    $finish;
end

endmodule

`default_nettype wire
