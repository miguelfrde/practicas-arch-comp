module EX_MEM_Register 
(
    input clk,
    input reset,
	 input [4:0] EX_WriteRegister,
	 input [31:0] EX_ALUResult,
    input [31:0] EX_ReadData2,
    input EX_MemToReg,
    input EX_MemWrite,
    input EX_MemRead,
    input EX_RegWrite,
    input EX_JumpAndLink,
    input EX_LoadUpperImmediate,
	 input EX_ALUSrc,
    input [31:0] EX_Instruction,
    input [31:0] EX_PC_4,
	 output [4:0] MEM_WriteRegister,
	 output [31:0] MEM_ALUResult,
    output [31:0] MEM_ReadData2,
    output MEM_MemToReg,
    output MEM_MemWrite,
    output MEM_MemRead,
    output MEM_RegWrite,
    output MEM_JumpAndLink,
	 output MEM_ALUSrc,
    output MEM_LoadUpperImmediate,
    output [31:0] MEM_Instruction,
    output [31:0] MEM_PC_4
);

reg [4:0] WriteRegister;
reg [31:0] ALUResult;
reg [31:0] ReadData2;
reg MemToReg;
reg MemWrite;
reg MemRead;
reg RegWrite;
reg AluSrc;
reg JumpAndLink;
reg LoadUpperImmediate;
reg [31:0] Instruction;
reg [31:0] PC_4;

assign MEM_WriteRegister = WriteRegister;
assign MEM_ALUResult = ALUResult;
assign MEM_ReadData2 = ReadData2;
assign MEM_MemToReg = MemToReg;
assign MEM_MemWrite = MemWrite;
assign MEM_MemRead = MemRead;
assign MEM_RegWrite = RegWrite;
assign MEM_JumpAndLink = JumpAndLink;
assign MEM_LoadUpperImmediate = LoadUpperImmediate;
assign MEM_Instruction = Instruction;
assign MEM_PC_4 = PC_4;
assign MEM_ALUSrc = AluSrc;

always @(negedge reset or posedge clk) begin
    if (!reset)
	   begin
        WriteRegister <= 5'b0;
        ALUResult <= 32'b0;
        ReadData2 <= 32'b0;
        MemToReg <= 1'b0;
        MemWrite <= 1'b0;
        MemRead <= 1'b0;
        RegWrite <= 1'b0;
        JumpAndLink <= 1'b0;
        LoadUpperImmediate <= 1'b0;
		  AluSrc <= 1'b0;
        Instruction <= 32'b0;
        PC_4 = 32'b0;
      end
	 else
	   begin
        WriteRegister <= EX_WriteRegister;
        ALUResult <= EX_ALUResult;
        ReadData2 <= EX_ReadData2;
        MemToReg <= EX_MemToReg;
        MemWrite <= EX_MemWrite;
        MemRead <= EX_MemRead;
        RegWrite <= EX_RegWrite;
        JumpAndLink <= EX_JumpAndLink;
        LoadUpperImmediate <= EX_LoadUpperImmediate;
        Instruction <= EX_Instruction;
        PC_4 <= EX_PC_4;
		  AluSrc <= EX_ALUSrc;
		end
end

endmodule
