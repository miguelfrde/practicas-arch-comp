module ForwardingUnit
(
	input [4:0] ID_EX_Rs,
	input [4:0] ID_EX_Rt,
	input [4:0] EX_MEM_Rd,
	input [4:0] EX_MEM_Rt,
	input EX_MEM_RegWrite,
	input MEM_WB_RegWrite,
	input [4:0] MEM_WB_Rd,
	input ID_EX_ALUSrc,
	input EX_MEM_ALUSrc,
	input MEM_WB_ALUSrc,
	input [4:0] MEM_WB_Rt,
	output reg [1:0] ForwardA,
	output reg [1:0] ForwardB
);

wire comparatorResultA;
wire comparatorResultB;

//ForwardA
always @(*)
begin
	if (ID_EX_ALUSrc == 0 && EX_MEM_ALUSrc == 0 &&(EX_MEM_Rd == ID_EX_Rs) && (EX_MEM_RegWrite == 1) && (EX_MEM_Rd != 0))		//R and R (Type A)
		begin
			ForwardA = 2'b10;
		end		
	else if(ID_EX_ALUSrc == 1 && EX_MEM_ALUSrc == 1 && (EX_MEM_RegWrite == 1) && (EX_MEM_Rt == ID_EX_Rs) && (EX_MEM_Rt != 0)) // I and I
		begin
			ForwardA = 2'b10;
		end	
	else if(ID_EX_ALUSrc == 0 && EX_MEM_ALUSrc == 1 && (EX_MEM_RegWrite == 1) && (EX_MEM_Rt == ID_EX_Rs) && (EX_MEM_Rt != 0)) // R and I (Type A)
		begin 		
			ForwardA = 2'b10;
		end
	else if(ID_EX_ALUSrc == 1 && EX_MEM_ALUSrc == 0 && (EX_MEM_RegWrite == 1) && (EX_MEM_Rd == ID_EX_Rs) && (EX_MEM_Rd != 0))	//I and R
		begin
			ForwardA = 2'b10;
		end
	else if(comparatorResultA == 1)
		begin
		ForwardA = 2'b01;
		end
	else
		begin
		ForwardA = 2'b00;
		end
end

//ForwardB
always @(*)
begin
  if(ID_EX_ALUSrc == 0 && EX_MEM_ALUSrc == 1 && (EX_MEM_RegWrite == 1) && (EX_MEM_Rt == ID_EX_Rt) && (EX_MEM_Rt != 0)) // R and I (Type B)
		begin 		
			ForwardB = 2'b10;
		end
	else if (ID_EX_ALUSrc == 0 && EX_MEM_ALUSrc == 0 &&(EX_MEM_Rd == ID_EX_Rt) && (EX_MEM_RegWrite == 1) && (EX_MEM_Rd != 0))	//R and R (Type B)
		begin
			ForwardB = 2'b10;
		end		
	else if(comparatorResultB == 1 && ID_EX_ALUSrc == 0)	//B can only be forwarded when Executing an R-Type Inst.
		begin
		ForwardB = 2'b01;
		end
	else
		begin
		ForwardB = 2'b00;
		end
end


RegisterComparator 
comparatorA
(
	.EX_ALUSrc(ID_EX_ALUSrc),
	.MEM_ALUSrc(EX_MEM_ALUSrc),
	.WB_ALUSrc(MEM_WB_ALUSrc),
	.WB_RegWrite(MEM_WB_RegWrite),
	.EX_Op(ID_EX_Rs),
	.EX_Rs(ID_EX_Rs),
	.MEM_Rd(EX_MEM_Rd),
	.MEM_Rt(EX_MEM_Rt),
	.WB_Rd(MEM_WB_Rd),
	.WB_Rt(MEM_WB_Rt),
	.ForwardPlease(comparatorResultA)
);

RegisterComparator 
comparatorB
(
	.EX_ALUSrc(ID_EX_ALUSrc),
	.MEM_ALUSrc(EX_MEM_ALUSrc),
	.WB_ALUSrc(MEM_WB_ALUSrc),
	.WB_RegWrite(MEM_WB_RegWrite),
	.EX_Op(ID_EX_Rt),
	.EX_Rs(ID_EX_Rs),
	.MEM_Rd(EX_MEM_Rd),
	.MEM_Rt(EX_MEM_Rt),
	.WB_Rd(MEM_WB_Rd),
	.WB_Rt(MEM_WB_Rt),
	.ForwardPlease(comparatorResultB)
);




endmodule