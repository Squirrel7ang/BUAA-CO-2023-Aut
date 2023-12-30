`include "header.v"

module D_STALL(
    input  [ 2:0 ]  TUseRs,
    input  [ 4:0 ]  Rs,

    input  [ 2:0 ]  TUseRt,
    input  [ 4:0 ]  Rt,
    
    input  [ 2:0 ]  ETNew,
    input  [ 4:0 ]  ERegDst,
    input           EWriteRegEn,

    input  [ 2:0 ]  MTNew,
    input  [ 4:0 ]  MRegDst,
    input           MWriteRegEn,

    input           DEret,
    input           EWriteEPC,
    input           MWriteEPC,

    output          Stall
);
    wire stall_from_E = (EWriteRegEn && (Rs == ERegDst) && (TUseRs < ETNew))
                     || (EWriteRegEn && (Rt == ERegDst) && (TUseRt < ETNew));
    wire stall_from_M = (MWriteRegEn && (Rs == MRegDst) && (TUseRs < MTNew))
                     || (MWriteRegEn && (Rt == MRegDst) && (TUseRt < MTNew));
    wire stall_by_eret = (DEret && (EWriteEPC || MWriteEPC));

    assign Stall = (stall_from_E || stall_from_M || stall_by_eret);



endmodule