// Initialize ROM in SystemVerilog to read all of the input signal data converted into Binary
// Author : Kwadwo Boateng
// Data : 8-10-2021

timeunit 1ns;
timeprecision 1ns;

module FPGA_Convolution_top
#(
		parameter DATA_WIDTH = 32, // ROM Data word width 
        parameter ROM_DEPTH_X_N  = 320, // Maximum number of words for the discrete-Time input signal
        parameter ADDR_WIDTH_BITS_X_N = $clog2(ROM_DEPTH_X_N), //Ceiling log2N
        parameter ROM_DEPTH_H_N  = 29, // Maximum number of words for the filter impulse-response
        parameter ADDR_WIDTH_BITS_H_N = $clog2(ROM_DEPTH_H_N), //Ceiling log2N
        parameter growth_N = 11 // Growth of the Addder block shall be stored in growth_N
)

(
input      wire   			sys_clock,   // this is the main system clock
input      wire   			reset_n,     // Active-low reset for the system
input      logic   			[DATA_WIDTH-1:0] input_fir_tdata, // input data to the FIR Filter 
input      wire   			en_i,         // this is an enable port
output     logic   			[growth_N+(2*DATA_WIDTH)-1:0] output_fir_tdata, // output data from the FIR Filter  
output     logic   			convolution_done_o     // This is the convolution done flag 
);

logic [DATA_WIDTH-1:0] input_fir_tdata_reg;

always @(posedge sys_clock)
begin
   input_fir_tdata_reg <= input_fir_tdata;
end 


Convolution #(.DATA_WIDTH(DATA_WIDTH)) Convolution_inst 	
                                        ( .sys_clock(sys_clock),
										  .reset_n(reset_n),
										  .input_fir_tdata(input_fir_tdata_reg),
										  .en_i(en_i),
                                          .output_fir_tdata(output_fir_tdata),
										  .convolution_done_o(convolution_done_o)
							            );
endmodule : FPGA_Convolution_top



