`timescale 1ns / 1ns
`include "top_proc.v"

module top_proc_tb;

    // Inputs
    reg clk;
    reg rst;

    // Instantiate the DUT
    top_proc #(
        .INITIAL_PC(32'h00400000)
    ) uut (
        .clk(clk),
        .rst(rst)
    );

    // Clock generation
    always begin
        #5; clk = ~clk;
    end

    task RESET();
    begin
        @(posedge clk);
        rst = 1;
        @(posedge clk);
        rst = 0;
    end
    endtask

    // Testbench procedure
    initial begin
        clk = 0;
        $dumpfile("top_proc_tb.vcd");
        $dumpvars(0, top_proc_tb);    
       
        // Initialize inputs
        rst = 0;

        #10;

        // Reset the DUT
        RESET();

        // Let the machine run for a while
        #3000;
       
        $finish;
    end
endmodule

// TODO: Check communications