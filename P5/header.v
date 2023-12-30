`ifndef HEADER
`define HEADER
    `timescale 1ns/1ps
    /****** Ctrl Signals ******/
    `define CTRL_LEN (8+6+9+8)
        /*
            CtrlSig[CTRL_LEN-1:0]:
            {
                    MemWrite,      30
                    RegWrite,      29
                    Jr,            28
                    Jump,          27
                    Branch,        26
                    ExtOp,         25
                    ALUASrc,       24
                    ALUBSrc,       23
            [ 1:0 ]  RegDst,        22: 21
            [ 1:0 ]  RegDataSrc,    20: 19
            [ 1:0 ]  MemType,       18: 17
            [ 2:0 ]  TUseRs,        16: 14
            [ 2:0 ]  TUseRt,        13: 11
            [ 2:0 ]  TNew,          10: 8
            [ 3:0 ]  ALUOp,          7: 4
            [ 3:0 ]  CmpOp,          3: 0
            }
        */

    /****** OpCode & Func ******/
    `define op_spc      6'b000000
    `define op_ori      6'b001101
    `define op_beq      6'b000100
    `define op_sw       6'b101011
    `define op_lw       6'b100011
    `define op_lui      6'b001111
    `define op_jal      6'b000011

    `define func_add    6'b100000
    `define func_sub    6'b100010
    `define func_jr     6'b001000

    /****** ALU OpCode & Src ******/
    `define alu_add     4'd0
    `define alu_sub     4'd1
    `define alu_or      4'd2
    `define alu_lui     4'd3
    `define alu_xor     4'd4
    `define alu_and     4'd5
    `define alu_shift_l 4'd6
    `define alu_shift_r 4'd7

    `define alu_a_rd1   1'd0
    `define alu_a_s     1'd1

    `define alu_b_rd2   1'd0
    `define alu_b_imm   1'd1

    /****** Memory Type ******/
    `define type_w      2'd0
    `define type_h      2'd1
    `define type_b      2'd2

    /****** GRF Src ******/
    `define grf_wd_alu      2'd0
    `define grf_wd_mem      2'd1
    `define grf_wd_pc       2'd2

    `define grf_wa_rt       2'd0
    `define grf_wa_rd       2'd1
    `define grf_wa_ra       2'd2
    
    /****** EXT OpCode ******/
    `define ext_zero    1'b0
    `define ext_sign    1'b1

    /****** CMP OpCode ******/
    `define cmp_beq     3'd0
    `define cmp_bne     3'd1
    `define cmp_bgez    3'd2
    `define cmp_bgtz    3'd3
    `define cmp_bltz    3'd4
    `define cmp_blez    3'd5

`endif