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

// Datapath initialization
reg loadPC;
reg Zero;
reg MemToReg;
reg [3:0] ALUCtrlModule;
reg [3:0] ALUCtrl;

datapath #(.INITIAL_PC(INITIAL_PC)) datapath (
    .instr(instr),
    .dReadData(dReadData),
    .PC(PC),
    .dAddress(dAddress),
    .dWriteData(dWriteData),
    .loadPC(loadPC),
    .MemToReg(MemToReg),
    .ALUCtrl(ALUCtrl)
);

// FSM initialization
wire [2:0] fsm_state;
assign fsm_state = 3'b000;




always @(posedge clk) begin
    // loadPC = 0;
    case(fsm_state)
        3'b000: begin
            // IF
            // PC = PC + 4
            // MemRead = 1
            // MemWrite = 0
            // WriteBackData = 0
            // Next state: 3'b001
        end
        3'b001: begin
            // ID
            // dAddress = 0
            // MemRead = 0
            // MemWrite = 0
            // WriteBackData = 0
            // Next state: 3'b010
        end
        3'b010: begin
            // EX
            // dAddress = 0
            // MemRead = 0
            // MemWrite = 0
            // WriteBackData = 0
            // Next state: 3'b011
        end
        3'b011: begin
            // MEM
            // dAddress = 0
            // MemRead = 0
            // MemWrite = 0
            // WriteBackData = 0
            // Next state: 3'b100
        end
        3'b100: begin
            // WB
            // loadPC <= 1;
            // PCSrc = ;
            // MemRead = 0
            // MemWrite = 0
            // WriteBackData = 0
            // Next state: 3'b000
        end
    endcase
end

endmodule