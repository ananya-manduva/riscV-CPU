module control (
    input wire [6:0] opcode,
    output reg RegWrite,
    output reg MemRead,
    output reg MemWrite,
    output reg ALUSrc,
    output reg MemToReg,
    output reg Branch,
    output reg Jump,
    output reg [1:0] ALUOp
);
    always @(*) begin
        // Default values
        RegWrite  = 0;
        MemRead   = 0;
        MemWrite  = 0;
        ALUSrc    = 0;
        MemToReg  = 0;
        Branch    = 0;
        Jump      = 0;
        ALUOp     = 2'b00;

        case (opcode)
            // R-type: add, sub, and, or, etc.
            7'b0110011: begin
                RegWrite  = 1;
                ALUSrc    = 0;
                ALUOp     = 2'b10;
            end

            // I-type: addi, lw, jalr
            7'b0010011: begin
                RegWrite  = 1;
                ALUSrc    = 1;
                ALUOp     = 2'b00;
            end

            // Load: lw
            7'b0000011: begin
                RegWrite  = 1;
                MemRead   = 1;
                ALUSrc    = 1;
                MemToReg  = 1;
                ALUOp     = 2'b00;
            end

            // Store: sw
            7'b0100011: begin
                MemWrite  = 1;
                ALUSrc    = 1;
                ALUOp     = 2'b00;
            end

            // Branch: beq, bne
            7'b1100011: begin
                Branch    = 1;
                ALUOp     = 2'b01;
            end

            // Jump (jal)
            7'b1101111: begin
                RegWrite  = 1;
                Jump      = 1;
            end

            // Jump-register (jalr)
            7'b1100111: begin
                RegWrite  = 1;
                Jump      = 1;
                ALUSrc    = 1;
            end

            // LUI / AUIPC
            7'b0110111, 7'b0010111: begin
                RegWrite  = 1;
                ALUSrc    = 1;
            end
        endcase
    end
endmodule
