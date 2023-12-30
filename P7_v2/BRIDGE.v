`include "header.v"

module BRIDGE(
    /*** for CPU ***/
    input  [31: 0]  AddrIn,
    input  [31: 0]  DataIn,
    input  [3 : 0]  ByteEn,
    output [31: 0]  TimerOut,
    output          TimerIRQOut0,
    output          TimerIRQOut1,

    /*** for Timer ***/
    output          TimerWrite0,
    output          TimerWrite1,
    output [31: 0]  DataOut,
    output [31: 0]  AddrOut,
    input  [31: 0]  TimerIn0,
    input  [31: 0]  TimerIn1,
    input           TimerIRQIn0,
    input           TimerIRQIn1
);
    /****** for Timer ******/
    assign TimerWrite0 = (AddrIn == `timer0_begin || AddrIn == `timer0_begin + 4) && (ByteEn == 4'b1111);
    assign TimerWrite1 = (AddrIn == `timer1_begin || AddrIn == `timer1_begin + 4) && (ByteEn == 4'b1111);
    assign DataOut = DataIn;
    assign AddrOut = AddrIn;
    
    /****** for CPU ******/
    assign TimerOut = (AddrIn == `timer0_begin || AddrIn == `timer0_begin + 4) ? TimerIn0 :
                      (AddrIn == `timer1_begin || AddrIn == `timer1_begin + 4) ? TimerIn1 :
                                                  4'b0x0x;
    assign TimerIRQOut0 = TimerIRQIn0;
    assign TimerIRQOut1 = TimerIRQIn1;

endmodule

// module BRIDGE(
//     input  [31: 0]  AddrIn,
//     input  [31: 0]  DataIn,
//     input  [3 : 0]  ByteEnIn, // 4'b0000 if illegal address input(realized in mips.v).
//     input  [31: 0]  PCIn,
//     output [31: 0]  Rdata,
//     output          TimerIRQOut0,
//     output          TimerIRQOut0,

//     output [31: 0]  DMAddrOut,
//     output [31: 0]  DMDataOut,
//     output [3 : 0]  DMByteEnOut,
//     input  [31: 0]  DMDataIn,

//     output [31: 0]  TimerAddrOut0,
//     output [31: 0]  TimerDataOut0,
//     output [3 : 0]  TimerByteEnOut0,
//     input  [31: 0]  TimerDataIn0,
//     input           TimerIRQIn0,

//     output [31: 0]  TimerAddrOut0,
//     output [31: 0]  TimerDataOut0,
//     output [3 : 0]  TimerByteEnOut0,
//     input  [31: 0]  TimerDataIn0,
//     input           TimerIRQIn0,

//     output [31: 0]  PCOut
// );
//     wire dm_en = (AddrIn >= `dm_begin) && (AddrIn <= `dm_end);
//     assign DMAddrOut = AddrIn;
//     assign DMDataOut = DataIn;
//     assign DMByteEnOut = 

// endmodule