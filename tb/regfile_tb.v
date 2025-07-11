`timescale 1ns/1ps
module regfile_tb;
    reg clk, we;
    reg [4:0] rs1, rs2, rd;
    reg [31:0] wd;
    wire [31:0] rd1, rd2;

    // Instantiate the register file
    regfile uut (
        .clk(clk),
        .we(we),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .wd(wd),
        .rd1(rd1),
        .rd2(rd2)
    );

    // Clock generation: 10ns period
    always #5 clk = ~clk;

    initial begin
        $dumpfile("regfile_tb.vcd");
        $dumpvars(0, regfile_tb);

        clk = 0;
        we = 1;

        // Write 42 to x1
        rd = 5'd1;
        wd = 32'd42;
        #10;

        // Write 99 to x2
        rd = 5'd2;
        wd = 32'd99;
        #10;

        // Read from x1 and x2
        we = 0; // disable write
        rs1 = 5'd1;
        rs2 = 5'd2;
        #10;

        // Check x0 behavior (should always be 0)
        rs1 = 5'd0;
        #10;

        $finish;
    end

    initial begin
        $monitor("Time=%t | rs1=%0d->%0d | rs2=%0d->%0d", $time, rs1, rd1, rs2, rd2);
    end
endmodule
