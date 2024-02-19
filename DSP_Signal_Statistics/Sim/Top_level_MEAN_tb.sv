////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Company :
// Design Engineer : Kwadwo Boateng
// Create Date : 8/11/2021
// Design Name : Signal Statistics 
// Module Name : Top_level_MEAN_tb (Test Bench) 
// Project Name : FPGA MEAN Algorithm
// FPGA Target Device: Agilex device
// Tool Version(s) : Quartus 21.3
// Description : This module is a Test Bench for the Convolution Kernel
// Revision : v1.0
// Additional Comments : None 
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

timeunit 1ns;
timeprecision 1ns;

`define clock_period 10

localparam DATA_WIDTH = 32;
localparam ROM_DEPTH = 512;
localparam ADDR_WIDTH_BITS = 9;


module Top_level_MEAN_tb();

logic            sys_clock;   // this is the main system clock for the entire design 
logic            reset_n;     // Active-low reset for the system
logic 			 en_i;        // this is an enable port, which essentially marks the beginning of all computation
logic  			 [DATA_WIDTH-1:0] output_MEAN;  // stores the computed MEAN of the input_signal 
logic   	     output_MEAN_done;     		   // This flag is asserted when the mean is computed 
logic            [DATA_WIDTH-1:0] output_VARIANCE;  // stores the computed Variance of the input_signal 
logic            output_VARIANCE_DONE;   // This flag is asserted when the Variance is computed
/* logic  			 [(DATA_WIDTH/2)-1:0] STD_DEVIATION_q;  // stores the computed Standard Deviation of the input_signal 
logic  			 [(DATA_WIDTH/2):0] STD_DEVIATION_REMAINDER;  // stores the computed Standard Deviation of the input_signal 
logic  			 [DATA_WIDTH-1:0] SNR;  // stores the computed SNR of the input_signal
logic  			 [DATA_WIDTH-1:0] COEFF_VARIATION;  // stores the computed Coefficient of Variation of the input_signal */

	// We instantiate the ROM_INIT file into our Test Bench
    Top_level_MEAN    Top_level_MEAN_inst (.*);
	initial sys_clock = '1;
    always #(`clock_period/2) sys_clock = !sys_clock;

    // Do test
    integer i; // this is an index for the loop counter

initial 
	begin
	  $vcdplusfile("MEAN_top.vpd");
      $vcdpluson(0, Top_level_MEAN_tb);
      $vcdplusmemon();
	   
	   // ensure that all input signals are set to zero 
	   reset_n = 1'd0;
	   en_i = 1'd0;
	   //data_in = 32'd0;
	   
	   // After 20ns bring the system out of reset 
	   #(`clock_period*2); 
	   reset_n = 1'b1;  // finish the reset
	   
	   // After 20ns assert the enable port 
	   #(`clock_period*2); 
	   en_i = 1'd1;

    @(output_MEAN_done);
	repeat(512) @(posedge sys_clock);
	repeat(20)  @(posedge sys_clock);
	$finish; 
    end
endmodule : Top_level_MEAN_tb