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
    output reg [31:0] WriteBackData
);

// Immediate generation
wire [31:0] imm_I;
wire [31:0] imm_S;
wire [31:0] imm_B;

assign imm_I = {{20{instr[31]}}, instr[31:20]};
assign imm_S = {{20{instr[31]}}, instr[31:25], instr[11:7]};
assign imm_B = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};

// Program Counter and Branch Target

// Branch instruction
wire [31:0] branch_offset;
assign branch_offset = {{14{imm_B[15]}}, imm_B[15:0]} << 2;

// Register File
// Decoded register addresses
wire [4:0] readReg1;
wire [4:0] readReg2;
wire [4:0] writeReg;
wire [31:0] readData1;
wire [31:0] readData2;

assign readReg1 = instr[19:15];
assign readReg2 = instr[24:20];

assign writeReg = RegWrite ? instr[11:7] : 5'b0;

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

// ALU
alu datapath_alu (
    .op1(readData1),
    .op2(ALUSrc ? imm_I : readData2),
    .alu_op(ALUCtrl),
    .result(dWriteData),
    .zero(Zero)
);

wire opcode = instr[6:0];

always @(posedge clk) begin
    if (rst) begin
        PC <= INITIAL_PC;
        WriteBackData <= 32'b0;
    end else begin
        if (loadPC) begin
            if(PCSrc) begin
                PC <= PC + branch_offset;
            end else begin
                PC <= PC + 4;
            end
        if (MemToReg) begin
            WriteBackData <= dReadData;
        end else begin
            WriteBackData <= dWriteData;
        end
    end
    end
end


endmodule