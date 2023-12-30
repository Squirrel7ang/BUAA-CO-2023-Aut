`include "header.v"

module E_MDU(
    input Clk,
    input Reset,

    input  [31:0 ]  A,
    input  [31:0 ]  B,
    input  [3 :0 ]  MDType,
    input  [31:0 ]  CalTime,

    output [31:0 ]  HIOut,
    output [31:0 ]  LOOut,
    output          Start,
    output          Busy
);
    reg [31:0 ]  hi_reg, lo_reg;
	 reg [31:0] a_reg, b_reg;
     reg [3:0] type_reg;

    wire mult   = (MDType == `mdu_mult);
    wire multu  = (MDType == `mdu_multu);
    wire div    = (MDType == `mdu_div);
    wire divu   = (MDType == `mdu_divu);
    wire mflo   = (MDType == `mdu_mflo);
    wire mfhi   = (MDType == `mdu_mfhi);
    wire mtlo   = (MDType == `mdu_mtlo);
    wire mthi   = (MDType == `mdu_mthi);

    assign HIOut = hi_reg;
    assign LOOut = lo_reg;
    assign Start = (state == 0) && (mult || multu || div || divu);
    assign Busy = (state >= 1); 
    wire MDEn = (MDType != `mdu_none); 

    reg [31:0] state = 0;

    always @(posedge Clk) begin
        if (Reset) begin
            state <= 0;
            hi_reg <= 0;
            lo_reg <= 0;
            a_reg <= 0;
            b_reg <= 0;
            type_reg <= 0;
        end
        else begin
            if (state == 0) begin
                if (Start) begin
                    state <= CalTime;
                    a_reg <= A;
                    b_reg <= B;
                    type_reg <= MDType;
                end
                else begin
                    state <= 0;
                    if (mthi) begin
                        hi_reg <= A;
                    end
                    else if (mtlo) begin
                        lo_reg <= A;
                    end
                end
            end 
            else if (state == 1) begin
                state <= state - 1;
                if (type_reg == `mdu_mult) begin
                    {hi_reg, lo_reg} <= $signed(a_reg) * $signed(b_reg);
                end
                else if (type_reg == `mdu_multu) begin
                    {hi_reg, lo_reg} <= a_reg * b_reg;                
                end
                else if (type_reg == `mdu_div) begin
                    hi_reg <= $signed(a_reg) % $signed(b_reg);
                    lo_reg <= $signed(a_reg) / $signed(b_reg);
                end
                else if (type_reg == `mdu_divu) begin
                    hi_reg <= a_reg % b_reg;
                    lo_reg <= a_reg / b_reg;
                end
                else begin
                    hi_reg <= hi_reg;
                    lo_reg <= lo_reg;
                end
            end
            else 
                state <= state - 1;

        end

    end

endmodule