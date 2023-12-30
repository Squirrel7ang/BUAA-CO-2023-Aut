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

    output          Stall
);
    wire stall_from_E = (EWriteRegEn && (Rs == ERegDst) && (TUseRs < ETNew))
                     || (EWriteRegEn && (Rt == ERegDst) && (TUseRt < ETNew));
    wire stall_from_M = (MWriteRegEn && (Rs == MRegDst) && (TUseRs < MTNew))
                     || (MWriteRegEn && (Rt == MRegDst) && (TUseRt < MTNew));

    assign Stall = (stall_from_E || stall_from_M);



endmodule