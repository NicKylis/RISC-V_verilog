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
    output [31:0] dReadData,
    output [31:0] WriteBackData
);

// Program Counter

// Branch instruction
wire [31:0] branch_offset;
assign branch_offset = {{14{instr[15]}}, instr[15:0]} << 2;

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

// Register File

// Decoded register addresses
wire [4:0] readReg1;
wire [4:0] readReg2;
wire [4:0] writeReg;

assign readReg1 = instr[25:21];
assign readReg2 = instr[20:16];
assign writeReg = instr[15:11];

regfile #(.DATAWIDTH(32), .REGCOUNT(32)) regfile (
    .clk(clk),
    .readReg1(readReg1),
    .readReg2(readReg2),
    .writeReg(writeReg),
    .writeData(dWriteData),
    .write(RegWrite),
    .readData1(),
    .readData2()
);

// Immediate generation

// ALU

// Branch target

// Write back

endmodule