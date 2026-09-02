`timescale 1ns/1ps

module tb_crypto_synth_top;

reg         PCLK;
reg         PRESETn;

reg         PSEL;
reg         PENABLE;
reg         PWRITE;
reg  [7:0]  PADDR;
integer i;
integer timeout;

reg         SER_DATA;
reg         SHIFT_EN;
reg [31:0] rdata;
reg [31:0] aes_result [0:3];
reg [31:0] sha_result [0:7];
reg [31:0] rsa_result;

wire [31:0] PRDATA;
wire        PREADY;
wire        PSLVERR;
wire        SER_OUT;
wire        SHIFT_OUT_EN;

//---------------------------------------------------------
// DUT
//---------------------------------------------------------

C2S0306 dut
(
    .main_clk_pad     (PCLK),
    .PRESETn_pad      (PRESETn),

    .PSEL_pad         (PSEL),
    .PENABLE_pad      (PENABLE),
    .PWRITE_pad       (PWRITE),
    .PADDR_pad        (PADDR),

    .SER_DATA_pad     (SER_DATA),
    .SHIFT_EN_pad     (SHIFT_EN),

    .PREADY_pad       (PREADY),
    .PSLVERR_pad      (PSLVERR),

    .SER_OUT_pad      (SER_OUT),
    .SHIFT_OUT_EN_pad (SHIFT_OUT_EN)
);

//---------------------------------------------------------
// Waveform Dump
//---------------------------------------------------------
initial begin
    $dumpfile("crypto_synth_top.vcd");
    $dumpvars(0, tb_crypto_synth_top);
end

//---------------------------------------------------------
// Monitor
//---------------------------------------------------------
initial begin
    $monitor("[%0t] SHIFT_EN=%b SER_DATA=%b SER_OUT=%b PSEL=%b PENABLE=%b PWRITE=%b PADDR=%h PRDATA=%h PREADY=%b",
             $time,
             SHIFT_EN,
             SER_DATA,
             SER_OUT,
             PSEL,
             PENABLE,
             PWRITE,
             PADDR,
             PRDATA,
             PREADY);
end


//---------------------------------------------------------
// Clock
//---------------------------------------------------------
initial begin
    PCLK = 0;
    forever #5 PCLK = ~PCLK;
end

//---------------------------------------------------------
// Reset
//---------------------------------------------------------
initial begin
    PRESETn  = 0;

    PSEL     = 0;
    PENABLE  = 0;
    PWRITE   = 0;
    PADDR    = 8'h00;

    SER_DATA = 0;
    SHIFT_EN = 0;

    #50;
    PRESETn = 1;
end

//---------------------------------------------------------
// Shift 32-bit word (MSB first)
//---------------------------------------------------------
task shift32;
input [31:0] data;
integer i;
begin
    $display("[%0t] Shifting %h", $time, data);

    for(i=31;i>=0;i=i-1)
    begin
        @(posedge PCLK);
        SHIFT_EN = 1'b1;
        SER_DATA = data[i];
    end

    @(posedge PCLK);
    SHIFT_EN = 0;
    SER_DATA = 0;

    repeat(2) @(posedge PCLK);
end
endtask

//---------------------------------------------------------
// APB Write
//---------------------------------------------------------
task apb_write;
input [7:0] addr;
begin
    @(posedge PCLK);
    PADDR   = addr;
    PWRITE  = 1;
    PSEL    = 1;
    PENABLE = 0;

    @(posedge PCLK);
    PENABLE = 1;

    @(posedge PCLK);
    PSEL    = 0;
    PENABLE = 0;
    PWRITE  = 0;
end
endtask


task apb_read;
input  [7:0] addr;
output [31:0] data;
begin
    @(posedge PCLK);
    PADDR   = addr;
    PWRITE  = 0;
    PSEL    = 1;
    PENABLE = 0;

    @(posedge PCLK);
    PENABLE = 1;

    @(posedge PCLK);
    data = PRDATA;

    $display("[%0t] APB READ  ADDR=%02h DATA=%08h",
             $time, addr, data);

    PSEL    = 0;
    PENABLE = 0;

    @(posedge PCLK);
end
endtask


//---------------------------------------------------------
// Test
//---------------------------------------------------------
initial begin

    wait(PRESETn);

    repeat(5) @(posedge PCLK);

    $display("========================================");
$display("      AES ENCRYPTION TEST");
$display("========================================");

//----------------------------------------------------
// CONFIG
//----------------------------------------------------
shift32(32'h00000000);
apb_write(8'h0A);

//----------------------------------------------------
// KEY (128-bit)
//----------------------------------------------------
shift32(32'h00010203); apb_write(8'h10);
shift32(32'h04050607); apb_write(8'h11);
shift32(32'h08090A0B); apb_write(8'h12);
shift32(32'h0C0D0E0F); apb_write(8'h13);

shift32(32'h00000000); apb_write(8'h14);
shift32(32'h00000000); apb_write(8'h15);
shift32(32'h00000000); apb_write(8'h16);
shift32(32'h00000000); apb_write(8'h17);

//----------------------------------------------------
// INIT
//----------------------------------------------------
shift32(32'h00000001);
apb_write(8'h08);

repeat(20) @(posedge PCLK);

//----------------------------------------------------
// PLAINTEXT
//----------------------------------------------------
shift32(32'h00112233); apb_write(8'h20);
shift32(32'h44556677); apb_write(8'h21);
shift32(32'h8899AABB); apb_write(8'h22);
shift32(32'hCCDDEEFF); apb_write(8'h23);

//----------------------------------------------------
// START ENCRYPTION
//----------------------------------------------------
shift32(32'h00000002);
apb_write(8'h08);

repeat(100) @(posedge PCLK);

//----------------------------------------------------
// READ RESULT
//----------------------------------------------------
apb_read(8'h30,aes_result[0]);
apb_read(8'h31,aes_result[1]);
apb_read(8'h32,aes_result[2]);
apb_read(8'h33,aes_result[3]);

$display("\nAES Ciphertext");
$display("%08h",aes_result[0]);
$display("%08h",aes_result[1]);
$display("%08h",aes_result[2]);
$display("%08h",aes_result[3]);
 //----------------------------------------------------
// SHA256 TEST
//----------------------------------------------------

$display("\n========================================");
$display("         SHA256 TEST");
$display("========================================");

// BLOCK0
$display("SHA BLOCK0");
shift32(32'h61626380); apb_write(8'h50);

// BLOCK1-14
shift32(32'h00000000); apb_write(8'h51);
shift32(32'h00000000); apb_write(8'h52);
shift32(32'h00000000); apb_write(8'h53);
shift32(32'h00000000); apb_write(8'h54);
shift32(32'h00000000); apb_write(8'h55);
shift32(32'h00000000); apb_write(8'h56);
shift32(32'h00000000); apb_write(8'h57);
shift32(32'h00000000); apb_write(8'h58);
shift32(32'h00000000); apb_write(8'h59);
shift32(32'h00000000); apb_write(8'h5A);
shift32(32'h00000000); apb_write(8'h5B);
shift32(32'h00000000); apb_write(8'h5C);
shift32(32'h00000000); apb_write(8'h5D);
shift32(32'h00000000); apb_write(8'h5E);

// BLOCK15
shift32(32'h00000018); apb_write(8'h5F);

// START SHA
$display("SHA INIT");
shift32(32'h00000005);
apb_write(8'h48);

repeat(250) @(posedge PCLK);

$display("SHA DIGEST");

apb_read(8'h60,sha_result[0]);
apb_read(8'h61,sha_result[1]);
apb_read(8'h62,sha_result[2]);
apb_read(8'h63,sha_result[3]);
apb_read(8'h64,sha_result[4]);
apb_read(8'h65,sha_result[5]);
apb_read(8'h66,sha_result[6]);
apb_read(8'h67,sha_result[7]);

$display("\nSHA256 Digest");
for(i=0;i<8;i=i+1)
    $display("%08h",sha_result[i]);
//---------------------------------------------------------
// RSA TEST (3^7 mod 11 = 9)
//---------------------------------------------------------


$display("\n======================================");
$display("RSA TEST");
$display("======================================");

//---------------------------------------------------------
// Reset pointers
//---------------------------------------------------------
shift32(32'h00000000);
apb_write(8'hD0);      // MESSAGE_PTR_RST

shift32(32'h00000000);
apb_write(8'hC0);      // EXPONENT_PTR_RST

shift32(32'h00000000);
apb_write(8'hB0);      // MODULUS_PTR_RST

//---------------------------------------------------------
// Load Message = 3
//---------------------------------------------------------
shift32(32'h00000003);
apb_write(8'hD1);

//---------------------------------------------------------
// Load Exponent = 7
//---------------------------------------------------------
shift32(32'h00000007);
apb_write(8'hC1);

// Exponent length = 1 word
shift32(32'h00000001);
apb_write(8'hA1);

//---------------------------------------------------------
// Load Modulus = 11
//---------------------------------------------------------
shift32(32'h0000000B);
apb_write(8'hB1);

// Modulus length = 1 word
shift32(32'h00000001);
apb_write(8'hA0);

//---------------------------------------------------------
// Start RSA
//---------------------------------------------------------
shift32(32'h00000001);
apb_write(8'h88);

//---------------------------------------------------------
// Poll until RSA completes
//---------------------------------------------------------
$display("\nPolling RSA STATUS...");

rdata   = 32'h00000000;
timeout = 0;

while ((rdata != 32'h00000001) && (timeout < 10000))
begin
    apb_read(8'h89, rdata);

    $display("[%0t] STATUS = %08h", $time, rdata);

    if (rdata != 32'h00000001)
    begin
        repeat (100) @(posedge PCLK);
        timeout = timeout + 1;
    end
end

if (timeout == 10000)
begin
    $display("\n******** RSA TIMEOUT ********");
    $finish;
end

//---------------------------------------------------------
// Reset Result Pointer
//---------------------------------------------------------
shift32(32'h00000000);
apb_write(8'hE0);

//---------------------------------------------------------
// Read RSA Result
//---------------------------------------------------------
$display("\n======================================");
$display("RSA RESULT");
$display("======================================");

apb_read(8'hE1, rsa_result);

$display("\nRSA RESULT = %08h", rsa_result);

if (rsa_result == 32'h00000009)
    $display("******** RSA PASS ********");
else
    $display("******** RSA FAIL ********");

#100;
$finish;
end

//---------------------------------------------------------
// Internal Debug
//---------------------------------------------------------
initial begin
    $display("\n============= INTERNAL SIGNALS =============");
    $display("Watching internal APB/SIPO/PISO signals...");
end

always @(posedge PCLK)
begin

    if (dut.SHIFT_OUT_EN)
        $display("[%0t] SER_OUT = %b", $time, dut.SER_OUT);
end



endmodule
