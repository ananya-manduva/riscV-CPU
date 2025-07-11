`timescale 1ns/1ps
module alu_tb;
    reg [31:0] a, b;
    reg [3:0] alu_ctrl;
    wire [31:0] result;
    wire zero;

    // Instantiate ALU
    alu uut (
        .a(a),
        .b(b),
        .alu_ctrl(alu_ctrl),
        .result(result),
        .zero(zero)
    );

    initial begin
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, alu_tb);

        a = 10; b = 5;

        alu_ctrl = 4'b0010; // ADD
        #10;

        alu_ctrl = 4'b0110; // SUB
        #10;

        alu_ctrl = 4'b0000; // AND
        #10;

        alu_ctrl = 4'b0001; // OR
        #10;

        alu_ctrl = 4'b0111; // SLT (a < b → false)
        #10;

        a = 3; b = 9;        // Check SLT true case
        alu_ctrl = 4'b0111;
        #10;

        a = 42; b = 42;      // Check zero output
        alu_ctrl = 4'b0110;  // SUB → result should be 0, zero should be 1
        #10;

        $finish;
    end

    initial begin
        $monitor("Time=%t | ctrl=%b | a=%0d | b=%0d | result=%0d | zero=%b",
                 $time, alu_ctrl, a, b, result, zero);
    end
endmodule
