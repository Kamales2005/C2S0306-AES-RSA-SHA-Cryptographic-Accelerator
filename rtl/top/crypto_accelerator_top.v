`timescale 1ns/1ps
`default_nettype none

//============================================================
// Module : crypto_accelerator_top
// Description : APB based AES + SHA256 + RSA Accelerator
//============================================================

module crypto_accelerator_top
(
    input  wire         PCLK,
    input  wire         PRESETn,

    input  wire         PSEL,
    input  wire         PENABLE,
    input  wire         PWRITE,

    input  wire [31:0]  PADDR,
    input  wire [31:0]  PWDATA,

    output wire [31:0]  PRDATA,
    output wire         PREADY,
    output wire         PSLVERR
);


    //--------------------------------------------------------
    // APB Internal Signals
    //--------------------------------------------------------

    wire        reg_write;
    wire        reg_read;

    wire [31:0] reg_addr;
    wire [31:0] reg_wdata;

    wire [31:0] reg_rdata;


    //--------------------------------------------------------
    // Decoder Signals
    //--------------------------------------------------------

    wire aes_cs;
    wire sha_cs;
    wire rsa_cs;


    //--------------------------------------------------------
    // AES Signals
    //--------------------------------------------------------

    wire        aes_we;
    wire [7:0]  aes_address;
    wire [31:0] aes_write_data;

    wire [31:0] aes_core_read_data;
    wire [31:0] aes_reg_rdata;


    //--------------------------------------------------------
    // SHA Signals
    //--------------------------------------------------------

    wire        sha_we;
    wire [7:0]  sha_address;
    wire [31:0] sha_write_data;

    wire [31:0] sha_core_read_data;
    wire [31:0] sha_reg_rdata;


    //--------------------------------------------------------
    // RSA Signals
    //--------------------------------------------------------

    wire        rsa_we;
    wire [11:0] rsa_address;
    wire [31:0] rsa_write_data;

    wire [31:0] rsa_core_read_data;
    wire [31:0] rsa_reg_rdata;



    //--------------------------------------------------------
    // APB Slave
    //--------------------------------------------------------

    apb_slave u_apb_slave
    (
        .PCLK       (PCLK),
        .PRESETn    (PRESETn),

        .PSEL       (PSEL),
        .PENABLE    (PENABLE),
        .PWRITE     (PWRITE),

        .PADDR      (PADDR),
        .PWDATA     (PWDATA),

        .PRDATA     (PRDATA),
        .PREADY     (PREADY),
        .PSLVERR    (PSLVERR),

        .reg_write  (reg_write),
        .reg_read   (reg_read),

        .reg_addr   (reg_addr),
        .reg_wdata  (reg_wdata),

        .reg_rdata  (reg_rdata)
    );



    //--------------------------------------------------------
    // Address Decoder
    //--------------------------------------------------------

    crypto_decoder u_decoder
    (
        .cs         (reg_write | reg_read),
        .we         (reg_write),
        .address    (reg_addr[7:0]),

        .aes_cs     (aes_cs),
        .sha_cs     (sha_cs),
        .rsa_cs     (rsa_cs)
    );



    //--------------------------------------------------------
    // AES Adapter
    //--------------------------------------------------------

    apb_to_secworks_aes u_aes_adapter
    (
        
        .reg_write      (reg_write & aes_cs),
        .reg_read       (reg_read  & aes_cs),

        .reg_addr       (reg_addr),
        .reg_wdata      (reg_wdata),

        .aes_cs         (aes_cs),

        .reg_rdata      (aes_reg_rdata),

        .aes_we         (aes_we),
        .aes_address    (aes_address),
        .aes_write_data (aes_write_data),

        .aes_read_data  (aes_core_read_data)
    );



    //--------------------------------------------------------
    // SHA Adapter
    //--------------------------------------------------------

    apb_to_secworks_sha256 u_sha_adapter
    (
        .reg_write      (reg_write & sha_cs),
        .reg_read       (reg_read  & sha_cs),

        .reg_addr       (reg_addr),
        .reg_wdata      (reg_wdata),

        .sha_cs         (sha_cs),

        .reg_rdata      (sha_reg_rdata),

        .sha_we         (sha_we),
        .sha_address    (sha_address),

        .sha_write_data (sha_write_data),

        .sha_read_data  (sha_core_read_data)
    );



    //--------------------------------------------------------
    // RSA Adapter
    //--------------------------------------------------------

    apb_to_secworks_rsa u_rsa_adapter
    (
        .clk(PCLK),
        .reset_n(PRESETn),
        .reg_write      (reg_write & rsa_cs),
        .reg_read       (reg_read  & rsa_cs),

        .reg_addr       (reg_addr),
        .reg_wdata      (reg_wdata),

        .rsa_cs         (rsa_cs),

        .reg_rdata      (rsa_reg_rdata),

        .rsa_we         (rsa_we),

        .rsa_address    (rsa_address),

        .rsa_write_data (rsa_write_data),

        .rsa_read_data  (rsa_core_read_data)
    );



    //--------------------------------------------------------
    // AES Core
    //--------------------------------------------------------

    aes u_aes
    (
        .clk        (PCLK),
        .reset_n    (PRESETn),

        .cs         (aes_cs),
        .we         (aes_we),

        .address    (aes_address),

        .write_data (aes_write_data),

        .read_data  (aes_core_read_data)
    );



    //--------------------------------------------------------
    // SHA256 Core
    //--------------------------------------------------------

    sha256 u_sha256
    (
        .clk        (PCLK),
        .reset_n    (PRESETn),

        .cs         (sha_cs),
        .we         (sha_we),

        .address    (sha_address),

        .write_data (sha_write_data),

        .read_data  (sha_core_read_data),

        .error      ()
    );



    //--------------------------------------------------------
    // RSA Core
    //--------------------------------------------------------

    modexp u_rsa
    (
        .clk        (PCLK),
        .reset_n    (PRESETn),

        .cs         (rsa_cs),
        .we         (rsa_we),

        .address    (rsa_address),

        .write_data (rsa_write_data),

        .read_data  (rsa_core_read_data)
    );



    always @(*) begin
end

assign reg_rdata =
        (reg_addr[7:0] < 8'h40) ? aes_reg_rdata :
        (reg_addr[7:0] < 8'h80) ? sha_reg_rdata :
                                  rsa_reg_rdata;
endmodule


`default_nettype wire
