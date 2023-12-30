`include "header.v"

module mips(
    input           clk,
    input           reset,
    input           interrupt,
    output [31: 0]  macroscopic_pc,

    output [31: 0]  i_inst_addr,
    input  [31: 0]  i_inst_rdata,

    output [31: 0]  m_data_addr,
    input  [31: 0]  m_data_rdata,
    output [31: 0]  m_data_wdata,
    output [3 : 0]  m_data_byteen,

    output [31: 0]  m_int_addr,
    output [3 : 0]  m_int_byteen,

    output [31: 0]  m_inst_addr,

    output          w_grf_we,
    output [4 : 0]  w_grf_addr,
    output [31: 0]  w_grf_wdata,

    output [31: 0]  w_inst_addr

);

    /******************** VARIABLES DECLARATION ********************/
	 wire [31: 0] f_pc, f_ins; 
	 wire [31: 0] d_pc, d_ins; 
	 wire [31: 0] e_pc, e_ins; 
	 wire [31: 0] m_pc, m_ins; 
	 wire [31: 0] w_pc, w_ins;
	 wire [`CTRL_LEN-1:0] f_ctrl;
	 wire [`CTRL_LEN-1:0] d_ctrl;
	 wire [`CTRL_LEN-1:0] e_ctrl;
	 wire [`CTRL_LEN-1:0] m_ctrl;
	 wire [`CTRL_LEN-1:0] w_ctrl;	 
	 
    // driven by level F
    wire [31:0 ] f_npc;
	 wire f_ri, f_bd;

    // driven by level D
    wire [31:0 ] d_grf_rd1, d_grf_rd2, d_rd1, d_rd2;
    wire stall, d_ri, d_bd;

    // driven by level E
    wire [31:0 ] e_reg_rd1, e_reg_rd2, e_rd1, e_rd2, 
                 e_ext_out, e_alu_out, e_hilo, e_cal_time, e_md_hi,
                 e_md_lo;
    wire e_cp0_we;
    wire e_md_stall, e_md_busy;
	 wire e_ri, e_bd;

    // driven by level M
    wire [31:0 ] m_alu, m_reg_rd2, m_rd2, 
                 m_dm_out, m_hilo, m_rd1;
    wire [31: 0] m_vpc, epc, m_cp0_epc, m_cp0_out;
    wire [4 : 0] m_exc_code;
    wire [5 : 0] m_hwint;
    wire m_lw, m_lh, m_lb, m_load, m_sw, m_sh, m_sb, m_store,
        m_cal, m_syscall, m_exc_adel, m_exc_ades, m_exc_syscall, 
        m_exc_ri, m_ri, mm_exc_ov, m_cp0_we, m_bd;

    // driven by level W
    wire [31:0 ] w_alu, w_dm_out, w_hilo, w_cp0;
    
    // multiplexer
    wire [31:0 ] m_write_reg_data;
    wire [31:0 ] w_write_reg_data;
    wire [31:0 ] e_alu_a;
    wire [31:0 ] e_alu_b;

    /********** Level D Ctrl Signals **********/
    // Control Signals
    wire          d_mem_write       = d_ctrl[0 ];
    wire          d_reg_write       = d_ctrl[1 ];
    wire          d_jr              = d_ctrl[2 ];
    wire          d_jump            = d_ctrl[3 ];
    wire          d_branch          = d_ctrl[4 ];
    wire          d_ext_op          = d_ctrl[5 ];
    wire          d_alu_a_src       = d_ctrl[6 ];
    wire          d_alu_b_src       = d_ctrl[7 ];
    wire [ 1:0 ]  d_reg_dst         = d_ctrl[9 :8 ];
    wire [ 1:0 ]  d_reg_data_src    = d_ctrl[11:10];
    wire [ 1:0 ]  d_mem_type        = d_ctrl[13:12];
    wire [ 2:0 ]  d_tuse_rs         = d_ctrl[16:14];
    wire [ 2:0 ]  d_tuse_rt         = d_ctrl[19:17];
    wire [ 2:0 ]  d_tnew            = d_ctrl[22:20];
    wire [ 3:0 ]  d_alu_op          = d_ctrl[26:23];
    wire [ 3:0 ]  d_cmp_op          = d_ctrl[30:27];
    wire [ 3:0 ]  d_md_type         = d_ctrl[34:31];
    wire [ 4:0 ]  d_wa              = (d_reg_dst == `grf_wa_rd) ? d_rd :
						              (d_reg_dst == `grf_wa_ra) ? 5'd31:
						              (d_reg_dst == `grf_wa_rt) ? d_rt :
									                              5'b0x0x0; // for debug
    
    // Instruction
    wire [ 5:0 ]  d_op              = d_ins[31:26];
    wire [ 4:0 ]  d_rs              = d_ins[25:21];
    wire [ 4:0 ]  d_rt              = d_ins[20:16];
    wire [ 4:0 ]  d_rd              = d_ins[15:11];
    wire [ 4:0 ]  d_shamt           = d_ins[10: 6];
    wire [ 5:0 ]  d_func            = d_ins[ 5: 0];
    wire [15:0 ]  d_imm16           = d_ins[15: 0];
    wire [25:0 ]  d_imm26           = d_ins[25: 0];

    /********** Level E Ctrl Signals **********/
    // Control Signals
    wire          e_mem_write       = e_ctrl[0 ];
    wire          e_reg_write       = e_ctrl[1 ];
    wire          e_jr              = e_ctrl[2 ];
    wire          e_jump            = e_ctrl[3 ];
    wire          e_branch          = e_ctrl[4 ];
    wire          e_ext_op          = e_ctrl[5 ];
    wire          e_alu_a_src       = e_ctrl[6 ];
    wire          e_alu_b_src       = e_ctrl[7 ];
    wire [ 1:0 ]  e_reg_dst         = e_ctrl[9 :8 ];
    wire [ 1:0 ]  e_reg_data_src    = e_ctrl[11:10];
    wire [ 1:0 ]  e_mem_type        = e_ctrl[13:12];
    wire [ 2:0 ]  e_tuse_rs         = e_ctrl[16:14];
    wire [ 2:0 ]  e_tuse_rt         = e_ctrl[19:17];
    wire [ 2:0 ]  e_tnew            = e_ctrl[22:20];
    wire [ 3:0 ]  e_alu_op          = e_ctrl[26:23];
    wire [ 3:0 ]  e_cmp_op          = e_ctrl[30:27];
    wire [ 3:0 ]  e_md_type         = e_ctrl[34:31];
    wire [ 4:0 ]  e_wa              = (e_reg_dst == `grf_wa_rd) ? e_rd :
						              (e_reg_dst == `grf_wa_ra) ? 5'd31:
						              (e_reg_dst == `grf_wa_rt) ? e_rt :
															      5'b0x0x0; // for debug
    
    // Instruction
    wire [ 5:0 ]  e_op              = e_ins[31:26];
    wire [ 4:0 ]  e_rs              = e_ins[25:21];
    wire [ 4:0 ]  e_rt              = e_ins[20:16];
    wire [ 4:0 ]  e_rd              = e_ins[15:11];
    wire [ 4:0 ]  e_shamt           = e_ins[10: 6];
    wire [ 5:0 ]  e_func            = e_ins[ 5: 0];
    wire [15:0 ]  e_imm16           = e_ins[15: 0];
    wire [25:0 ]  e_imm26           = e_ins[25: 0];

    wire e_hilo_src = (e_md_type == `mdu_mfhi) ? `hilo_hi :
                      (e_md_type == `mdu_mflo) ? `hilo_lo : 
                                                 1'bx; // for debug


    /********** Level M Ctrl Signals **********/
    // Control Signals
    wire          m_mem_write       = m_ctrl[0 ];
    wire          m_reg_write       = m_ctrl[1 ];
    wire          m_jr              = m_ctrl[2 ];
    wire          m_jump            = m_ctrl[3 ];
    wire          m_branch          = m_ctrl[4 ];
    wire          m_ext_op          = m_ctrl[5 ];
    wire          m_alu_a_src       = m_ctrl[6 ];
    wire          m_alu_b_src       = m_ctrl[7 ];
    wire [ 1:0 ]  m_reg_dst         = m_ctrl[9 : 8];
    wire [ 1:0 ]  m_reg_data_src    = m_ctrl[11:10];
    wire [ 1:0 ]  m_mem_type        = m_ctrl[13:12];
    wire [ 2:0 ]  m_tuse_rs         = m_ctrl[16:14];
    wire [ 2:0 ]  m_tuse_rt         = m_ctrl[19:17];
    wire [ 2:0 ]  m_tnew            = m_ctrl[22:20];
    wire [ 3:0 ]  m_alu_op          = m_ctrl[26:23];
    wire [ 3:0 ]  m_cmp_op          = m_ctrl[30:27];
    wire [ 3:0 ]  m_md_type         = m_ctrl[34:31];
    wire [ 4:0 ]  m_wa              = (m_reg_dst == `grf_wa_rd) ? m_rd :
						              (m_reg_dst == `grf_wa_ra) ? 5'd31:
						              (m_reg_dst == `grf_wa_rt) ? m_rt :
											                      5'b0x0x0; // for debug
    
    // Instruction
    wire [ 5:0 ]  m_op              = m_ins[31:26];
    wire [ 4:0 ]  m_rs              = m_ins[25:21];
    wire [ 4:0 ]  m_rt              = m_ins[20:16];
    wire [ 4:0 ]  m_rd              = m_ins[15:11];
    wire [ 4:0 ]  m_shamt           = m_ins[10: 6];
    wire [ 5:0 ]  m_func            = m_ins[5 : 0];
    wire [15:0 ]  m_imm16           = m_ins[15: 0];
    wire [25:0 ]  m_imm26           = m_ins[25: 0];
    
    /********** Level W Ctrl Signals **********/
    // Control Signals
    wire          w_mem_write       = w_ctrl[0 ];
    wire          w_reg_write       = w_ctrl[1 ];
    wire          w_jr              = w_ctrl[2 ];
    wire          w_jump            = w_ctrl[3 ];
    wire          w_branch          = w_ctrl[4 ];
    wire          w_ext_op          = w_ctrl[5 ];
    wire          w_alu_a_src       = w_ctrl[6 ];
    wire          w_alu_b_src       = w_ctrl[7 ];
    wire [ 1:0 ]  w_reg_dst         = w_ctrl[9 :8 ];
    wire [ 1:0 ]  w_reg_data_src    = w_ctrl[11:10];
    wire [ 1:0 ]  w_mem_type        = w_ctrl[13:12];
    wire [ 2:0 ]  w_tuse_rs         = w_ctrl[16:14];
    wire [ 2:0 ]  w_tuse_rt         = w_ctrl[19:17];
    wire [ 2:0 ]  w_tnew            = w_ctrl[22:20];
    wire [ 3:0 ]  w_alu_op          = w_ctrl[26:23];
    wire [ 3:0 ]  w_cmp_op          = w_ctrl[30:27];
    wire [ 3:0 ]  w_md_type         = w_ctrl[34:31];
    wire [ 4:0 ]  w_wa              = (w_reg_dst == `grf_wa_rd) ? w_rd :
						              (w_reg_dst == `grf_wa_ra) ? 5'd31:
						              (w_reg_dst == `grf_wa_rt) ? w_rt :
												                  5'b0x0x0; // for debug
        
    // Instruction
    wire [ 5:0 ]  w_op              = w_ins[31:26];
    wire [ 4:0 ]  w_rs              = w_ins[25:21];
    wire [ 4:0 ]  w_rt              = w_ins[20:16];
    wire [ 4:0 ]  w_rd              = w_ins[15:11];
    wire [ 4:0 ]  w_shamt           = w_ins[10: 6];
    wire [ 5:0 ]  w_func            = w_ins[5 : 0];
    wire [15:0 ]  w_imm16           = w_ins[15: 0];
    wire [25:0 ]  w_imm26           = w_ins[25: 0];


    /******************** LEVEL F ********************/
    
	 assign f_bd = d_branch || d_jump || d_jr;

    F_NPC F_npc(
        .Jump(d_jump),
        .Jr(d_jr),
        .Branch(d_branch),
        .PC(f_pc),
        .Cmp(d_cmp),
        .Ra(d_rd1),
        .Stall(stall),
        .MDStall(e_md_stall),
        .Imm26(d_imm26),
        .Eret(d_eret),
        .EPC(epc),
        .Req(req),

        .NPC(f_npc)
    );

    F_PC F_pc(
        .Clk(clk),
        .Reset(reset),
        .NPC(f_npc),

        .PC(f_pc)
    );

    /**** F_IM ****/
    assign i_inst_addr = f_pc;
    assign f_ins = i_inst_rdata;

    F_CTRL F_ctrl(
        .InsIn(f_ins),

        .CtrlOut(f_ctrl),
		.RI(f_ri)
    );


    /******************** LEVEL D ********************/

    assign d_eret = (d_op == `op_cop0 && d_rs == `cp0_eret && d_func == `func_eret);

    assign e_epc_write = (e_cp0_we && e_rd == `cp0_epc);
    assign m_epc_write = (m_cp0_we && m_rd == `cp0_epc);

    D_REG D_reg(
        .Clk(clk),
        .Reset(reset),
		.Stall(stall),
		.MDStall(e_md_stall),
		.Req(req),
		.Eret(d_eret),
		.EPC(epc),

        .InsIn(f_ins),
        .PCIn(f_pc),
        .CtrlIn(f_ctrl),
		.RIIn(f_ri),
		.BDIn(f_bd),

		.InsOut(d_ins),
        .PCOut(d_pc),
        .CtrlOut(d_ctrl),
		.RIOut(d_ri),
		.BDOut(d_bd)
    );

    D_STALL  D_stall(
        .TUseRs(d_tuse_rs),
        .Rs(d_rs),

        .TUseRt(d_tuse_rt),
        .Rt(d_rt),
        
        .ETNew(e_tnew),
        .ERegDst(e_wa),
        .EWriteRegEn(e_reg_write),
        
        .MTNew(m_tnew),
        .MRegDst(m_wa),
        .MWriteRegEn(m_reg_write),

        .DEret(d_eret),
        .EWriteEPC(e_epc_write),
        .MWriteEPC(m_epc_write),
        
        .Stall(stall)
    );
	 
    D_GRF D_grf(
        .Clk(clk),
        .Reset(reset),
        .WE(w_reg_write),
        .A1(d_rs),
        .A2(d_rt),
        .WA(w_wa), 
        .WD(w_write_reg_data),
        .PC(w_pc),

        .Read1(d_grf_rd1),
        .Read2(d_grf_rd2)
    );
	 
	 assign w_grf_we = w_reg_write;
	 assign w_grf_addr = w_wa;
	 assign w_grf_wdata = w_write_reg_data;
	 assign w_inst_addr = w_pc;

    FWD D_rd1_fwd(
        .ThisRegAddr(d_rs),
        .ThisData(d_grf_rd1),
        
        .MRegAddr(m_wa),
        .MWriteRegEn(m_reg_write),
        .MData(m_write_reg_data), 
        
        .WRegAddr(w_wa),
        .WWriteRegEn(w_reg_write),
        .WData(w_write_reg_data),
        
        .Output(d_rd1)
    );

    FWD D_rd2_fwd(
        .ThisRegAddr(d_rt),
        .ThisData(d_grf_rd2),
        
        .MRegAddr(m_wa),
        .MWriteRegEn(m_reg_write),
        .MData(m_write_reg_data), 
        
        .WRegAddr(w_wa),
        .WWriteRegEn(w_reg_write),
        .WData(w_write_reg_data),
        
        .Output(d_rd2)
    );

    D_CMP D_cmp(
        .Rd1(d_rd1),
        .Rd2(d_rd2),
        .CmpOp(d_cmp_op),
        .Flag(d_cmp)
    );


    /******************** LEVEL E ********************/

    assign e_cp0_we = (e_op == `op_cop0 && e_rs == `cp0_mtc0);

    E_REG E_reg(
        .Clk(clk),
        .Reset(reset),
        .Stall(stall),
        .MDStall(e_md_stall),
		  .Req(req),

        .InsIn(d_ins),
        .PCIn(d_pc),
        .RdIn1(d_rd1),
        .RdIn2(d_rd2),
        .CtrlIn(d_ctrl),
		  .RIIn(d_ri),
		  .BDIn(d_bd),
        
        .InsOut(e_ins),
        .PCOut(e_pc),
        .RdOut1(e_reg_rd1),
        .RdOut2(e_reg_rd2),
        .CtrlOut(e_ctrl),
		  .RIOut(e_ri),
		  .BDOut(e_bd)
    );

    FWD E_rd1_fwd(
        .ThisRegAddr(e_rs),
        .ThisData(e_reg_rd1),
        
        .MRegAddr(m_wa),
        .MWriteRegEn(m_reg_write),
        .MData(m_write_reg_data), 
        
        .WRegAddr(w_wa),
        .WWriteRegEn(w_reg_write),
        .WData(w_write_reg_data),
        
        .Output(e_rd1)
    );

    FWD E_rd2_fwd(
        .ThisRegAddr(e_rt),
        .ThisData(e_reg_rd2),
        
        .MRegAddr(m_wa),
        .MWriteRegEn(m_reg_write),
        .MData(m_write_reg_data), 
        
        .WRegAddr(w_wa),
        .WWriteRegEn(w_reg_write),
        .WData(w_write_reg_data),
        
        .Output(e_rd2)
    );

    E_EXT E_ext(
        .ExtIn(e_imm16),
        .ExtOp(e_ext_op),

        .ExtOut(e_ext_out)
    );

    assign e_alu_a = (e_alu_a_src == `alu_a_rd1) ? e_rd1 : e_shamt;
    assign e_alu_b = (e_alu_b_src == `alu_b_rd2) ? e_rd2 : e_ext_out;

    E_ALU E_alu(
        .A(e_alu_a),
        .B(e_alu_b),
        .ALUOp(e_alu_op),

        .Result(e_alu_out),
        .Overflow(e_ov)
    );

    assign e_cal_time = (e_md_type == `mdu_mult)  ? 5  : 
                        (e_md_type == `mdu_multu) ? 5  :
                        (e_md_type == `mdu_div)   ? 10 :
                        (e_md_type == `mdu_divu)  ? 10 :
                                                    0;

    E_MDU E_mdu(
        .Clk(clk),
        .Reset(reset),
        .Req(req),

        .A(e_rd1),
        .B(e_rd2),
        .MDType(e_md_type),
        .CalTime(e_cal_time),

        .HIOut(e_md_hi),
        .LOOut(e_md_lo),
        .Start(e_md_start),
        .Busy(e_md_busy)
    );
	 assign e_md_stall = (e_md_start || e_md_busy) && (d_md_type != `mdu_none); // the first change

    assign e_hilo = (e_hilo_src == `hilo_hi) ? e_md_hi :
                    (e_hilo_src == `hilo_lo) ? e_md_lo :
                                               32'h0x0x_0x0x; // for debug
    
    /******************** LEVEL M ********************/  

    assign macroscopic_pc = m_pc;    

    /*** Exception ***/
    assign m_lw = (m_reg_data_src == `grf_wd_mem) && (m_mem_type == `type_w);
    assign m_lh = (m_reg_data_src == `grf_wd_mem) && (m_mem_type == `type_h);
    assign m_lb = (m_reg_data_src == `grf_wd_mem) && (m_mem_type == `type_b);
    assign m_load = m_lw || m_lh || m_lb;

    assign m_sw = (m_mem_write == 1'b1) && (m_mem_type == `type_w);
    assign m_sh = (m_mem_write == 1'b1) && (m_mem_type == `type_h);
    assign m_sb = (m_mem_write == 1'b1) && (m_mem_type == `type_b);
    assign m_store = m_sw || m_sh || m_sb;

    assign m_cal = (m_op == `op_spc && m_func == `func_add)
                || (m_op == `op_spc && m_func == `func_sub)
                || (m_op == `op_addi);

    assign m_syscall = (m_op == `op_spc && m_func == `func_syscall);
    
    assign m_exc_adel = (m_pc[1:0] != 2'b00)
                ||  (m_pc < 32'h3000 || m_pc > 32'h6ffc)
                ||  (m_lw && m_alu[1:0] != 2'b00)
                ||  (m_lh && m_alu[0] != 1'b0)
                ||  ((m_lh || m_lb) && ((m_alu >= `timer0_begin && m_alu <= `timer0_end) || (m_alu >= `timer1_begin && m_alu <= `timer1_end)))
                ||  (m_load && m_ov)
                ||  (m_load &&  (m_alu > `dm_end) 
                            &&  ((m_alu < `timer0_begin) || (m_alu > `timer0_end))
                            &&  ((m_alu < `timer1_begin) || (m_alu > `timer1_end))
                            &&  ((m_alu < `int_gen_begin) || (m_alu > `int_gen_end)));
    assign m_exc_ades = (m_sw && m_alu[1:0] != 2'b00)
                ||  (m_sh && m_alu[0] != 1'b0)
                ||  ((m_sh || m_sb) && ((m_alu >= `timer0_begin && m_alu <= `timer0_end) || (m_alu >= `timer1_begin && m_alu <= `timer1_end)))
                ||  (m_store && m_ov)
                ||  (m_store &&  (m_alu > `dm_end) 
                             &&  ((m_alu < `timer0_begin) || (m_alu > `timer0_end - 4))
                             &&  ((m_alu < `timer1_begin) || (m_alu > `timer1_end - 4))
                             &&  ((m_alu < `int_gen_begin) || (m_alu > `int_gen_end)));
    assign m_exc_syscall = m_syscall;
    assign m_exc_ri = m_ri;
    assign m_exc_ov = m_cal && m_ov;

    assign m_cp0_we = (m_op == `op_cop0 && m_rs == `cp0_mtc0);
    
    assign m_hwint = {3'b000, interrupt, timer1_irq, timer0_irq};
    assign m_vpc =  m_bd ? m_pc - 4 :
                    m_pc; // xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
    assign m_exc_code = m_exc_adel ? `exc_adel :
                        m_exc_ades ? `exc_ades :
                        m_exc_syscall ? `exc_syscall :
                        m_exc_ri ? `exc_ri :
                        m_exc_ov ? `exc_ov :
                        (m_hwint & 6'b000111) != 0 ? `exc_int :
                        5'd1;
    assign m_eret = (m_op == `op_cop0 && m_rs == `cp0_eret && m_func == `func_eret);
    //  where is interrupt generator ????????
	 always @(posedge clk) begin
	     if (req) begin
		      $display("exception at address %h", m_pc);
		  end
	 end

    M_REG M_reg(
        .Clk(clk),
        .Reset(reset),
        .MDStall(e_md_stall),
		  .Req(req),
        
        .InsIn(e_ins),
        .PCIn(e_pc),
        .ALUIn(e_alu_out),
		  .RdIn1(e_rd1),
        .RdIn2(e_rd2),
        .CtrlIn(e_ctrl),
        .HiloIn(e_hilo),
        .OvIn(e_ov),
		  .RIIn(e_ri),
		  .BDIn(e_bd),

        .InsOut(m_ins),
        .PCOut(m_pc),
        .ALUOut(m_alu),
		  .RdOut1(m_rd1),
        .RdOut2(m_reg_rd2),
        .CtrlOut(m_ctrl),
        .HiloOut(m_hilo),
        .OvOut(m_ov),
		  .RIOut(m_ri),
		  .BDOut(m_bd)
    );

    M_CP0 M_cp0(
        .Clk(clk),
        .Reset(reset),
        .WE(m_cp0_we),
        .BDIn(m_bd),
        .EXLClr(m_eret), // ???
        .HWInt(m_hwint),
        .CP0Add(m_rd),
        .CP0In(m_rd2),
        .VPC(m_vpc),
        .ExcCodeIn(m_exc_code),

        .EPCOut(m_cp0_epc),
        .CP0Out(m_cp0_out),
        .Req(req)
    );
    
    assign epc = m_cp0_epc;

    FWD M_rd2_fwd(
        .ThisRegAddr(m_rt),
        .ThisData(m_reg_rd2),
        
        .MRegAddr(m_wa), // useless because RegWriteEn = False
        .MWriteRegEn(1'b0), 
        .MData(m_write_reg_data),  // useless because RegWriteEn = False
        
        .WRegAddr(w_wa),
        .WWriteRegEn(w_reg_write),
        .WData(w_write_reg_data),
        
        .Output(m_rd2)
    );
    
    /**** M_DM ****/
    assign m_data_addr = m_alu; // the address of dm
    assign m_data_wdata = m_rd2 << {m_alu[1:0], 3'b000}; // the data written
    M_BYTEEN M_byteen(
        .WE(m_mem_write),
        .Addr(m_alu),
        .Type(m_mem_type),
        .Req(req),
        .AdEL(m_exc_adel),
        .AdES(m_exc_ades),

        .EnCode(m_data_byteen)
    ); // calculate m_data_type
    assign m_inst_addr = m_pc;

    M_DM_EXT M_dm_ext(
        .Type(m_mem_type),
        .Addr(m_data_addr[1:0]),
        .DIn(m_data_rdata),

        .DOut(m_dm_out)
    );
	 
	 assign m_int_addr = m_data_addr;
	 assign m_int_byteen = ((m_data_addr >= `int_gen_begin && m_data_addr <= `int_gen_end) && (m_data_byteen != 4'b0000)) ? m_data_byteen: 4'b0000; 


    assign m_write_reg_data = (m_reg_data_src == `grf_wd_alu) ? m_alu :
                              (m_reg_data_src == `grf_wd_pc ) ? (m_pc + 8) :
                              (m_reg_data_src == `grf_wd_hilo)? m_hilo :
                                                                32'hx0x0_x0x0; // for debug

    
    /******************** LEVEL W ********************/

    W_REG W_reg(
        .Clk(clk),
        .Reset(reset),
		  .Req(req),

        .InsIn(m_ins),
        .PCIn(m_pc),
        .ALUIn(m_alu),
        .DMIn(m_dm_out),
        .CtrlIn(m_ctrl),
        .HiloIn(m_hilo),
        .CP0In(m_cp0_out), // ????????????
        
        .InsOut(w_ins),
        .PCOut(w_pc),
        .ALUOut(w_alu),
        .DMOut(w_dm_out),
        .CtrlOut(w_ctrl),
        .HiloOut(w_hilo),
        .CP0Out(w_cp0)
    );

    assign w_write_reg_data = (w_op == `op_cop0 && w_rs == `cp0_mfc0) ? w_cp0 :
                              (w_reg_data_src == `grf_wd_alu) ? w_alu :
                              (w_reg_data_src == `grf_wd_pc)  ? w_pc + 8 :
                              (w_reg_data_src == `grf_wd_mem) ? w_dm_out :
                              (w_reg_data_src == `grf_wd_hilo)? w_hilo :
                                                                32'hx0x0_x0x0; // for debug

    /******************** PERIPHERAL - LEVEL P ********************/
    
    wire [31: 0] m_timer_rdata, p_timer0_data_out, p_timer1_data_out,
                p_data_in, p_timer_addr;
    wire p_bridge_we, p_timer0_we, p_timer1_we, timer0_irq, timer1_irq;
	 

    BRIDGE Bridge(
        /*** CPU ***/
        .AddrIn(m_alu),
        .DataIn(m_data_wdata),
        .ByteEn(m_data_byteen),

        .TimerOut(m_timer_rdata),
        .TimerIRQOut0(timer0_irq),
        .TimerIRQOut1(timer1_irq),

        /*** Timer ***/
        .TimerWrite0(p_timer0_we),
        .TimerWrite1(p_timer1_we),
        .DataOut(p_data_in),
        .AddrOut(p_timer_addr),

        .TimerIn0(p_timer0_data_out),
        .TimerIn1(p_timer1_data_out),
        .TimerIRQIn0(p_timer0_irq),
        .TimerIRQIn1(p_timer1_irq)
    );

    TC Timer0(
        .Clk(clk),
        .Reset(reset),
        .Addr(p_timer_addr[31:2]),
        .WE(p_timer0_we),
        .Din(p_data_in),

        .Dout(p_timer0_data_out),
        .IRQ(p_timer0_irq)
    );

    TC Timer1(
        .Clk(clk),
        .Reset(reset),
        .Addr(p_timer_addr[31:2]),
        .WE(p_timer1_we),
        .Din(p_data_in),

        .Dout(p_timer1_data_out),
        .IRQ(p_timer1_irq)
    );


endmodule