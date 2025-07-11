`timescale 1ns/1ps
module data_mem_tb;
    reg clk;
    reg MemRead, MemWrite;
    reg [31:0] addr;
    reg [31:0] write_data;
    wire [31:0] read_data;

    data_mem uut (
        .clk(clk),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .addr(addr),
        .write_data(write_data),
        .read_data(read_data)
    );

    // Clock generator: 10ns period
    always #5 clk = ~clk;

    initial begin
        $dumpfile("data_mem_tb.vcd");
        $dumpvars(0, data_mem_tb);

        clk = 0;

        // === Write to addr 0x00 ===
        MemRead = 0;
        MemWrite = 1;
        addr = 32'h00000000;
        write_data = 32'hdeadbeef;
        #10; // rising edge for write

        // === Write to addr 0x04 ===
        addr = 32'h00000004;
        write_data = 32'h12345678;
        #10;

        // === Read back from addr 0x00 ===
        MemWrite = 0;
        MemRead = 1;
        addr = 32'h00000000;
        #1;
        $display("Read from 0x00: %h", read_data);

        // === Read back from addr 0x04 ===
        addr = 32'h00000004;
        #1;
        $display("Read from 0x04: %h", read_data);

        // === Try reading from unused addr 0x08 ===
        addr = 32'h00000008;
        #1;
        $display("Read from 0x08: %h", read_data);

        $finish;
    end
endmodule
