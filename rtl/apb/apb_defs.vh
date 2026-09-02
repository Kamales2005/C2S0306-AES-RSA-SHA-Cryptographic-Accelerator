`ifndef APB_DEFS_VH
`define APB_DEFS_VH

//==============================================================
// APB Register Address Map
//==============================================================

//--------------------------------------------------------------
// Control Registers
//--------------------------------------------------------------

localparam ADDR_CONTROL     = 32'h00000000;
localparam ADDR_STATUS      = 32'h00000004;
localparam ADDR_MODE        = 32'h00000008;
localparam ADDR_IRQ_EN      = 32'h0000000C;
localparam ADDR_IRQ_STATUS  = 32'h00000010;


//--------------------------------------------------------------
// AES Register Space
//--------------------------------------------------------------

localparam ADDR_AES_KEY0    = 32'h00000020;
localparam ADDR_AES_KEY1    = 32'h00000024;
localparam ADDR_AES_KEY2    = 32'h00000028;
localparam ADDR_AES_KEY3    = 32'h0000002C;

localparam ADDR_DATA_IN0    = 32'h00000030;
localparam ADDR_DATA_IN1    = 32'h00000034;
localparam ADDR_DATA_IN2    = 32'h00000038;
localparam ADDR_DATA_IN3    = 32'h0000003C;

localparam ADDR_DATA_OUT0   = 32'h00000040;
localparam ADDR_DATA_OUT1   = 32'h00000044;
localparam ADDR_DATA_OUT2   = 32'h00000048;
localparam ADDR_DATA_OUT3   = 32'h0000004C;


//--------------------------------------------------------------
// Reserved Address Space
//--------------------------------------------------------------

localparam ADDR_RSA_BASE    = 32'h00000100;
localparam ADDR_SHA_BASE    = 32'h00000200;


//==============================================================
// CONTROL Register Bit Definitions
//==============================================================

localparam CTRL_START_BIT      = 0;
localparam CTRL_RESET_BIT      = 1;
localparam CTRL_IRQ_CLR_BIT    = 2;


//==============================================================
// STATUS Register Bit Definitions
//==============================================================

localparam STATUS_BUSY_BIT     = 0;
localparam STATUS_DONE_BIT     = 1;
localparam STATUS_ERROR_BIT    = 2;
localparam STATUS_IRQ_BIT      = 3;


//==============================================================
// MODE Register Definitions
//==============================================================

localparam MODE_AES            = 2'b00;
localparam MODE_RSA            = 2'b01;
localparam MODE_SHA            = 2'b10;


//==============================================================
// IRQ STATUS Bits
//==============================================================

localparam IRQ_AES_DONE        = 0;
localparam IRQ_RSA_DONE        = 1;
localparam IRQ_SHA_DONE        = 2;

`endif
