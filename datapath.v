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
    output [31:0] PC,
    output Zero,
    output [31:0] dAddress,
    output [31:0] dWriteData,
    output [31:0] dReadData,
    output [31:0] WriteBackData
);

endmodule