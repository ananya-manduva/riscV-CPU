`timescale 1ns/1ps
module pc_tb;
    reg clk, reset;
    reg [31:0] pc_next;
    wire [31:0] pc_out;

    pc uut (.clk(clk), .reset(reset), .pc_next(pc_next), .pc_out(pc_out));

    initial begin
        $dumpfile("pc_tb.vcd");
        $dumpvars(0, pc_tb);

        clk = 0;
        reset = 1;
        pc_next = 32'h00000004;

        #10 reset = 0;    // Deassert reset
        #10 pc_next = 32'h00000008;
        #10 pc_next = 32'h0000000C;
        #10 $finish;
    end

    always #5 clk = ~clk;  // Clock generator (10 ns period)

    initial begin
        $monitor("Time = %t | PC = %h", $time, pc_out);
    end
endmodule
