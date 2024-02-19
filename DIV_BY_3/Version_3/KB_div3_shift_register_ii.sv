module KB_div3_shift_register_ii 
#(parameter SIZE = 20)
(
    input      wire   			sys_clock,   // this is the main system clock
	input      wire   			reset_n,
	input      wire             shift_en,
	input 	   wire				[SIZE-1:0] divident,
	output     logic 			[SIZE-1:0] quotient,
	output     logic		    [1:0] reminder
	//output     logic            [SIZE-1:0]    SHIFT_REG_OUT // declare output to read out the current value of all flops in the register
);

logic [SIZE-1:0]    SHIFT_REG_OUT; 
logic [3:0] temp_quotient;  // temporarily stores the value of the computed quotient per clock cycle 
logic [1:0] temp_reminder;  // temporarily stores the value of the computed remainder per clock cycle
ROM_INIT #(.DATA_WIDTH(6)) ROM_INIT_inst_1(.sys_clock(sys_clock), .reset_n(reset_n), .divident({reminder, SHIFT_REG_OUT[19:16]}), .quotient(temp_quotient), .reminder(temp_reminder));

// We create a 20-bit shift register with async active-low reset
always_ff @(posedge sys_clock or negedge reset_n) 
begin
		if(!reset_n) 
			begin
								  SHIFT_REG_OUT 	<= '0;
				                  quotient 			<= '0;
				                  reminder 			<= '0;
			end 
		else
		begin 
		          if(shift_en) 
				   begin 
						           SHIFT_REG_OUT <= divident;
								   quotient      <= '0;
                                   reminder 	 <= '0;
					end 
                  else
				  begin
				  
				                   SHIFT_REG_OUT <= (SHIFT_REG_OUT << 4);
								   quotient      <= {quotient[SIZE-5:0], temp_quotient};
                                   reminder 	 <= temp_reminder;
				  end 
        end 
end 
endmodule : KB_div3_shift_register_ii


