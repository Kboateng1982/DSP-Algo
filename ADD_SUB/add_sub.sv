// Design model with input and output ports (a 32-bit adder/subtractor)

timeunit 1ns;
timeprecision 1ns;

module rtl_adder_subtractor
#(parameter N = 32)
(  		input wire clk,                      // 1-bit scalar clock 
		input wire reset_n,				     // 1-bit scalar reset_n 
		input wire mode,                     // 1-bit scalar mode
		input wire [N-1:0] a, b,             // 32-bit vector inputs
		output logic [N-1:0] sum			 // 32-bit vector output sum 
);

always_ff @(posedge clk or negedge reset_n)
begin
     if (!reset_n) 
	 begin
			sum <= '0;
	 end 
	 
	 else 
	 begin 
	      if ( mode == 0)  sum <= (a + b);
		  else 			   sum <= (a - b);
	 end 
end 

endmodule : rtl_adder_subtractor