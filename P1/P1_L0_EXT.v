`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:51:49 10/11/2023 
// Design Name: 
// Module Name:    exp 
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
module ext (
    input [15:0] imm,
    input EOp[1:0],
    output ext[31:0]
);

assign ext = EOp == 2'b00 ? {{16{imm[15]}}, imm} :
             EOp == 2'b01 ? {16'h0000, imm} :
             EOp == 2'b10 ? {imm, 16'h0000} :
             {{14{imm[15]}}, imm, 2'b00};

    
endmodule
