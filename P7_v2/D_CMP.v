`include "header.v"

module D_CMP(
    input  [31:0 ]  Rd1,
    input  [31:0 ]  Rd2,
    input  [ 3:0 ]  CmpOp,

    output          Flag
);
    wire beq  = (CmpOp == `cmp_beq );
    wire bne  = (CmpOp == `cmp_bne );
    wire bgez = (CmpOp == `cmp_bgez);
    wire bgtz = (CmpOp == `cmp_bgtz);
    wire bltz = (CmpOp == `cmp_bltz);
    wire blez = (CmpOp == `cmp_blez);

    assign Flag = beq  ? ((Rd1 ^ Rd2) == 0) :
                  bne  ? ((Rd1 ^ Rd2) != 0) :
                  bgez ? ( Rd1        >= 0) :
                  bgtz ? ( Rd1        >  0) :
                  blez ? ( Rd1        <= 0) :
                  bltz ? ( Rd1        <  0) :
                         0;




endmodule