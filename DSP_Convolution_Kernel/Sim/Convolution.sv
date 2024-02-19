////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Company :
// Design Engineer : Kwadwo Boateng
// Create Date : 8/11/2021
// Design Name : Signal Statistics 
// Module Name : Top_level_MEAN
// Project Name : 
// FPGA Target Device: Agilex device
// Tool Version(s) : Quartus 21.3
// Description : This module computes the Convolution of a discrete-Time input signal with the impulse response of a LPF with a cut-off frequency of 6kHz
// Revision : v1.0
// Additional Comments : None 
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module Convolution
#(
		parameter DATA_WIDTH = 32, // ROM Data word width 
        parameter ROM_DEPTH_X_N  = 320, // Maximum number of words for the discrete-Time input signal
        parameter ADDR_WIDTH_BITS_X_N = $clog2(ROM_DEPTH_X_N), //Ceiling log2N
        parameter ROM_DEPTH_H_N  = 29, // Maximum number of words for the filter impulse-response
        parameter ADDR_WIDTH_BITS_H_N = $clog2(ROM_DEPTH_H_N), //Ceiling log2N
        parameter growth_N = $clog2(ROM_DEPTH_H_N + ROM_DEPTH_X_N) // Growth of the Addder block shall be stored in growth_N
)

(
input      wire   			sys_clock,   // this is the main system clock
input      wire   			reset_n,     // Active-low reset for the system
input      logic   			[DATA_WIDTH-1:0] input_fir_tdata, // input data to the FIR Filter 
input      wire   			en_i,         // this is an enable port
output     logic   			[growth_N+(2*DATA_WIDTH)-1:0] output_fir_tdata, // output data from the FIR Filter  
output     logic   			convolution_done_o     // This is the convolution done flag 
);

// The amount of memory allocated for the impulse-response must be the same as the amount of memory allocated for samples of the input_signal
// Instantiate and connect shift register for each impulse response coefficient
// x[k] = x[k-1]
// The memory block that stores the delayed samples of the input signal is called : delay 
logic [DATA_WIDTH-1:0] delay[ROM_DEPTH_H_N-1:0];

genvar n;
generate
        for(n = 0; n < ROM_DEPTH_H_N; n++)
            begin: delay_generator
                  if (n==0) 
				     begin
                    // Connect signal source to first element of the shift register
                        register reg_inst0(.datain(input_fir_tdata),.sys_clock(sys_clock),.reset_n(reset_n),.en_i(en_i),.dataout(delay[n]));
                     end
                  else 
				     begin
                        register reg_instn(.datain(delay[n-1]),.sys_clock(sys_clock),.reset_n(reset_n),.en_i(en_i),.dataout(delay[n]));
                    end
            end
endgenerate

localparam PROD_MSB = (2*DATA_WIDTH)-1;    // MSB of product
localparam ACCUM_MSB = growth_N + PROD_MSB; // MSB of accumulator
  
//logic [2*DATA_WIDTH-1:0] prod [0:ROM_DEPTH_H_N-1];  // This register stores the product of the multiplication 
logic [PROD_MSB:0] prod [0:ROM_DEPTH_H_N-1];       // 2.30*2.30 = 4.60 output of multiplier
//logic [DATA_WIDTH-1:0] input_x_n_lut_rom[0:ROM_DEPTH_X_N-1];
//wire  [DATA_WIDTH-1:0] my_tap [0:ROM_DEPTH_H_N-1]; 
// 2.30 impulse response coefficient
(* ram_style = "block" *) reg [DATA_WIDTH-1:0] my_tap[0:ROM_DEPTH_H_N-1];

// Sign extend to account for 29-element adder (growth_N*4.60)
// Sign extend to account for 29-element adder (growth_N*4.60)
logic [ACCUM_MSB:0] my_temp[ROM_DEPTH_H_N-1:0];
//input [SIZE-1:0] din[0:NUM-1],

// 1. The Impulse Response needs to be in a time-reversed order
// 2. Samples of the input signal shift-left across the array in memory based on natural order
// 3. We have to allocate memory for the impulse-response
// 4. The name of the memory block that stores the impulse-response is called my_tap 
// Define FIR filter coeffients (impulse response)      
initial
begin :  FIR_LPF_lut_initalization
   $readmemb("mem_initialization_vlog_LPF.mem", my_tap); 
end 

logic conv_done_flag;
logic [ADDR_WIDTH_BITS_X_N-1:0] count;
integer w;

// This is the Multiply Loop for the Filter 
 always_ff @ (posedge sys_clock or negedge reset_n)
 begin
        if (!reset_n) 
            begin
                conv_done_flag  <= 1'b0;
                count<='0;
                for (w=0; w<ROM_DEPTH_H_N; w++)
                    begin
                             prod[w]<= '0;
                    end
            end
        else if( reset_n && count == 9'd319 )   
            begin
                count<='0;
                conv_done_flag <= 1'b1;
                for (w=0; w<ROM_DEPTH_H_N; w++)
                    begin
                        prod[w]<= '0;
                    end
            end
        else
            begin 
            count<=count + 1'd1;
            conv_done_flag<=0;
				for (w=0; w<ROM_DEPTH_H_N; w++)
					begin
                        prod[w]<= my_tap[w] * delay[w];
                    end 
            end
end 
//  logic for sign-extension of the Multiply aspect of the MAC
always_comb 
begin
  for(int j = 0; j < ROM_DEPTH_H_N; j++) 
  begin
    my_temp[j] = {{growth_N{prod[j][PROD_MSB]}},prod[j]};
  end
end

// We create a register to store the output of the Accumulator 
logic   [ACCUM_MSB:0] my_output_fir_tdata;

// This is the Accumulate Loop that goes from 0 to 28 for the Low-pass Filter 
always_comb 
begin
		my_output_fir_tdata = '0;
		for(int i = 0; i < ROM_DEPTH_H_N; i++) 
		begin
			my_output_fir_tdata += my_temp[i];
		end
end 

assign output_fir_tdata = my_output_fir_tdata;
assign convolution_done_o = conv_done_flag;
  
endmodule : Convolution






