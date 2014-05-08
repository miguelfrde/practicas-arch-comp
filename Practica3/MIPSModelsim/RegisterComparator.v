module RegisterComparator
(
	input EX_ALUSrc,
	input MEM_ALUSrc,
	input WB_ALUSrc,
	input WB_RegWrite,
	input [4:0] EX_Op, //Rs FOR A Rt for B
	input [4:0] EX_Rs,
	input [4:0] MEM_Rd,
	input [4:0] MEM_Rt,
	input [4:0] WB_Rd,
	input [4:0] WB_Rt,
	output reg ForwardPlease
);

wire[4:0] WBdest_wire;
wire[4:0] MEMdest_wire;
wire[4:0] EXOp_wire;

Multiplexer2to1
#(
	.NBits(5)
)
MUX_WB
(
	.Selector(WB_ALUSrc),
	.MUX_Data0(WB_Rd),
	.MUX_Data1(WB_Rt),
	.MUX_Output(WBdest_wire)

);

Multiplexer2to1
#(
	.NBits(5)
)
MUX_MEM
(
	.Selector(MEM_ALUSrc),
	.MUX_Data0(MEM_Rd),
	.MUX_Data1(MEM_Rt),
	.MUX_Output(MEMdest_wire)

);

Multiplexer2to1
#(
	.NBits(5)
)
MUX_EX
(
	.Selector(EX_ALUSrc),
	.MUX_Data0(EX_Op),
	.MUX_Data1(EX_Rs),
	.MUX_Output(EXOp_wire)

);


always @(*)
begin
	if(WB_RegWrite == 1 && WBdest_wire!= 0 && (MEMdest_wire != EXOp_wire) && (WBdest_wire == EXOp_wire))
	begin
		ForwardPlease = 1;
	end
	else
		ForwardPlease = 0;
end

endmodule