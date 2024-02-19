// Define the timescale and timeprecision
timeunit 1ns;
timeprecision 1ns;

// Define the clock period as 10 ns 
`define clock_period 10

// Define parameters that will be used as part of the Simulation as localparams
localparam N = 32; // number of bit in a vector array 

module rtl_adder_subtractor_tb();

logic			 clk;                        // 1-bit scalar clock 
logic			 reset_n;				     // 1-bit scalar reset_n 
logic			 mode;                       // 1-bit scalar mode
logic			 [N-1:0] a, b;               // 32-bit vector inputs
logic			 [N-1:0] sum;				 // 32-bit vector output sum 	

// We instantiate the mem_led_driver UUT into our Test Bench
rtl_adder_subtractor    rtl_adder_subtractor_inst (.*);

// Initialize Inputs 	
initial
    begin
	    clk   		= '0;
        reset_n     = '0;
        mode     	= '0;	
        a           = '0;
        b           = '0;
        sum         = '0;		
	end 

// Create a running clock with a 10ns period
initial
    begin 	
	    forever #(`clock_period/2) clk = !clk;
    end 

// Reset generation
initial 
begin
    reset_n = 0;
    #20 reset_n = 1;  // De-assert reset after 50 time units
end

// Generate Stimulus
initial
begin 
	repeat (10)
	begin
		@(negedge clk);
		void' (std::randomize(a) with {a >=10; a <= 20;});
		void' (std::randomize(b) with {b <= 10;});
		void' (std::randomize(mode));		
		@(negedge clk)  check_results;	
	end 
	@(negedge clk)		$finish;
end 

// Verify Stimulus
task check_results;
	$display("At %0d: \t a=%0d  b=%0d  mode=%b   sum=%0d", $time, a, b, mode, sum);
	
	case (mode)
	 1'b0: if (sum !==  a + b )
	          $error ("expected sum = %0d", a + b);
	 1'b1: if (sum !==  a - b )
	          $error ("expected sum = %0d", a - b);	
	endcase
endtask 

endmodule : rtl_adder_subtractor_tb
