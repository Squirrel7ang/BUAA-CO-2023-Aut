`include "header.v"

/* Centralized Decoding */

module F_CTRL(
    input  [31:0 ]  InsIn,

    output [`CTRL_LEN-1:0] CtrlOut
);

    wire [ 5: 0] op     =  InsIn[31:26];
    wire [ 5: 0] func   =  InsIn[ 5:0 ];

    wire spc    =  (op  ==  `op_spc);
    wire add    =  (op  ==  `op_spc && func ==  `func_add);
    wire sub    =  (op  ==  `op_spc && func ==  `func_sub);
    wire jr     =  (op  ==  `op_spc && func ==  `func_jr );
    wire ori    =  (op  ==  `op_ori);
    wire beq    =  (op  ==  `op_beq);
    wire sw     =  (op  ==  `op_sw );
    wire lw     =  (op  ==  `op_lw );
    wire lui    =  (op  ==  `op_lui);
    wire jal    =  (op  ==  `op_jal);

    wire          MemWrite;
    wire          RegWrite;
    wire          Jr;
    wire          Jump;
	 wire          Branch;
    wire          ExtOp;
    wire          ALUASrc;
    wire          ALUBSrc;
    wire [ 1:0 ]  RegDst;
    wire [ 1:0 ]  RegDataSrc;
    wire [ 1:0 ]  MemType;
    wire [ 2:0 ]  TUseRs;
    wire [ 2:0 ]  TUseRt;
    wire [ 2:0 ]  TNew;
    wire [ 3:0 ]  ALUOp;
    wire [ 3:0 ]  CmpOp;
    
    assign MemWrite     =   sw                       ? 1            : 0;
    assign RegWrite     =   lw  || lui || jal || ori
                         || add || sub               ? 1            : 0;
    assign Jr           =   jr                       ? 1            : 0;
    assign Jump         =   jal                      ? 1            : 0;
    assign Branch       =   beq                      ? 1            : 0;
    assign ExtOp        =   beq || sw  || lw         ? 1            : 0;
    assign ALUASrc      =   `alu_a_rd1;
    assign ALUBSrc      =   sw  || lw  || ori || lui ? 1            : 0;
    assign RegDst       =   add || sub               ? `grf_wa_rd   :
                            jal                      ? `grf_wa_ra   :
                            ori || sw  || lw  || lui ? `grf_wa_rt   :
                                                       `grf_wa_rd;
    assign RegDataSrc   =   add || sub || ori || lui ? `grf_wd_alu  :
                            lw                       ? `grf_wd_mem  :
                            jal                      ? `grf_wd_pc   :
                                                       `grf_wd_alu;
    assign MemType      =   sw  || lw                ? `type_w      :
                                                       `type_w;
    assign TUseRs       =   beq || jr                ? 3'd0         :
                            add || sub || sw  || lw
                         || ori                      ? 3'd1         :
                                                       3'd3; // never gonna be used
    assign TUseRt       =   beq                      ? 3'd0         :
                            add || sub || lui        ? 3'd1         :
                            lw  || sw                ? 3'd2         :
                                                       3'd3; // never gonna be used
    assign TNew         =   lw                       ? 3'd4         : // after DM in W-level
                            lui || add || sub || ori
                         || jal                      ? 3'd3         : // after ALU in E-level
                                                       3'd0; // update quickly so as not to cause pause
    assign ALUOp        =   add || sw  || lw         ? `alu_add     :
                            sub                      ? `alu_sub     :
                            ori                      ? `alu_or      :
                            lui                      ? `alu_lui     :
                                                       `alu_add;
    assign CmpOp        =   beq                      ? `cmp_beq     :
                                                       `cmp_beq;
    /****** Output ******/
    assign CtrlOut = {
        {MemWrite},
        {RegWrite},
        {Jr},
        {Jump},
        {Branch},
        {ExtOp},
        {ALUASrc},
        {ALUBSrc},
        {RegDst},
        {RegDataSrc},
        {MemType},
        {TUseRs},
        {TUseRt},
        {TNew},
        {ALUOp},
        {CmpOp}
    };
endmodule