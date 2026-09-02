`timescale 1ns/1ps
`default_nettype none

module tb_sub_word;

reg  [31:0] word_in;
wire [31:0] word_out;

sub_word dut
(
    .word_in(word_in),
    .word_out(word_out)
);

initial
begin

    $vcdplusfile("sub_word.vpd");
    $vcdpluson();

    //------------------------------------------
    // Official AES Example
    //------------------------------------------

    word_in = 32'h09CF4F3C;

    #10;

    $display("--------------------------------");
    $display("Input  = %h",word_in);
    $display("Output = %h",word_out);
    $display("--------------------------------");

    if(word_out == 32'h8A84EB01)
        $display("PASS");
    else
        $display("FAIL");

    #10;

    $finish;

end

endmodule

`default_nettype wire
