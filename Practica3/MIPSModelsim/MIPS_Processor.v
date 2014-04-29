/******************************************************************
* Description
*	This is the top-level of a MIPS processor that can execute the next set of instructions:
*		add
*		addi
*		sub
*		ori
*		or
*		bne
*		beq
*		and
*		nor
* This processor is written Verilog-HDL. Also, it is synthesizable into hardware.
* Parameter MEMORY_DEPTH configures the program memory to allocate the program to
* be execute. If the size of the program changes, thus, MEMORY_DEPTH must change.
* This processor was made for computer organization class at ITESO.
* Version:
*	1.0
* Author:
*	MSc. José Luis Pizano Escalante
* Date:
*	01/03/2014
******************************************************************/
`include "Definitions.v" 

module MIPS_Processor
#(
	parameter MEMORY_DEPTH = 100
)

(
	// Inputs
	input clk,
	input reset,
	// Output
	output [31:0] ALUResultOut

);
//******************************************************************/
//******************************************************************/
// Data types to connect modules

wire [31:0] IF_PC_wire;
wire [31:0] IF_Instruction_wire;
wire [31:0] IF_PC_4_wire;
wire [63:0] IF_Reg_Data;

wire [31:0] ID_Instruction_wire;
wire [31:0] ID_PC_4_wire;
wire ID_RegDst_wire;
wire ID_BranchNE_wire;
wire ID_BranchEQ_wire;
wire [2:0] ID_ALUOp_wire;
wire ID_ALUSrc_wire;
wire ID_RegWrite_wire;
wire ID_Jump_wire;
wire ID_JumpAndLink_wire;
wire ID_LoadUpperImmediate_wire;
wire ID_MemToReg_wire;
wire ID_MemWrite_wire;
wire ID_MemRead_wire;
wire ID_JumpRegister_wire;
wire [31:0] ID_ImmediateExtend_wire;
wire [31:0] ID_ReadData1_wire;
wire [31:0] ID_ReadData2_wire;
wire [27:0] ID_JumpAddressShifted_wire;
wire [173:0] ID_Reg_Data;

wire EX_JumpRegister_wire;
wire EX_BranchNE_wire;
wire EX_BranchEQ_wire;
wire EX_RegDst_wire;
wire [31:0] EX_ReadData1_wire;
wire [31:0] EX_ImmediateExtend_wire;
wire EX_ALUSrc_wire;
wire [2:0] EX_ALUOp_wire;
wire [31:0] EX_ReadData2_wire;
wire EX_MemToReg_wire;
wire EX_MemWrite_wire;
wire EX_MemRead_wire;
wire EX_RegWrite_wire;
wire EX_JumpAndLink_wire;
wire EX_LoadUpperImmediate_wire;
wire [31:0] EX_Instruction_wire;
wire [31:0] EX_PC_4_wire;
wire [4:0] EX_WriteRegisterOrRA_wire;
wire [4:0] EX_WriteRegister_wire;
wire [4:0] EX_WriteRegisterOrI_wire;
wire EX_Zero_wire;
wire [3:0] EX_ALUOperation_wire;
wire [31:0] EX_ALUResult_wire;
wire [31:0] EX_ReadData2OrImmediate_wire;
wire [31:0] EX_ImmediateExtendAndShifted_wire;
wire [31:0] EX_PCtoBranch_wire;
wire [173:0] EX_Reg_Data;

wire MEM_BranchNE_wire;
wire MEM_BranchEQ_wire;
wire [4:0] MEM_WriteRegister_wire;
wire [31:0] MEM_ALUResult_wire;
wire MEM_Zero_wire;
wire [31:0] MEM_PCtoBranch_wire;
wire [31:0] MEM_ReadData2_wire;
wire MEM_MemToReg_wire;
wire MEM_MemWrite_wire;
wire MEM_MemRead_wire;
wire MEM_RegWrite_wire;
wire MEM_JumpAndLink_wire;
wire MEM_LoadUpperImmediate_wire;
wire [31:0] MEM_Instruction_wire;
wire [31:0] MEM_PC_4_wire;
wire MEM_ZeroANDBrachEQ;
wire MEM_NotZeroANDBrachNE;
wire MEM_ORForBranch;
wire [31:0] MEM_MemoryData_wire;
wire [136:0] MEM_Reg_Data;

wire WB_MemToReg_wire;
wire [31:0] WB_MemoryData_wire;
wire [4:0] WB_WriteRegister_wire;
wire [31:0] WB_ALUResult_wire;
wire WB_RegWrite_wire;
wire WB_JumpAndLink_wire;
wire WB_LoadUpperImmediate_wire;
wire [31:0] WB_Instruction_wire;
wire [31:0] WB_PC_4_wire;
wire [31:0] WB_WriteData_wire;
wire [31:0] WB_ALUResultOrMemoryData_wire;
wire [31:0] WB_ALUResultOrMemoryDataOrPC4_wire;

wire [31:0] MUX_PC_wire;
wire [31:0] MUX_PC_JUMP_wire;
wire [31:0] MUX_PC_JUMP_REG_wire;

integer ALUStatus;


/*****************************************************************************************************
 *                                   MUX FOR BRANCH, JUMP CONTROL                                    *
 *****************************************************************************************************/
 
Multiplexer2to1
#(
	.NBits(32)
)
MUX_PC
(
	.Selector(MEM_ORForBranch),
	.MUX_Data0(IF_PC_4_wire),
	.MUX_Data1(MEM_PCtoBranch_wire),
	.MUX_Output(MUX_PC_wire)

);
 
Multiplexer2to1
#(
	.NBits(32)
)
MUX_JUMP
(
	.Selector(ID_Jump_wire),
	.MUX_Data0(MUX_PC_wire),
	.MUX_Data1({ID_PC_4_wire[31:28], ID_JumpAddressShifted_wire}),
	.MUX_Output(MUX_PC_JUMP_wire)
);

Multiplexer2to1
#(
	.NBits(32)
)
MUX_JUMP_REGISTER
(
	.Selector(EX_JumpRegister_wire),
	.MUX_Data0(MUX_PC_JUMP_wire),
	.MUX_Data1(EX_ReadData1_wire),
	.MUX_Output(MUX_PC_JUMP_REG_wire)
);


/*****************************************************************************************************
 *                              INSTRUCTION FETCH (IF) PIPELINE STAGE                                *
 *****************************************************************************************************/
 
PC_Register
ProgramCounter
(
    .clk(clk),
    .reset(reset),
    .NewPC(MUX_PC_JUMP_REG_wire),
    .PCValue(IF_PC_wire)
);


`ifdef MONITORS
initial
	ALUStatus = $fopen("ALUResult.dat");

always@(posedge clk)
  $display("PC value %d ALU result %00h",IF_PC_wire,ALUResult_wire );
  
always@(posedge clk)
	$fdisplay(ALUStatus, "%h", ALUResult_wire);
`endif 


ProgramMemory
#(
	.MEMORY_DEPTH(MEMORY_DEPTH)
)
ROMProgramMemory
(
	.Address(IF_PC_wire),
	.Instruction(IF_Instruction_wire)
);

Adder32bits
PC_Puls_4
(
	.Data0(IF_PC_wire),
	.Data1(4),
	.Result(IF_PC_4_wire)
);

Pipeline_Reg
#(
	.SIZE(64)
)
IF_ID_Register
(
    .clk(clk),
    .reset(reset),
    .DataIn({IF_Instruction_wire, IF_PC_4_wire}),
	 .DataOut(IF_Reg_Data)
);

assign ID_Instruction_wire = IF_Reg_Data[63:32];
assign ID_PC_4_wire = IF_Reg_Data[31:0];


/*****************************************************************************************************
 *                           INSTRUCTION DECODE (ID) PIPELINE STAGE                                  *
 *****************************************************************************************************/

Control
ControlUnit
(
	.OP(ID_Instruction_wire[31:26]),
	.funct(ID_Instruction_wire[5:0]),
	.RegDst(ID_RegDst_wire),
	.BranchNE(ID_BranchNE_wire),
	.BranchEQ(ID_BranchEQ_wire),
	.ALUOp(ID_ALUOp_wire),
	.ALUSrc(ID_ALUSrc_wire),
	.RegWrite(ID_RegWrite_wire),
	.Jump(ID_Jump_wire),
	.JumpAndLink(ID_JumpAndLink_wire),
	.LoadUpperImmediate(ID_LoadUpperImmediate_wire),
	.MemToReg(ID_MemToReg_wire),
	.MemWrite(ID_MemWrite_wire),
	.MemRead(ID_MemRead_wire),
	.JumpRegister(ID_JumpRegister_wire)
);

RegisterFile
Register_File
(
	.clk(clk),
	.reset(reset),
	.RegWrite(WB_RegWrite_wire),
	.WriteRegister(WB_WriteRegister_wire),
	.ReadRegister1(ID_Instruction_wire[25:21]),
	.ReadRegister2(ID_Instruction_wire[20:16]),
	.WriteData(WB_WriteData_wire),
	.ReadData1(ID_ReadData1_wire),
	.ReadData2(ID_ReadData2_wire)

);


// NOTE: Not sure if this is ok here or if it should be in EX
ShiftLeft2
ShifterInstructionJAddress
(   
   .DataInput(ID_Instruction_wire[25:0]),
   .DataOutput(ID_JumpAddressShifted_wire)
);

SignExtend
SignExtendForConstants
(   
	.DataInput(ID_Instruction_wire[15:0]),
   .SignExtendOutput(ID_ImmediateExtend_wire)
);

Pipeline_Reg
#(
	.SIZE(174)
)
ID_EX_Register
(
    .clk(clk),
    .reset(reset),
    .DataIn({ID_JumpRegister_wire, ID_BranchNE_wire, ID_BranchEQ_wire,
				ID_RegDst_wire, ID_ReadData1_wire, ID_ImmediateExtend_wire, ID_ALUOp_wire, ID_ALUSrc_wire, // Needed by EX
				ID_ReadData2_wire, ID_MemToReg_wire, ID_MemWrite_wire, ID_MemRead_wire, // Needed by MEM
				ID_RegWrite_wire, ID_JumpAndLink_wire, ID_LoadUpperImmediate_wire, // Needed by WB
				ID_Instruction_wire, ID_PC_4_wire}), // Needed by all pipeline stages
	 .DataOut(ID_Reg_Data)
);

assign EX_JumpRegister_wire = ID_Reg_Data[173];
assign EX_BranchNE_wire = ID_Reg_Data[172];
assign EX_BranchEQ_wire = ID_Reg_Data[171];
assign EX_RegDst_wire = ID_Reg_Data[170];
assign EX_ReadData1_wire = ID_Reg_Data[169:138];
assign EX_ImmediateExtend_wire = ID_Reg_Data[137:106];
assign EX_ALUOp_wire = ID_Reg_Data[105:103];
assign EX_ALUSrc_wire = ID_Reg_Data[102];
assign EX_ReadData2_wire = ID_Reg_Data[101:70];
assign EX_MemToReg_wire = ID_Reg_Data[69];
assign EX_MemWrite_wire = ID_Reg_Data[68];
assign EX_MemRead_wire = ID_Reg_Data[67];
assign EX_RegWrite_wire = ID_Reg_Data[66];
assign EX_JumpAndLink_wire = ID_Reg_Data[65];
assign EX_LoadUpperImmediate_wire = ID_Reg_Data[64];
assign EX_Instruction_wire = ID_Reg_Data[63:32];
assign EX_PC_4_wire = ID_Reg_Data[31:0];


/*****************************************************************************************************
 *                                 EXECUTION (EX) PIPELINE STAGE                                     *
 *****************************************************************************************************/

// TODO: Move this to ID stage
ShiftLeft2
Shifter 
(   
	.DataInput(EX_ImmediateExtend_wire),
   .DataOutput(EX_ImmediateExtendAndShifted_wire)
);

// TODO: Move this to ID stage
Adder32bits
AdderForBranching
(
	.Data0(EX_PC_4_wire),
	.Data1(EX_ImmediateExtendAndShifted_wire),
	.Result(EX_PCtoBranch_wire)
);

Multiplexer2to1
#(
	.NBits(32)
)
MUX_ForReadDataAndInmediate
(
	.Selector(EX_ALUSrc_wire),
	.MUX_Data0(EX_ReadData2_wire),
	.MUX_Data1(EX_ImmediateExtend_wire),
	
	.MUX_Output(EX_ReadData2OrImmediate_wire)

);

ALUControl
ArithmeticLogicUnitControl
(
	.ALUOp(EX_ALUOp_wire),
	.ALUFunction(EX_Instruction_wire[5:0]),
	.ALUOperation(EX_ALUOperation_wire)
);

ALU
ArithmeticLogicUnit 
(
	.ALUOperation(EX_ALUOperation_wire),
	.A(EX_ReadData1_wire),
	.B(EX_ReadData2OrImmediate_wire),
	.shamt(EX_Instruction_wire[10:6]),
	.Zero(EX_Zero_wire),
	.ALUResult(EX_ALUResult_wire)
);

Multiplexer2to1
#(
	.NBits(5)
)
MUX_ForRTypeAndIType
(
	.Selector(EX_RegDst_wire),
	.MUX_Data0(EX_Instruction_wire[20:16]),
	.MUX_Data1(EX_Instruction_wire[15:11]),
	
	.MUX_Output(EX_WriteRegisterOrI_wire)

);

Multiplexer2to1
#(
	.NBits(5)
)
MUX_ForRTypeAndITypeOrRA
(
	.Selector(EX_JumpAndLink_wire),
	.MUX_Data0(EX_WriteRegisterOrI_wire),
	.MUX_Data1(5'b11111),
	.MUX_Output(EX_WriteRegister_wire)
);

// PIPELINE REG
Pipeline_Reg
#(
	.SIZE(174)
)
EX_MEM_Register
(
    .clk(clk),
    .reset(reset),
    .DataIn({EX_BranchNE_wire, EX_BranchEQ_wire,
				 EX_WriteRegister_wire, EX_ALUResult_wire, EX_Zero_wire, EX_PCtoBranch_wire,
				 EX_ReadData2_wire, EX_MemToReg_wire, EX_MemWrite_wire, EX_MemRead_wire, // Needed by MEM
				 EX_RegWrite_wire, EX_JumpAndLink_wire, EX_LoadUpperImmediate_wire, // Needed by WB
				 EX_Instruction_wire, EX_PC_4_wire}), // Needed by all pipeline stages
	 .DataOut(EX_Reg_Data)
);

assign MEM_BranchNE_wire = EX_Reg_Data[173];
assign MEM_BranchEQ_wire = EX_Reg_Data[172];
assign MEM_WriteRegister_wire = EX_Reg_Data[171:167];
assign MEM_ALUResult_wire = EX_Reg_Data[166:135];
assign MEM_Zero_wire = EX_Reg_Data[134];
assign MEM_PCtoBranch_wire = EX_Reg_Data[133:102];
assign MEM_ReadData2_wire = EX_Reg_Data[101:70];
assign MEM_MemToReg_wire = EX_Reg_Data[69];
assign MEM_MemWrite_wire = EX_Reg_Data[68];
assign MEM_MemRead_wire = EX_Reg_Data[67];
assign MEM_RegWrite_wire = EX_Reg_Data[66];
assign MEM_JumpAndLink_wire = EX_Reg_Data[65];
assign MEM_LoadUpperImmediate_wire = EX_Reg_Data[64];
assign MEM_Instruction_wire = EX_Reg_Data[63:32];
assign MEM_PC_4_wire = EX_Reg_Data[31:0];


/*****************************************************************************************************
 *                                   MEMORY (MEM) PIPELINE STAGE                                     *
 *****************************************************************************************************/

// TODO: remove this, add COMPARISON module to ID stage
ANDGate
ANDGateForBEQ
(
	.A(MEM_Zero_wire),
	.B(MEM_BranchEQ_wire),
	.C(MEM_ZeroANDBrachEQ)
);

// TODO: remove this, add COMPARISON module to ID stage
ANDGate
ANDGateForBNE
(
	.A(~MEM_Zero_wire),
	.B(MEM_BranchNE_wire),
	.C(MEM_NotZeroANDBrachNE)
);

// TODO: remove this, add COMPARISON module to ID stage
ORGate
ORGateForBNEOrBEQ
(
	.A(MEM_ZeroANDBrachEQ),
	.B(MEM_NotZeroANDBrachNE),
	.C(MEM_ORForBranch)
);


DataMemory
#(
	.DATA_WIDTH(32),
	.ADDR_SIZE(10)
)
RAMDataMemory
(
	.clk(clk),
	.WriteData(MEM_ReadData2_wire),
	.Address(MEM_ALUResult_wire[9:0]),
	.MemWrite(MEM_MemWrite_wire),
	.MemRead(MEM_MemRead_wire),
	.ReadData(MEM_MemoryData_wire)
);
// PIPELINE REG
Pipeline_Reg
#(
	.SIZE(137)
)
MEM_WB_Register
(
    .clk(clk),
    .reset(reset),
    .DataIn({MEM_MemToReg_wire, MEM_MemoryData_wire, MEM_WriteRegister_wire, MEM_ALUResult_wire,
				 MEM_RegWrite_wire, MEM_JumpAndLink_wire, MEM_LoadUpperImmediate_wire, // Needed by WB
				 MEM_Instruction_wire, MEM_PC_4_wire}), // Needed by all pipeline stages
	 .DataOut(MEM_Reg_Data)
);

assign WB_MemToReg_wire = MEM_Reg_Data[136];
assign WB_MemoryData_wire = MEM_Reg_Data[135:104];
assign WB_WriteRegister_wire = MEM_Reg_Data[103:99];
assign WB_ALUResult_wire = MEM_Reg_Data[98:67];
assign WB_RegWrite_wire = MEM_Reg_Data[66];
assign WB_JumpAndLink_wire = MEM_Reg_Data[65];
assign WB_LoadUpperImmediate_wire = MEM_Reg_Data[64];
assign WB_Instruction_wire = MEM_Reg_Data[63:32];
assign WB_PC_4_wire = MEM_Reg_Data[31:0];


/*****************************************************************************************************
 *                                 WRITE BACK (WB) PIPELINE STAGE                                    *
 *****************************************************************************************************/

Multiplexer2to1
#(
	.NBits(32)
)
MUX_ForALUResultAndMemoryData
(
	.Selector(WB_MemToReg_wire),
	.MUX_Data0(WB_ALUResult_wire),
	.MUX_Data1(WB_MemoryData_wire),
	.MUX_Output(WB_ALUResultOrMemoryData_wire)
);

Multiplexer2to1
#(
	.NBits(32)
)
MUX_ForALUResultAndMemoryDataAndPC4
(
	.Selector(WB_JumpAndLink_wire),
	.MUX_Data0(WB_ALUResultOrMemoryData_wire),
	.MUX_Data1(WB_PC_4_wire),
	.MUX_Output(WB_ALUResultOrMemoryDataOrPC4_wire)
);

Multiplexer2to1
#(
	.NBits(32)
)
MUX_ForALUResultAndMemoryDataAndPC4AndLUI
(
	.Selector(WB_LoadUpperImmediate_wire),
	.MUX_Data0(WB_ALUResultOrMemoryDataOrPC4_wire),
	.MUX_Data1({WB_Instruction_wire[15:0], 16'b0}),
	.MUX_Output(WB_WriteData_wire)
);

assign ALUResultOut = WB_ALUResult_wire;


endmodule
