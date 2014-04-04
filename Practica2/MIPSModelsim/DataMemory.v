module DataMemory 
#(	parameter DATA_WIDTH = 8,
	parameter ADDR_SIZE = 10

)
(
	input [DATA_WIDTH-1:0] WriteData,
	input [ADDR_SIZE-1:0] Address,
	input MemWrite, MemRead, clk,
	output [DATA_WIDTH-1:0]  ReadData
);
	
// Declare the RAM variable
reg [DATA_WIDTH-1:0] ram[2**ADDR_SIZE-1:0];
wire [DATA_WIDTH-1:0] ReadDataAux;

always @ (posedge clk)
begin
	// Write
	if (MemWrite)
		ram[Address] <= WriteData;
end

assign ReadDataAux = ram[Address];
assign ReadData = {DATA_WIDTH{MemRead}}& ReadDataAux;

endmodule
