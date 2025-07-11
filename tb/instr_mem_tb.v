`timescale 1ns/1ps
module instr_mem_tb;
    reg [31:0] addr;
    wire [31:0] instr;

    instr_mem uut (.addr(addr), .instr(instr));

    initial begin
        $dumpfile("instr_mem_tb.vcd");
        $dumpvars(0, instr_mem_tb);

        addr = 32'h00000000;
        #10 addr = 32'h00000004;
        #10 addr = 32'h00000008;
        #10 $finish;
    end

    initial begin
        $monitor("Time = %t | Addr = %h | Instr = %h", $time, addr, instr);
    end
endmodule
