`include "header.v"

module E_ALU(
    input   [31:0 ] A,
    input   [31:0 ] B,
    input   [ 3:0 ] ALUOp,
    
    output  [31:0 ] result
);

    assign result = (ALUOp == `alu_add  )   ? A + B :
                    (ALUOp == `alu_sub  )   ? A - B :
                    (ALUOp == `alu_or   )   ? A | B :
						  (ALUOp == `alu_lui  )   ? {{B[15:0]}, {16'h0000}}:
                                              32'h0;



endmodule