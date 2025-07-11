`timescale 1ns/1ps
module control_tb;
    reg [6:0] opcode;
    wire RegWrite, MemRead, MemWrite, ALUSrc, MemToReg, Branch, Jump;
    wire [1:0] ALUOp;

    control uut (
        .opcode(opcode),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .MemToReg(MemToReg),
        .Branch(Branch),
        .Jump(Jump),
        .ALUOp(ALUOp)
    );

    initial begin
        $dumpfile("control_tb.vcd");
        $dumpvars(0, control_tb);

        // R-type: add
        opcode = 7'b0110011; #10;

        // I-type: addi
        opcode = 7'b0010011; #10;

        // Load: lw
        opcode = 7'b0000011; #10;

        // Store: sw
        opcode = 7'b0100011; #10;

        // Branch: beq
        opcode = 7'b1100011; #10;

        // Jump: jal
        opcode = 7'b1101111; #10;

        // Jump-register: jalr
        opcode = 7'b1100111; #10;

        // U-type: lui
        opcode = 7'b0110111; #10;

        $finish;
    end

    initial begin
        $monitor("Time=%t | opcode=%b | RegWrite=%b MemRead=%b MemWrite=%b ALUSrc=%b MemToReg=%b Branch=%b Jump=%b ALUOp=%b",
                 $time, opcode, RegWrite, MemRead, MemWrite, ALUSrc, MemToReg, Branch, Jump, ALUOp);
    end
endmodule
