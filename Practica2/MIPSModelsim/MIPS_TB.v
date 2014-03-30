/******************************************************************
* Description
*	This is the verifaction envioroment ofr testeting the basic MIPS
*	procesor.
* Version:
*	1.0
* Author:
*	MSc. José Luis Pizano Escalante
* Date:
*	01/03/2014
******************************************************************/
`include "Definitions.v" 

module MIPS_TB;
reg clk = 0;
reg reset = 0;  
wire [31:0] ALUResultOut;  
  
  
MIPS_Processor
DUV
(
	.clk(clk),
	.reset(reset),
	.ALUResultOut(ALUResultOut)

);
/*********************************************************/
initial // Clock generator
  begin
    $dumpfile("MIPS.vcd");
    $dumpvars(0,MIPS_TB);
    forever #2 clk = !clk;
  end
/*********************************************************/
initial begin // reset generator
	#6 reset = 1;
end
/*********************************************************/
initial 
  $monitor($realtime, " ALU Results =%d",ALUResultOut);
endmodule
