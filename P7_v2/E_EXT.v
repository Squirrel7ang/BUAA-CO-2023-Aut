`include "header.v"

module E_EXT(
    input   [15:0 ] ExtIn ,
    input           ExtOp ,

    output  [31:0 ] ExtOut
);
    assign ExtOut = (ExtOp == `ext_sign) ? {{16{ExtIn[15]}}, ExtIn} : 
                                           {{16'b0}, ExtIn};

endmodule