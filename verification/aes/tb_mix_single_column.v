`timescale 1ns/1ps
`default_nettype none

module tb_mix_single_column;

reg  [31:0] column_in;
wire [31:0] column_out;

mix_single_column dut (
    .column_in(column_in),
    .column_out(column_out)
);

initial begin

    $vcdplusfile("mix_single_column.vpd");
    $vcdpluson();

    // FIPS-197 Known Answer Test
    column_in = 32'hDB135345;

    #10;

    $display("Input : %h", column_in);
    $display("Output: %h", column_out);

    if (column_out == 32'h8E4DA1BC)
        $display("PASS");
    else
        $display("FAIL Expected = 8E4DA1BC");

    #10;
    $finish;

end

endmodule

`default_nettype wire
