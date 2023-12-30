`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:53:56 10/11/2023 
// Design Name: 
// Module Name:    gray 
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
module gray (
        input Clk,
        input Reset,
        input En,
        output reg [2:0] Output,
        output reg Overflow
    );
	 initial begin
		  Output <= 3'b0;
		  Overflow <= 1'b0;
	 end

    always @(posedge Clk) begin
        if (Reset == 1'b1) begin
            Output <= 3'b000;
				Overflow <= 1'b0;
		  end
        else if (En == 1'b1) begin
            case (Output)
                3'b000: begin
                    Output <= 3'b001;
                end
                3'b001: begin
                    Output <= 3'b011;
                end
                3'b011: begin
                    Output <= 3'b010;
                end
                3'b010: begin
                    Output <= 3'b110;
                end
                3'b110: begin
                    Output <= 3'b111;
                end
                3'b111: begin
                    Output <= 3'b101;
                end
                3'b101: begin
                    Output <= 3'b100;
                end
                default: begin
                    Output <= 3'b000;
						  Overflow <= 1'b1;
                end
            endcase
        end
		  else
				Output <= Output;
    end
    
endmodule
