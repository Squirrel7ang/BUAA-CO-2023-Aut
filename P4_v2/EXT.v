`include "header.v"

module EXT(
    input [15:0] In,
    input ExtOp,

    output [31:0] Out
);
    assign Out = ExtOp ? {{16{In[15]}}, {In}}: {{16'b0}, {In}};

endmodule