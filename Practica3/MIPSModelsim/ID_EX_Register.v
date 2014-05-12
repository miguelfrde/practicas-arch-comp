module ID_EX_Register 
(
    input clk,
    input reset,
    input ID_JumpRegister,
    input ID_RegDst,
    input [31:0] ID_ReadData1,
	 input [31:0] ID_ImmediateExtend,
    input [2:0] ID_ALUOp,
    input ID_ALUSrc,
    input [31:0] ID_ReadData2,
    input ID_MemToReg,
    input ID_MemWrite,
    input ID_MemRead,
    input ID_RegWrite,
    input ID_JumpAndLink,
    input ID_LoadUpperImmediate,
    input [31:0] ID_Instruction,
    input [31:0] ID_PC_4,
	 output EX_JumpRegister,
    output EX_RegDst,
    output [31:0] EX_ReadData1,
	 output [31:0] EX_ImmediateExtend,
    output [2:0] EX_ALUOp,
    output EX_ALUSrc,
    output [31:0] EX_ReadData2,
    output EX_MemToReg,
    output EX_MemWrite,
    output EX_MemRead,
    output EX_RegWrite,
    output EX_JumpAndLink,
    output EX_LoadUpperImmediate,
    output [31:0] EX_Instruction,
    output [31:0] EX_PC_4
);

reg JumpRegister;
reg RegDst;
reg [31:0] ReadData1;
reg [31:0] ImmediateExtend;
reg [2:0] ALUOp;
reg ALUSrc;
reg [31:0] ReadData2;
reg MemToReg;
reg MemWrite;
reg MemRead;
reg RegWrite;
reg JumpAndLink;
reg LoadUpperImmediate;
reg [31:0] Instruction;
reg [31:0] PC_4;

assign EX_JumpRegister = JumpRegister;
assign EX_RegDst = RegDst;
assign EX_ReadData1 = ReadData1;
assign EX_ImmediateExtend = ImmediateExtend;
assign EX_ALUOp = ALUOp;
assign EX_ALUSrc = ALUSrc;
assign EX_ReadData2 = ReadData2;
assign EX_MemToReg = MemToReg;
assign EX_MemWrite = MemWrite;
assign EX_MemRead = MemRead;
assign EX_RegWrite = RegWrite;
assign EX_JumpAndLink = JumpAndLink;
assign EX_LoadUpperImmediate = LoadUpperImmediate;
assign EX_Instruction = Instruction;
assign EX_PC_4 = PC_4;

always @(negedge reset or posedge clk) begin
    if (!reset)
	   begin
        JumpRegister <= 1'b0;
        RegDst <= 1'b0;
        ReadData1 <= 32'b0;
        ImmediateExtend <= 32'b0;
        ALUOp <= 3'b0;
        ALUSrc <= 1'b0;
        ReadData2 <= 32'b0;
        MemToReg <= 1'b0;
        MemWrite <= 1'b0;
        MemRead <= 1'b0;
        RegWrite <= 1'b0;
        JumpAndLink <= 1'b0;
        LoadUpperImmediate <= 1'b0;
        Instruction <= 32'b0;
        PC_4 <= 32'b0;
      end
	 else
	   begin
	     JumpRegister <= ID_JumpRegister;
        RegDst <= ID_RegDst;
        ReadData1 <= ID_ReadData1;
        ImmediateExtend <= ID_ImmediateExtend;
        ALUOp <= ID_ALUOp;
        ALUSrc <= ID_ALUSrc;
        ReadData2 <= ID_ReadData2;
        MemToReg <= ID_MemToReg;
        MemWrite <= ID_MemWrite;
        MemRead <= ID_MemRead;
        RegWrite <= ID_RegWrite;
        JumpAndLink <= ID_JumpAndLink;
        LoadUpperImmediate <= ID_LoadUpperImmediate;
        Instruction <= ID_Instruction;
        PC_4 <= ID_PC_4;
		end
end

endmodule
