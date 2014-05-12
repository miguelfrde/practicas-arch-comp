/******************************************************************
* Description
*	This is a  an 3to1 multiplexer that can be parameterized in its bit-width.
*	1.0
* Author:
*	Miguel Flores Ruiz de Eguino
* Date:
*	05/02/2014
******************************************************************/

module EqualsComparator
#(
	parameter DATA_SIZE=32
)
(
    input[DATA_SIZE-1:0] A,
    input[DATA_SIZE-1:0] B,
    output equals
);

assign equals = (A - B) == 'b0;

endmodule