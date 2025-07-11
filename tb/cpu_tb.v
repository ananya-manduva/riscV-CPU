`timescale 1ns/1ps
module cpu_tb;
    reg clk;
    reg reset;

    cpu uut (
        .clk(clk),
        .reset(reset)
    );

    // Clock generator: 10ns period
    always #5 clk = ~clk;

    initial begin
        $dumpfile("cpu_tb.vcd");
        $dumpvars(0, cpu_tb);

        clk = 0;
        reset = 1;
        #10 reset = 0;

        // Run for 100 clock cycles
        repeat (100) begin
            #10;
        end

        $finish;
    end
endmodule
