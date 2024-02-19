timeunit 1ns;
timeprecision 1ns;

`define clock_period 10

localparam DATA_WIDTH = 20;

module KB_div3_tb();
    logic   	sys_clock;   // this is the main system clock
	logic       reset_n;
	logic       [DATA_WIDTH-1:0] divident;
	logic       select;
	logic       [DATA_WIDTH-1:0] quotient;
	logic       [1:0] reminder;

	// We instantiate the ROM_INIT file into our Test Bench
    KB_div3   KB_div3_inst (.*); 

	initial sys_clock = '1;
    always #(`clock_period/2) sys_clock = !sys_clock;

logic [DATA_WIDTH-1:0] counter;
 // This value will be assigned to the divident

initial 
	begin
	  $vcdplusfile("KB_div3_tom.vpd");
      $vcdpluson(0, KB_div3_tb);
      $vcdplusmemon();
	   
	   // ensure that all input signals are set to zero 
	   reset_n = 1'd0;
	   select  = 1'd0;
	   counter = 20'd0;
	   divident = 20'd0;
	   //data_in = 32'd0;
	   
	   
	   // After 20ns bring the system out of reset 
	   #(`clock_period*2); 
	   reset_n = 1'b1;  // finish the reset
	   counter = 77689;

	   
	repeat (64)
		begin
            @(negedge sys_clock);
			select = 1'b1;
			divident = counter;
			#(`clock_period);
			select = 1'd0;
			#(`clock_period*4);
			counter++;
		end 
			#(`clock_period*20);
			@(negedge sys_clock);
			$finish; 
	end
endmodule : KB_div3_tb

