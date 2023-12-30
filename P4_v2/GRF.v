`include "header.v"

module GRF(
    input Clk,
    input Reset,
    input WE,
    input [ 4:0 ] A1,
    input [ 4:0 ] A2,
    input [ 4:0 ] A3,
    input [31:0 ] WD,
	 input [31:0 ] PC,

    output [31:0 ] RD1,
    output [31:0 ] RD2
);
    reg [31:0 ] grf[31:0 ];

    assign RD1 = grf[A1];
    assign RD2 = grf[A2];

    integer i;
    initial begin
        for (i = 0; i < 32; i=i+1) begin
            grf[i] <= 0;
        end
    end

    always @(posedge Clk) begin
        if (Reset) begin
            for (i = 0; i < 32; i=i+1) begin
                grf[i] <= 0;
            end
        end
        else begin
            if (WE && (A3 != 5'd0)) begin
				    $display("@%h: $%d <= %h", PC, A3, WD);
                grf[A3] <= WD;
            end
            else grf[0] <= 0;
        end
    end

endmodule