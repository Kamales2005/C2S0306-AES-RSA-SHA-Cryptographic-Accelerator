`timescale 1ns/1ps
`include "crypto_defines.vh"

module register_bank
(
    input  wire                         clk,
    input  wire                         rst_n,

    input  wire                         reg_write,
    input  wire                         reg_read,

    input  wire [`APB_ADDR_WIDTH-1:0]   reg_addr,
    input  wire [`APB_DATA_WIDTH-1:0]   reg_wdata,

    output reg  [`APB_DATA_WIDTH-1:0]   reg_rdata,

    output reg                          start,
    output reg  [3:0]                   mode,

    input  wire                         busy,
    input  wire                         done,
    input  wire                         error
);

reg [31:0] control_reg;

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        control_reg <= 32'd0;
        mode        <= 4'd0;
        start       <= 1'b0;
    end
    else
    begin
        // Default: start is a pulse
        start <= 1'b0;

        if(reg_write)
        begin
            case(reg_addr)

                `REG_CONTROL:
                begin
                    control_reg <= reg_wdata;

                    if(reg_wdata[`CTRL_START_BIT])
                        start <= 1'b1;
                end

                `REG_MODE:
                begin
                    mode <= reg_wdata[3:0];
                end

                default:
                begin
                end

            endcase
        end
    end
end

always @(*)
begin
    reg_rdata = 32'd0;

    if(reg_read)
    begin
        case(reg_addr)

            `REG_CONTROL:
                reg_rdata = control_reg;

            `REG_STATUS:
            begin
                reg_rdata[0] = busy;
                reg_rdata[1] = done;
                reg_rdata[2] = error;
            end

            `REG_MODE:
                reg_rdata = {28'd0, mode};

            default:
                reg_rdata = 32'd0;

        endcase
    end
end

endmodule
