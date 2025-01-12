`include "datapath.v"

module top_proc #(parameter INITIAL_PC = 32'h00400000) (
    input clk,
    input rst,
    input [31:0] instr,
    input [31:0] dReadData,
    output [31:0] PC,
    output [31:0] dAddress,
    output [31:0] dWriteData,
    output MemRead,
    output MemWrite,
    output [31:0] WriteBackData
);

datapath #(.INITIAL_PC(INITIAL_PC)) datapath (
    .instr(instr),
    .dReadData(dReadData),
    .PC(PC),
    .dAddress(dAddress),
    .dWriteData(dWriteData)
);


endmodule