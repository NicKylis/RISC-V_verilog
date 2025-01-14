`timescale 1ns / 1ns
`include "top_proc.v"

module top_proc_tb;

    // Inputs
    reg clk;
    reg rst;
    reg [31:0] instr;
    reg [31:0] dReadData;

    // Outputs
    wire [31:0] PC;
    wire [31:0] dAddress;
    wire [31:0] dWriteData;
    wire MemRead;
    wire MemWrite;
    wire [31:0] WriteBackData;

    // Instantiate the DUT
    top_proc #(
        .INITIAL_PC(32'h00400000)
    ) uut (
        .clk(clk),
        .rst(rst),
        .instr(instr),
        .dReadData(dReadData),
        .PC(PC),
        .dAddress(dAddress),
        .dWriteData(dWriteData),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .WriteBackData(WriteBackData)
    );

    // Clock generation
    always begin
        #5; clk = ~clk;
    end

    task RESET();
    begin
        @(posedge clk);
        rst = 1;
        @(posedge clk); // Use smaller delay for input change
        rst = 0;
    end
    endtask

    task ASSIGN(input rstI, input [31:0] instrI, input [31:0] dReadDataI);
    begin
        rst = rstI;
        instr = instrI;
        dReadData = dReadDataI;
        @(posedge clk);
    end
    endtask

    // Testbench procedure
    initial begin
        clk = 0;
        $dumpfile("top_proc_tb.vcd");  // Name of the waveform file
        $dumpvars(0, top_proc_tb);    
        // Initialize inputs
        rst = 0;
        instr = 32'b0;
        dReadData = 32'b0;
        // Reset the DUT
        RESET();
        // Wait for 100ns before starting the test
        #100;
       
    end
endmodule