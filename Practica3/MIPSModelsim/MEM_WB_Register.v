module MEM_WB_Register 
(
    input clk,
    input reset,
	 input MEM_MemToReg,
	 input [31:0] MEM_MemoryData,
	 input [4:0] MEM_WriteRegister,
	 input [31:0] MEM_ALUResult,
    input MEM_RegWrite,
    input MEM_JumpAndLink,
    input MEM_LoadUpperImmediate,
    input [31:0] MEM_Instruction,
    input [31:0] MEM_PC_4,
	 input MEM_ALUSrc,
	 output WB_MemToReg,
	 output [31:0] WB_MemoryData,
	 output [4:0] WB_WriteRegister,
	 output [31:0] WB_ALUResult,
    output WB_RegWrite,
    output WB_JumpAndLink,
    output WB_LoadUpperImmediate,
    output [31:0] WB_Instruction,
    output [31:0] WB_PC_4,
	 output WB_ALUSrc
);

reg MemToReg;
reg [31:0] MemoryData;
reg [4:0] WriteRegister;
reg [31:0] ALUResult;
reg RegWrite;
reg JumpAndLink;
reg LoadUpperImmediate;
reg [31:0] Instruction;
reg [31:0] PC_4;
reg ALUSrc;

assign WB_MemToReg = MemToReg;
assign WB_MemoryData = MemoryData;
assign WB_WriteRegister = WriteRegister;
assign WB_ALUResult = ALUResult;
assign WB_RegWrite = RegWrite;
assign WB_JumpAndLink = JumpAndLink;
assign WB_LoadUpperImmediate = LoadUpperImmediate;
assign WB_Instruction = Instruction;
assign WB_ALUSrc = ALUSrc;
assign WB_PC_4 = PC_4;

always @(negedge reset or posedge clk) begin
    if (!reset)
	   begin
		  MemToReg <= 1'b0;
		  MemoryData <= 32'b0;
        WriteRegister <= 5'b0;
        ALUResult <= 32'b0;
        RegWrite <= 1'b0;
        JumpAndLink <= 1'b0;
        LoadUpperImmediate <= 1'b0;
        Instruction <= 32'b0;
        PC_4 = 32'b0;
		  ALUSrc = 1'b0;
      end
	 else
	   begin
		  MemToReg <= MEM_MemToReg;
		  MemoryData <= MEM_MemoryData;
        WriteRegister <= MEM_WriteRegister;
        ALUResult <= MEM_ALUResult;
        RegWrite <= MEM_RegWrite;
        JumpAndLink <= MEM_JumpAndLink;
        LoadUpperImmediate <= MEM_LoadUpperImmediate;
        Instruction <= MEM_Instruction;
        PC_4 <= MEM_PC_4;
		  ALUSrc <= MEM_ALUSrc;
		end
end

endmodule
