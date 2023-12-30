`include "header.v"

/* Centralized Decoding */

module F_CTRL(
    input  [31:0 ]  InsIn,

    output [`CTRL_LEN-1:0] CtrlOut
);
//  add a MDEn signal - 1 bit

    wire [ 5: 0] op     =  InsIn[31:26];
    wire [ 5: 0] func   =  InsIn[ 5:0 ];

    wire spc    =  (op  ==  `op_spc );
    wire spc_n  =  ~spc;

    wire addi   =  (op  ==  `op_addi);
    wire andi   =  (op  ==  `op_andi);
    wire bne    =  (op  ==  `op_bne );
    wire beq    =  (op  ==  `op_beq );
    wire jal    =  (op  ==  `op_jal );
    wire lb     =  (op  ==  `op_lb  );
    wire lh     =  (op  ==  `op_lh  );
    wire lw     =  (op  ==  `op_lw  );
    wire lui    =  (op  ==  `op_lui );
    wire ori    =  (op  ==  `op_ori );
    wire sb     =  (op  ==  `op_sb  );
    wire sh     =  (op  ==  `op_sh  );
    wire sw     =  (op  ==  `op_sw  );

    wire add    =  (op  ==  `op_spc  && func ==  `func_add  );
    wire _and   =  (op  ==  `op_spc  && func ==  `func_and  );
    wire div    =  (op  ==  `op_spc  && func ==  `func_div  );
    wire divu   =  (op  ==  `op_spc  && func ==  `func_divu );
    wire jr     =  (op  ==  `op_spc  && func ==  `func_jr   );
    wire jalr   =  (op  ==  `op_spc  && func ==  `func_jalr );
    wire mfhi   =  (op  ==  `op_spc  && func ==  `func_mfhi );
    wire mflo   =  (op  ==  `op_spc  && func ==  `func_mflo );
    wire mthi   =  (op  ==  `op_spc  && func ==  `func_mthi );
    wire mtlo   =  (op  ==  `op_spc  && func ==  `func_mtlo );
    wire mult   =  (op  ==  `op_spc  && func ==  `func_mult );
    wire multu  =  (op  ==  `op_spc  && func ==  `func_multu);
    wire _or    =  (op  ==  `op_spc  && func ==  `func_or   );
    wire slt    =  (op  ==  `op_spc  && func ==  `func_slt  );
    wire sltu   =  (op  ==  `op_spc  && func ==  `func_sltu );
    wire sub    =  (op  ==  `op_spc  && func ==  `func_sub  );

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
    wire [ 3:0 ]  MDType;
    
    assign MemWrite     = (sb   || sh   ||  sw );
    assign RegWrite     = (add  || addi || _and || andi
                        || jal  || lb   || lh   || lui  
								        || lw   || mfhi || mflo || ori  
								        
                        || _or  || slt  || sltu || sub);
    assign Jr           =  jr;
    assign Jump         =  jal;
    assign Branch       = (beq || bne);
    assign ExtOp        = (addi || beq  || bne  || sw  
                        || sh   || sb   || lw   || lh  
                        || lb);
    assign ALUASrc      = `alu_a_rd1;
    assign ALUBSrc      = (addi || andi || lb  || lh 
                        || lui  || lw   || ori || sb
                        || sh   || sw)                  ? `alu_b_imm : 
                                                          `alu_b_rd2; 
    assign RegDst       = (add  || _and || mfhi || mflo
                        || _or  || slt  || sltu || sub) ? `grf_wa_rd   :
                           jal                          ? `grf_wa_ra   :
                          (addi || andi || lb   || lh
                        || lui  || lw   || ori)         ? `grf_wa_rt   :
                                                          `grf_wa_rd;
    assign RegDataSrc   = (add || addi || _and || andi
                        || lui || ori  || _or || slt 
                        || sltu || sub)                 ? `grf_wd_alu  :
                          (lb || lh || lw)              ? `grf_wd_mem  :
                           jal                          ? `grf_wd_pc   :
                          (mfhi || mflo)                ? `grf_wd_hilo :
                                                          `grf_wd_alu;
    assign MemType      = (sw || lw) ? `type_w :
                          (sh || lh) ? `type_h :
                          (sb || lb) ? `type_b :
                                       `type_w;
    assign TUseRs       = (beq  || bne  || jr)          ? 3'd0 :
                          (add  || addi || _and || andi
                        || div  || divu || lb   || lh
                        || lui  || lw   || mthi || mtlo
                        || mult || multu|| ori  || _or
                        || sb   || sh   || slt  || sltu 
                        || sub  || sw)                  ? 3'd1 :
                                                          3'd3; // never gonna be used
    assign TUseRt       = (beq || bne)                  ? 3'd0 :
                          (add  || _and || div  || divu
                        || mult || multu|| _or  || slt
                        || sltu || sub)                 ? 3'd1 :
                          (lb   || lh   || lw   || sb
                        || sh   || sw)                  ? 3'd2 :
                                                          3'd3; // never gonna be used
    assign TNew         = (lb   || lh   || lw)          ? 3'd4         : // after DM in W-level
                          (add  || addi || _and || andi
                        || jal  || lui  || mfhi || mflo 
								        || ori  || _or  || slt  || sltu 
								        || sub) ? 3'd3         : // certain in W Level
                                                          3'd0; // update quickly so as not to cause pause
    assign ALUOp        = (add || addi || lb || lh
                        || lw || sb || sh || sw)        ? `alu_add :
                           sub                          ? `alu_sub :
                          (ori || _or)                  ? `alu_or :
                          (_and || andi)                ? `alu_and :
                           slt                          ? `alu_slt :
                           sltu                         ? `alu_sltu :
                           lui                          ? `alu_lui :
                                  `alu_add;
    assign CmpOp        =  beq ? `cmp_beq     :
                           bne ? `cmp_bne     :
                                 `cmp_beq;
    assign MDType       =  mult ? `mdu_mult :
                           multu? `mdu_multu:
                           div  ? `mdu_div  :
                           divu ? `mdu_divu :
                           mfhi ? `mdu_mfhi :
                           mflo ? `mdu_mflo :
                           mthi ? `mdu_mthi :
                           mtlo ? `mdu_mtlo :
                                  `mdu_none;
    /****** Output ******/
    assign CtrlOut = {
        {MDType},       // [34:31]
        {CmpOp},        // [30:27]
        {ALUOp},        // [26:23]
        {TNew},         // [22:20]
        {TUseRt},       // [19:17]
        {TUseRs},       // [16:14]
        {MemType},      // [13:12]
        {RegDataSrc},   // [11:10]
        {RegDst},       // [9 :8 ]
        {ALUBSrc},      // [7]
        {ALUASrc},      // [6]
        {ExtOp},        // [5]
        {Branch},       // [4]
        {Jump},         // [3]
        {Jr},           // [2]
        {RegWrite},     // [1]
        {MemWrite}      // [0]
    };
endmodule