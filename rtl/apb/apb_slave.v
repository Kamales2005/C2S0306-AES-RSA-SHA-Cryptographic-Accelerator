`timescale 1ns/1ps
`default_nettype none

module apb_slave
(
    input  wire         PCLK,
    input  wire         PRESETn,

    input  wire         PSEL,
    input  wire         PENABLE,
    input  wire         PWRITE,

    input  wire [31:0]  PADDR,
    input  wire [31:0]  PWDATA,

    output wire  [31:0]  PRDATA,
    output wire         PREADY,
    output wire         PSLVERR,

    //----------------------------------------------------
    // Register File Interface
    //----------------------------------------------------
    output wire         reg_write,
    output wire         reg_read,
    output wire [31:0]  reg_addr,
    output wire [31:0]  reg_wdata,

    input  wire [31:0]  reg_rdata
);

assign PREADY  = 1'b1;
assign PSLVERR = 1'b0;

assign reg_write = PSEL & PENABLE & PWRITE;
assign reg_read  = PSEL & PENABLE & (~PWRITE);

assign reg_addr  = PADDR;
assign reg_wdata = PWDATA;

assign PRDATA = reg_rdata;

always @(posedge PCLK)
begin
    if (reg_read)
    begin
       
    end
end
always @(posedge PCLK)
begin
   
end

endmodule

`default_nettype wire
