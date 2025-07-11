module cpu (
    input wire clk,
    input wire reset
);
    // === PC ===
    wire [31:0] pc_out;
    wire [31:0] pc_plus_4 = pc_out + 4;
    wire [31:0] pc_branch = pc_out + imm;
    wire pc_src = Branch & alu_zero;
    wire [31:0] pc_jal = pc_out + imm;
    wire [31:0] pc_next = (Jump) ? pc_jal : (pc_src ? pc_branch : pc_plus_4);

    pc pc_inst (
        .clk(clk),
        .reset(reset),
        .pc_next(pc_next),
        .pc_out(pc_out)
    );

    // === Instruction Memory ===
    wire [31:0] instr;
    instr_mem instr_mem_inst (
        .addr(pc_out),
        .instr(instr)
    );

    // === Instruction Decode ===
    wire [6:0] opcode = instr[6:0];
    wire [2:0] funct3 = instr[14:12];
    wire [6:0] funct7 = instr[31:25];
    wire [4:0] rs1 = instr[19:15];
    wire [4:0] rs2 = instr[24:20];
    wire [4:0] rd  = instr[11:7];

    // === Control Signals ===
    wire RegWrite, MemRead, MemWrite, ALUSrc, MemToReg, Branch, Jump;
    wire [1:0] ALUOp;

    control control_inst (
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

    // === Register File ===
    wire [31:0] rd1, rd2, write_data;

    regfile regfile_inst (
        .clk(clk),
        .we(RegWrite),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .wd(write_data),
        .rd1(rd1),
        .rd2(rd2)
    );

    // === Immediate Generator ===
    wire [31:0] imm;
    imm_gen imm_gen_inst (
        .instr(instr),
        .imm(imm)
    );

    // === ALU Control ===
    wire [3:0] alu_ctrl;

    alu_control alu_control_inst (
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .alu_ctrl(alu_ctrl)
    );

    // === ALU ===
    wire [31:0] alu_src_b = (ALUSrc) ? imm : rd2;
    wire [31:0] alu_result;
    wire alu_zero;

    alu alu_inst (
        .a(rd1),
        .b(alu_src_b),
        .alu_ctrl(alu_ctrl),
        .result(alu_result),
        .zero(alu_zero)
    );

    // === Data Memory ===
    wire [31:0] mem_data_out;

    data_mem data_mem_inst (
        .clk(clk),
        .addr(alu_result),
        .write_data(rd2),
        .mem_read(MemRead),
        .mem_write(MemWrite),
        .read_data(mem_data_out)
    );

    // === Write Back MUX ===
    wire [31:0] write_back_pre = (MemToReg) ? mem_data_out : alu_result;
    wire [31:0] write_back = (Jump) ? pc_plus_4 : write_back_pre;

    // Connect write_back to regfile
    assign regfile_inst.wd = write_back;

    // === Branch & Jump PC Logic ===
    wire take_branch = Branch && alu_zero;
    wire [31:0] pc_branch = pc_out + imm;       // For beq/bne
    wire [31:0] pc_jump = pc_out + imm;         // For jal
    wire [31:0] pc_jalr = (rd1 + imm) & ~32'b1; // For jalr

    assign pc_next =
        (Jump && opcode == 7'b1100111) ? pc_jalr   : // jalr
        (Jump && opcode == 7'b1101111) ? pc_jump   : // jal
        (take_branch)                  ? pc_branch :
                                         pc_out + 4;

    always @(posedge clk) begin
    $display("PC=%h | instr=%h | rd1=%h | rd2=%h | imm=%h | alu_result=%h | wd=%h",
             pc_out, instr, rd1, rd2, imm, alu_result, write_data);
    end

endmodule
