/******************************************************************
* Description
*	This is  a RAM memory that represents the data memory. 
*  The initial values of this memory are written from a file named data.dat.
* Version:
*	1.0
* Author:
*	MSc. José Luis Pizano Escalante
* Date:
*	01/03/2014
******************************************************************/
module DataMemory
#(parameter DATA_WIDTH=32
)
(
	input [(DATA_WIDTH-1):0] WriteData,
	input [(DATA_WIDTH-1):0] Address,
	input MemWrite,MemRead, clk,
	output [(DATA_WIDTH-1):0] ReadData
);

	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] ram[1023:0];

	// Variable to hold the registered read address
	reg [DATA_WIDTH-1:0] addr_reg;
	reg [(DATA_WIDTH-1):0] ReadData_reg;

	initial
	begin
		$readmemh("data.dat", ram);
	end
	
	always @ (posedge clk)
	begin
		// Write
		if (MemWrite)
			ram[Address] <= WriteData;
			ReadData_reg <= ram[Address];
	end


		// read
assign ReadData = {DATA_WIDTH{MemRead}} & ReadData_reg;
			

endmodule
