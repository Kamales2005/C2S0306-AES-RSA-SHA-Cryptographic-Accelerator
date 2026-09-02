`timescale 1ns/1ps
`default_nettype none

//============================================================
// Module : apb_to_secworks_aes
// Description : APB Register Interface to Secworks AES Adapter
//============================================================

module apb_to_secworks_aes
(
    //--------------------------------------------------------
    // Interface from APB Slave
    //--------------------------------------------------------

    input  wire         reg_write,
    input  wire         reg_read,
    input  wire [31:0]  reg_addr,
    input  wire [31:0]  reg_wdata,
    input wire aes_cs,

    output wire [31:0]  reg_rdata,

    //--------------------------------------------------------
    // Interface to Secworks AES
    //--------------------------------------------------------

   
    output wire         aes_we,
    output wire [7:0]   aes_address,
    output wire [31:0]  aes_write_data,

    input  wire [31:0]  aes_read_data
);

    //--------------------------------------------------------
    // APB Read/Write -> AES Control
    //--------------------------------------------------------

   

    // Write Enable
    assign aes_we = reg_write;

    // AES uses only 8-bit addresses
    assign aes_address = reg_addr[7:0];

    // Write Data
    assign aes_write_data = reg_wdata;

    // Read Data
    assign reg_rdata = aes_read_data;

endmodule

`default_nettype wire
