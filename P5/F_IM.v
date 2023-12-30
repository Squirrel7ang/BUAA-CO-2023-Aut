`include "header.v"
`define IM_BEGIN (32'h0c00+32'h0000)
`define IM_END   (32'h0c00+32'h1000)

module F_IM(
    input  [31:0 ]  PC,

    output [31:0 ]  Ins
);

    reg [31:0] im [`IM_BEGIN : `IM_END - 1];

    assign Ins = im[PC[17:2]];

    initial begin
        $readmemh("code.txt", im);
    end

endmodule