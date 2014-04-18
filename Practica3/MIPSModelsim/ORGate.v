/******************************************************************
* Description
*		This is an OR gate:
* Version:
*	1.0
* Author:
*	MSc. José Luis Pizano Escalante
* Date:
*	01/03/2014
******************************************************************/
module ORGate
(
	input A,
	input B,
	output reg C
);

always@(*)
	C = A | B;

endmodule