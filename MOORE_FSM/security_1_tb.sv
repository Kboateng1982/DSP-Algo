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

module security_1_tb();

logic		[WIDTH-1:0] 	keypad;
logic					    front_door;
logic   					rear_door;
logic    					window;
logic   					reset_n;
logic    					sys_clk;
logic   					alarm_siren;
logic    					is_armed;
logic    					is_wait_delay;

	// We instantiate the security_1 UUT into our Test Bench
    security_1    security_1_inst (.*);
// Initialize Inputs 	
initial
    begin
	    sys_clk   			= '0;
        reset_n     		= '0;
        keypad      		= '0;
        front_door      	= '0;
        rear_door      		= '0;
        window        	    = '0;		
	end 

// Create a running clock with a 10ns period
initial
    begin 	
	    forever #(`clock_period/2) sys_clk = !sys_clk;
    end 


// Creation of the INPUT stimulus 
initial 
	begin
	  //$vcdplusfile("security_1_top.vpd");
      //$vcdpluson(0, security_1_tb);
      //$vcdplusmemon();
	   
	  // After 20ns bring the system out of reset 
	   #(`clock_period*2); 
	   reset_n = '1;  // release the reset -- This is an active Low reset
	   
	   // Stimulus for Window to get into ARMED state
	    #(`clock_period*1); 
		@ (posedge sys_clk) ;
	   window = '1;  // 
	   keypad = 4'b0011;
	   
	   #(`clock_period*100); 
	   @ (posedge sys_clk) ;
	   window = '1;  // 
	   keypad = 4'b1111;
	   
	    #(`clock_period*2); 
	   @ (posedge sys_clk) ;
	   window = '1;  // 
	   keypad = 4'b1100;
	   
	   
	   // Stimulus for Front door to get into ARMED state
	    #(`clock_period*2); 
		@ (posedge sys_clk) ;
	   front_door = '1;  // 
	   keypad = 4'b0011;
	   
	   #(`clock_period*100); 
	   @ (posedge sys_clk) ;
	   front_door = '1;  // 
	   keypad = 4'b1111;
	   
	   #(`clock_period*2); 
	   @ (posedge sys_clk) ;
	   window = '1;  // 
	   keypad = 4'b1100;
	   
	   // Stimulus for Rear door to get into ARMED state
	    #(`clock_period*2); 
		@ (posedge sys_clk) ;
	   rear_door = '1;  // 
	   keypad = 4'b0011;
	   
	   #(`clock_period*100); 
	   @ (posedge sys_clk) ;
	   rear_door = '1;  // 
	   keypad = 4'b1111;
	   #(`clock_period*200); 
	   	@ (posedge sys_clk) ;
	 $finish;
	 
    end

endmodule : security_1_tb