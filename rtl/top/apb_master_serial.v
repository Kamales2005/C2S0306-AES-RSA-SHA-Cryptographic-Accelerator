`timescale 1ns/1ps
`default_nettype none

//============================================================
// APB Master for Serial AES Transactions
//
// Receives 32-bit words from SIPO and automatically performs
// APB writes to crypto_accelerator_top.
//
// Version : AES Only
//============================================================

module apb_master_serial
(
    input  wire        PCLK,
    input  wire        PRESETn,

    //--------------------------------------------------------
    // Control
    //--------------------------------------------------------
    input  wire        start,
    input  wire [3:0]  mode,          //00 = AES

    //--------------------------------------------------------
    // From SIPO
    //--------------------------------------------------------
    input  wire [31:0] parallel_data,
    input  wire        word_ready,

    //--------------------------------------------------------
    // APB Outputs
    //--------------------------------------------------------
    output reg         PSEL,
    output reg         PENABLE,
    output reg         PWRITE,
    output reg [7:0]   PADDR,
    output reg [31:0]  PWDATA,

    //--------------------------------------------------------
    // Status
    //--------------------------------------------------------
    output reg         busy,
    output reg         done
);

    //--------------------------------------------------------
    // FSM States
    //--------------------------------------------------------

 localparam IDLE       = 3'd0;
localparam SHIFT      = 3'd1;
localparam WAIT_WORD  = 3'd2;
localparam APB_SETUP  = 3'd3;
localparam APB_ENABLE = 3'd4;
localparam APB_FINISH = 3'd5;

    reg [2:0] state;

    //--------------------------------------------------------
    // Internal Registers
    //--------------------------------------------------------

    reg [3:0] word_count;
    reg [31:0] data_reg;

    //--------------------------------------------------------
    // AES Address Generator
    //--------------------------------------------------------

function [31:0] aes_addr;

input [3:0] index;

begin

    case(index)

        4'd0 : aes_addr = 32'h00000010;   // KEY0
        4'd1 : aes_addr = 32'h00000011;   // KEY1
        4'd2 : aes_addr = 32'h00000012;   // KEY2
        4'd3 : aes_addr = 32'h00000013;   // KEY3

        4'd4 : aes_addr = 32'h00000020;   // BLOCK0
        4'd5 : aes_addr = 32'h00000021;   // BLOCK1
        4'd6 : aes_addr = 32'h00000022;   // BLOCK2
        4'd7 : aes_addr = 32'h00000023;   // BLOCK3

        4'd8 : aes_addr = 32'h00000008;   // REG_MODE

        4'd9 : aes_addr = 32'h00000000;   // REG_CONTROL

        default : aes_addr = 32'h00000000;

    endcase

end

endfunction

    //--------------------------------------------------------
    // FSM
    //--------------------------------------------------------

    always @(posedge PCLK or negedge PRESETn)
    begin

        if(!PRESETn)
        begin

            state      <= IDLE;

            PSEL       <= 1'b0;
            PENABLE    <= 1'b0;
            PWRITE     <= 1'b1;

            PADDR      <= 8'h00;
            PWDATA     <= 32'h00000000;

            busy       <= 1'b0;
            done       <= 1'b0;

            word_count <= 4'd0;
            data_reg   <= 32'h00000000;

        end

        else
        begin

            done <= 1'b0;

done <= 1'b0;



case(state)

//------------------------------------------------
// IDLE
//------------------------------------------------            //------------------------------------------------
            // IDLE
            //------------------------------------------------

            IDLE:
            begin

                PSEL    <= 1'b0;
                PENABLE <= 1'b0;
                busy    <= 1'b0;

                if(start && (mode==4'd1))
                begin

                    word_count <= 4'd0;

                    busy <= 1'b1;

                    state <= WAIT_WORD;

                end

            end

            //------------------------------------------------
            // WAIT FOR NEXT SERIAL WORD
            //------------------------------------------------

            WAIT_WORD:
            begin

                if(word_ready)
                begin

                    data_reg <= parallel_data;

                    state <= APB_SETUP;

                end

            end

            //------------------------------------------------
            // APB SETUP
            //------------------------------------------------

            APB_SETUP:
            begin

                PSEL    <= 1'b1;
                PENABLE <= 1'b0;
                PWRITE  <= 1'b1;

             
               PADDR <= aes_addr(word_count);

case(word_count)

    4'd8:
        PWDATA <= 32'h00000001;   // AES Encrypt

    4'd9:
        PWDATA <= 32'h00000001;   // START bit

    default:
        PWDATA <= data_reg;

endcase



state <= APB_ENABLE;
end
           
//------------------------------------------------
// APB ENABLE
//------------------------------------------------

APB_ENABLE:
begin

    PSEL    <= 1'b1;
    PENABLE <= 1'b1;
    PWRITE  <= 1'b1;

    if(word_count == 4'd9)
    begin
        busy <= 1'b0;
        done <= 1'b1;
    end
    else
    begin
        word_count <= word_count + 1'b1;
    end

    state <= APB_FINISH;

end

//------------------------------------------------
// APB FINISH
//------------------------------------------------

APB_FINISH:
begin

    PSEL    <= 1'b0;
    PENABLE <= 1'b0;
    PWRITE  <= 1'b0;

    if(done)
        state <= IDLE;
    else
        state <= WAIT_WORD;

end

default:
begin
    state <= IDLE;
end

endcase

end

end

endmodule

`default_nettype wire