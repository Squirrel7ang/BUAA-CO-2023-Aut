module mips_tb(

);
    /* input */
    reg clk;
    reg rst;

    mips u_mips(
        .clk(clk),
        .reset(rst)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("test.vcd");
        $dumpvars;
        clk = 0;
        rst = 0;
        #2 rst = 1;
        #5 rst = 0;
        #1000;
        $finish;
    end
endmodule