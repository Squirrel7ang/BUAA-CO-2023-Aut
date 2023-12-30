`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:55:36 10/11/2023 
// Design Name: 
// Module Name:    expr 
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
/*
module expr (
        input clk,
        input clr,
        input [7:0] in,
        output out
    );

    localparam [1:0] s0 = 2'b00, //  no input
                     s1 = 2'b01, // digit input
                     s2 = 2'b10, // sign input
                     s3 = 2'b11; // wrong input
    reg [1:0] state;
	 
	 initial begin
		  state <= 2'b00;
	 end
	 
	 assign out = (clr == 1) ? 1'b0 : 
					  (state == s1) ? 1'b1 :
					  1'b0;
    always @(posedge clk or posedge clr) begin
		  state <= (clr == 1'b1) ? 2'b00 :
					  (state == s0 && in >= "0" && in <= "9") ? s1 :
					  (state == s1 && in == "+" || in == "*") ? s2 :
					  (state == s2 && in >= "0" && in <= "9") ? s1 :
					  s3;
    end

endmodule
*/
module expr (
        input clk,
        input clr,
        input [7:0] in,
        output reg out
    );

    localparam [1:0] s0 = 2'b00, //  no input
                     s1 = 2'b01, // digit input
                     s2 = 2'b10, // sign input
                     s3 = 2'b11; // wrong input
	 reg [1:0] state;
    initial begin
        state <= 2'b00;
		  out <= 1'b0;
    end

    always @(posedge clk or posedge clr) begin
		state <= (clr == 1'b1) ? 2'b00 :
				 (state == s0 && in >= "0" && in <= "9") ? s1 :
				 (state == s1 && in == "+" || in == "*") ? s2 :
			     (state == s2 && in >= "0" && in <= "9") ? s1 :
				 s3;
        out <= (clr == 1'b1) ? 1'b0 :
               ((state == s2 || state == s0) && in >= "0" && in <= "9") ? 1'b1 :
               1'b0;
    end
endmodule
