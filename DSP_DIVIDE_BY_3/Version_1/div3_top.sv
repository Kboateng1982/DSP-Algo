// Initialize ROM in SystemVerilog to read all of the input signal data converted into Binary
// Author : Kwadwo Boateng
// Data : 8-10-2021

timeunit 1ns;
timeprecision 1ns;

module div3_top #(
    parameter SIZE = 20
) 

(
	input      wire   		sys_clock,   // this is the main system clock
	input      wire   		reset_n,
	input 	   wire			[SIZE-1:0] divident,
	input 	   wire 		select,
	output     logic 		[SIZE-1:0] quotient,
	output     logic		[1:0] reminder
);

logic [SIZE-1:0] divident_reg;

always @(posedge sys_clock)
begin
   divident_reg <= divident;
end 

KB_div3 #(.SIZE(SIZE)) KB_div3_inst 	(.sys_clock(sys_clock),
										 .reset_n(reset_n),
                                         .divident(divident_reg),
							             .select(select),
							             .quotient(quotient),
							             .reminder(reminder)
							            );
endmodule : div3_top 
