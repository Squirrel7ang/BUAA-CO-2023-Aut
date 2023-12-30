`ifndef HEADER
`define HEADER
    `timescale 1ns/1ps
    /****** Ctrl Signals ******/
    `define CTRL_LEN (8+6+9+12) // = 35
    /*
        Ctrl = {
            {MDType},       // [31:34]
            {CmpOp},        // [27:30]
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
    */

    /****** OpCode & Func ******/
    `define op_spc      6'b000000

    `define op_andi     6'b001100
    `define op_addi     6'b001000
    `define op_beq      6'b000100
    `define op_bne      6'b000101
    `define op_jal      6'b000011
    `define op_lb       6'b100000
    `define op_lh       6'b100001
    `define op_lw       6'b100011
    `define op_lui      6'b001111
    `define op_ori      6'b001101
    `define op_sb       6'b101000
    `define op_sh       6'b101001
    `define op_sw       6'b101011

    `define func_add    6'b100000
    `define func_and    6'b100100
    `define func_div    6'b011010
    `define func_divu   6'b011011
    `define func_jr     6'b001000
    `define func_jalr   6'b001001 // ???
    `define func_mfhi   6'b010000
    `define func_mflo   6'b010010
    `define func_mthi   6'b010001
    `define func_mtlo   6'b010011
    `define func_mult   6'b011000
    `define func_multu  6'b011001
    `define func_or     6'b100101
    `define func_slt    6'b101010
    `define func_sltu   6'b101011
    `define func_sub    6'b100010

    /****** ALU OpCode & Src ******/
    `define alu_add     4'd0
    `define alu_sub     4'd1
    `define alu_or      4'd2
    `define alu_lui     4'd3
    `define alu_xor     4'd4
    `define alu_and     4'd5
    `define alu_slt     4'd6
    `define alu_sltu    4'd7

    `define alu_a_rd1   1'd0
    `define alu_a_s     1'd1

    `define alu_b_rd2   1'd0
    `define alu_b_imm   1'd1

    /****** MDU & HI/LO ******/
    `define hilo_hi     1'b0
    `define hilo_lo     1'b1

    `define hilo_start  1'b0
    `define hilo_busy   1'b1

    `define mdu_none    4'd0
    `define mdu_mult    4'd1
    `define mdu_multu   4'd2
    `define mdu_div     4'd3
    `define mdu_divu    4'd4
    `define mdu_mfhi    4'd5
    `define mdu_mflo    4'd6
    `define mdu_mthi    4'd7
    `define mdu_mtlo    4'd8

    /****** Memory Type ******/
    `define type_w      2'd0
    `define type_h      2'd1
    `define type_b      2'd2

    /****** GRF Src ******/
    `define grf_wd_alu      2'd0
    `define grf_wd_mem      2'd1
    `define grf_wd_pc       2'd2
    `define grf_wd_hilo     2'd3

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