module calc (
    input clk,                 // Clock
    input btnc,                // Center button (unused here, but available for future use)
    input btnl, btnu, btnr, btnd, // Control buttons
    input [15:0] sw,           // 16-bit switches for input
    output reg [15:0] led      // 16-bit LEDs for output
);

    // Internal Signals
    wire [31:0] sign_ext_sw;   // Sign-extended switch input
    wire [31:0] alu_result;    // ALU result
    reg [15:0] accumulator;    // Accumulator (16-bit register)
    reg [3:0] alu_op;          // ALU operation control signal

    // Sign-Extend Module
    assign sign_ext_sw = {{16{sw[15]}}, sw}; // Sign-extend 16-bit to 32-bit

    // ALU Instance
    alu my_alu (
        .op1({16'b0, accumulator}), // Extend 16-bit accumulator to 32 bits for ALU input
        .op2(sign_ext_sw),         // Second operand (from sign-extended switches)
        .alu_op(alu_op),           // ALU operation code
        .result(alu_result),       // Result from ALU
        .zero()                    // Zero flag (not used here)
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
    always @(posedge clk) begin
        if (btnl) alu_op <= 4'b0000;  // AND operation (ALU_AND)
        if (btnu) alu_op <= 4'b0001;  // OR operation (ALU_OR)
        if (btnr) alu_op <= 4'b0010;  // ADD operation (ALU_ADD)
        if (btnd) alu_op <= 4'b0110;  // SUB operation (ALU_SUB)
    end

    // Connect accumulator value to LEDs
    always @(posedge clk) begin
        led <= accumulator;
    end

endmodule



