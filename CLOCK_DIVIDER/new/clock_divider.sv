/*
Problem Statement : In this lab you will write the Verilog source code for the two submodules of the led_driver circuit,
that is, the Clock Divider and Address Counter modules.

Objectives
After completing this lab, you will be able to:
• Create a simple clock divider circuit using if-else-if conditional statements
• Keep the design fully synchronous by using the ce resource
• Create a 4-bit counter whose output serves as an address bus using if-else-if conditional
statements

*/

// This is a counter based clock divider, which will be used to slow down the main system clock

/*
Introduction
You will use a dedicated 300-MHz clock input source on the demo KCU105 board. This signal
needs to be divided down to allow the LEDs to change at a rate that you can visually observe.
The output of this divided clock will drive a counter that addresses the mem module that is
already created.
As part of this exercise, you will decide exactly which frequency to use for changing the LED
pattern. This choice will be reflected in your Verilog source code.
*/

timeunit 1ns;
timeprecision 1ns;

module clock_divider
(
		input 	wire 		sys_clock,      // This is the dedicated 300-MHz clock input source on the demo KCU105 board
		input   wire        reset_n,		
		output 	reg 		divided_clock   // This is the divided 4 Hz clock signal that will drive the LED. This signal is ON 2 sec and OFF 2 sec
);

localparam divider = 75; 

logic [$clog2(divider)-1: 0]  counter_value;  // This is a 32-bit wide bus


// This is the counter module
always_ff  @ (posedge sys_clock or negedge reset_n)
begin
     if (!reset_n) 
	    begin 
		     counter_value <= '0;
			 divided_clock <= '0;
		end 
     else 
	 begin 
	       if (counter_value == divider)
		   begin 
		       counter_value <= '0;
			   divided_clock <= ~divided_clock;
			end 
		   else
		      counter_value <= counter_value + 1'b1;
	 end 
end 

endmodule : clock_divider