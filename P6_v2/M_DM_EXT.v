`include "header.v"
module M_DM_EXT(
    input  [1 :0 ]  Type,
	 input  [1 :0 ]  Addr,
    input  [31:0 ]  DIn,
    
    output [31:0 ]  DOut
);

wire [3:0] byte_en =(Type == `type_w && Addr == 2'b00) ? 4'b1111 :
                    (Type == `type_h && Addr[1] == 1'b0) ? 4'b0011 :
                    (Type == `type_h && Addr[1] == 1'b1) ? 4'b1100 :
                    (Type == `type_b && Addr == 2'b00) ? 4'b0001 :
                    (Type == `type_b && Addr == 2'b01) ? 4'b0010 :
                    (Type == `type_b && Addr == 2'b10) ? 4'b0100 :
                    (Type == `type_b && Addr == 2'b11) ? 4'b1000 :
                                                              4'b0x0x; // for debug

assign DOut = (byte_en == 4'b1111) ? DIn :
              (byte_en == 4'b0011) ? {{16{DIn[15]}}, DIn[15:0 ]} :
              (byte_en == 4'b1100) ? {{16{DIn[31]}}, DIn[31:16]} :
              (byte_en == 4'b1000) ? {{24{DIn[31]}}, DIn[31:24]} :
              (byte_en == 4'b0100) ? {{24{DIn[23]}}, DIn[23:16]} :
              (byte_en == 4'b0010) ? {{24{DIn[15]}}, DIn[15:8 ]} :
              (byte_en == 4'b0001) ? {{24{DIn[7 ]}}, DIn[7 :0 ]} :
                                    32'h0x0x_0x0x; // for debug

endmodule