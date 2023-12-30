`include "header.v"

module D_GRF(
    input           Clk,
    input           Reset,
    input           WE,
    input   [ 4:0 ] A1,
    input   [ 4:0 ] A2,
    input   [ 4:0 ] WA,
    input   [31:0 ] WD,
    input   [31:0 ] PC,

    output  [31:0 ] Read1,
    output  [31:0 ] Read2
);
    reg [31:0 ] grf [31:0 ];

    assign Read1 = grf[A1];
    assign Read2 = grf[A2];

    integer i;
    initial begin
        for (i = 0; i < 32; i=i+1) begin
            grf[i] <= 32'b0;
        end
    end

    always @(posedge Clk) begin
        if (Reset) begin
            for (i = 0; i < 32; i=i+1) begin
                grf[i] <= 32'b0;
            end
        end
        else begin
            if (WE && WA) begin
                grf[WA] <= WD;
                $display("%d@%h: $%d <= %h", $time, PC, WA, WD);
            end
            else begin
                grf[0] <= 32'b0;
            end
        end
    end
endmodule