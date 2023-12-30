`include "header.v"
`define IM_BEGIN (32'h0c00+32'h0000)
`define IM_END   (32'h0c00+32'h1000)

module IFU(
    input Clk,
    input Reset,
    input ZF,
    input Branch,
    input Jump,
    input Jr,
    input [15:0 ] Offset16,
    input [25:0 ] Offset26,
    input [31:0 ] Ra,
    
    output [ 5:0 ] Op,
    output [ 4:0 ] Rs,
    output [ 4:0 ] Rt,
    output [ 4:0 ] Rd,
    output [ 4:0 ] Shamt,
    output [ 5:0 ] Func,
    output [15:0 ] Imm16,
    output [25:0 ] Imm26,
    output reg [31:0] PC
);
    reg [31:0] im [`IM_BEGIN : `IM_END - 1];
    
    wire [31:0] ins =   im[PC[17:2]];
    assign Op       =   ins[31:26];
    assign Rs       =   ins[25:21];
    assign Rt       =   ins[20:16];
    assign Rd       =   ins[15:11];
    assign Shamt    =   ins[10:6 ];
    assign Func     =   ins[ 5:0 ];
    assign Imm16    =   ins[15:0 ];
    assign Imm26    =   ins[25:0 ];

    initial begin
        PC <= 32'h0000_3000;
        $readmemh("code.txt", im);
    end

    always @(posedge Clk) begin
        if (Reset) begin
            PC <= 32'h0000_3000;
        end
        else begin
            PC <=   Jump        ?   {{PC[31:28]}, {Offset26}, {2'b00}}              :
                    Branch && ZF?   PC + 4 + {{14{Offset16[15]}}, {Offset16}, 2'b00}:
                    Jr          ?   Ra                                              :
                                    PC + 4;
        end
    end

endmodule