`timescale 1ns/1ps
`default_nettype none

//============================================================
// Module : sipo32
// Description : 32-bit Serial-In Parallel-Out Register
//               - MSB First
//               - Generates one-cycle word_ready pulse
//               - Counts received bits
//============================================================

module sipo32
(
    input  wire        clk,
    input  wire        reset_n,

    input  wire        shift_en,
    input  wire        serial_in,

    output reg [31:0]  parallel_out,

    output reg         word_ready,
    output reg [5:0]   bit_count
);

reg [31:0] shift_reg;

always @(posedge clk or negedge reset_n)
begin
    if (!reset_n)
    begin
        shift_reg    <= 32'h00000000;
        parallel_out <= 32'h00000000;
        bit_count    <= 6'd0;
        word_ready   <= 1'b0;
    end
    else
    begin

        //----------------------------------------------------
        // Default
        //----------------------------------------------------
        word_ready <= 1'b0;

        //----------------------------------------------------
        // Shift Serial Data
        //----------------------------------------------------
        if (shift_en)
        begin

            // MSB First
            shift_reg <= {shift_reg[30:0], serial_in};

            //------------------------------------------------
            // 32 bits received
            //------------------------------------------------
            if (bit_count == 6'd31)
            begin
                parallel_out <= {shift_reg[30:0], serial_in};

                bit_count  <= 6'd0;

                word_ready <= 1'b1;
            end
            else
            begin
                bit_count <= bit_count + 6'd1;
            end

        end

    end

end

endmodule

`default_nettype wire