`timescale 1ns/1ps
`default_nettype none

module crypto_synth_top
(
    input  wire        PCLK,
    input  wire        PRESETn,

    input  wire        PSEL,
    input  wire        PENABLE,
    input  wire        PWRITE,

    input  wire [7:0]  PADDR,
    input  wire        SER_DATA,
    input  wire        SHIFT_EN,

    output wire        PREADY,
    output wire        PSLVERR,
    output wire        SER_OUT,
    output wire        SHIFT_OUT_EN
);
wire [31:0] PWDATA_INT;
wire [31:0] PRDATA;


wire piso_busy;
wire piso_done;
wire load_piso;

// Add these two lines
wire        word_ready;
wire [5:0]  bit_count;

assign load_piso = PSEL & PENABLE & (~PWRITE) & PREADY;

sipo32 u_sipo
(
    .clk          (PCLK),
    .reset_n      (PRESETn),
    .shift_en     (SHIFT_EN),
    .serial_in    (SER_DATA),
    .parallel_out (PWDATA_INT),
    .word_ready   (word_ready),
    .bit_count    (bit_count)
);

piso32 u_piso
(
    .clk          (PCLK),
    .rst_n(PRESETn),

    .load(load_piso),
    .parallel_in  (PRDATA),

    .shift_en     (SHIFT_EN),

    .serial_out   (SER_OUT),
    .busy         (piso_busy),
    .done         (piso_done)
);

    crypto_accelerator_top u_top
    (
        .PCLK       (PCLK),
        .PRESETn    (PRESETn),

        .PSEL       (PSEL),
        .PENABLE    (PENABLE),
        .PWRITE     (PWRITE),

        .PADDR      ({24'h0,PADDR}),
        .PWDATA     (PWDATA_INT),

        .PRDATA     (PRDATA),
        .PREADY     (PREADY),
        .PSLVERR    (PSLVERR)
    );

assign SHIFT_OUT_EN = piso_busy;




endmodule

`default_nettype wire
