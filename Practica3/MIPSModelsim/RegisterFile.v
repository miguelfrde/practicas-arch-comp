/******************************************************************
* Description
*	This is  module represents the register file where the registers 
*	like $s0-$s7 are store. 
*	of MIPS processor.
* Version:
*	1.0
* Author:
*	MSc. José Luis Pizano Escalante
* Date:
*	01/03/2014
******************************************************************/
module RegisterFile
#(
	parameter N=32
)
(
	input clk,
	input reset,
	input RegWrite,
	input [4:0] WriteRegister,
	input [4:0] ReadRegister1,
	input [4:0] ReadRegister2,
	input  [31:0] WriteData,
	output [31:0] ReadData1,
	output [31:0] ReadData2

);

genvar i;
wire [32*N-1:0]Intercnection_wire;
wire [31:0] SelectRegister_wire;
`ifdef MONITORS
reg [31:0]RegiterArray[0:31];

always@(*) begin
	if(RegWrite)
		RegiterArray[WriteRegister] <= WriteData;
end
`endif 

DecoderRegisterFile
Decoder
(
	.WriteRegister(WriteRegister),
	.SelectRegister(SelectRegister_wire)
);



Register
ZeroRegister
(
	.clk(clk),
	.reset(reset),
	.enable(SelectRegister_wire[0]&RegWrite),
	.DataInput(0),
	.DataOutput(Intercnection_wire[N-1:0])
);


//Register
//atRegister
//(
//	.clk(clk),
//	.reset(reset),
//	.enable(SelectRegister_wire[1]&RegWrite),
//	.DataInput(WriteData),
//	.DataOutput(Reverse)
//);

//assign Intercnection_wire[(2*N)-1:N] = Reverse;

//always begin
	generate
		for(i=1;i<32;i=i+1)begin:Registeri
		Register
		Register_i
		(
			.clk(clk),
			.reset(reset),
			.enable(SelectRegister_wire[i]&RegWrite),
			.DataInput(WriteData),
			.DataOutput(Intercnection_wire[((i+1)*N)-1:i*N])
		);
		end
	endgenerate
//end

MUXRegisterFile
#(
	.N(32)
)
MUXRegister1
(
	.Selector(ReadRegister1),

	.Data_0(Intercnection_wire[1*N-1:0*N]),
	.Data_1(Intercnection_wire[2*N-1:1*N]),
	.Data_2(Intercnection_wire[3*N-1:2*N]),
	.Data_3(Intercnection_wire[4*N-1:3*N]),
	.Data_4(Intercnection_wire[5*N-1:4*N]),
	.Data_5(Intercnection_wire[6*N-1:5*N]),
	.Data_6(Intercnection_wire[7*N-1:6*N]),
	.Data_7(Intercnection_wire[8*N-1:7*N]),
	.Data_8(Intercnection_wire[9*N-1:8*N]),
   .Data_9(Intercnection_wire[10*N-1:9*N]),
	.Data_10(Intercnection_wire[11*N-1:10*N]),
	.Data_11(Intercnection_wire[12*N-1:11*N]),
	.Data_12(Intercnection_wire[13*N-1:12*N]),
	.Data_13(Intercnection_wire[14*N-1:13*N]),
	.Data_14(Intercnection_wire[15*N-1:14*N]),
	.Data_15(Intercnection_wire[16*N-1:15*N]),
	.Data_16(Intercnection_wire[17*N-1:16*N]),
	.Data_17(Intercnection_wire[18*N-1:17*N]),
	.Data_18(Intercnection_wire[19*N-1:18*N]),
	.Data_19(Intercnection_wire[20*N-1:19*N]),
	.Data_20(Intercnection_wire[21*N-1:20*N]),
	.Data_21(Intercnection_wire[22*N-1:21*N]),
	.Data_22(Intercnection_wire[23*N-1:22*N]),
	.Data_23(Intercnection_wire[24*N-1:23*N]),
	.Data_24(Intercnection_wire[25*N-1:24*N]),
	.Data_25(Intercnection_wire[26*N-1:25*N]),
	.Data_26(Intercnection_wire[27*N-1:26*N]),
	.Data_27(Intercnection_wire[28*N-1:27*N]),
	.Data_28(Intercnection_wire[29*N-1:28*N]),
	.Data_29(Intercnection_wire[30*N-1:29*N]),
	.Data_30(Intercnection_wire[31*N-1:30*N]),
	.Data_31(Intercnection_wire[32*N-1:31*N]),
	
	.MUX_Output(ReadData1)
);


MUXRegisterFile
#(
	.N(32)
)
MUXRegister2
(
	.Selector(ReadRegister2),

		.Data_0(Intercnection_wire[1*N-1:0*N]),
	.Data_1(Intercnection_wire[2*N-1:1*N]),
	.Data_2(Intercnection_wire[3*N-1:2*N]),
	.Data_3(Intercnection_wire[4*N-1:3*N]),
	.Data_4(Intercnection_wire[5*N-1:4*N]),
	.Data_5(Intercnection_wire[6*N-1:5*N]),
	.Data_6(Intercnection_wire[7*N-1:6*N]),
	.Data_7(Intercnection_wire[8*N-1:7*N]),
	.Data_8(Intercnection_wire[9*N-1:8*N]),
   .Data_9(Intercnection_wire[10*N-1:9*N]),
	.Data_10(Intercnection_wire[11*N-1:10*N]),
	.Data_11(Intercnection_wire[12*N-1:11*N]),
	.Data_12(Intercnection_wire[13*N-1:12*N]),
	.Data_13(Intercnection_wire[14*N-1:13*N]),
	.Data_14(Intercnection_wire[15*N-1:14*N]),
	.Data_15(Intercnection_wire[16*N-1:15*N]),
	.Data_16(Intercnection_wire[17*N-1:16*N]),
	.Data_17(Intercnection_wire[18*N-1:17*N]),
	.Data_18(Intercnection_wire[19*N-1:18*N]),
	.Data_19(Intercnection_wire[20*N-1:19*N]),
	.Data_20(Intercnection_wire[21*N-1:20*N]),
	.Data_21(Intercnection_wire[22*N-1:21*N]),
	.Data_22(Intercnection_wire[23*N-1:22*N]),
	.Data_23(Intercnection_wire[24*N-1:23*N]),
	.Data_24(Intercnection_wire[25*N-1:24*N]),
	.Data_25(Intercnection_wire[26*N-1:25*N]),
	.Data_26(Intercnection_wire[27*N-1:26*N]),
	.Data_27(Intercnection_wire[28*N-1:27*N]),
	.Data_28(Intercnection_wire[29*N-1:28*N]),
	.Data_29(Intercnection_wire[30*N-1:29*N]),
	.Data_30(Intercnection_wire[31*N-1:30*N]),
	.Data_31(Intercnection_wire[32*N-1:31*N]),
	
	.MUX_Output(ReadData2)
);
endmodule