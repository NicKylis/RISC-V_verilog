`include "alu.v"
`include "regfile.v"

module datapath #(parameter INITIAL_PC = 32'h00400000) (
    input clk,
    input rst,
    input [31:0] instr,
    input PCSrc,
    input ALUSrc,
    input RegWrite,
    input MemToReg,
    input [3:0] ALUCtrl,
    input loadPC,
    output reg [31:0] PC,
    output Zero,
    output [31:0] dAddress,
    output [31:0] dWriteData,
    input [31:0] dReadData,
    output [31:0] WriteBackData
);

// Program Counter and Branch Target

// Branch instruction
wire [31:0] branch_offset;
assign branch_offset = {{14{instr[15]}}, instr[15:0]} << 2;

// Register File
// Decoded register addresses
wire [4:0] readReg1;
wire [4:0] readReg2;
wire [4:0] writeReg;
wire [31:0] readData1;
wire [31:0] readData2;

assign readReg1 = instr[19:15];
assign readReg2 = instr[24:20];
assign writeReg = instr[11:7];

// Write back
assign WriteBackData = MemToReg ? dReadData : dWriteData;

regfile #(.DATAWIDTH(32), .REGCOUNT(32)) regfile (
    .clk(clk),
    .readReg1(readReg1),
    .readReg2(readReg2),
    .writeReg(writeReg),
    .writeData(dWriteData),
    .write(RegWrite),
    .readData1(readData1),
    .readData2(readData2)
);

// Immediate generation
wire [31:0] imm_I;
wire [31:0] imm_S;
wire [31:0] imm_B;

assign imm_I = {{20{instr[31]}}, instr[31:20]};
assign imm_S = {{20{instr[31]}}, instr[31:25], instr[11:7]};
assign imm_B = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};

// ALU control
// always @(*) begin
//     case(instr[6:0])
//         7'b0110011: ALUCtrl = 4'b0010; // R-type
//         7'b0010011: ALUCtrl = 4'b0010; // I-type
//         7'b0000011: ALUCtrl = 4'b0000; // Load
//         7'b1100011: ALUCtrl = 4'b0110; // Branch
//         7'b0100011: ALUCtrl = 4'b0000; // Store
//         7'b0010111: ALUCtrl = 4'b0010; // U-type
//         7'b0110111: ALUCtrl = 4'b0010; // UJ-type
//         default: ALUCtrl = 4'b0000;
//     endcase
// end

// ALU
alu datapath_alu (
    .op1(readData1),
    .op2(ALUSrc ? imm_I : readData2),
    .alu_op(ALUCtrl),
    .result(dWriteData),
    .zero(Zero)
);

// Next instruciton
wire [31:0] next_PC;
assign next_PC = PCSrc ? (PC + branch_offset) : (PC + 4);

always @(posedge clk) begin
    if (rst) begin
        PC <= INITIAL_PC;
    end else begin
        PC <= next_PC;
    end
end

endmodule