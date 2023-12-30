`include "header.v"

module CTRL (
    input [5:0] Op,
    input [5:0] Func,

    output MemWrite,
    output RegWrite,
    output Jr,
    output Jump,
	output Branch,
    // output Link,
    output ExtOp,
    output ALUSrc,
    output [3:0] ALUOp,
    output [1:0] RegDst,
    output [1:0] RegDataSrc,
    output [1:0] MemType
);
    wire add    =  (Op  ==  `op_spc && Func ==  `func_add);
    wire sub    =  (Op  ==  `op_spc && Func ==  `func_sub);
    wire jr     =  (Op  ==  `op_spc && Func ==  `func_jr );
    wire ori    =  (Op  ==  `op_ori);
    wire beq    =  (Op  ==  `op_beq);
    wire sw     =  (Op  ==  `op_sw );
    wire lw     =  (Op  ==  `op_lw );
    wire lui    =  (Op  ==  `op_lui);
    wire jal    =  (Op  ==  `op_jal);
    assign MemWrite =   sw                  ? 1         : 0;
    assign RegWrite =   lw  || lui || jal 
                     || ori || add || sub   ? 1         : 0;

    assign Jr       =   jr                  ? 1         : 0;
    assign Jump     =   jal                 ? 1         : 0;
	assign Branch   =   beq                 ? 1         : 0;
    assign ExtOp    =   beq || sw  || lw    ? 1         : 0;
    assign ALUSrc   =   sw  || lw  || ori
                     || lui              	? 1         : 0;
    assign ALUOp    =   add || sw  || lw    ? `alu_add  :
                        sub || beq          ? `alu_sub  :
                        ori                 ? `alu_or   :
                        lui                 ? `alu_lui  :
                                              `alu_add;
    assign RegDst   =   add || sub          ? `a3_rd    :
                        jal                 ? `a3_ra    :
                        ori || sw  || lw
                     || lui                 ? `a3_rt    :
                                              `a3_rd;
    assign RegDataSrc = add || sub || ori 
                     || lui                 ? `wd_alu   :
                        lw                  ? `wd_mem   :
                        jal                 ? `wd_pc    :
                                              `wd_alu;
    assign MemType  =   sw  || lw           ? `type_w  :
                                              `type_w;

endmodule