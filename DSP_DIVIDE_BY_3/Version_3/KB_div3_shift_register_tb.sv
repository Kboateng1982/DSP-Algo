timeunit 1ns;
timeprecision 1ns;

`define clock_period 10

localparam DATA_WIDTH = 20;
localparam SIZE = 20;

module KB_div3_shift_register_tb();
     logic  				sys_clock;   // this is the main system clock
	 logic   				reset_n;
	 logic                  shift_en;
	 logic					[SIZE-1:0] divident;
	 logic 					[SIZE-1:0] quotient;
	 logic		    		[1:0] reminder;
	 //logic                  [SIZE-1:0]    SHIFT_REG_OUT;
	// We instantiate the ROM_INIT file into our Test Bench
    KB_div3_shift_register_ii    KB_div3_shift_register_ii_inst (.*); 

	initial sys_clock = '1;
    always #(`clock_period/2) sys_clock = !sys_clock;

  // logic [DATA_WIDTH-1:0] counter;
 // This value will be assigned to the divident

initial 
	begin
	  $vcdplusfile("KB_div3_shift_reg.vpd");
      $vcdpluson(0, KB_div3_shift_register_tb);
      $vcdplusmemon();
	end 

initial 
begin 	   
	   // ensure that all input signals are set to zero 
	   reset_n = 1'd0;
	   divident = 20'd0;
	   shift_en = '0;
	   //sel = 0;
	   // After 20ns bring the system out of reset 
	   #(`clock_period*2); 
	   reset_n = 1'b1;  // finish the reset
	   //counter = 70000;
	   repeat (64) 
	   begin 
            @(posedge sys_clock);
			shift_en = 1'b1;
			//divident = counter;
			divident = $random;
			#(`clock_period);
 			shift_en = '0;
			#(`clock_period*5);
	    end 
			#(`clock_period*20);
			@(negedge sys_clock);
			$finish; 
end
endmodule : KB_div3_shift_register_tb
