`timescale 1ns/1ps
`default_nettype none

//============================================================
// 32-bit Parallel-In Serial-Out Shift Register
//============================================================

module piso32
(
    input  wire        clk,
    input  wire        rst_n,

    //--------------------------------------------------------
    // Load Parallel Data
    //--------------------------------------------------------
    input  wire        load,
    input  wire [31:0] parallel_in,

    //--------------------------------------------------------
    // Shift Control
    //--------------------------------------------------------
    input  wire        shift_en,

    //--------------------------------------------------------
    // Serial Output
    //--------------------------------------------------------
    output wire        serial_out,

    //--------------------------------------------------------
    // Status
    //--------------------------------------------------------
    output reg         busy,
    output reg         done
);

reg [31:0] shift_reg;
reg [5:0]  bit_count;

//------------------------------------------------------------
// MSB First Output
//------------------------------------------------------------
assign serial_out = shift_reg[31];

//------------------------------------------------------------
// Shift Logic
//------------------------------------------------------------
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        shift_reg <= 32'd0;
        bit_count <= 6'd0;
        busy      <= 1'b0;
        done      <= 1'b0;
    end
    else
    begin
        done <= 1'b0;

        //----------------------------------------------------
        // Load Parallel Data
        //----------------------------------------------------
        if(load)
        begin
            shift_reg <= parallel_in;
            bit_count <= 6'd0;
            busy      <= 1'b1;
        end

        //----------------------------------------------------
        // Shift Data
        //----------------------------------------------------
        else if(shift_en && busy)
        begin
            shift_reg <= {shift_reg[30:0],1'b0};

            if(bit_count == 6'd31)
            begin
                busy      <= 1'b0;
                done      <= 1'b1;
                bit_count <= 6'd0;
            end
            else
            begin
                bit_count <= bit_count + 1'b1;
            end
        end
    end
end

endmodule

`default_nettype wire
