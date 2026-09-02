`timescale 1ns/1ps
`default_nettype none

module tb_apb_slave;

reg         PCLK;
reg         PRESETn;
reg         PSEL;
reg         PENABLE;
reg         PWRITE;
reg [31:0]  PADDR;
reg [31:0]  PWDATA;

wire [31:0] PRDATA;
wire        PREADY;
wire        PSLVERR;

wire        reg_write;
wire        reg_read;
wire [31:0] reg_addr;
wire [31:0] reg_wdata;

reg [31:0] reg_rdata;

apb_slave dut
(
    .PCLK(PCLK),
    .PRESETn(PRESETn),

    .PSEL(PSEL),
    .PENABLE(PENABLE),
    .PWRITE(PWRITE),

    .PADDR(PADDR),
    .PWDATA(PWDATA),

    .PRDATA(PRDATA),
    .PREADY(PREADY),
    .PSLVERR(PSLVERR),

    .reg_write(reg_write),
    .reg_read(reg_read),
    .reg_addr(reg_addr),
    .reg_wdata(reg_wdata),

    .reg_rdata(reg_rdata)
);

always #5 PCLK = ~PCLK;

initial begin

    $vcdplusfile("apb_slave.vpd");
    $vcdpluson();

    PCLK     = 0;
    PRESETn  = 0;
    PSEL     = 0;
    PENABLE  = 0;
    PWRITE   = 0;
    PADDR    = 0;
    PWDATA   = 0;
    reg_rdata = 32'hA5A5A5A5;

    #20;
    PRESETn = 1;

    //-------------------------------------------------
    // Write Transaction
    //-------------------------------------------------
    @(posedge PCLK);
    PSEL    <= 1;
    PWRITE  <= 1;
    PADDR   <= 32'h20;
    PWDATA  <= 32'h12345678;

    @(posedge PCLK);
    PENABLE <= 1;

    @(posedge PCLK);
    PSEL     <= 0;
    PENABLE  <= 0;
    PWRITE   <= 0;

    //-------------------------------------------------
    // Read Transaction
    //-------------------------------------------------
    @(posedge PCLK);
    PSEL   <= 1;
    PWRITE <= 0;
    PADDR  <= 32'h20;

    @(posedge PCLK);
    PENABLE <= 1;

    @(posedge PCLK);
    PSEL    <= 0;
    PENABLE <= 0;

    #20;

    $finish;

end

endmodule

`default_nettype wire
