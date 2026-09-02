`timescale 1ns/1ps
`default_nettype none

module tb_mix_columns;

reg  [127:0] state_in;
wire [127:0] state_out;

mix_columns dut
(
    .state_in(state_in),
    .state_out(state_out)
);

initial begin

    $vcdplusfile("mix_columns.vpd");
    $vcdpluson();

    //------------------------------------------------
    // Four identical columns
    //------------------------------------------------

    state_in =
    {
        32'hDB135345,
        32'hDB135345,
        32'hDB135345,
        32'hDB135345
    };

    #10;

    $display("Input : %h", state_in);
    $display("Output: %h", state_out);

    if(state_out ==
    {
        32'h8E4DA1BC,
        32'h8E4DA1BC,
        32'h8E4DA1BC,
        32'h8E4DA1BC
    })
        $display("PASS");
    else
        $display("FAIL");

    #10;

    $finish;

end

endmodule

`default_nettype wire
