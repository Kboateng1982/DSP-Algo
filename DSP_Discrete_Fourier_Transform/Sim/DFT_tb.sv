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

localparam DATA_WIDTH = 16; // ROM Data word width 
localparam ROM_DEPTH_X_N  = 320; // Maximum number of words for the discrete-Time input signal
localparam K              = ROM_DEPTH_X_N;
localparam ADDR_WIDTH_BITS_X_N = $clog2(ROM_DEPTH_X_N); //Ceiling log2N
localparam growth_N = $clog2(K); // Growth of the Addder block shall be stored in growth_N



module DFT_tb();
logic                       sys_clock;   // this is the main system clock
logic              			reset_n;     // Active-low reset for the system
logic       		        [DATA_WIDTH-1:0] input_2_14_frac; // discrete-time domain signal
logic   			        en_i;         // this is an enable port
logic   			        [growth_N + (2*DATA_WIDTH)-1:0] output_REAL_dft_12_28_frac; // output REAL DFT 
logic   			        [growth_N + (2*DATA_WIDTH)-1:0] output_IMAG_dft_12_28_frac; // output IMAG DFT
logic   			        DFT_done_flag;  

/* logic sys_clock;   // this is the main system clock
logic reset_n;    // Active-low reset for the system
logic       		[growth_N + (2*DATA_WIDTH)-1:0] input_2_14_frac; // discrete-time domain signal
logic   			en_i;         // this is an enable port
logic   			signed [growth_N + (2*DATA_WIDTH)-1:0] output_DFT_REAL; // output REAL DFT 
logic   			signed [growth_N + (2*DATA_WIDTH)-1:0] output_DFT_IMAG; // output IMAG DFT
logic   			DFT_done_flag;     // This is the convolution done flag  */

// We instantiate the ROM_INIT file into our Test Bench
DFT    DFT_inst (.*);
initial sys_clock = '1;
always #(`clock_period/2) sys_clock = !sys_clock;

    // Do test
integer i,j; // this is an index for the loop counter

logic [DATA_WIDTH-1:0] input_x_n_lut_rom[0:K-1];
initial
begin :  input_x_n_lut_initalization
   $readmemb("mem_initialization_vlog.mem", input_x_n_lut_rom); 
end 


initial 
	begin
	  $vcdplusfile("top.vpd");
      $vcdpluson(0, DFT_tb);
      $vcdplusmemon();
	   
	   // ensure that all input signals are set to zero 
	   reset_n = 1'd0;
	   en_i = 1'd0;
	   input_2_14_frac = 16'd0;
	   
	   // After 20ns bring the system out of reset 
	   #(`clock_period*2); 
	   reset_n = 1'b1;  // finish the reset
	   
	   // After 20ns assert the enable port 
 	   #(`clock_period*2); 
	   en_i = 1'd1; 
	   
	   repeat (5) 
	   begin 
		   @(posedge sys_clock)
		   begin 
				for(j = 0; j < K; j = j + 1)
				begin: generate_input_address
					input_2_14_frac  = input_x_n_lut_rom[j];
					#(`clock_period);
				end  
			end 
	   end 
     
       #(`clock_period*K*K*4);
	   en_i = 1'b0; 
	   
	   $finish;
    end
endmodule : DFT_tb


