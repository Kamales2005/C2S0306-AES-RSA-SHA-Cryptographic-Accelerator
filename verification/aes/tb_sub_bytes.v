`timescale 1ns/1ps

module tb_sub_bytes;

reg  [127:0] state_in;
wire [127:0] state_out;

sub_bytes DUT(
    .state_in(state_in),
    .state_out(state_out)
);

initial begin

    state_in = 128'h00112233445566778899AABBCCDDEEFF;

    #10;

    $display("Input  = %h",state_in);
    $display("Output = %h",state_out);

    $finish;

end

endmodule
