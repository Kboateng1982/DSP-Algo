
timeunit 1ns;
timeprecision 100ps;

// Define the clock period as 10 ns 
`define clock_period 10

module sequence_detector_tb();

// Signals
logic clk;
logic reset_n;
logic din;
logic z;

// Instantiate SerialSequenceDetector module
sequence_detector UUT_1 (.*);

// Initialize Inputs 	
initial
    begin
	    clk   		= '0;
        reset_n     = '0;
        din     	= '0;			
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

// Serial input generation
initial 
begin 
	@(negedge clk);
     #5; 	 @(posedge clk) din <= '0;
     #5;     @(posedge clk) din <= '1;	
     #5;     @(posedge clk) din <= '0;
     #5;     @(posedge clk) din <= '1;
     #5;     @(posedge clk) din <= '0;

     #5;     @(posedge clk) din <= '1;
     #5;     @(posedge clk) din <= '1; 
     #5;     @(posedge clk) din <= '0; 
     #5;     @(posedge clk) din <= '1; 
     #5;     @(posedge clk) din <= '1; 

     #5; 	 @(posedge clk) din <= '0;
     #5;     @(posedge clk) din <= '1;	
     #5;     @(posedge clk) din <= '0;
     #5;     @(posedge clk) din <= '1;
     #5;     @(posedge clk) din <= '0;

     #5; 	 @(posedge clk) din <= '0;
     #5;     @(posedge clk) din <= '1;	
     #5;     @(posedge clk) din <= '0;
     #5;     @(posedge clk) din <= '1;
     #5;     @(posedge clk) din <= '0; 

     #5; 	 @(posedge clk) din <= '0;
     #5;     @(posedge clk) din <= '1;	
     #5;     @(posedge clk) din <= '0;
     #5;     @(posedge clk) din <= '1;
     #5;     @(posedge clk) din <= '0;

     #5; 	 @(posedge clk) din <= '0;
     #5;     @(posedge clk) din <= '1;	
     #5;     @(posedge clk) din <= '0;
     #5;     @(posedge clk) din <= '1;
     #5;     @(posedge clk) din <= '0;
	 
     #5; 	 @(posedge clk) din <= '0;
     #5;     @(posedge clk) din <= '1;	
     #5;     @(posedge clk) din <= '0;
     #5;     @(posedge clk) din <= '1;
     #5;     @(posedge clk) din <= '0;
	 
	@(negedge clk);		
	#100 $finish;
end 

// Display sequence detection
always @(posedge clk) 
begin
    if (reset_n)
        $display("Sequence detected: %b", z);
end

endmodule: sequence_detector_tb
