`timescale 1ns/1ps
module imm_gen_tb;
    reg [31:0] instr;
    wire [31:0] imm;

    imm_gen uut (
        .instr(instr),
        .imm(imm)
    );

    initial begin
        $dumpfile("imm_gen_tb.vcd");
        $dumpvars(0, imm_gen_tb);

        // I-type: addi x1, x2, -5 → imm = 0xFFFFFFFB
        instr = 32'b111111111011_00010_000_00001_0010011;
        #10;

        // S-type: sw x3, -8(x1) → imm = 0xFFFFFFF8
        instr = 32'b1111111_00011_00001_010_00000_0100011;
        #10;

        // B-type: beq x1, x2, -4 → imm = 0xFFFFFFFC
        instr = 32'b11111100000000010000110111100011;  // -4 offset
        #10;

        // U-type: lui x1, 0x12345 → imm = 0x12345000
        instr = 32'b00010010001101000101_00001_0110111;
        #10;

        // J-type: jal x1, -8 → imm = 0xFFFFFFF8
        instr = 32'b1_11111111_0_1111111100_00001_1101111;
        #10;

        $finish;
    end

    initial begin
        $monitor("Time=%t | Instr=%b | Imm=%h", $time, instr, imm);
    end
endmodule
