////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Company :
// Design Engineer : Kwadwo Boateng
// Create Date : 
// Design Name : 
// Module Name : 
// Project Name : 
// FPGA Target Device: 
// Tool Version(s) : Quartus 21.3
// Description : 
// Revision : v1.0
// Additional Comments : None 
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Define the timescale and timeprecision
timeunit 1ns;
timeprecision 1ns;

// Define the clock period as 10 ns 
`define clock_period 3.3333333333333

module clock_divider_tb();

	logic   sys_clock;   // this is the main system clock (300 MHz)
    logic   reset_n;
    logic   divided_clock; // This is the 1 Hz divided clock 


	// We instantiate the clock_divider UUT into our Test Bench
    clock_divider    clock_divider_inst (.*);
// Initialize Inputs 	
initial
    begin
	    sys_clock   = '0;
		reset_n     = '0;
	end 

// Create a running clock with a 10ns period
initial
    begin 	
	    forever #(`clock_period/2) sys_clock = !sys_clock;
    end 
// Creation of the INPUT stimulus 
initial 
	begin
	  //$vcdplusfile("clock_divider_top.vpd");
      //$vcdpluson(0, clock_divider_tb);
      //$vcdplusmemon();
	  
	  // After 20ns bring the system out of reset 
	   #(`clock_period*2); 
	   reset_n = 1'b1;  // release the reset -- This is an active low reset
	   
	   @ (negedge sys_clock)   
	   
     #4000000000
	   $finish;
	 
    end

endmodule : clock_divider_tb