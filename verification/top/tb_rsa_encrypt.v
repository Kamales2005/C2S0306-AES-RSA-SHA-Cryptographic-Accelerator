`timescale 1ns/1ps

module tb_rsa_encrypt;

parameter CLK_PERIOD = 10;


//------------------------------------------------------------
// Signals
//------------------------------------------------------------

reg clk;
reg reset_n;

reg [11:0] tb_address;
reg [31:0] tb_write_data;
reg tb_cs;
reg tb_we;

wire [31:0] tb_read_data;


//------------------------------------------------------------
// DUT
//------------------------------------------------------------

modexp dut
(
    .clk        (clk),
    .reset_n    (reset_n),

    .cs         (tb_cs),
    .we         (tb_we),
    .address    (tb_address),
    .write_data (tb_write_data),
    .read_data  (tb_read_data)
);



//------------------------------------------------------------
// Addresses
//------------------------------------------------------------

localparam GENERAL_PREFIX = 4'h0;

localparam ADDR_CTRL             = 8'h08;
localparam ADDR_STATUS           = 8'h09;

localparam ADDR_MODULUS_LENGTH   = 8'h20;
localparam ADDR_EXPONENT_LENGTH  = 8'h21;

localparam ADDR_MODULUS_PTR_RST  = 8'h30;
localparam ADDR_MODULUS_DATA     = 8'h31;

localparam ADDR_EXPONENT_PTR_RST = 8'h40;
localparam ADDR_EXPONENT_DATA    = 8'h41;

localparam ADDR_MESSAGE_PTR_RST  = 8'h50;
localparam ADDR_MESSAGE_DATA     = 8'h51;

localparam ADDR_RESULT_PTR_RST   = 8'h60;
localparam ADDR_RESULT_DATA      = 8'h61;



//------------------------------------------------------------
// Clock
//------------------------------------------------------------

initial
    clk = 0;

always #(CLK_PERIOD/2)
    clk = ~clk;



//------------------------------------------------------------
// Write task
//------------------------------------------------------------

task write_word(
    input [11:0] addr,
    input [31:0] data
);

begin

    @(negedge clk);

    tb_address = addr;
    tb_write_data = data;

    tb_cs = 1;
    tb_we = 1;


    @(posedge clk);

    #1;

    tb_cs = 0;
    tb_we = 0;

end

endtask



//------------------------------------------------------------
// Read task
//------------------------------------------------------------

task read_word(
    input [11:0] addr
);

begin

    @(negedge clk);

    tb_address = addr;

    tb_cs = 1;
    tb_we = 0;


    @(posedge clk);

    #1;

    tb_cs = 0;

end

endtask



//------------------------------------------------------------
// Wait RSA done
//------------------------------------------------------------

task wait_ready;

integer i;

begin


for(i=0;i<30000;i=i+1)
begin


    read_word(
        {GENERAL_PREFIX,ADDR_STATUS}
    );


    if(i%100==0)
    begin

        $display(
        "Cycle=%0d STATUS=%08x FSM=%h",
        i,
        tb_read_data,
        dut.core_inst.modexp_ctrl_reg
        );

    end



    if(tb_read_data[0])
    begin

        $display("RSA DONE");
        disable wait_ready;

    end


end


$display("RSA TIMEOUT");


end

endtask




//------------------------------------------------------------
// MAIN TEST
//------------------------------------------------------------

initial
begin


tb_address=0;
tb_write_data=0;
tb_cs=0;
tb_we=0;



reset_n=0;

#50;

reset_n=1;

#50;



$display("-----------------------------");
$display(" RSA TEST ");
$display("-----------------------------");



//------------------------------------------------------------
// Message
//------------------------------------------------------------

write_word(
 {GENERAL_PREFIX,ADDR_MESSAGE_PTR_RST},
 32'h00000000
);


write_word(
 {GENERAL_PREFIX,ADDR_MESSAGE_DATA},
 32'h00000041
);



//------------------------------------------------------------
// Exponent
//------------------------------------------------------------

write_word(
 {GENERAL_PREFIX,ADDR_EXPONENT_PTR_RST},
 32'h00000000
);


write_word(
 {GENERAL_PREFIX,ADDR_EXPONENT_DATA},
 32'h00000011
);


write_word(
 {GENERAL_PREFIX,ADDR_EXPONENT_LENGTH},
 32'h00000001
);



//------------------------------------------------------------
// Modulus
//------------------------------------------------------------

write_word(
 {GENERAL_PREFIX,ADDR_MODULUS_PTR_RST},
 32'h00000000
);


write_word(
 {GENERAL_PREFIX,ADDR_MODULUS_DATA},
 32'h00000CA1
);


write_word(
 {GENERAL_PREFIX,ADDR_MODULUS_LENGTH},
 32'h00000001
);



//------------------------------------------------------------
// Memory check
//------------------------------------------------------------

#20;


$display("MESSAGE  = %08x",
dut.core_inst.message_mem.mem[0]);

$display("EXPONENT = %08x",
dut.core_inst.exponent_mem.mem[0]);

$display("MODULUS  = %08x",
dut.core_inst.modulus_mem.mem[0]);



//------------------------------------------------------------
// START
//------------------------------------------------------------

$display("Starting RSA");


write_word(
 {GENERAL_PREFIX,ADDR_CTRL},
 32'h00000001
);



//------------------------------------------------------------
// WAIT
//------------------------------------------------------------

wait_ready();



//------------------------------------------------------------
// Result debug
//------------------------------------------------------------

repeat(10)
@(posedge clk);



$display("--------------------------------");
$display("RESULT MEMORY DEBUG");

$display("RESULT[0]=%08x",
dut.core_inst.result_mem.mem[0]);

$display("RESULT[1]=%08x",
dut.core_inst.result_mem.mem[1]);

$display("--------------------------------");



//------------------------------------------------------------
// Read result through interface
//------------------------------------------------------------

write_word(
 {GENERAL_PREFIX,ADDR_RESULT_PTR_RST},
 32'h00000000
);


repeat(5)
@(posedge clk);



read_word(
 {GENERAL_PREFIX,ADDR_RESULT_DATA}
);



$display("--------------------------------");
$display("RESULT=%08x",
tb_read_data);
$display("--------------------------------");



if(tb_read_data==32'h00000AE6)
begin

    $display("******** PASS ********");

end

else

begin

    $display("******** FAIL ********");

end



$finish;


end


endmodule
