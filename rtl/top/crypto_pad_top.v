`timescale 1ns/1ps
`default_nettype none

module C2S0306
(
    main_clk_pad,

    PRESETn_pad,

    PSEL_pad,
    PENABLE_pad,
    PWRITE_pad,

    PADDR_pad,

    SER_DATA_pad,
    SHIFT_EN_pad,

    PREADY_pad,
    PSLVERR_pad,
    SER_OUT_pad,
    SHIFT_OUT_EN_pad
);

//=========================================================
// Port Declaration
//=========================================================

input main_clk_pad;

input PRESETn_pad;

input PSEL_pad;
input PENABLE_pad;
input PWRITE_pad;

input [7:0] PADDR_pad;

input SER_DATA_pad;
input SHIFT_EN_pad;

output PREADY_pad;
output PSLVERR_pad;
output SER_OUT_pad;
output SHIFT_OUT_EN_pad;


//=========================================================
// Internal Signals
//=========================================================

wire PCLK;

wire PRESETn;

wire PSEL;
wire PENABLE;
wire PWRITE;

wire [7:0] PADDR;

wire SER_DATA;
wire SHIFT_EN;

wire PREADY;
wire PSLVERR;
wire SER_OUT;
wire SHIFT_OUT_EN;

wire crypto_clk;


//=========================================================
// Clock Pad
//=========================================================

pc3c01 pc3c01_1
(
    .CCLK (crypto_clk),
    .CP   (PCLK)
);

pc3d01 pc3d01_1
(
    .PAD (main_clk_pad),
    .CIN (crypto_clk)
);


//=========================================================
// Input Pads
//=========================================================

// PRESETn
pc3d01 pc3d01_2
(
    .PAD (PRESETn_pad),
    .CIN (PRESETn)
);

// PSEL
pc3d01 pc3d01_3
(
    .PAD (PSEL_pad),
    .CIN (PSEL)
);

// PENABLE
pc3d01 pc3d01_4
(
    .PAD (PENABLE_pad),
    .CIN (PENABLE)
);

// PWRITE
pc3d01 pc3d01_5
(
    .PAD (PWRITE_pad),
    .CIN (PWRITE)
);

// SER_DATA
pc3d01 pc3d01_6
(
    .PAD (SER_DATA_pad),
    .CIN (SER_DATA)
);

// SHIFT_EN
pc3d01 pc3d01_7
(
    .PAD (SHIFT_EN_pad),
    .CIN (SHIFT_EN)
);


//=========================================================
// PADDR Input Pads
//=========================================================

// PADDR[0]
pc3d01 pc3d01_8
(
    .PAD (PADDR_pad[0]),
    .CIN (PADDR[0])
);

// PADDR[1]
pc3d01 pc3d01_9
(
    .PAD (PADDR_pad[1]),
    .CIN (PADDR[1])
);

// PADDR[2]
pc3d01 pc3d01_10
(
    .PAD (PADDR_pad[2]),
    .CIN (PADDR[2])
);

// PADDR[3]
pc3d01 pc3d01_11
(
    .PAD (PADDR_pad[3]),
    .CIN (PADDR[3])
);

// PADDR[4]
pc3d01 pc3d01_12
(
    .PAD (PADDR_pad[4]),
    .CIN (PADDR[4])
);

// PADDR[5]
pc3d01 pc3d01_13
(
    .PAD (PADDR_pad[5]),
    .CIN (PADDR[5])
);

// PADDR[6]
pc3d01 pc3d01_14
(
    .PAD (PADDR_pad[6]),
    .CIN (PADDR[6])
);

// PADDR[7]
pc3d01 pc3d01_15
(
    .PAD (PADDR_pad[7]),
    .CIN (PADDR[7])
);
//=========================================================
// PREADY Output Pad
//=========================================================

pc3o05 pc3o05_1
(
    .I   (PREADY),
    .PAD (PREADY_pad)
);


//=========================================================
// PSLVERR Output Pad
//=========================================================

pc3o05 pc3o05_2
(
    .I   (PSLVERR),
    .PAD (PSLVERR_pad)
);


//=========================================================
// SER_OUT Output Pad
//=========================================================

pc3o05 pc3o05_3
(
    .I   (SER_OUT),
    .PAD (SER_OUT_pad)
);


//=========================================================
// SHIFT_OUT_EN Output Pad
//=========================================================

pc3o05 pc3o05_4
(
    .I   (SHIFT_OUT_EN),
    .PAD (SHIFT_OUT_EN_pad)
);


//=========================================================
// Crypto Accelerator Core
//=========================================================

crypto_synth_top u_crypto_synth_top
(
    .PCLK          (PCLK),
    .PRESETn       (PRESETn),

    .PSEL          (PSEL),
    .PENABLE       (PENABLE),
    .PWRITE        (PWRITE),

    .PADDR         (PADDR),

    .SER_DATA      (SER_DATA),
    .SHIFT_EN      (SHIFT_EN),

    .PREADY        (PREADY),
    .PSLVERR       (PSLVERR),
    .SER_OUT       (SER_OUT),
    .SHIFT_OUT_EN  (SHIFT_OUT_EN)
);

endmodule

`default_nettype wire
