module alu (
    input wire [31:0] a, b,
    input wire [3:0] alu_ctrl,   // Control signal (e.g., ADD, SUB)
    output reg [31:0] result,
    output wire zero             // True if result == 0
);
    always @(*) begin
        case (alu_ctrl)
            4'b0000: result = a & b; // AND
            4'b0001: result = a | b; // OR
            4'b0010: result = a + b; // ADD
            4'b0110: result = a - b; // SUB
            4'b0111: result = (a < b) ? 32'b1 : 32'b0; // SLT
            default: result = 32'b0;
        endcase
    end

    assign zero = (result == 0);
endmodule
