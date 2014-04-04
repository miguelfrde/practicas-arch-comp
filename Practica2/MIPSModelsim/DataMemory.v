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

wire [ADDR_SIZE-1:0] RealAddress;
assign RealAddress = Address >> 2;

always @ (posedge clk)
begin
	// Write
	if (MemWrite)
		ram[RealAddress] <= WriteData;
end

assign ReadDataAux = ram[RealAddress];
assign ReadData = {DATA_WIDTH{MemRead}}& ReadDataAux;

endmodule
