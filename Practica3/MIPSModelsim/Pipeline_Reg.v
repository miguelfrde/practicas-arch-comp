module Pipeline_Reg 
#(	
	parameter SIZE = 32
)
(
    input clk,
    input reset,
    input [SIZE-1:0] DataIn,
    output [SIZE-1:0] DataOut
);

reg [SIZE-1:0] data;

assign DataOut = data;

always @(negedge reset or posedge clk) begin
    if (!reset)
        data <= {SIZE{1'b0}};
    else
	     data <= DataIn;
end

endmodule
