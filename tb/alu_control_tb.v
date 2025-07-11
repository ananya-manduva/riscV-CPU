`timescale 1ns/1ps
module alu_control_tb;
    reg [1:0] ALUOp;
    reg [2:0] funct3;
    reg [6:0] funct7;
    wire [3:0] alu_ctrl;

    alu_control uut (
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .alu_ctrl(alu_ctrl)
    );

    initial begin
        $dumpfile("alu_control_tb.vcd");
        $dumpvars(0, alu_control_tb);

        // ADDI (I-type, ALUOp = 00 → always ADD)
        ALUOp = 2'b00; funct3 = 3'b000; funct7 = 7'b0000000; #10;

        // BEQ (branch, ALUOp = 01 → always SUB)
        ALUOp = 2'b01; funct3 = 3'b000; funct7 = 7'b0000000; #10;

        // R-type ADD (funct3=000, funct7=0000000)
        ALUOp = 2'b10; funct3 = 3'b000; funct7 = 7'b0000000; #10;

        // R-type SUB (funct3=000, funct7=0100000 → bit 5 = 1)
        ALUOp = 2'b10; funct3 = 3'b000; funct7 = 7'b0100000; #10;

        // R-type AND (funct3=111)
        ALUOp = 2'b10; funct3 = 3'b111; funct7 = 7'b0000000; #10;

        // R-type OR (funct3=110)
        ALUOp = 2'b10; funct3 = 3'b110; funct7 = 7'b0000000; #10;

        // R-type SLT (funct3=010)
        ALUOp = 2'b10; funct3 = 3'b010; funct7 = 7'b0000000; #10;

        $finish;
    end

    initial begin
        $monitor("Time=%t | ALUOp=%b | funct7=%b | funct3=%b | alu_ctrl=%b",
                 $time, ALUOp, funct7, funct3, alu_ctrl);
    end
endmodule
