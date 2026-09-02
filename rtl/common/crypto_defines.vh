//============================================================
// Crypto Accelerator Global Definitions
//============================================================

`ifndef CRYPTO_DEFINES_VH
`define CRYPTO_DEFINES_VH

//------------------------------------------------------------
// Bus Widths
//------------------------------------------------------------
`define APB_ADDR_WIDTH      16
`define APB_DATA_WIDTH      32

//------------------------------------------------------------
// AES Parameters
//------------------------------------------------------------
`define AES_BLOCK_WIDTH     128
`define AES_KEY_WIDTH       128
`define AES_ROUNDS          10

//------------------------------------------------------------
// SHA Parameters
//------------------------------------------------------------
`define SHA_BLOCK_WIDTH     512
`define SHA_HASH_WIDTH      256

//------------------------------------------------------------
// RSA Parameters
//------------------------------------------------------------
`define RSA_KEY_WIDTH       2048
`define RSA_EXP_WIDTH       2048

//------------------------------------------------------------
// Mode Register
//------------------------------------------------------------
`define MODE_IDLE           4'd0
`define MODE_AES_ENC        4'd1
`define MODE_AES_DEC        4'd2
`define MODE_SHA256         4'd3
`define MODE_RSA_ENC        4'd4
`define MODE_RSA_DEC        4'd5
`define MODE_RSA_SIGN       4'd6
`define MODE_RSA_VERIFY     4'd7

//------------------------------------------------------------
// Register Addresses
//------------------------------------------------------------
`define REG_CONTROL         16'h0000
`define REG_STATUS          16'h0004
`define REG_MODE            16'h0008
`define REG_KEY_BASE        16'h0010
`define REG_INPUT_BASE      16'h0100
`define REG_OUTPUT_BASE     16'h0200
`define REG_INT_STATUS      16'h0300

//------------------------------------------------------------
// Control Register Bits
//------------------------------------------------------------
`define CTRL_START_BIT      0
`define CTRL_SOFTRESET_BIT  1

//------------------------------------------------------------
// Status Register Bits
//------------------------------------------------------------
`define STATUS_BUSY_BIT     0
`define STATUS_DONE_BIT     1
`define STATUS_ERROR_BIT    2

`endif
