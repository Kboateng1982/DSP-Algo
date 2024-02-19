////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Company :
// Design Engineer : Kwadwo Boateng
// Create Date : 9/23/2022
// Design Name : Discrete-Fourier Transform  
// Module Name : DFT
// Project Name : 
// FPGA Target Device: Agilex device
// Tool Version(s) : Quartus 22.4 (MAIN)
// Description : This module computes the DFT on a discrete-time domain signal 
// Revision : v1.0
// Additional Comments : None 
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module DFT
#(
		parameter DATA_WIDTH = 16, // ROM Data word width 
        parameter ROM_DEPTH_X_N  = 320, // Maximum number of words for the discrete-Time input signal
		parameter K              = ROM_DEPTH_X_N,
        parameter ADDR_WIDTH_BITS_X_N = $clog2(ROM_DEPTH_X_N), //Ceiling log2N
        parameter growth_N = $clog2(K) // Growth of the Addder block shall be stored in growth_N
)

(
input      wire   			sys_clock,   // this is the main system clock
input      wire   			reset_n,     // Active-low reset for the system
input      logic       		[DATA_WIDTH-1:0] input_2_14_frac, // discrete-time domain signal
input      logic   			en_i,         // this is an enable port
output     logic   			[growth_N + (2*DATA_WIDTH)-1:0] output_REAL_dft_12_28_frac, // output REAL DFT 
output     logic   			[growth_N + (2*DATA_WIDTH)-1:0] output_IMAG_dft_12_28_frac, // output IMAG DFT
output     logic   			DFT_done_flag     // This is the convolution done flag 
);

// Create a memory-block to store the COSINE LUT values : // 2.14 number notation
logic [DATA_WIDTH-1:0] cosine_2_14_frac[0:K-1];
// Create a memory-block to store the SINE LUT values  : // 2.14 number notation
logic [DATA_WIDTH-1:0] sine_2_14_frac[0:K-1];

initial
begin
   $readmemb("cosine_mem_initialization_vlog.mem", cosine_2_14_frac); 
   $readmemb("sine_mem_initialization_vlog.mem", sine_2_14_frac); 
end 

localparam PROD_MSB = (2*DATA_WIDTH)-1;    // MSB of product
localparam ACCUM_MSB = growth_N + PROD_MSB; // MSB of accumulator
logic [ADDR_WIDTH_BITS_X_N-1:0] count;      // loop counter variable 

logic [PROD_MSB:0]     cosine_prod_4_28_frac;
logic [PROD_MSB:0]     sine_prod_4_28_frac;

logic [ACCUM_MSB:0]    cosine_prod_12_28_frac;
logic [ACCUM_MSB:0]    sine_prod_12_28_frac;

// Multiply the input signal against the cosine and sine LUT values 
assign cosine_prod_4_28_frac =  cosine_2_14_frac[count] * input_2_14_frac; 
assign sine_prod_4_28_frac   =  sine_2_14_frac[count]   * input_2_14_frac;

// Sign extend the product to 12 integer bits and 28 fractional bits
assign cosine_prod_12_28_frac = {{growth_N{cosine_prod_4_28_frac[PROD_MSB]}}, cosine_prod_4_28_frac};
assign sine_prod_12_28_frac   = {{growth_N{sine_prod_4_28_frac[PROD_MSB]}}, sine_prod_4_28_frac};

// Design of the MAC
always_ff @ (posedge sys_clock or negedge reset_n)
begin
         if (!reset_n) 
            begin
			    DFT_done_flag  <= 1'b0;
                count<='0;
				output_REAL_dft_12_28_frac      <= '0;
				output_IMAG_dft_12_28_frac      <= '0;
		    end 
 		else if(reset_n && count == 9'd319)   
            begin
				DFT_done_flag  <= 1'b1;
                count<='0;
				output_REAL_dft_12_28_frac      <= '0;
				output_IMAG_dft_12_28_frac      <= '0;
            end 
   
        else if (en_i) 
            begin 
				count<=count + 1'd1;
				DFT_done_flag <=0;
				output_REAL_dft_12_28_frac     <= output_REAL_dft_12_28_frac + cosine_prod_12_28_frac;
				output_IMAG_dft_12_28_frac     <= output_IMAG_dft_12_28_frac - sine_prod_12_28_frac; 
            end 
end 

endmodule : DFT




