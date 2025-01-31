`include "datapath.v"
`include "rom.v"
`include "ram.v"

module top_proc #(parameter INITIAL_PC = 32'h00400000) (
    input clk,
    input rst,
    input [31:0] instr,
    input [31:0] dReadData,
    output [31:0] PC,
    output [31:0] dAddress,
    output [31:0] dWriteData,
    output reg MemRead,
    output reg MemWrite,
    output [31:0] WriteBackData
);

// Datapath initialization
reg loadPC;
reg Zero;
reg MemToReg;
reg ALUSrc;
reg [3:0] ALUCtrl;
reg RegWrite;
reg PCSrc;

// FSM initialization
reg [2:0] fsm_state;
initial begin
    fsm_state = 3'b000;
end

DATA_MEMORY data_mem(
    .clk(clk),
    .we(MemWrite),
    .addr(PC[8:0]),
    .din(dWriteData),
    .dout(dReadData)
);

// TODO: complete the ID and EX stages
always @(posedge clk, rst) begin
    // loadPC = 0;
    ALUSrc <= (instr[6:0] == 7'b0000011 || instr[6:0] == 7'b0010011) ? 1 : 0;
    MemRead <= 0;
    MemWrite <= 0;
    MemToReg <= 0;
    PCSrc <= 0;
    if (rst) begin
        fsm_state = 3'b100;
    end
    case(fsm_state)
        3'b000: begin
            // IF
            PCSrc = (ALUCtrl == 4'b0110 && Zero) ? 1 : 0;
            loadPC = 0;
            // Next state: 3'b001
        end
        3'b001: begin
            // ID
            // Next state: 3'b010
        end
        3'b010: begin
            // EX
            // Next state: 3'b011
        end
        3'b011: begin
            // MEM
            if(instr[6:0] == 7'b0000011) begin
                MemRead = 1;
                MemWrite = 0;
                MemToReg = 1;
            end else if(instr[6:0] == 7'b0100011) begin
                MemRead = 0;
                MemWrite = 1;
                MemToReg = 0;
            end
            // Next state: 3'b100
        end
        3'b100: begin
            // WB
            loadPC = 1;
            RegWrite = 1;
            // Next state: 3'b000
        end
    endcase

    if(loadPC) begin
        fsm_state <= 3'b000;
    end else begin
        fsm_state <= fsm_state + 3'b001;
    end
    RegWrite <= 0;

end

datapath #(.INITIAL_PC(INITIAL_PC)) top_datapath (
    .clk(clk),
    .rst(rst),
    .instr(instr),
    .dReadData(dReadData),
    .PC(PC),
    .dAddress(dAddress),
    .dWriteData(dWriteData),
    .loadPC(loadPC),
    .MemToReg(MemToReg),
    .ALUCtrl(ALUCtrl),
    .ALUSrc(ALUSrc),
    .RegWrite(RegWrite),
    .PCSrc(PCSrc)
);

INSTRUCTION_MEMORY instr_mem (
    .clk(clk),
    .addr(PC[8:0]),
    .dout(instr)
);

always @(posedge clk) begin
        case (instr[6:0])
            // Memory instructions
            7'b0000011, // LW
            7'b0100011: // SW
                ALUCtrl = 4'b0010; // Addition for address calculation
            // Branch instruction
            7'b1100011:
                ALUCtrl = 4'b0110; // Subtraction for comparison
            // R and I instructions
            default:
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
        endcase
end

endmodule