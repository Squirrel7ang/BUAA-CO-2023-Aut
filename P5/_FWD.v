`include "header.v"

module _FWD(
    input  [ 4:0 ]  ThisRegAddr,
    input  [31:0 ]  ThisData,

    input  [ 4:0 ]  MRegAddr,
    input           MWriteRegEn,
    input  [31:0 ]  MData, 

    input  [ 4:0 ]  WRegAddr,
    input           WWriteRegEn,
    input  [31:0 ]  WData, 

    output [31:0 ]  Output
);
    wire fwd_from_M = MWriteRegEn && (MRegAddr == ThisRegAddr) && (ThisRegAddr != 0);
    wire fwd_from_W = WWriteRegEn && (WRegAddr == ThisRegAddr) && (ThisRegAddr != 0);

    assign Output = fwd_from_M ? MData      :
                    fwd_from_W ? WData      :
                                 ThisData;

endmodule