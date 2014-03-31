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
	output MemtoReg,
	output MemWrite,
	output ALUSrc,
	output RegWrite,
	output Jump,
	output JumpAndLink,
	output [2:0]ALUOp
);

localparam R_Type = 0;
localparam I_Type_ADDI = 6'h8;
localparam I_Type_ORI = 6'h0d;
localparam I_Type_ANDI = 6'h0c;
localparam BEQ = 6'h4;
localparam BNE = 6'h5;
localparam J = 6'h2;
localparam JAL = 6'h3;

reg [12:0] ControlValues;

always@(OP) begin
	casex(OP)
		R_Type:      ControlValues = 13'b00_1_001_00_00_111;
		I_Type_ADDI: ControlValues = 13'b00_0_101_00_00_100;  
		I_Type_ORI:  ControlValues = 13'b00_0_101_00_00_101;  
		I_Type_ANDI: ControlValues = 13'b00_0_101_00_00_110;
		BEQ:         ControlValues = 13'b00_0_000_00_01_001;
		BNE:         ControlValues = 13'b00_0_000_00_10_001;
		J:           ControlValues = 13'b01_0_000_00_00_000;
		JAL:         ControlValues = 13'b11_0_001_00_00_000;
		default:
			ControlValues= 13'b000000000000;
		endcase
end	

assign JumpAndLink = ControlValues[12];
assign Jump = ControlValues[11];
assign RegDst = ControlValues[10];
assign ALUSrc = ControlValues[9];
assign MemtoReg = ControlValues[8];
assign RegWrite = ControlValues[7];
assign MemRead = ControlValues[6];
assign MemWrite = ControlValues[5];
assign BranchNE = ControlValues[4];
assign BranchEQ = ControlValues[3];
assign ALUOp = ControlValues[2:0];
	

endmodule