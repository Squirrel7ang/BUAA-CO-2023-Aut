`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:56:40 10/11/2023 
// Design Name: 
// Module Name:    ALU 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module alu (
    input [31:0] A,
    input [31:0] B,
    input [2:0]  ALUOp,
    output [31:0] C
    );
    // always @(*) begin
    //     case(ALUOp) 
    //         3'b000: C = A + B;
    //         3'b001: C = A - B;
    //         3'b010: C = A & B;
    //         3'b011: C = A | B;
    //         3'b100: C = A >> B;
    //         default : C = $signed(A) >>> 2;
    //     endcase
    // end
    wire [31:0] tmp;
    assign tmp = $signed(A) >>> B;
    assign C = (ALUOp == 3'b000) ? A + B :
               (ALUOp == 3'b001) ? A - B :
               (ALUOp == 3'b010) ? A & B :
               (ALUOp == 3'b011) ? A | B :
               (ALUOp == 3'b100) ? A >> B :
               tmp;


endmodule
