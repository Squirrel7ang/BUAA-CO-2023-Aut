`include "header.v"

module E_ALU(
    input   [31:0 ] A,
    input   [31:0 ] B,
    input   [ 3:0 ] ALUOp,
    
    output  [31:0 ] result
);
    wire slt = ($signed(A) < $signed(B));

    assign result = (ALUOp == `alu_add  )   ? A + B :
                    (ALUOp == `alu_sub  )   ? A - B :
						  (ALUOp == `alu_and  )   ? A & B :
						  (ALUOp == `alu_slt  )   ? slt   :
						  (ALUOp == `alu_sltu )   ? A < B :
                    (ALUOp == `alu_or   )   ? A | B :
						  (ALUOp == `alu_lui  )   ? {{B[15:0]}, {16'h0000}}:
                                              32'h0;



endmodule