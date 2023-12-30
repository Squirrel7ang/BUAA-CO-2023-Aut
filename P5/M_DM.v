`include "header.v"
`define DM_END  32'h0c00

module M_DM(
    input           Clk,
    input           Reset,
    input           WE,
    input  [31:0 ]  Addr,
    input  [31:0 ]  Data,
    input  [ 1:0 ]  DataType,
	input  [31:0 ]  PC,

    output [31:0 ]  Out
);
    reg  [31:0 ] dm[0 : `DM_END];
    wire [31:0 ] Read;
    assign Read =   dm[Addr[13:2]];
    assign Out  =   (DataType == `type_b)   ?   {{24'b0}, {Read[ 7:0 ]}}    :
                    (DataType == `type_h)   ?   {{16'b0}, {Read[15:0 ]}}    :
                                                Read;

    integer i;
    initial begin
        for (i = 0; i < `DM_END; i=i+1) begin
            dm[i] <= 0;
        end
    end

    always @(posedge Clk) begin
        if (Reset) begin
            for (i = 0; i < `DM_END; i=i+1) begin
                dm[i] <= 0;
            end
        end
        else begin
            if (WE) begin
                case (DataType)
                    `type_b: begin
                        dm[Addr[13:2]][16 + 8 * Addr[1:0] +:16] <= Data[ 7:0];
                    end
                    `type_h: begin
                        dm[Addr[13:2]][8  + 8 * Addr[1:0] -:8 ] <= Data[15:0];
                    end
                    default: begin
                        dm[Addr[13:2]] <= Data;
                    end
                endcase
					 $display("%d@%h: *%h <= %h", $time, PC, Addr, Data);
            end
            else dm[0] <= dm[0];
        end
    end

endmodule