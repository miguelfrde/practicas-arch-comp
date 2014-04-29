module IF_ID_Register 
(
    input clk,
    input reset,
    input [31:0] IF_Instruction,
    input [31:0] IF_PC_4,
	 output [31:0] ID_Instruction,
	 output [31:0] ID_PC_4
);

reg [31:0] Instruction;
reg [31:0] PC_4;

assign ID_Instruction = Instruction;
assign ID_PC_4 = PC_4;

always @(negedge reset or posedge clk) begin
    if (!reset)
	   begin
        Instruction <= 32'b0;
		  PC_4 <= 32'b0;
      end
	 else
	   begin
	     Instruction <= IF_Instruction;
		  PC_4 <= IF_PC_4;
		end
end

endmodule
