`timescale 1ns/1ps
`default_nettype none

module tb_register_file;

//--------------------------------------------------
// Clock & Reset
//--------------------------------------------------

reg clk;
reg rst_n;

//--------------------------------------------------
// APB Register Interface
//--------------------------------------------------

reg         reg_write;
reg         reg_read;
reg [31:0]  reg_addr;
reg [31:0]  reg_wdata;

wire [31:0] reg_rdata;

//--------------------------------------------------
// AES Interface
//--------------------------------------------------

reg          aes_busy;
reg          aes_done;
reg          aes_error;
reg [127:0]  aes_ciphertext;

//--------------------------------------------------
// Outputs
//--------------------------------------------------

wire [31:0] control;
wire [31:0] mode;

wire [127:0] aes_key;
wire [127:0] aes_data_in;


//--------------------------------------------------
// DUT
//--------------------------------------------------

register_file dut
(
    .clk(clk),
    .rst_n(rst_n),

    .reg_write(reg_write),
    .reg_read(reg_read),
    .reg_addr(reg_addr),
    .reg_wdata(reg_wdata),

    .reg_rdata(reg_rdata),

    .aes_busy(aes_busy),
    .aes_done(aes_done),
    .aes_error(aes_error),

    .aes_ciphertext(aes_ciphertext),

    .control(control),
    .mode(mode),

    .aes_key(aes_key),
    .aes_data_in(aes_data_in)
);


//--------------------------------------------------
// Clock
//--------------------------------------------------

always #5 clk = ~clk;
initial
begin

    $vcdplusfile("register_file.vpd");
    $vcdpluson();

    clk = 0;
    rst_n = 0;

    reg_write = 0;
    reg_read  = 0;
    reg_addr  = 0;
    reg_wdata = 0;

    aes_busy = 0;
    aes_done = 0;
    aes_error = 0;

    aes_ciphertext = 128'd0;

    //------------------------------------
    // Reset
    //------------------------------------

    #20;

    rst_n = 1;

    #20;
    //------------------------------------------------
    // Write CONTROL
    //------------------------------------------------

    @(posedge clk);

    reg_write <= 1;
    reg_addr  <= ADDR_CONTROL;
    reg_wdata <= 32'h00000001;

    @(posedge clk);

    reg_write <= 0;
    //------------------------------------------------
    // AES KEY
    //------------------------------------------------

    @(posedge clk);

    reg_write <= 1;
    reg_addr <= ADDR_AES_KEY0;
    reg_wdata <= 32'h11111111;

    @(posedge clk);

    reg_addr <= ADDR_AES_KEY1;
    reg_wdata <= 32'h22222222;

    @(posedge clk);

    reg_addr <= ADDR_AES_KEY2;
    reg_wdata <= 32'h33333333;

    @(posedge clk);

    reg_addr <= ADDR_AES_KEY3;
    reg_wdata <= 32'h44444444;

    @(posedge clk);

    reg_write <= 0;
    //------------------------------------------------
    // Plaintext
    //------------------------------------------------

    @(posedge clk);

    reg_write <= 1;
    reg_addr <= ADDR_DATA_IN0;
    reg_wdata <= 32'hAAAAAAAA;

    @(posedge clk);

    reg_addr <= ADDR_DATA_IN1;
    reg_wdata <= 32'hBBBBBBBB;

    @(posedge clk);

    reg_addr <= ADDR_DATA_IN2;
    reg_wdata <= 32'hCCCCCCCC;

    @(posedge clk);

    reg_addr <= ADDR_DATA_IN3;
    reg_wdata <= 32'hDDDDDDDD;

    @(posedge clk);

    reg_write <= 0;
    //------------------------------------------------
    // AES Finished
    //------------------------------------------------

    @(posedge clk);

    aes_busy <= 1;

    @(posedge clk);

    aes_busy <= 0;

    aes_done <= 1;

    aes_ciphertext <=
    {
        32'h12345678,
        32'h87654321,
        32'hABCDEF12,
        32'h55AA55AA
    };

    @(posedge clk);

    aes_done <= 0;
    //------------------------------------------------
    // Read DATA_OUT0
    //------------------------------------------------

    @(posedge clk);

    reg_read <= 1;
    reg_addr <= ADDR_DATA_OUT0;

    @(posedge clk);

    reg_addr <= ADDR_DATA_OUT1;

    @(posedge clk);

    reg_addr <= ADDR_DATA_OUT2;

    @(posedge clk);

    reg_addr <= ADDR_DATA_OUT3;

    @(posedge clk);

    reg_read <= 0;

    #50;

    $finish;

end

endmodule

`default_nettype wire

