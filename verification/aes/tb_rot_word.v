`timescale 1ns/1ps
`default_nettype none

module tb_rot_word;

reg  [31:0] word_in;
wire [31:0] word_out;

rot_word dut
(
    .word_in(word_in),
    .word_out(word_out)
);

initial begin

    $vcdplusfile("rot_word.vpd");
    $vcdpluson();

    //----------------------------------------
    // Test 1
    //----------------------------------------
    word_in = 32'h12345678;
    #10;

    if(word_out == 32'h34567812)
        $display("TEST1 PASS");
    else
        $display("TEST1 FAIL");

    //----------------------------------------
    // Test 2
    //----------------------------------------
    word_in = 32'h09CF4F3C;
    #10;

    if(word_out == 32'hCF4F3C09)
        $display("TEST2 PASS");
    else
        $display("TEST2 FAIL");

    //----------------------------------------
    // Test 3
    //----------------------------------------
    word_in = 32'hFFFFFFFF;
    #10;

    if(word_out == 32'hFFFFFFFF)
        $display("TEST3 PASS");
    else
        $display("TEST3 FAIL");

    $finish;

end;

initial begin
    $monitor("Time=%0t IN=%h OUT=%h",
              $time, word_in, word_out);
end

endmodule

`default_nettype wire
