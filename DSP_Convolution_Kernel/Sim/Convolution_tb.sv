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
localparam ROM_DEPTH_X_N = 320;
localparam ROM_DEPTH_H_N = 29; 
localparam ADDR_WIDTH_BITS_X_N = $clog2(ROM_DEPTH_X_N); 
localparam ADDR_WIDTH_BITS_H_N = $clog2(ROM_DEPTH_H_N);
localparam growth_N = $clog2(ROM_DEPTH_H_N + ROM_DEPTH_X_N); // Growth of the Addder block shall be stored in growth_N


module Convolution_tb();

	logic   sys_clock;   // this is the main system clock
    logic   reset_n;     // Active-low reset for the system
	logic   [DATA_WIDTH-1:0] input_fir_tdata;
    logic   en_i;         // this is an enable port
	//logic   [ADDR_WIDTH_BITS-1:0] addr_i; // this is the ROM address bits 
	//logic   [DATA_WIDTH-1:0] data_in;
	logic   [growth_N+(2*DATA_WIDTH)-1:0] output_fir_tdata;
	logic   convolution_done_o;
	//logic   done_o;     // 
	//logic   output_valid;


	// We instantiate the ROM_INIT file into our Test Bench
    Convolution    Convolution_inst (.*);
	initial sys_clock = '1;
    always #(`clock_period/2) sys_clock = !sys_clock;

    // Do test
integer i,j; // this is an index for the loop counter

logic [DATA_WIDTH-1:0] input_x_n_lut_rom[0:ROM_DEPTH_X_N-1];
initial
begin :  input_x_n_lut_initalization
   $readmemb("mem_initialization_vlog.mem", input_x_n_lut_rom); 
end 


initial 
	begin
	  $vcdplusfile("top.vpd");
      $vcdpluson(0, Convolution_tb);
      $vcdplusmemon();
	   
	   // ensure that all input signals are set to zero 
	   reset_n = 1'd0;
	   en_i = 1'd0;
	   input_fir_tdata = 32'd0;
	   
	   // After 20ns bring the system out of reset 
	   #(`clock_period*2); 
	   reset_n = 1'b1;  // finish the reset
	   
	   // After 20ns assert the enable port 
	   #(`clock_period*2); 
	   en_i = 1'd1;
	   
	   	for(j = 0; j < ROM_DEPTH_X_N; j = j + 1)
		begin: generate_input_address
			input_fir_tdata  <= input_x_n_lut_rom[j];
			#(`clock_period);
		end
     
       #(`clock_period*ROM_DEPTH_X_N*ROM_DEPTH_H_N);
	   en_i = 1'b0; 
	   
	   $finish;
    end
endmodule : Convolution_tb
