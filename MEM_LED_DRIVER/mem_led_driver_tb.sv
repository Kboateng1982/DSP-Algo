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
localparam DATA_WIDTH = 8; // mem_array Data word width 
localparam mem_array_DEPTH  = 16; // Maximum number of words
localparam ADDR_WIDTH_BITS = $clog2(mem_array_DEPTH); //Ceiling log2N

module mem_led_driver_tb();

	logic   sys_clk;   // this is the main system clock
    logic   reset;     // Active-low reset for the system
	logic   [ADDR_WIDTH_BITS-1:0] addr_i;
	logic   [DATA_WIDTH-1:0] led_out;


	// We instantiate the mem_led_driver UUT into our Test Bench
    mem_led_driver    mem_led_driver_inst (.*);
// Initialize Inputs 	
initial
    begin
	    sys_clk   = '0;
        reset     = '0;
        addr_i    = '0;		
	end 

// Create a running clock with a 10ns period
initial
    begin 	
	    forever #(`clock_period/2) sys_clk = !sys_clk;
    end 
// Do test
integer i; // this is an index for the loop counter
// Creation of the INPUT stimulus 
initial 
	begin
	  // After 20ns bring the system out of reset 
	   #(`clock_period*2); 
	   reset = 1'b1;  // release the reset -- This is an active low reset
       for (i = 0; i < 16; i = i + 1)
        begin
		   @ (negedge sys_clk) ;
            addr_i = i;
			#(`clock_period);
		   @ (negedge sys_clk) ;
		   //check_results;
        end 
	 @ (negedge sys_clk)    $finish;
    end

endmodule : mem_led_driver_tb