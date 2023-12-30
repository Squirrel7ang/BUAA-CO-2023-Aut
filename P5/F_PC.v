`include "header.v"

module F_PC(
    input Clk,
    input Reset,    
    input  [31:0 ]  NPC,
    
    output [31:0 ]  PC
);
    reg [31:0 ] pc;
    assign PC = pc;

    initial begin
        pc <= 32'h0000_3000;
    end

    always @(posedge Clk) begin
        if (Reset) begin
            pc <= 32'h0000_3000;
        end
        else begin
            pc <= NPC;
        end
    end


endmodule