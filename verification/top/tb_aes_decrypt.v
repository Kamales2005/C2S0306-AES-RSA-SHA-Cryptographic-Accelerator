`timescale 1ns/1ps
`default_nettype none

module tb_aes_decrypt;

    //--------------------------------------------------------
    // Clock and Reset
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
        PCLK = 0;
        forever #5 PCLK = ~PCLK;
    end


    //--------------------------------------------------------
    // Reset
    //--------------------------------------------------------

    initial
    begin
        PRESETn = 0;

        PSEL    = 0;
        PENABLE = 0;
        PWRITE  = 0;

        PADDR   = 0;
        PWDATA  = 0;

        #50;

        PRESETn = 1;
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

            PADDR <= addr;


            @(posedge PCLK);

            PENABLE <= 1'b1;


            @(posedge PCLK);

            data = PRDATA;


            PSEL    <= 1'b0;
            PENABLE <= 1'b0;
            PADDR   <= 0;

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
    // Debug monitor
    //--------------------------------------------------------

    initial
    begin

        $display("--------------------------------");
        $display(" APB AES DEBUG ENABLED ");
        $display("--------------------------------");

/*
        $monitor(
        "T=%0t CS=%b WE=%b ADDR=%02h WDATA=%08h RDATA=%08h",
        $time,
        dut.u_adapter.aes_cs,
        dut.u_adapter.aes_we,
        dut.u_adapter.aes_address,
        dut.u_adapter.aes_write_data,
        dut.u_adapter.aes_read_data
        );
*/
    end



    //--------------------------------------------------------
    // Test
    //--------------------------------------------------------

    initial
    begin


        @(posedge PRESETn);


        $display("--------------------------------");
        $display(" AES-128 DECRYPTION TEST ");
        $display("--------------------------------");



        //----------------------------------------------------
        // Load AES Key
        // 000102030405060708090A0B0C0D0E0F
        //----------------------------------------------------

        $display("Loading Key");


        apb_write(32'h10,32'h00010203);
        apb_write(32'h11,32'h04050607);
        apb_write(32'h12,32'h08090A0B);
        apb_write(32'h13,32'h0C0D0E0F);



        //----------------------------------------------------
        // Set Decrypt Mode
        // ENCDEC = 0
        // KEYLEN = 0
        //----------------------------------------------------

        apb_write(
            32'h08,
            32'h00000000
        );



        //----------------------------------------------------
        // Initialize Key Expansion
        //----------------------------------------------------

        $display("Initializing Key");


        apb_write(
            32'h08,
            32'h00000001
        );



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
        // Load Ciphertext
        //
        // 69C4E0D86A7B0430D8CDB78070B4C55A
        //----------------------------------------------------


        apb_write(32'h20,32'h69C4E0D8);
        apb_write(32'h21,32'h6A7B0430);
        apb_write(32'h22,32'hD8CDB780);
        apb_write(32'h23,32'h70B4C55A);



        //----------------------------------------------------
        // Start Decryption
        //----------------------------------------------------

        $display("Starting AES Decryption");


        apb_write(
            32'h08,
            32'h00000002
        );



        //----------------------------------------------------
        // Wait DONE
        //----------------------------------------------------

        status = 0;


        while(status[1] == 0)
        begin
            apb_read(32'h09,status);
        end


        $display("AES DECRYPT DONE");



        //----------------------------------------------------
        // Read Plaintext
        //----------------------------------------------------

        apb_read(32'h30,result0);
        apb_read(32'h31,result1);
        apb_read(32'h32,result2);
        apb_read(32'h33,result3);



        //----------------------------------------------------
        // Display
        //----------------------------------------------------

        $display("");
        $display("--------------------------------");
        $display("RESULT");
        $display("--------------------------------");

        $display("%08h %08h %08h %08h",
        result0,
        result1,
        result2,
        result3);



        //----------------------------------------------------
        // Check
        //----------------------------------------------------


        if(
          (result0 == 32'h00112233) &&
          (result1 == 32'h44556677) &&
          (result2 == 32'h8899AABB) &&
          (result3 == 32'hCCDDEEFF)
          )

        begin

            $display("");
            $display("***********************");
            $display(" AES DECRYPT PASS ");
            $display("***********************");

        end

        else

        begin

            $display("");
            $display("***********************");
            $display(" AES DECRYPT FAIL ");
            $display("***********************");

            $display("Expected:");
            $display("00112233 44556677 8899AABB CCDDEEFF");

            $display("Received:");
            $display("%08h %08h %08h %08h",
            result0,
            result1,
            result2,
            result3);

        end


        #100;

        $finish;


    end


endmodule

`default_nettype wire
