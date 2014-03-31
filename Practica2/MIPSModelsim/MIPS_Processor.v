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
	parameter MEMORY_DEPTH = 32
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
wire BranchNE_wire;
wire BranchEQ_wire;
wire RegDst_wire;
wire NotZeroANDBrachNE;
wire ZeroANDBrachEQ;
wire ORForBranch;
wire ALUSrc_wire;
wire RegWrite_wire;
wire Zero_wire;
wire [2:0] ALUOp_wire;
wire [3:0] ALUOperation_wire;
wire [4:0] WriteRegister_wire;

wire [31:0] Instruction_wire;
wire [31:0] ReadData1_wire;
wire [31:0] ReadData2_wire;
wire [31:0] InmmediateExtend_wire;
wire [31:0] ReadData2OrInmmediate_wire;
wire [31:0] ALUResult_wire;
wire [31:0] PC_4_wire;
wire [31:0] InmmediateExtendAndShifted_wire;
wire [31:0] PCtoBranch_wire;

wire[31:0] MUX_PC_wire;
wire[31:0] PC_wire;

wire ALUShamt_wire;
wire [31:0] ReadData1OrShamt_wire;

wire [27:0] JumpAddressShifted_wire;
wire [31:0] MUX_PC_JUMP_wire;
wire Jump_wire;

wire JumpAndLink_wire;
wire [4:0] WriteRegisterOrRA_wire;
wire [31:0] ALUResultOrPC4_wire;

integer ALUStatus;


//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
Control
ControlUnit
(
	.OP(Instruction_wire[31:26]),
	.RegDst(RegDst_wire),
	.BranchNE(BranchNE_wire),
	.BranchEQ(BranchEQ_wire),
	.ALUOp(ALUOp_wire),
	.ALUSrc(ALUSrc_wire),
	.RegWrite(RegWrite_wire),
	.Jump(Jump_wire),
	.JumpAndLink(JumpAndLink_wire)
);

PC_Register
ProgramCounter
(
    .clk(clk),
    .reset(reset),
    .NewPC(MUX_PC_JUMP_wire),
    .PCValue(PC_wire)
);


`ifdef MONITORS
initial
	ALUStatus = $fopen("ALUResult.dat");

always@(posedge clk)
  $display("PC value %d ALU result %00h",PC_wire,ALUResult_wire );
  
always@(posedge clk)
	$fdisplay(ALUStatus, "%h", ALUResult_wire);
`endif 

ProgramMemory
#(
	.MEMORY_DEPTH(MEMORY_DEPTH)
)
ROMProgramMemory
(
	.Address(PC_wire),
	.Instruction(Instruction_wire)
);

Adder32bits
PC_Puls_4
(
	.Data0(PC_wire),
	.Data1(4),
	
	.Result(PC_4_wire)
);

ShiftLeft2
Shifter 
(   
	.DataInput(InmmediateExtend_wire),
   .DataOutput(InmmediateExtendAndShifted_wire)

);

Adder32bits
AdderForBranching
(
	.Data0(PC_4_wire),
	.Data1(InmmediateExtendAndShifted_wire),
	
	.Result(PCtoBranch_wire)
);

ANDGate
ANDGateForBEQ
(
	.A(Zero_wire),
	.B(BranchEQ_wire),
	.C(ZeroANDBrachEQ)
);

ANDGate
ANDGateForBNE
(
	.A(~Zero_wire),
	.B(BranchNE_wire),
	.C(NotZeroANDBrachNE)
);

ORGate
ORGateForBNEOrBEQ
(
	.A(ZeroANDBrachEQ),
	.B(NotZeroANDBrachNE),
	.C(ORForBranch)
);


Multiplexer2to1
#(
	.NBits(32)
)
MUX_PC
(
	.Selector(ORForBranch),
	.MUX_Data0(PC_4_wire),
	.MUX_Data1(PCtoBranch_wire),
	
	.MUX_Output(MUX_PC_wire)

);

ShiftLeft2
ShifterInstructionJAddress
(   
   .DataInput(Instruction_wire[25:0]),
   .DataOutput(JumpAddressShifted_wire)
);

Multiplexer2to1
#(
	.NBits(32)
)
MUX_JUMP
(
	.Selector(Jump_wire),
	.MUX_Data0(MUX_PC_wire),
	.MUX_Data1({PC_4_wire[31:28], JumpAddressShifted_wire}),
	.MUX_Output(MUX_PC_JUMP_wire)
);


//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
Multiplexer2to1
#(
	.NBits(5)
)
MUX_ForRTypeAndIType
(
	.Selector(RegDst_wire),
	.MUX_Data0(Instruction_wire[20:16]),
	.MUX_Data1(Instruction_wire[15:11]),
	
	.MUX_Output(WriteRegister_wire)

);

Multiplexer2to1
#(
	.NBits(5)
)
MUX_ForRTypeAndITypeOrRA
(
	.Selector(JumpAndLink_wire),
	.MUX_Data0(WriteRegister_wire),
	.MUX_Data1(5'b11111),
	.MUX_Output(WriteRegisterOrRA_wire)
);

RegisterFile
Register_File
(
	.clk(clk),
	.reset(reset),
	.RegWrite(RegWrite_wire),
	.WriteRegister(WriteRegisterOrRA_wire),
	.ReadRegister1(Instruction_wire[25:21]),
	.ReadRegister2(Instruction_wire[20:16]),
	.WriteData(ALUResultOrPC4_wire),
	.ReadData1(ReadData1_wire),
	.ReadData2(ReadData2_wire)

);

SignExtend
SignExtendForConstants
(   
	.DataInput(Instruction_wire[15:0]),
   .SignExtendOutput(InmmediateExtend_wire)
);

Multiplexer2to1
#(
	.NBits(32)
)
MUX_ForReadDataAndInmediate
(
	.Selector(ALUSrc_wire),
	.MUX_Data0(ReadData2_wire),
	.MUX_Data1(InmmediateExtend_wire),
	
	.MUX_Output(ReadData2OrInmmediate_wire)

);


ALUControl
ArithmeticLogicUnitControl
(
	.ALUOp(ALUOp_wire),
	.ALUFunction(Instruction_wire[5:0]),
	.ALUOperation(ALUOperation_wire),
	.ALUShamt(ALUShamt_wire)
);

Multiplexer2to1
#(
	.NBits(32)
)
MUX_ForReadDataAndShamt
(
	.Selector(ALUShamt_wire),
	.MUX_Data0(ReadData1_wire),
	.MUX_Data1({27'b0, Instruction_wire[10:6]}),
	.MUX_Output(ReadData1OrShamt_wire)
);

ALU
ArithmeticLogicUnit 
(
	.ALUOperation(ALUOperation_wire),
	.A(ReadData1OrShamt_wire),
	.B(ReadData2OrInmmediate_wire),
	.Zero(Zero_wire),
	.ALUResult(ALUResult_wire)
);

Multiplexer2to1
#(
	.NBits(32)
)
MUX_ForALUResultAndPC4
(
	.Selector(JumpAndLink_wire),
	.MUX_Data0(ALUResult_wire),
	.MUX_Data1(PC_4_wire),
	.MUX_Output(ALUResultOrPC4_wire)
);

assign ALUResultOut = ALUResult_wire;


endmodule

