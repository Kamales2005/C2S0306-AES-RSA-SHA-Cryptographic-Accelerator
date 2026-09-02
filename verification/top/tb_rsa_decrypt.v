`timescale 1ns/1ps

module tb_rsa_decrypt;

reg PCLK;
reg PRESETn;


// APB signals
reg         PSEL;
reg         PENABLE;
reg         PWRITE;

reg [31:0]  PADDR;
reg [31:0]  PWDATA;

wire [31:0] PRDATA;
wire        PREADY;
wire        PSLVERR;


// DUT
crypto_accelerator_top dut
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
    .PSLVERR(PSLVERR)
);



always #5 PCLK = ~PCLK;



//------------------------------------------------
// APB WRITE
//------------------------------------------------

task apb_write;

input [31:0] addr;
input [31:0] data;

begin

    @(posedge PCLK);

    PSEL    = 1'b1;
    PENABLE = 1'b0;
    PWRITE  = 1'b1;

    PADDR   = addr;
    PWDATA  = data;


    @(posedge PCLK);

    PENABLE = 1'b1;


    @(posedge PCLK);

    PSEL    = 1'b0;
    PENABLE = 1'b0;
    PWRITE  = 1'b0;


end

endtask



//------------------------------------------------
// APB READ
//------------------------------------------------

// -----------------------------
// APB READ
// -----------------------------
task apb_read;

input  [31:0] addr;
output [31:0] data;

begin

    @(posedge PCLK);

    PSEL    = 1;
    PENABLE = 0;
    PWRITE  = 0;
    PADDR   = addr;

    @(posedge PCLK);

    PENABLE = 1;

    @(posedge PCLK);

    #1;

    data = PRDATA;

    $display("--------------------------------");
    $display("READ ADDR=%h DATA=%h", addr, data);
    $display("--------------------------------");

    PSEL    = 0;
    PENABLE = 0;
    PWRITE  = 0;

end

endtask

integer i;

reg [31:0] result;



initial
begin


PCLK = 0;

PRESETn = 0;


PSEL = 0;
PENABLE = 0;
PWRITE = 0;

PADDR = 0;
PWDATA = 0;


#50;

PRESETn = 1;



$display("--------------------------------");
$display(" RSA DECRYPT TEST START ");
$display("--------------------------------");



//================================================
// RSA INPUT SETUP
//
// ciphertext = 0xae6
// private key d = 1
// modulus n = 0x1001
//
// RSA map:
// CTRL       80+08 = 88
// MOD LEN    80+20 = a0
// EXP LEN    80+21 = a1
// MOD DATA   80+31 = b1
// EXP DATA   80+41 = c1
// MSG DATA   80+51 = d1
// RESULT     80+61 = e1
//================================================



// modulus length = 1 word
apb_write(
32'hA0,
32'h00000001
);


// exponent length = 1 word
apb_write(
32'hA1,
32'h00000001
);



//-------------------------------
// Write modulus
//-------------------------------

apb_write(
32'hB0,
32'h00000000
);


apb_write(
32'hB1,
32'h00001001
);



//-------------------------------
// Write exponent d
//-------------------------------

apb_write(
32'hC0,
32'h00000000
);


apb_write(
32'hC1,
32'h00000001
);



//-------------------------------
// Write ciphertext
//-------------------------------

apb_write(
32'hD0,
32'h00000000
);


apb_write(
32'hD1,
32'h00000ae6
);




//-------------------------------
// START RSA
//-------------------------------

$display("Starting RSA decrypt");


apb_write(
32'h88,
32'h00000001
);




$display("Waiting RSA calculation...");



// wait enough cycles
repeat(25000)
begin
    @(posedge PCLK);
end




//-------------------------------
// Read result
//-------------------------------

//-------------------------------
// Read result
//-------------------------------


apb_read(32'hE1, result);


$display("--------------------------------");
$display("RSA DECRYPT RESULT = %h",result);
$display("--------------------------------");



if(result == 32'h00000ae6)
begin

    $display("***********************");
    $display(" RSA DECRYPT PASS ");
    $display("***********************");

end

else

begin

    $display("***********************");
    $display(" RSA DECRYPT FAIL ");
    $display("***********************");

end



#100;

$finish;


end


endmodule
