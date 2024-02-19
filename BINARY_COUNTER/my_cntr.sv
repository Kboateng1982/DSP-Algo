// Authur : Kwadwo Boateng
// Lab 5

/*
Abstract
In this lab you will write the complete RTL description for a counter module using a parameter
statement. You will also create the testbench and verify the design.
This lab should take approximately 45 minutes.

Objectives
After completing this lab, you will be able to:
• Create, simulate, and verify RTL code for an n-bit binary counter
• Use the language templates in the Vivado® Design Suite
• Use Verilog parameter statements

*/

module my_cntr
#(parameter WIDTH = 4)
(
 input 		wire 	[WIDTH-1:0] data,
 input 		wire 				reset,   // Active high synchronous reset
 input 		wire 				sys_clk, // Clock signal
 input 		wire 				updn,    // When set to '1' the counter behaves as up counter or else down counter
 input      wire                load,    // When set to high loads the data input on to the output port q
 input      wire                ce,      // enables the counter
 output     reg    [WIDTH-1:0]  Q
);

 //Internal variables
reg [WIDTH-1:0] Count = 0; 
always_ff @ (posedge sys_clk)
begin
      if (reset) 
	  begin 
	      Count <= '0;
	  end 
	  
	  else if (load) 
	  begin 
	       Count <= data;
	  end 
	  
	  else if (ce)
         begin 	  
		        Count <= '0;
		    if (updn)  //Up mode selected
			  begin 
					if(Count == '1)
						Count <= '0;
					else 
						Count <= Count + 1'b1; //Incremend Counter
			 end 
            else       //Down mode selected
			 begin 
					if(Count == '0)
						Count <= '1;
					else 
						Count <= Count - 1'b1; //Decrement counter
			 end 
		 end 
end 

assign Q = Count;

endmodule : my_cntr