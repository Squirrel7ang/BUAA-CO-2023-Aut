`include "header.v"

module F_NPC(
    input           Jump,
    input           Jr,
    input           Branch,
    input  [31:0 ]  PC,
    input           Cmp,
    input  [31:0 ]  Ra,
    input           Stall,
	 input           MDStall,
    input  [25:0 ]  Imm26,

    output [31:0 ]  NPC
);
    wire [15:0 ] Imm16 = Imm26[15:0 ];

    assign NPC =    Stall || MDStall ?   PC :
                    Jump    ?   {{PC[31:28]}, Imm26, {2'b00}} :
                    Jr      ?   {Ra[31:0]} : // is this the problem??
                    Branch && Cmp ? PC + {{14{Imm16[15]}}, Imm16, 2'b00} :
                    PC + 4;
endmodule