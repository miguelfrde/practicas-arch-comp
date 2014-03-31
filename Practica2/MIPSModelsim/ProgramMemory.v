/******************************************************************
* Description
*	This is  a ROM memory that represents the program memory. 
* 	Internally, the memory is read without a signal clock. The initial 
*	values (program) of this memory are written from a file named text.dat.
* Version:
*	1.0
* Author:
*	MSc. José Luis Pizano Escalante
* Date:
*	01/03/2014
******************************************************************/
module ProgramMemory
#
(
	parameter MEMORY_DEPTH=32,
	parameter DATA_WIDTH=32
)
(
	input [(DATA_WIDTH-1):0] Address,
	output reg [(DATA_WIDTH-1):0] Instruction
);
wire [(DATA_WIDTH-1):0] RealAddress;

assign RealAddress = (Address - 'h400000) >> 2;

	// Declare the ROM variable
	reg [DATA_WIDTH-1:0] rom[MEMORY_DEPTH-1:0];

	initial
	begin
		$readmemh("text.dat", rom);
	end

	always @ (RealAddress)
	begin
		Instruction = rom[RealAddress];
	end

endmodule
