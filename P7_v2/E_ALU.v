`include "header.v"

module E_ALU(
    input   [31:0 ] A,
    input   [31:0 ] B,
    input   [ 3:0 ] ALUOp,
    
    output  [31:0 ] Result,
    output Overflow
);
    wire slt = ($signed(A) < $signed(B));
    wire [32: 0] _A = {A[31], A};
    wire [32: 0] _B = {B[31], B};
    wire [32: 0] add = _A + _B;
    wire [32: 0] sub = _A - _B;
    assign Overflow = (ALUOp == `alu_add  ) ? add[32] != add[31] :
                    (ALUOp == `alu_sub  ) ? sub[32] != sub[31] :
                    0;

    assign Result = (ALUOp == `alu_none )   ? 32'd0 :
                    (ALUOp == `alu_add  )   ? A + B :
                    (ALUOp == `alu_sub  )   ? A - B :
                    (ALUOp == `alu_and  )   ? A & B :
                    (ALUOp == `alu_slt  )   ? slt   :
                    (ALUOp == `alu_sltu )   ? A < B :
                    (ALUOp == `alu_or   )   ? A | B :
                    (ALUOp == `alu_lui  )   ? {{B[15:0]}, {16'h0000}}:
                                              32'h0;



endmodule