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
reg [3:0] ALUSrc;
reg [3:0] ALUCtrl;
reg RegWrite;
reg PCSrc;

// FSM initialization
wire [2:0] fsm_state;
assign fsm_state = 3'b000;

// ALUCtrl unit
always @(*) begin
        case (instr[6:0])
            7'b0000011, // LW
            7'b0100011: // SW
                ALUCtrl = 4'b0010; // Addition for address calculation
            7'b1100011: // BEQ
                ALUCtrl = 4'b0110; // Subtraction for comparison
            7'b0110011: // R instructions
                case (instr[14:12])
                    3'b000: // ADD/SUB
                        ALUCtrl = (instr[31:25] == 7'b0100000) ? 4'b0110 : 4'b0010; // SUB if funct7=0100000, else ADD
                    3'b111: // AND
                        ALUCtrl = 4'b0000;
                    3'b110: // OR
                        ALUCtrl = 4'b0001;
                    3'b100: // XOR
                        ALUCtrl = 4'b0101;
                    3'b001: // SLL
                        ALUCtrl = 4'b1001;
                    3'b101: // SRL/SRA
                        ALUCtrl = (instr == 7'b0100000) ? 4'b1010 : 4'b1000; // SRA if funct7=0100000, else SRL
                    3'b010: // SLT
                        ALUCtrl = 4'b0100;
                    default:
                        ALUCtrl = 4'b1111; // Default error code
                endcase

            default: // Undefined opcode
                ALUCtrl = 4'b1111; // Default error code
        endcase
end

always @(posedge clk) begin
    // loadPC = 0;
    case(fsm_state)
        3'b000: begin
            // IF
            RegWrite = 0;
            PCSrc = (ALUCtrl == 4'b0000 || Zero) ? 1 : 0; // Todo: add the correct ALUCtrl value
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
            loadPC = 1;
            RegWrite = 1;
            // PCSrc = ;
            // MemRead = 0
            // MemWrite = 0
            // WriteBackData = 0
            // Next state: 3'b000
        end
    endcase
end

datapath #(.INITIAL_PC(INITIAL_PC)) datapath (
    .instr(instr),
    .dReadData(dReadData),
    .PC(PC),
    .dAddress(dAddress),
    .dWriteData(dWriteData),
    .loadPC(loadPC),
    .MemToReg(MemToReg),
    .ALUCtrl(ALUCtrl),
    .RegWrite(RegWrite),
    .PCSrc(PCSrc)
);

endmodule