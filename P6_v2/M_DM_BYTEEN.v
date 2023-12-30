`include "header.v"
module M_DM_BYTEEN(
    input           WE,
    input  [31:0 ]  Addr,
    input  [1 :0 ]  Type,

    output [3 :0 ]  EnCode
);
    assign EnCode = ~WE ? 4'b0000 :
                    (Type == `type_w) ? 4'b1111 :
                    (Type == `type_h && Addr[1:0] == 2'b00) ? 4'b0011 :
                    (Type == `type_h && Addr[1:0] == 2'b10) ? 4'b1100 :
                    (Type == `type_b && Addr[1:0] == 2'b00) ? 4'b0001 :
                    (Type == `type_b && Addr[1:0] == 2'b01) ? 4'b0010 :
                    (Type == `type_b && Addr[1:0] == 2'b10) ? 4'b0100 :
                    (Type == `type_b && Addr[1:0] == 2'b11) ? 4'b1000 :
                                                              4'b0x0x; // for debug


endmodule