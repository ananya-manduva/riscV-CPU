module data_mem (
    input wire clk,
    input wire MemRead,
    input wire MemWrite,
    input wire [31:0] addr,
    input wire [31:0] write_data,
    output wire [31:0] read_data
);
    reg [31:0] memory [0:255]; // 1KB of memory

    // // Optional: preload memory from file
    // initial begin
    //     $readmemh("data.hex", memory);
    // end

    // Read (asynchronous)
    assign read_data = (MemRead) ? memory[addr[9:2]] : 32'b0;

    // Write (on positive edge of clk)
    always @(posedge clk) begin
        if (MemWrite)
            memory[addr[9:2]] <= write_data;
    end
endmodule
