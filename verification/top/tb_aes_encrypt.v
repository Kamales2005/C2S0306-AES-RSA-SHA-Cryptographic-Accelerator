`timescale 1ns/1ps
`default_nettype none

//============================================================
// Testbench : AES-128 Encryption through APB
//============================================================

module tb_aes_encrypt;

    //--------------------------------------------------------
    // Clock & Reset
    //--------------------------------------------------------

    reg PCLK;
    reg PRESETn;


    //--------------------------------------------------------
    // APB Signals
    //--------------------------------------------------------

    reg         PSEL;
    reg         PENABLE;
    reg         PWRITE;

    reg [31:0]  PADDR;
    reg [31:0]  PWDATA;

    wire [31:0] PRDATA;
    wire        PREADY;
    wire        PSLVERR;


    //--------------------------------------------------------
    // DUT
    //--------------------------------------------------------

    crypto_accelerator_top dut
    (
        .PCLK      (PCLK),
        .PRESETn   (PRESETn),

        .PSEL      (PSEL),
        .PENABLE   (PENABLE),
        .PWRITE    (PWRITE),

        .PADDR     (PADDR),
        .PWDATA    (PWDATA),

        .PRDATA    (PRDATA),
        .PREADY    (PREADY),
        .PSLVERR   (PSLVERR)
    );


    //--------------------------------------------------------
    // Clock
    //--------------------------------------------------------

    initial
    begin
        PCLK = 1'b0;
        forever #5 PCLK = ~PCLK;
    end


    //--------------------------------------------------------
    // Reset
    //--------------------------------------------------------

    initial
    begin
        PRESETn = 1'b0;

        PSEL    = 1'b0;
        PENABLE = 1'b0;
        PWRITE  = 1'b0;

        PADDR   = 32'd0;
        PWDATA  = 32'd0;

        #50;

        PRESETn = 1'b1;
    end



    //--------------------------------------------------------
    // APB WRITE
    //--------------------------------------------------------

    task apb_write;

        input [31:0] addr;
        input [31:0] data;

        begin

            @(posedge PCLK);

            PSEL    <= 1'b1;
            PENABLE <= 1'b0;
            PWRITE  <= 1'b1;

            PADDR   <= addr;
            PWDATA  <= data;


            @(posedge PCLK);

            PENABLE <= 1'b1;


            @(posedge PCLK);

            PSEL    <= 1'b0;
            PENABLE <= 1'b0;
            PWRITE  <= 1'b0;

            PADDR   <= 0;
            PWDATA  <= 0;

        end

    endtask



    //--------------------------------------------------------
    // APB READ
    //--------------------------------------------------------

    task apb_read;

        input  [31:0] addr;
        output [31:0] data;

        begin

            @(posedge PCLK);

            PSEL    <= 1'b1;
            PENABLE <= 1'b0;
            PWRITE  <= 1'b0;

            PADDR   <= addr;


            @(posedge PCLK);

            PENABLE <= 1'b1;


            @(posedge PCLK);

            data = PRDATA;


            PSEL    <= 1'b0;
            PENABLE <= 1'b0;

            PADDR <= 0;

        end

    endtask



    //--------------------------------------------------------
    // Variables
    //--------------------------------------------------------

    reg [31:0] status;

    reg [31:0] result0;
    reg [31:0] result1;
    reg [31:0] result2;
    reg [31:0] result3;



    //--------------------------------------------------------
    // Test Sequence
    //--------------------------------------------------------

    initial
    begin


        @(posedge PRESETn);


        $display("--------------------------------");
        $display(" AES-128 ENCRYPTION TEST ");
        $display("--------------------------------");



        //----------------------------------------------------
        // Load AES Key
        //
        // 000102030405060708090A0B0C0D0E0F
        //----------------------------------------------------

        $display("Loading Key");


        apb_write(32'h10,32'h00010203);
        apb_write(32'h11,32'h04050607);
        apb_write(32'h12,32'h08090A0B);
        apb_write(32'h13,32'h0C0D0E0F);



        //----------------------------------------------------
        // AES Configuration
        //
        // bit0 = encrypt
        // bit1 = key length 128
        //----------------------------------------------------

        apb_write(32'h0A,32'h00000001);



        //----------------------------------------------------
        // Initialize Key Expansion
        //----------------------------------------------------

        $display("Initializing Key");

        apb_write(32'h08,32'h00000001);



        //----------------------------------------------------
        // Wait READY
        //----------------------------------------------------

        status = 0;


        while(status[0] == 0)
        begin
            apb_read(32'h09,status);
        end


        $display("KEY READY");



        //----------------------------------------------------
        // Load Plaintext
        //
        // 00112233445566778899AABBCCDDEEFF
        //----------------------------------------------------

        apb_write(32'h20,32'h00112233);
        apb_write(32'h21,32'h44556677);
        apb_write(32'h22,32'h8899AABB);
        apb_write(32'h23,32'hCCDDEEFF);



        //----------------------------------------------------
        // Start Encryption
        //----------------------------------------------------

        $display("Starting AES");

        apb_write(32'h08,32'h00000002);



        //----------------------------------------------------
        // Wait DONE
        //----------------------------------------------------

        status = 0;


        while(status[1] == 0)
        begin
            apb_read(32'h09,status);
        end


        $display("AES DONE");



        //----------------------------------------------------
        // Read Result
        //----------------------------------------------------

        apb_read(32'h30,result0);
        apb_read(32'h31,result1);
        apb_read(32'h32,result2);
        apb_read(32'h33,result3);



        //----------------------------------------------------
        // Display
        //----------------------------------------------------

        $display("--------------------------------");
        $display("RESULT");
        $display("--------------------------------");

        $display("%08h %08h %08h %08h",
                 result0,
                 result1,
                 result2,
                 result3);



        //----------------------------------------------------
        // Compare
        //----------------------------------------------------

        if((result0 == 32'h69C4E0D8) &&
           (result1 == 32'h6A7B0430) &&
           (result2 == 32'hD8CDB780) &&
           (result3 == 32'h70B4C55A))
        begin

            $display("***********************");
            $display("     AES PASS");
            $display("***********************");

        end

        else
        begin

            $display("***********************");
            $display("     AES FAIL");
            $display("***********************");

            $display("Expected:");
            $display("69C4E0D8 6A7B0430 D8CDB780 70B4C55A");

        end



        #100;

        $finish;


    end


endmodule

`default_nettype wire
