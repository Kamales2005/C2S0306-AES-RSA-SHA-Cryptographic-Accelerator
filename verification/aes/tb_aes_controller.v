`timescale 1ns/1ps
`default_nettype none

module tb_aes_controller;

reg clk;
reg rst_n;

reg start;
reg key_ready;
reg last_round;

wire busy;
wire done;

wire load_state;
wire key_expand_start;

wire counter_load;
wire counter_enable;

wire round_enable;
wire final_round;

//-----------------------------------------
// DUT
//-----------------------------------------
aes_controller dut
(
    .clk(clk),
    .rst_n(rst_n),

    .start(start),

    .key_ready(key_ready),

    .last_round(last_round),

    .busy(busy),
    .done(done),

    .load_state(load_state),

    .key_expand_start(key_expand_start),

    .counter_load(counter_load),
    .counter_enable(counter_enable),

    .round_enable(round_enable),

    .final_round(final_round)
);

//-----------------------------------------
// Clock
//-----------------------------------------
always #5 clk = ~clk;

//-----------------------------------------
// Waveform
//-----------------------------------------
initial begin
    $vcdplusfile("aes_controller.vpd");
    $vcdpluson();
end;

//-----------------------------------------
// Monitor
//-----------------------------------------
initial begin
    $monitor(
    "T=%0t START=%b KEY_RDY=%b LAST=%b BUSY=%b DONE=%b LOAD=%b KEY_EXP=%b CNT_LOAD=%b CNT_EN=%b ROUND_EN=%b FINAL=%b",
    $time,
    start,
    key_ready,
    last_round,
    busy,
    done,
    load_state,
    key_expand_start,
    counter_load,
    counter_enable,
    round_enable,
    final_round
    );
end;

//-----------------------------------------
// Stimulus
//-----------------------------------------
initial begin

    clk = 0;

    rst_n = 0;

    start = 0;
    key_ready = 0;
    last_round = 0;

    //-------------------------------------
    // Reset
    //-------------------------------------
    #20;

    rst_n = 1;

    //-------------------------------------
    // Start Encryption
    //-------------------------------------
    #20;

    start = 1;

    #10;

    start = 0;

    //-------------------------------------
    // Key Expansion Complete
    //-------------------------------------
    #40;

    key_ready = 1;

    #10;

    key_ready = 0;

    //-------------------------------------
    // Final Round
    //-------------------------------------
    #80;

    last_round = 1;

    #10;

    last_round = 0;

    //-------------------------------------
    // Finish
    //-------------------------------------
    #50;

    $finish;

end;

endmodule

`default_nettype wire
