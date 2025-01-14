module regfile #(parameter DATAWIDTH = 32, REGCOUNT = 32) ( //Defaults to 32-bit data width and 32 registers
    input clk,
    input [4:0] readReg1,
    input [4:0] readReg2,
    input [4:0] writeReg,
    input [DATAWIDTH-1:0] writeData,
    input write,
    output reg [DATAWIDTH-1:0] readData1,
    output reg [DATAWIDTH-1:0] readData2
);

    // Port declarations
    // input reg clk;
    // input [4:0] readReg1;               
    // input [4:0] readReg2;
    // input [4:0] writeReg;    
    // input [DATAWIDTH-1:0] writeData;
    // input write;                        
    // output reg [DATAWIDTH-1:0] readData1;
    // output reg [DATAWIDTH-1:0] readData2;



    // Register file definition
    reg [DATAWIDTH-1:0] registers [0:REGCOUNT-1];

    // Initialize all registers to zero
    integer i;
    initial begin
        for (i = 0; i < REGCOUNT; i = i + 1) begin
            registers[i] = 0;
        end
    end

    // Synchronous read and write
    always @(posedge clk) begin
        // Handle writes
        if (write) begin
            registers[writeReg] <= writeData;
        end

        // Handle reads
        if (write && (writeReg == readReg1)) begin
            readData1 <= writeData; // Write-through for read port 1
        end else begin
            readData1 <= registers[readReg1];
        end

        if (write && (writeReg == readReg2)) begin
            readData2 <= writeData; // Write-through for read port 2
        end else begin
            readData2 <= registers[readReg2];
        end
    end
endmodule

