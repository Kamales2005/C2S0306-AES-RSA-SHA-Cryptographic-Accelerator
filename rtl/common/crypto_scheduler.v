`timescale 1ns/1ps
`include "crypto_defines.vh"

module crypto_scheduler
(
    input  wire clk,
    input  wire rst_n,

    input  wire start,
    input  wire [3:0] mode,

    input  wire aes_done,
    input  wire sha_done,
    input  wire rsa_done,

    input  wire aes_error,
    input  wire sha_error,
    input  wire rsa_error,

    output reg aes_start,
    output reg sha_start,
    output reg rsa_start,

    output reg busy,
    output reg done,
    output reg error,

    output reg interrupt
);

reg [2:0] state;

localparam IDLE         = 3'd0;
localparam START_ENGINE = 3'd1;
localparam WAIT_DONE    = 3'd2;
localparam COMPLETE     = 3'd3;

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        state <= IDLE;

        aes_start <= 0;
        sha_start <= 0;
        rsa_start <= 0;

        busy <= 0;
        done <= 0;
        error <= 0;
        interrupt <= 0;
    end
    else
    begin

        aes_start <= 0;
        sha_start <= 0;
        rsa_start <= 0;

        done <= 0;
        interrupt <= 0;

        case(state)

        //---------------------------------------------------
        IDLE:
        begin
            busy <= 0;
            error <= 0;

            if(start)
            begin
                busy <= 1;
                state <= START_ENGINE;
            end
        end

        //---------------------------------------------------
        START_ENGINE:
        begin

            case(mode)

            `MODE_AES_ENC,
            `MODE_AES_DEC:
                aes_start <= 1;

            `MODE_SHA256:
                sha_start <= 1;

            `MODE_RSA_ENC,
            `MODE_RSA_DEC,
            `MODE_RSA_SIGN,
            `MODE_RSA_VERIFY:
                rsa_start <= 1;

            default:
                error <= 1;

            endcase

            state <= WAIT_DONE;

        end

        //---------------------------------------------------
        WAIT_DONE:
        begin

            if(aes_done || sha_done || rsa_done)
                state <= COMPLETE;

            if(aes_error || sha_error || rsa_error)
            begin
                error <= 1;
                state <= COMPLETE;
            end

        end

        //---------------------------------------------------
        COMPLETE:
        begin

            busy <= 0;

            done <= 1;

            interrupt <= 1;

            state <= IDLE;

        end

        default:
            state <= IDLE;

        endcase

    end
end

endmodule
