`include "header.v"
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

module D_REG(
    input                   Clk,
    input                   Reset,
	 input                   Stall,
	 input                   MDStall,
    
    input  [31:0 ]          InsIn,
    input  [31:0 ]          PCIn,
    input  [`CTRL_LEN-1:0]   CtrlIn,

    output [31:0 ]          InsOut,
    output [31:0 ]          PCOut,
    output [`CTRL_LEN-1:0]   CtrlOut

);
    reg [31:0 ] ins;
    reg [31:0 ] pc;
    reg [`CTRL_LEN-1:0] ctrl;

    assign PCOut        = pc;
    assign InsOut       = ins;
    assign CtrlOut[`CTRL_LEN-1:23]= ctrl[`CTRL_LEN-1:23];
    assign CtrlOut[19:0] = ctrl[19:0];
    
    // update Tnew
    assign CtrlOut[22:20] = (ctrl[22:20] == 0) ? ctrl[22:20] : (ctrl[22:20] - 3'b1);
	 
    initial begin
        ins <= 0;
        pc <= 32'h0000_3000;
        ctrl <= {`CTRL_LEN{1'b0}};
    end
    
    always @(posedge Clk) begin
        if (Reset) begin
            ins <= 0;
            pc <= 32'h0000_3000;
            ctrl <= {`CTRL_LEN{1'b0}};
        end
		  else if (Stall || MDStall) begin
		      ins <= ins;
				pc <= pc;
				ctrl <= ctrl;
		  end
        else begin
            ins <= InsIn;
            pc <= PCIn;                   
            ctrl <= CtrlIn;
        end
    end

endmodule