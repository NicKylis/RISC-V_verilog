`include "alu.v"
`include "calc_enc.v"

module calc (
    input clk,                 // Clock
    input btnc,                // Center button
    input btnl, btnu, btnr, btnd, // Control buttons
    input [15:0] sw,           // 16-bit switches for input
    output reg [15:0] led      // 16-bit LEDs for output
);

    // Internal Signals
    wire [31:0] sign_ext_sw;   // Sign-extended switch input
    wire [31:0] alu_result;    // ALU result
    reg [15:0] accumulator;    // Accumulator (16-bit register)
    wire [3:0] alu_op;          // ALU operation control signal
    wire [3:0] encout;         // Encoder output

    // Sign-Extend Module
    assign sign_ext_sw = {{16{sw[15]}}, sw}; // Sign-extend 16-bit to 32-bit

    // ALU Instance
    alu my_alu (
        .op1({{16{accumulator[15]}}, accumulator}), // Extend 16-bit accumulator to 32 bits for ALU input
        .op2(sign_ext_sw),         // Second operand (from sign-extended switches)
        .alu_op(alu_op),           // ALU operation code
        .result(alu_result),       // Result from ALU
        .zero()                    // Zero flag (not used here)
    );

    // Encoder Instance
    calc_enc my_enc (
        .btnc(btnc),
        .btnl(btnl),
        .btnr(btnr),
        .btnu(btnu),
        .btnd(btnd),
        .encout(encout)
    );

    // Accumulator Logic
    always @(posedge clk) begin
        if (btnu) begin
            accumulator <= 16'b0; // Reset accumulator when btnu is pressed
        end else if (btnd) begin
            accumulator <= alu_result[15:0]; // Update accumulator on btnd press
        end
    end

    // ALU Operation Control Logic
    assign alu_op = encout;

    // Connect accumulator value to LEDs
    always @(posedge clk) begin
        //led <= accumulator;
        led <= alu_result[15:0];
    end

endmodule

// // ALU Operation Control Logic
//     always @(*) begin
//         //alu_op = 4'b0000; // Default operation (AND)
//         case ({btnl, btnc, btnr})
//             3'b000: alu_op = 4'b0000; // AND
//             3'b001: alu_op = 4'b0001; // OR
//             3'b010: alu_op = 4'b0010; // ADD
//             3'b011: alu_op = 4'b0110; // SUB
//             3'b111: alu_op = 4'b0101; // XOR
//             3'b101: alu_op = 4'b1001; // Logical Shift Left
//             3'b110: alu_op = 4'b1010; // Shift Right Arithmetic
//             3'b100: alu_op = 4'b0100; // Less Than
//             default: alu_op = 4'b0000; // Default (AND)
//         endcase
//     end