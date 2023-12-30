`ifndef HEADER
`define HEADER
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

    `define alu_add     4'd0
    `define alu_sub     4'd1
    `define alu_or      4'd2
    `define alu_lui     4'd3

    `define type_w      2'd0
    `define type_h      2'd1
    `define type_b      2'd2

    `define wd_alu      2'd0
    `define wd_mem      2'd1
    `define wd_pc       2'd2

    `define a3_rt       2'd0
    `define a3_rd       2'd1
    `define a3_ra       2'd2

`endif