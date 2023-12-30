`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:12:16 10/12/2023 
// Design Name: 
// Module Name:    BlockChecker 
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
module BlockChecker(
    input clk,
    input reset,
    input [7:0]in,
    output result
);
reg [31:0]cnt;
reg [7:0] b6, b5, b4, b3, b2, b1, b0;
reg [1:0] flag;/*   
                 00: normal
                 01: read " end"  when cnt is 8'h00
                 10: read " end " when cnt is 8'h00
                 */
wire start  = ((b5 == " " || b5 == 8'h00)
           && (b4 == "B" || b4 == "b")
           && (b3 == "E" || b3 == "e")
           && (b2 == "G" || b2 == "g")
           && (b1 == "I" || b1 == "i")
           && (b0 == "N" || b0 == "n")) ? 1'b1 : 1'b0;
wire start_n  = ((b6 == " " || b6 == 8'h00)
             && (b5 == "B" || b5 == "b")
             && (b4 == "E" || b4 == "e")
             && (b3 == "G" || b3 == "g")
             && (b2 == "I" || b2 == "i")
             && (b1 == "N" || b1 == "n")
             && (b0 != " ")) ? 1'b1 : 1'b0;
wire finish = ((b3 == " " || b3 == 8'h00)
           && (b2 == "E" || b2 == "e")
           && (b1 == "N" || b1 == "n")
           && (b0 == "D" || b0 == "d")) ? 1'b1 : 1'b0;
wire finish_n = ((b4 == " " || b4 == 8'h00)
             && (b3 == "E" || b3 == "e")
             && (b2 == "N" || b2 == "n")
             && (b1 == "D" || b1 == "d")             
             && (b0 != " ")) ? 1'b1 : 1'b0;

initial begin
    cnt <= 1'b0;
    flag <= 2'b00;
    b6 <= 8'h00;
    b5 <= 8'h00;
    b4 <= 8'h00;
    b3 <= 8'h00;
    b2 <= 8'h00;
    b1 <= 8'h00;
    b0 <= 8'h00;
end

assign result = (cnt == 0 && flag == 0) ? 1'b1 : 1'b0;

//  state transition
always @(posedge clk or reset) begin
    if (reset == 1) begin
        b6 = 8'h00;
        b5 = 8'h00;
        b4 = 8'h00;
        b3 = 8'h00;
        b2 = 8'h00;
        b1 = 8'h00;
        b0 = 8'h00;
        cnt = 32'h0;
        flag = 2'b0;
    end
    else if (clk == 1) begin
		  b6 = b5;
 		  b5 = b4;
 		  b4 = b3;
		  b3 = b2;
		  b2 = b1;
		  b1 = b0;
		  b0 = in;
	 end
	 else begin
        b6 = b6;
        b5 = b5;
        b4 = b4;
        b3 = b3;
        b2 = b2;
        b1 = b1;
        b0 = b0;
     end
end

always @(input) begin
    if (cnt == 32'b0 && flag == 0) begin
        if (finish == 1'b1) 
            flag <= 2'b01;
        else if (start == 1'b1 || finish_n == 1'b1)
            cnt <= cnt + 32'b1;
    end
    else if (cnt == 32'b0 && flag == 1)begin
        if (finish_n == 1'b1) 
            flag <= 0;
        else 
            flag <= 2;
    end
    else if (cnt != 32'b0 && flag == 0) begin
        if (start == 1'b1 || finish_n == 1'b1)
            cnt <= cnt + 32'b1;
        else if (start_n == 1'b1 || finish == 1'b1)
            cnt <= cnt - 32'b1;
		  else 
			   cnt <= cnt;
    end
    else begin
        cnt <= cnt;
        flag <= flag;
    end
end

// assign result = (flag == 2'b00 && cnt == 32'b0) ? 1'b1 : 1'b0;

// always @(posedge clk) begin
// 	 b6 = b5;
// 	 b5 = b4;
// 	 b4 = b3;
// 	 b3 = b2;
// 	 b2 = b1;
// 	 b1 = b0;
// 	 b0 = in;
// end

// always @(posedge clk or posedge reset) begin
//     if (reset == 1'b1) begin
//         cnt <= 1'b0;
//         flag <= 2'b00;
// 		  b6 <= 8'h00;
//         b5 <= 8'h00;
//         b4 <= 8'h00;
//         b3 <= 8'h00;
//         b2 <= 8'h00;
//         b1 <= 8'h00;
//         b0 <= 8'h00;
//     end
//     else begin
//         if (cnt == 32'b0 && finish == 1'b1) begin
//             cnt <= cnt - 32'b1;
//             flag <= 2'b01;
//         end
//         else if (flag == 2'b01 && finish_n == 1'b1) begin
//             flag <= 2'b00;
//             cnt <= 32'b0;
//         end
// 		  else if (flag == 2'b01)
//             flag <= 2'b10;
//         else if (flag == 2'b10) 
//             flag <= 2'b10;
//         else if (start == 1'b1) 
//             cnt <= cnt + 32'b1;
//         else if (finish == 1'b1)
//             cnt <= cnt - 32'b1;
//         else if (start_n == 1'b1)
//             cnt <= cnt - 32'b1;
//         else if (finish_n == 1'b1)
//             cnt <= cnt + 32'b1;
//         else
//             cnt <= cnt; 
//     end
// end

// assign result = (cnt == 32'h0000_0000) ? 1'b1 : 1'b0;
endmodule
