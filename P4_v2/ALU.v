`include "header.v"

module ALU(
    input [31:0] A,
    input [31:0] B,
    input [ 3:0] ALUOp,
    
    output [31:0] Result,
    output ZF
);
    wire add = (ALUOp == `alu_add);
    wire sub = (ALUOp == `alu_sub);
    wire or_ = (ALUOp == `alu_or );
    wire lui = (ALUOp == `alu_lui);
    assign Result = add ? A + B     :
                    sub ? A - B     :
                    or_ ? A | B     :
                    lui ? B << 16   :
                          32'b0; // default add
    assign ZF = (Result == 0);

endmodule