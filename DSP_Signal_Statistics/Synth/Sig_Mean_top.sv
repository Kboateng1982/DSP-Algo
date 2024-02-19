// Initialize ROM in SystemVerilog to read all of the input signal data converted into Binary
// Author : Kwadwo Boateng
// Data : 8-10-2021

timeunit 1ns;
timeprecision 1ns;

module Sig_Mean_top #(
    parameter DATA_WIDTH = 32, // ROM Data word width 
	parameter ROM_DEPTH  = 512, // Maximum number of words
	parameter ADDR_WIDTH_BITS = $clog2(ROM_DEPTH) //Ceiling log2N
)

(
input      			wire   			 sys_clock,   // this is the main system clock for the entire design 
input      			wire   			 reset_n,     // Active-low reset for the system
input      			wire   			 en_i,        // this is an enable port, which essentially marks the beginning of all computation
output     			logic  			 [DATA_WIDTH-1:0] output_MEAN,  // stores the computed MEAN of the input_signal 
output     			logic   	     output_MEAN_done,     		   // This flag is asserted when the mean is computed 
output     			logic  			 [DATA_WIDTH-1:0] output_VARIANCE,  // stores the computed Variance of the input_signal 
output              logic            output_VARIANCE_DONE   // This flag is asserted when the Variance is computed
);

/* logic [SIZE-1:0] divident_reg;

always @(posedge sys_clock)
begin
   divident_reg <= divident;
end  */

Top_level_MEAN #(.DATA_WIDTH(DATA_WIDTH)) Top_level_MEAN_inst 	
                                        ( .sys_clock(sys_clock),
										  .reset_n(reset_n),
										  .en_i(en_i),
                                          .output_MEAN(output_MEAN),
										  .output_MEAN_done(output_MEAN_done),
										  .output_VARIANCE(output_VARIANCE),									  
										  .output_VARIANCE_DONE(output_VARIANCE_DONE)
							            );
endmodule : Sig_Mean_top