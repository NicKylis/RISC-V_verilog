`timescale 1ns / 1ns
`include "calc.v"

module calc_tb;

    // Inputs
    reg clk;
    reg btnc, btnl, btnr, btnu, btnd;
    reg [15:0] sw;

    // Outputs
    wire [15:0] led;

    // Instantiate the DUT
    calc uut (
        .clk(clk),
        .btnc(btnc),
        .btnl(btnl),
        .btnr(btnr),
        .btnu(btnu),
        .btnd(btnd),
        .sw(sw),
        .led(led)
    );

    // Clock generation
    always begin
        #5; clk = ~clk;
    end

    task RESET();
    begin
        @(posedge clk);
        btnu = 1;
        @(posedge clk); // Use smaller delay for input change
        btnu = 0;
    end
    endtask

    // Works on the posedge, led output is 1 cycle behind
    task ASSIGN(input btncI, input btnlI, input btnrI, input btndI, input[15:0] swI);
    begin
        btnc = btncI;
        btnl = btnlI;
        btnr = btnrI;
        btnd = btndI;
        sw = swI;
        @(posedge clk);
    end
    endtask

    // Testbench procedure
    initial begin
        clk = 0;
        $dumpfile("calc_tb.vcd");  // Name of the waveform file
        $dumpvars(0, calc_tb);    
        // Initialize inputs
        btnc = 0; btnl = 0; btnr = 0; btnu = 0; btnd = 0;
        sw = 16'b0;

        

        // // Test Case 1: Reset accumulator
        RESET();
        $display("Test 1: Reset => LED: %h (Expected next value: 0x0000)", led);

        // Test Case 2: ADD
        ASSIGN(1, 0, 0, 1, 16'h354a);
        $display("Test 2: ADD => LED: %h (Expected next value: 0x354a)", led);

        // Test Case 3: SUB
        ASSIGN(1, 0, 1, 1, 16'h1234);
        $display("Test 3: SUB => LED: %h (Expected next value: 0x2316)", led);

        // Test Case 4: OR
        ASSIGN(0, 0, 1, 1, 16'h1001);
        $display("Test 4: OR => LED: %h (Expected next value: 0x3317)", led);

        // Test Case 5: AND
        ASSIGN(0, 0, 0, 1, 16'hf0f0);
        $display("Test 5: AND => LED: %h (Expected next value: 0x3010)", led);

        // Test Case 6: XOR
        ASSIGN(1, 1, 1, 1, 16'h1fa2);
        $display("Test 6: XOR => LED: %h (Expected next value: 0x2fb2)", led);

        // Test Case 6.5: AND 2
        ASSIGN(1, 0, 0, 1, 16'h6aa2);
        $display("Test 6: XOR => LED: %h (Expected next value: 0x9a54)", led);

        // Test Case 7: Logical Shift Left
        ASSIGN(0, 1, 1, 1, 16'h0004);
        $display("Test 7: Logical Shift Left => LED: %h (Expected next value: 0xa540)", led);

        // Test Case 8: Shift Right Arithmetic
        ASSIGN(1, 1, 0, 1, 16'h0001);
        $display("Test 8: Shift Right Arithmetic => LED: %h (Expected next value: 0xd2a0)", led);

        // Test Case 9: Less Than
        ASSIGN(0, 1, 0, 1, 16'h46ff);
        $display("Test 9: Less Than => LED: %h (Expected last value: 0x0001)", led);
        
        @(posedge clk);
        $display("Final result => LED: %h", led);
        // End simulation
        $finish;
    end
endmodule