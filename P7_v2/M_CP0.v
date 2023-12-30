`include "header.v"

module M_CP0(
    input           Clk,
    input           Reset,
    input           WE,
    input           BDIn,
    input           EXLClr,
    input  [5 : 0]  HWInt,

    input  [4 : 0]  CP0Add,
    input  [31: 0]  CP0In,
    input  [31: 0]  VPC,
    input  [4 : 0]  ExcCodeIn,
    
    output [31: 0]  EPCOut,
    output [31: 0]  CP0Out,
    output          Req
);
    /****** Output ******/
    assign Req = exc || int;
    assign EPCOut = epc;
    assign CP0Out = (CP0Add == `cp0_sr)     ? sr :
                    (CP0Add == `cp0_cause)  ? cause :
                    (CP0Add == `cp0_epc)    ? epc :
                                            32'h0x0x_x0x0;

    /****** Main ******/
    reg [31:0] sr, cause, epc;

    wire int = (!exl) && (ie) && ((HWInt & im) != 0);
    wire exc = (!int) && ((ExcCodeIn == 5'd4) || (ExcCodeIn == 5'd5)
                        ||(ExcCodeIn == 5'd8) || (ExcCodeIn == 5'd10) || (ExcCodeIn == 5'd12));

    wire ie = sr[0]; // sr[0] can only be modified though mtc0 instruction
    wire exl = sr[1]; //set 1 to ignore any interrupt
    wire [5:0] im = sr[15:10];

    // wire bd = cause[31];
    // wire [5:0] ip = cause[15:10];
    // wire [4:0] exc_code = cause[6:2];

    // wire int  = (exc_code == `exc_int );
    // wire adel = (exc_code == `exc_adel);
    // wire ades = (exc_code == `exc_ades);
    // wire syscall = (exc_code == `exc_syscall);
    // wire ri = (exc_code == `exc_ri );
    // wire ov = (exc_code == `exc_ov);
    
    initial begin
        sr <= 0;
        cause <= 0;
        epc <= 0;
    end

    always @(posedge Clk) begin
        if (Reset) begin
            sr <= 0;
            cause <= 0;
            epc <= 0;
        end // end of reset
        else if (exc || int) begin
            if (int) begin
                sr[0] <= sr[0]; // remains the same
                sr[1] <= 1;
                sr[15:10] <= sr[15:10];
                cause[6 : 2] <= `exc_int; // in case of accident. use "cause[6:2] <= ExcCode" to debug
                cause[31] <= BDIn;
                epc <= VPC; // VPC is modified outside EPC

                sr[31:16] <= 0; sr[9:2] <= 0; // the rest is set to 0
            end // interrupt has higher priority
            else if (exc) begin
                sr[0] <= sr[0]; // ??????
                sr[1] <= 1;
                sr[15:10] <= sr[15:10]; // ??????
                cause[6 : 2] <= ExcCodeIn;
                cause[31] <= BDIn;
                epc <= VPC; // VPC is modified outside EPC

                sr[31:16] <= 0; sr[9:2] <= 0; // the rest is set to 0;
            end
            cause[15:10]<= HWInt;
        end // end of exc || int
        else if (WE) begin
            if (CP0Add == `cp0_sr) begin
                sr[15:10] <= CP0In[15:10];
                sr[1]     <= CP0In[1]; // this shouldn't be modified by programmer
                sr[0]     <= CP0In[0];
                sr[31:16] <= 0;
                sr[9 : 2] <= 0;
            end
            else if (CP0Add == `cp0_cause) begin
				// cause register cannot be modified
            end
            else if (CP0Add == `cp0_epc) begin
                epc <= CP0In;
            end
            else begin

            end
            cause[15:10]<= HWInt;
        end // end of WE
        else begin
            sr[1] <= (EXLClr) ? 0 : sr[1];
            cause[15:10]<= HWInt;
        end
    end // end of alwaus block

endmodule