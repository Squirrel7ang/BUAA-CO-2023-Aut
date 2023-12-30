`include "header.v"

module mips(
    input clk,
    input reset
);
    wire [31:0] pc, rd1, rd2, grf_wd, ext_out,
                alu_b, alu_out, dm_out;
    wire [25:0] imm_26;
    wire [15:0] imm_16;
    wire [ 5:0] op, func;
    wire [ 4:0] rs, rt, rd, shamt, grf_a3;
    wire [ 3:0] alu_op;
    wire [ 1:0] reg_dst, reg_data_src, mem_type;
    wire        branch, jump, jr, ext_op, zf, 
                mem_write, reg_write, alu_src;
                 

    IFU Ifu(
        .Clk(clk),
        .Reset(reset),
        .ZF(zf),
        .Branch(branch),
        .Jump(jump),
        .Jr(jr),
        .Offset16(imm_16),
        .Offset26(imm_26),
        .Ra(rd1),

        .Op(op),
        .Rs(rs),
        .Rt(rt),
        .Rd(rd),
        .Shamt(shamt),
        .Func(func),
        .Imm16(imm_16),
        .Imm26(imm_26),
        .PC(pc)
    );

    CTRL Ctrl(
        .Op(op),
        .Func(func),

        .MemWrite(mem_write),
        .RegWrite(reg_write),
        .Jr(jr),
        .Jump(jump),
        // .Link(link),
		  .Branch(branch),
        .ExtOp(ext_op),
        .ALUSrc(alu_src),
        .ALUOp(alu_op),
        .RegDst(reg_dst),
        .RegDataSrc(reg_data_src),
        .MemType(mem_type)
    );

    assign grf_a3 = (reg_dst == `a3_ra) ? 5'd31 :
                    (reg_dst == `a3_rd) ? rd    :
                                          rt;
    assign grf_wd = (reg_data_src == `wd_alu) ? alu_out :
                    (reg_data_src == `wd_mem) ? dm_out  :
                                                pc + 4;
    GRF Grf(
        .Clk(clk),
        .Reset(reset),
        .WE(reg_write),
        .A1(rs),
        .A2(rt),
        .A3(grf_a3),
        .WD(grf_wd),
		  .PC(pc),

        .RD1(rd1),
        .RD2(rd2)
    );

    EXT Ext(
        .In(imm_16),
        .ExtOp(ext_op),

        .Out(ext_out)
    );

    assign alu_b = (alu_src) ? ext_out : rd2;
    ALU Alu(
        .A(rd1),
        .B(alu_b),
        .ALUOp(alu_op),

        .Result(alu_out),
        .ZF(zf)
    );

    DM Dm(
        .Clk(clk),
        .Reset(reset),
        .WE(mem_write),
        .Addr(alu_out),
        .Data(rd2),
        .DataType(mem_type),
		  .PC(pc),

        .Out(dm_out)
    );
endmodule