`timescale 1ns/1ps
`default_nettype none

//============================================================
// Module : apb_to_secworks_sha256
// Description : APB Register Interface to Secworks SHA256
//============================================================

module apb_to_secworks_sha256
(
    //--------------------------------------------------------
    // APB Register Interface
    //--------------------------------------------------------

    input  wire         reg_write,
    input  wire         reg_read,

    input  wire [31:0]  reg_addr,
    input  wire [31:0]  reg_wdata,
    input wire sha_cs,
    
    output wire [31:0]  reg_rdata,


    //--------------------------------------------------------
    // Secworks SHA256 Interface
    //--------------------------------------------------------

    
    output wire         sha_we,

    output wire [7:0]   sha_address,

    output wire [31:0]  sha_write_data,

    input  wire [31:0]  sha_read_data
);

    //--------------------------------------------------------
    // APB -> SHA256 Control
    //--------------------------------------------------------



    assign sha_we = reg_write;


    //--------------------------------------------------------
    // Address Translation
    //
    // APB Map:
    // 0x40 - 0x7F
    //
    // SHA Core:
    // 0x00 - 0x3F
    //--------------------------------------------------------

    assign sha_address = reg_addr[7:0] - 8'h40;


    //--------------------------------------------------------
    // Write Data
    //--------------------------------------------------------

    assign sha_write_data = reg_wdata;


    //--------------------------------------------------------
    // Read Data
    //--------------------------------------------------------

    assign reg_rdata = sha_read_data;

endmodule

`default_nettype wire
