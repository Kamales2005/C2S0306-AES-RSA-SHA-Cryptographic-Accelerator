`timescale 1ns/1ps
`default_nettype none

module tb_rcon;

reg [3:0] round;
wire [31:0] rcon_out;

rcon dut
(
    .round(round),
    .rcon_out(rcon_out)
);

integer i;

initial begin

    $vcdplusfile("rcon.vpd");
    $vcdpluson();

    for(i=1;i<=10;i=i+1)
    begin
        round = i;
        #10;
        $display("Round=%0d  RCON=%h",round,rcon_out);
    end

    #10;
    $finish;

end

endmodule

`default_nettype wire
