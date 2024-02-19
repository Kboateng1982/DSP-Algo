
Kwadwo Boateng <kwadwo.boateng@gmail.com>
7:01 AM (1 hour ago)
to me

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Company :
// Design Engineer : Kwadwo Boateng
// Create Date : 8/11/2021
// Design Name : Signal Statistics 
// Module Name : Top_level_MEAN
// Project Name : 
// FPGA Target Device: Agilex device
// Tool Version(s) : Quartus 21.3
// Description : This module computes average value of a discrete-Time input signal 
// Revision : v1.0
// Additional Comments : None 
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

timeunit 1ns;
timeprecision 1ns;

module Top_level_MEAN
#(
    parameter DATA_WIDTH = 32, // ROM Data word width 
	parameter ROM_DEPTH  = 512, // Maximum number of words
	parameter ADDR_WIDTH_BITS = $clog2(ROM_DEPTH) //Ceiling log2N
)

(
input      			wire   			 sys_clock,   // this is the main system clock for the entire design 
input      			wire   			 reset_n,     // Active-low reset for the system
input      			wire   			 en_i,        // this is an enable port, which essentially marks the beginning of all computation
output     			logic  			 [DATA_WIDTH-1:0] output_MEAN,  // stores the computed MEAN of the input_signal 
output     			logic   	     output_MEAN_done,     		   // This flag is asserted when the mean is computed 
output     			logic  			 [DATA_WIDTH-1:0] output_VARIANCE,  // stores the computed Variance of the input_signal 
output              logic            output_VARIANCE_DONE  // This flag is asserted when the Variance is computed
);

logic [DATA_WIDTH-1:0]      data_in;       			// this wire connects the output of the ROM to the input of this module
logic [ADDR_WIDTH_BITS-1:0] addr_i; 			        // this is a register that stores the ROM address bits 

// Instantiate the ROM 
ROM_INIT  ROM_INIT_inst ( .sys_clock(sys_clock),
                          .addr_i(addr_i),
						  .data_o(data_in)
						); 

// MEAN Calculation 
// Step 1: Create a register to store the final total sum value after 512 clock cycles. 
// This register must include additional bits for exponential growth	
// The number convention used here is a 11.30 notation 	
logic [ADDR_WIDTH_BITS + DATA_WIDTH-1:0] sumTotal;

// The number convention used here is a 11.30 notation 
// Step 2: Create a register to store the intermediate sum value during the 512 clock cycles. 
logic [ADDR_WIDTH_BITS + DATA_WIDTH-1:0] sum; 

// The number convention used here is a 11.30 notation 
// Step 3: Create a register to store a Sign-extension of each input : data_in
logic [ADDR_WIDTH_BITS + DATA_WIDTH-1:0] sign_ext_data_in;


// Step 4: Create a register, which flags the beginning of summation and end of summation 
logic sum_done_int;

// The number convention used here is a 11.30 notation 
// Step 5: Sign-extension is created here to make sure the decimal points are properly aligned 
assign	sign_ext_data_in = {{ADDR_WIDTH_BITS{data_in[31]}},data_in};

// Create an always block to flag the beginning of summation and end of summation 
always_ff @ (posedge sys_clock or negedge reset_n)
begin
       if (!reset_n) 
	     begin 
			   sum_done_int <= 1'b0;
		 end 
	   else if (addr_i < 511) 
	     begin 
		       sum_done_int <=1'b0;
		 end 
 	   else 
	     begin 
		       sum_done_int <= 1'b1;
		 end  
end

// Create an always block to increment the address bits beginning with addr_i = 0             
always_ff @ (posedge sys_clock or negedge reset_n)
begin
       if (!reset_n)
		begin
			addr_i <= '0;
		end 
		else if (en_i)
	    begin 
		    for (int j=0; j<512; j=j+1)
			  begin 
				 addr_i <= addr_i  + 9'b000000001;
			  end 
		end 

end 

// We create 3 pipeline 41-bit registers to register the value of sign_ext_data_in
	// Data Input Pipeline Register
(* altera_attribute = {" -name SYNCHRONIZER_IDENTIFICATION OFF "} *) reg [ADDR_WIDTH_BITS + DATA_WIDTH-1:0] Pipe_12_sign_ext_data_in, Pipe_23_sign_ext_data_in, Pipe_34_sign_ext_data_in;

// This is how we compute the sum of the discrete-Time input signal 
always_ff @ (posedge sys_clock)
begin
       if (!reset_n)
		begin
			sum <= '0;
			Pipe_12_sign_ext_data_in <= '0;
			Pipe_23_sign_ext_data_in <= '0;
			Pipe_34_sign_ext_data_in <= '0;
		end 
	  else if (en_i && !sum_done_int)
	    begin 
		    // Addition of 4-pipeline Registers for the input sign_ext_data_in   	
			Pipe_12_sign_ext_data_in   <=  sign_ext_data_in;
			Pipe_23_sign_ext_data_in   <=  Pipe_12_sign_ext_data_in;
			Pipe_34_sign_ext_data_in   <=  Pipe_23_sign_ext_data_in;
			// Perform the sum 
			sum <= sum + Pipe_34_sign_ext_data_in;  
		end 
	 else if (en_i && output_MEAN_done)
		   begin
		         sum <= '0;
		   end 
end 

// Assign the intermediate value sum to sumTotal 
assign	sumTotal = sum;



// This is how we compute the MEAN value of the discrete-Time input signal
// always_ff @ (posedge sys_clock or negedge reset_n)
always_comb 
begin

if (!reset_n)
		begin
		     output_MEAN       = '0; // we shift right here 2^9 = 512
			 output_MEAN_done  = '0; 
		end 
else if (sum_done_int) 
	    begin 
		     output_MEAN       = sumTotal >> 9 ; // we shift right here 2^9 = 512
			 output_MEAN_done  = 1'd1; 
		end 
		      	
end 

// We create 3 pipeline 33-bit registers to register the value of sign_ext_data_in_diff
(* altera_attribute = {" -name SYNCHRONIZER_IDENTIFICATION OFF "} *) reg [DATA_WIDTH:0] Pipe_12_sign_ext_data_in_diff, Pipe_23_sign_ext_data_in_diff, Pipe_34_sign_ext_data_in_diff;

// We create 3 pipeline 33-bit registers to register the value of sign_ext_mean_diff
(* altera_attribute = {" -name SYNCHRONIZER_IDENTIFICATION OFF "} *) reg [DATA_WIDTH:0] Pipe_12_sign_ext_mean_diff, Pipe_23_sign_ext_mean_diff, Pipe_34_sign_ext_mean_diff;

// Using a 3.30 notation 
logic [DATA_WIDTH:0] sign_ext_data_in_diff;
assign  sign_ext_data_in_diff = {data_in[31],data_in};

// We create a Sign-extension of the MEAN value, in order to create the variance 
// Using a 3.30 notation  
logic [DATA_WIDTH:0] sign_ext_mean_diff;
assign	sign_ext_mean_diff = {output_MEAN[31],output_MEAN};

// Using a 3.30 notation 
logic [DATA_WIDTH:0] difference;

//logic [2*DATA_WIDTH:0] Diff_SQ;
logic [2*DATA_WIDTH:0] Diff_SQ;


always_ff @ (posedge sys_clock)
begin
      if (!reset_n)
	  begin
	      difference <= '0;
		  Pipe_12_sign_ext_data_in_diff <= '0;
		  Pipe_23_sign_ext_data_in_diff <= '0;
		  Pipe_34_sign_ext_data_in_diff <= '0;
		  Pipe_12_sign_ext_mean_diff    <= '0;
		  Pipe_23_sign_ext_mean_diff    <= '0;
		  Pipe_34_sign_ext_mean_diff    <= '0;
	  end 
	  
      else if (!output_MEAN_done)
	  begin
	      difference <= '0;
		  Pipe_12_sign_ext_data_in_diff <= '0;
		  Pipe_23_sign_ext_data_in_diff <= '0;
		  Pipe_34_sign_ext_data_in_diff <= '0;
		  Pipe_12_sign_ext_mean_diff    <= '0;
		  Pipe_23_sign_ext_mean_diff    <= '0;
		  Pipe_34_sign_ext_mean_diff    <= '0;
	  end 
	  
	  else if (output_MEAN_done && addr_i == '0)
	    begin
	      difference <= '0;
		  Pipe_12_sign_ext_data_in_diff <= '0;
		  Pipe_23_sign_ext_data_in_diff <= '0;
		  Pipe_34_sign_ext_data_in_diff <= '0;
		  Pipe_12_sign_ext_mean_diff    <= '0;
		  Pipe_23_sign_ext_mean_diff    <= '0;
		  Pipe_34_sign_ext_mean_diff    <= '0;	   
		end 
      else if (output_MEAN_done && addr_i != '0)
	  begin
	      Pipe_12_sign_ext_data_in_diff <= sign_ext_data_in_diff;
		  Pipe_23_sign_ext_data_in_diff <= Pipe_12_sign_ext_data_in_diff;
          Pipe_34_sign_ext_data_in_diff <= Pipe_23_sign_ext_data_in_diff;

          Pipe_12_sign_ext_mean_diff    <= sign_ext_mean_diff;
          Pipe_23_sign_ext_mean_diff    <= Pipe_12_sign_ext_mean_diff;
          Pipe_34_sign_ext_data_in_diff <= Pipe_23_sign_ext_mean_diff;

		  difference = Pipe_34_sign_ext_data_in_diff - Pipe_34_sign_ext_data_in_diff;
	  end 
	  
  	  else 
		begin
	      difference = '0;
		end  

end  


// We create 3 pipeline 65-bit registers to register the value of Diff_SQ
(* altera_attribute = {" -name SYNCHRONIZER_IDENTIFICATION OFF "} *) reg [2*DATA_WIDTH:0] Pipe_12_Diff_SQ, Pipe_23_Diff_SQ, Pipe_34_Diff_SQ;

// Compute the Square of the difference
assign Diff_SQ = difference * difference; 


always_ff @ (posedge sys_clock)
begin
      if (!reset_n)
	  begin
		  Pipe_12_Diff_SQ <= '0;
		  Pipe_23_Diff_SQ <= '0;
		  Pipe_34_Diff_SQ <= '0;
	  end
	  else 
	  begin 
	      Pipe_12_Diff_SQ <=  Diff_SQ;
		  Pipe_23_Diff_SQ <=  Pipe_12_Diff_SQ;
		  Pipe_34_Diff_SQ <=  Pipe_23_Diff_SQ;	  
	  end 
end 

// create a register to store the intermediate value of the variance during the 512 clock cycles. 
logic [ADDR_WIDTH_BITS + 2*DATA_WIDTH:0] variance; 

always_ff @ (posedge sys_clock or negedge reset_n)
begin
       if (!reset_n)
		begin
			variance <= '0;
		end 
		else if (output_MEAN_done && addr_i == '0)
	    begin
		   variance <= '0;  
		end 
 	  else if (output_MEAN_done && addr_i <= 321)
	    begin
		   variance <= variance + Pipe_34_Diff_SQ;  
		end 
	  else 
		begin
		    variance <= '0;
		end  
end 

always_comb 
begin
       if (!reset_n)
		begin
			output_VARIANCE 	   = '0;
			output_VARIANCE_DONE   = '0;	
		end 
	  else if (output_MEAN_done && addr_i == 312)
	    begin 
		     output_VARIANCE       = variance >> 9; // we shift right here 2^9 = 512
			 output_VARIANCE_DONE  = 1'd1; 		 
		end 
	  else 
		begin
			output_VARIANCE 	   = '0;
			output_VARIANCE_DONE   = '0;
		end 
end 

endmodule : Top_level_MEAN
















