`timescale 1ns/1ps
`default_nettype none

//============================================================
// Module : apb_to_secworks_rsa
// Description : APB Register Interface to Secworks RSA Adapter
//============================================================

module apb_to_secworks_rsa
(
    //--------------------------------------------------------
    // Clock / Reset
    //--------------------------------------------------------

    input  wire         clk,
    input  wire         reset_n,


    //--------------------------------------------------------
    // APB Register Interface
    //--------------------------------------------------------

    input  wire         reg_write,
    input  wire         reg_read,

    input  wire [31:0]  reg_addr,
    input  wire [31:0]  reg_wdata,

    input  wire         rsa_cs,

    output wire [31:0]  reg_rdata,


    //--------------------------------------------------------
    // Secworks RSA Interface
    //--------------------------------------------------------

    output wire         rsa_we,

    output wire [11:0]  rsa_address,

    output wire [31:0]  rsa_write_data,

    input  wire [31:0]  rsa_read_data
);



    //--------------------------------------------------------
    // APB -> RSA write control
    //--------------------------------------------------------

    assign rsa_we = reg_write & rsa_cs;



    //--------------------------------------------------------
    // Address translation
    //
    // APB:
    // 0x80 - 0xFF
    //
    // RSA:
    // 0x00 - 0x7F
    //--------------------------------------------------------

    assign rsa_address = reg_addr[11:0] - 12'h080;



    //--------------------------------------------------------
// Write data
//--------------------------------------------------------

assign rsa_write_data = reg_wdata;


//--------------------------------------------------------
// Read data
//--------------------------------------------------------

assign reg_rdata = rsa_read_data;


//--------------------------------------------------------
// Debug
//--------------------------------------------------------
//--------------------------------------------------------
// Read data
//--------------------------------------------------------

assign reg_rdata = rsa_read_data;


//--------------------------------------------------------
// Debug
//--------------------------------------------------------
always @(posedge clk)
begin
    if (rsa_we)
        $display("[%0t] RSA WRITE  ADDR=%03h DATA=%08h",
                 $time,
                 rsa_address,
                 rsa_write_data);

    if (reg_read && rsa_cs)
        $display("[%0t] RSA READ   ADDR=%03h DATA=%08h",
                 $time,
                 rsa_address,
                 rsa_read_data);
end

endmodule

`default_nettype wire
