module alu
#(  parameter [3:0] ALU_AND  = 4'b0000, // AND operation
    parameter [3:0] ALU_OR   = 4'b0001, // OR operation
    parameter [3:0] ALU_ADD  = 4'b0010, // Addition
    parameter [3:0] ALU_SUB  = 4'b0110, // Subtraction
    parameter [3:0] ALU_SLT  = 4'b0100, // Less Than
    parameter [3:0] ALU_SRL  = 4'b1000, // Shift Right Logical
    parameter [3:0] ALU_SLL  = 4'b1001, // Shift Left Logical
    parameter [3:0] ALU_SRA  = 4'b1010, // Shift Right Arithmetic
    parameter [3:0] ALU_XOR  = 4'b0101  // XOR operation
) 
(
    input [31:0] op1,     // Operand 1
    input [31:0] op2,     // Operand 2
    input [3:0] alu_op,   // ALU operation code
    output reg [31:0] result, // Result of ALU operation
    output zero           // Zero flag (1 if result is 0)
);

    // Zero flag logic
    assign zero = (result == 32'b0);

    always @(*) begin
        case (alu_op)
            ALU_AND:  result = op1 & op2;                  // AND
            ALU_OR:   result = op1 | op2;                  // OR
            ALU_ADD:  result = op1 + op2;                  // Addition
            ALU_SUB:  result = op1 - op2;                  // Subtraction
            ALU_SLT:  result = ($signed(op1) < $signed(op2)) ? 32'b1 : 32'b0;// Less Than
            ALU_SRL:  result = op1 >> op2[4:0];            // Shift Right Logical
            ALU_SLL:  result = op1 << op2[4:0];            // Shift Left Logical
            ALU_SRA:  result = $signed(op1) >>> op2[4:0];  // Shift Right Arithmetic
            ALU_XOR:  result = op1 ^ op2;                  // XOR
            default:  result = 32'b0;                      // Default case
        endcase
    end

endmodule
