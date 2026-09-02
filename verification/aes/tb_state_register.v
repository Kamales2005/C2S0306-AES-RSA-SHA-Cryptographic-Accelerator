`timescale 1ns/1ps
`default_nettype none

module tb_state_register;

    reg         clk;
    reg         rst_n;
    reg         load;
    reg         enable;
    reg [127:0] state_in;

    wire [127:0] state_out;

    //--------------------------------------
    // DUT
    //--------------------------------------
    state_register dut (
        .clk      (clk),
        .rst_n    (rst_n),
        .load     (load),
        .enable   (enable),
        .state_in (state_in),
        .state_out(state_out)
    );

    //--------------------------------------
    // Clock Generation
    //--------------------------------------
    always #5 clk = ~clk;

    //--------------------------------------
    // Waveform Dump
    //--------------------------------------
    initial begin
        $vcdplusfile("state_register.vpd");
        $vcdpluson();
    end

    //--------------------------------------
    // Monitor
    //--------------------------------------
    initial begin
        $monitor("T=%0t rst=%b load=%b enable=%b state_out=%h",
                 $time, rst_n, load, enable, state_out);
    end

    //--------------------------------------
    // Test Sequence
    //--------------------------------------
    initial begin

        clk      = 0;
        rst_n    = 0;
        load     = 0;
        enable   = 0;
        state_in = 128'd0;

        //--------------------------
        // Reset
        //--------------------------
        #20;
        rst_n = 1;

        //--------------------------
        // Load Plaintext
        //--------------------------
        state_in = 128'h00112233445566778899AABBCCDDEEFF;
        load = 1;
        #10;
        load = 0;

        //--------------------------
        // Hold Value
        //--------------------------
        #20;

        //--------------------------
        // Update State
        //--------------------------
        state_in = 128'hFFEEDDCCBBAA99887766554433221100;
        enable = 1;
        #10;
        enable = 0;

        //--------------------------
        // Hold Again
        //--------------------------
        #30;

        $finish;

    end

endmodule

`default_nettype wire
