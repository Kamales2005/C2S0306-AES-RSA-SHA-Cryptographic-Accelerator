`timescale 1ns/1ps
`default_nettype none

module tb_sbox;

reg [7:0] data_in;
wire [7:0] data_out;

sbox dut(
    .data_in(data_in),
    .data_out(data_out)
);

initial begin

    $vcdplusfile("sbox.vpd");
    $vcdpluson();

    data_in = 8'h00;
    #10;

    data_in = 8'h53;
    #10;

    data_in = 8'hFF;
    #10;

    $finish;

end

initial
    $monitor("Time=%0t IN=%h OUT=%h",
              $time,data_in,data_out);

endmodule

`default_nettype wire
