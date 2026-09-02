`timescale 1ns/1ps
`default_nettype none

module crypto_decoder
(
    input  wire       cs,
    input  wire       we,
    input  wire [7:0] address,

    output wire       aes_cs,
    output wire       sha_cs,
    output wire       rsa_cs
);

assign aes_cs = cs && (address < 8'h40);
assign sha_cs = cs && (address >= 8'h40) && (address < 8'h80);
assign rsa_cs = cs && (address >= 8'h80);

always @(*) begin

end

endmodule

`default_nettype wire
