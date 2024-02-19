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
`define clock_period 10

// Define parameters that will be used as part of the Simulation as localparams
localparam WIDTH = 4; // mem_array Data word width 

module my_cntr_tb();

logic 	[WIDTH-1:0] data;
logic				reset;   // Active high synchronous reset
logic 				sys_clk; // Clock signal
logic 				updn;    // When set to '1' the counter behaves as up counter or else down counter
logic               load;    // When set to high loads the data input on to the output port q
logic               ce;      // enables the counter
logic    [WIDTH-1:0]  Q;


	// We instantiate the my_cntr UUT into our Test Bench
    my_cntr    my_cntr_inst (.*);
// Initialize Inputs 	
initial
    begin
	    sys_clk   = '0;
        reset     = '1;
        data      = '0;
        updn      = '0;
        load      = '0;
        ce        = '0;		
	end 

// Create a running clock with a 10ns period
initial
    begin 	
	    forever #(`clock_period/2) sys_clk = !sys_clk;
    end 


// Creation of the INPUT stimulus 
initial 
	begin
/* 	  $vcdplusfile("my_cntr_top.vpd");
      $vcdpluson(0, my_cntr_tb);
      $vcdplusmemon(); */
	   
	  // After 20ns bring the system out of reset 
	   #(`clock_period*2); 
	   reset = '0;  // release the reset -- This is an active High reset
	   
	    #(`clock_period*1); 
		@ (posedge sys_clk) ;
	   load = '1;  // 
	   data = '1;
	   
	   #(`clock_period*2); 
	   load = '0;  // 
	   data = '0;
	   
	    #(`clock_period*2); 
        ce = '1; 
		updn      = '1; 
 
	   #(`clock_period*16); 
	   updn      = '0;
	   
	   #(`clock_period*16); 
	   	@ (posedge sys_clk) ;
	 $finish;
	 
    end

endmodule : my_cntr_tb

