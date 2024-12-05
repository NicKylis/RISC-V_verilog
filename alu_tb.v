`timescale 1ns / 1ps

module alu_tb;

    // Inputs to the ALU
    reg [31:0] op1;
    reg [31:0] op2;
    reg [3:0] alu_op;

    // Outputs from the ALU
    wire [31:0] result;
    wire zero;

    // Instantiate the ALU module
    alu dut (
        .op1(op1),
        .op2(op2),
        .alu_op(alu_op),
        .result(result),
        .zero(zero)
    );

    // Test procedure
    initial begin
        // Monitor outputs
        $monitor("Time: %0t | op1: %h | op2: %h | alu_op: %b | result: %h | zero: %b",
                 $time, op1, op2, alu_op, result, zero);

        // Test AND operation
        op1 = 32'hA5A5A5A5;
        op2 = 32'h5A5A5A5A;
        alu_op = 4'b0000;  // ALU_AND
        #10;

        // Test OR operation
        alu_op = 4'b0001;  // ALU_OR
        #10;

        // Test ADD operation
        op1 = 32'd20;
        op2 = 32'd22;
        alu_op = 4'b0010;  // ALU_ADD
        #10;

        // Test SUB operation
        op1 = 32'd50;
        op2 = 32'd30;
        alu_op = 4'b0110;  // ALU_SUB
        #10;

        // Test SLT operation
        op1 = 32'd10;
        op2 = 32'd20;
        alu_op = 4'b0100;  // ALU_SLT
        #10;

        // Test SRL operation
        op1 = 32'hFFFFFFFF;
        op2 = 32'd4;
        alu_op = 4'b1000;  // ALU_SRL
        #10;

        // Test SLL operation
        alu_op = 4'b1001;  // ALU_SLL
        #10;

        // Test SRA operation
        alu_op = 4'b1010;  // ALU_SRA
        #10;

        // Test XOR operation
        op1 = 32'h12345678;
        op2 = 32'h87654321;
        alu_op = 4'b0101;  // ALU_XOR
        #10;

        // End of test
        $stop;
    end

endmodule