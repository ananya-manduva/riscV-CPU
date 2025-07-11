module instr_mem (
    input wire [31:0] addr,
    output wire [31:0] instr
);
    reg [31:0] memory [0:255]; // 256 x 32-bit instructions

    initial begin
        $readmemh("program.hex", memory); // Use a hex file with instructions
    end

    assign instr = memory[addr[9:2]]; // addr must be word-aligned
endmodule
