`timescale 1ns/1ps

module tb_crypto_accelerator;

reg         PCLK;
reg         PRESETn;

reg         SER_DATA;
reg         SHIFT_EN;

reg         START;
reg [3:0] MODE;

wire        BUSY;
wire        DONE;

wire [31:0] PRDATA;
wire        PREADY;
wire        PSLVERR;

//---------------------------------------------------------
// DUT
//---------------------------------------------------------
crypto_synth_top dut
(
    .PCLK      (PCLK),
    .PRESETn   (PRESETn),

    .SER_DATA  (SER_DATA),
    .SHIFT_EN  (SHIFT_EN),

    .START     (START),
    .MODE      (MODE),

    .BUSY      (BUSY),
    .DONE      (DONE),

    .PRDATA    (PRDATA),
    .PREADY    (PREADY),
    .PSLVERR   (PSLVERR)
);

//---------------------------------------------------------
// Clock
//---------------------------------------------------------
initial
begin
    PCLK = 0;
    forever #5 PCLK = ~PCLK;
end

//---------------------------------------------------------
// Reset
//---------------------------------------------------------
initial
begin
    PRESETn  = 0;

    SER_DATA = 0;
    SHIFT_EN = 0;

    START    = 0;
    MODE     = 3'd0;

    #50;
    PRESETn = 1;
end

//---------------------------------------------------------
// Shift one 32-bit word serially (MSB first)
//---------------------------------------------------------
task shift32;
input [31:0] data;
integer i;
begin
    $display("[%0t] Shifting %h", $time, data);

    for(i=31;i>=0;i=i-1)
    begin
        @(posedge PCLK);
        SHIFT_EN <= 1'b1;
        SER_DATA <= data[i];
    end

    @(posedge PCLK);
    SHIFT_EN <= 1'b0;
    SER_DATA <= 1'b0;

    // Give SIPO/APB master time to detect word_ready
    repeat(5) @(posedge PCLK);
end
endtask

//---------------------------------------------------------
// Start AES operation
//---------------------------------------------------------
task start_aes;
begin
    @(posedge PCLK);
    MODE <= 4'd1;    // AES Encrypt     // AES Encrypt
    START <= 1'b1;

    @(posedge PCLK);
    START <= 1'b0;

    $display("[%0t] AES START asserted", $time);
end
endtask

//---------------------------------------------------------
// Wait until accelerator becomes busy
//---------------------------------------------------------
task wait_busy;
begin
    while(BUSY == 1'b0)
        @(posedge PCLK);

    $display("[%0t] Accelerator BUSY", $time);
end
endtask

//---------------------------------------------------------
// Wait until operation completes
//---------------------------------------------------------
task wait_done;
begin
    while(DONE == 1'b0)
        @(posedge PCLK);

    $display("[%0t] Accelerator DONE", $time);

    repeat(10) @(posedge PCLK);
end
endtask

//---------------------------------------------------------
// Test Vectors
//---------------------------------------------------------
localparam [31:0] KEY0 = 32'h00010203;
localparam [31:0] KEY1 = 32'h04050607;
localparam [31:0] KEY2 = 32'h08090A0B;
localparam [31:0] KEY3 = 32'h0C0D0E0F;

localparam [31:0] TXT0 = 32'h00112233;
localparam [31:0] TXT1 = 32'h44556677;
localparam [31:0] TXT2 = 32'h8899AABB;
localparam [31:0] TXT3 = 32'hCCDDEEFF;

localparam [31:0] CONFIG = 32'h00000001;
localparam [31:0] GO     = 32'h00000001;

//---------------------------------------------------------
// Main Test
//---------------------------------------------------------
initial
begin

    //-----------------------------------------------------
    // Wait for reset
    //-----------------------------------------------------
    wait(PRESETn);

    repeat(5) @(posedge PCLK);

    $display("\n======================================");
    $display("      CRYPTO SERIAL INTERFACE TEST");
    $display("======================================");

    //-----------------------------------------------------
    // Select AES mode
    //-----------------------------------------------------
    start_aes();

    //-----------------------------------------------------
    // Send AES Key
    //-----------------------------------------------------
    shift32(KEY0);
    shift32(KEY1);
    shift32(KEY2);
    shift32(KEY3);

    //-----------------------------------------------------
    // Send Plaintext
    //-----------------------------------------------------
    shift32(TXT0);
    shift32(TXT1);
    shift32(TXT2);
    shift32(TXT3);

    //-----------------------------------------------------
    // Configuration
    //-----------------------------------------------------
    shift32(CONFIG);

    //-----------------------------------------------------
    // GO Command
    //-----------------------------------------------------
    shift32(GO);

    //-----------------------------------------------------
    // Wait for accelerator
    //-----------------------------------------------------
    wait_busy();
    wait_done();

    //-----------------------------------------------------
    // Results
    //-----------------------------------------------------
    $display("\n======================================");
    $display("Simulation Finished");
    $display("DONE    = %0d", DONE);
    $display("BUSY    = %0d", BUSY);
    $display("PRDATA  = %h", PRDATA);
    $display("PSLVERR = %0d", PSLVERR);
    $display("======================================");

    #100;

    $finish;

end

endmodule
