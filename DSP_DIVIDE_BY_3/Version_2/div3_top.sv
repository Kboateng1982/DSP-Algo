// Initialize ROM in SystemVerilog to read all of the input signal data converted into Binary
// Author : Kwadwo Boateng
// Data : 8-10-2021

timeunit 1ns;
timeprecision 1ns;

module div3_top #(
    parameter SIZE = 20
) 

(
	input      wire   			sys_clock,   // this is the main system clock
	input      wire   			reset_n,
	input      wire             shift_en,
	input      wire             [2:0]  sel,
	input 	   wire				[SIZE-1:0] divident,
	output     logic 			[SIZE-1:0] quotient,
	output     logic		    [1:0] reminder
);

logic [SIZE-1:0] divident_reg;

always @(posedge sys_clock)
begin
   divident_reg <= divident;
end 

KB_div3_shift_register #(.SIZE(SIZE)) KB_div3_shift_register_inst 	
                                        ( .sys_clock(sys_clock),
										  .reset_n(reset_n),
										  .shift_en(shift_en),
										  .sel(sel),
                                          .divident(divident_reg),
							              .quotient(quotient),
							              .reminder(reminder)
							            );
endmodule : div3_top 

