module alu_control (
    input  wire [1:0] ALUOp,
    input  wire [2:0] funct3,
    input  wire [6:0] funct7,   // full funct7, but we'll usually just check bit 30
    output reg  [3:0] alu_ctrl
);
    always @(*) begin
        case (ALUOp)
            2'b00: alu_ctrl = 4'b0010;  // lw/sw/addi → ADD
            2'b01: alu_ctrl = 4'b0110;  // beq → SUB
            2'b10: begin                // R-type
                case ({funct7[5], funct3}) // key: bit 30 (sub) and funct3
                    4'b0000: alu_ctrl = 4'b0010; // ADD
                    4'b1000: alu_ctrl = 4'b0110; // SUB
                    4'b0111: alu_ctrl = 4'b0000; // AND
                    4'b0110: alu_ctrl = 4'b0001; // OR
                    4'b0010: alu_ctrl = 4'b0111; // SLT
                    default: alu_ctrl = 4'b1111; // invalid
                endcase
            end
            default: alu_ctrl = 4'b1111; // invalid
        endcase
    end
endmodule
