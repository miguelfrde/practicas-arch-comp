/******************************************************************
* Description
*	This is control unit for the MIPS processor. The control unit is 
*	in charge of generation of the control signals. Its only input 
*	corresponds to opcode from the instruction.
*	1.0
* Author:
*	MSc. José Luis Pizano Escalante
* Date:
*	01/03/2014
******************************************************************/
module Control
(
	input [5:0]OP,
	
	output RegDst,
	output BranchEQ,
	output BranchNE,
	output MemRead,
	output MemToReg,
	output MemWrite,
	output ALUSrc,
	output RegWrite,
	output Jump,
	output JumpAndLink,
	output LoadUpperImmediate,
	output [2:0]ALUOp
);

localparam R_Type = 0;
localparam I_Type_ADDI = 6'h8;
localparam I_Type_ORI = 6'h0d;
localparam I_Type_ANDI = 6'h0c;
localparam I_Type_SW = 6'h2b;
localparam I_Type_LW = 6'h23;
localparam BEQ = 6'h4;
localparam BNE = 6'h5;
localparam J = 6'h2;
localparam JAL = 6'h3;
localparam LUI = 6'hf;

reg [13:0] ControlValues;

always@(OP) begin
	casex(OP)
		R_Type:      ControlValues = 14'b0_00_1_001_00_00_111;
		I_Type_ADDI: ControlValues = 14'b0_00_0_101_00_00_100;  
		I_Type_ORI:  ControlValues = 14'b0_00_0_101_00_00_101;  
		I_Type_ANDI: ControlValues = 14'b0_00_0_101_00_00_110;
		BEQ:         ControlValues = 14'b0_00_0_000_00_01_001;
		BNE:         ControlValues = 14'b0_00_0_000_00_10_001;
		J:           ControlValues = 14'b0_01_0_000_00_00_000;
		JAL:         ControlValues = 14'b0_11_0_001_00_00_000;
		LUI:         ControlValues = 14'b1_00_0_001_00_00_000;
		I_Type_SW:	 ControlValues = 14'b0_00_0_100_01_00_100;
		I_Type_LW:	 ControlValues = 14'b0_00_0_111_10_00_100;
		default:     ControlValues = 14'b0;
		endcase
end	

assign LoadUpperImmediate = ControlValues[13];
assign JumpAndLink = ControlValues[12];
assign Jump = ControlValues[11];
assign RegDst = ControlValues[10];
assign ALUSrc = ControlValues[9];
assign MemToReg = ControlValues[8];
assign RegWrite = ControlValues[7];
assign MemRead = ControlValues[6];
assign MemWrite = ControlValues[5];
assign BranchNE = ControlValues[4];
assign BranchEQ = ControlValues[3];
assign ALUOp = ControlValues[2:0];
	

endmodule