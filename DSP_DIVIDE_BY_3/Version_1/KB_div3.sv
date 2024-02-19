module KB_div3 #(
    parameter SIZE = 20
) (
    input      wire   	sys_clock,   // this is the main system clock
	input      wire   	reset_n,
	input 	   wire		[SIZE-1:0] divident,
	input 	   wire 	select,
	output     logic 		[SIZE-1:0] quotient,
	output     logic		[1:0] reminder
);


wire [3:0] temp_quotient;  // temporarily stores the value of the computed quotient per clock cycle
logic  [1:0] init_remainder; // stores the value of the remainder prior to the division algorithm 

wire [1:0] temp_reminder;  // temporarily stores the value of the computed remainder per clock cycle
assign init_remainder = 2'b00; // At reset the value of the init_remainder should be set to 2'b00 

wire [1:0] MUX_OUT_reminder; // This is the output of the 2:1 MUX 

assign MUX_OUT_reminder = (select) ? init_remainder : reminder;

reg [2:0] counter_down;

always_ff @(posedge sys_clock or negedge reset_n)
begin
            if(!reset_n) 
			begin
			     counter_down <= 3'b100;
				 
			end 
			// Division begins when select = 1
			else if (select) 
			begin
	            counter_down <= 3'b011;
			end 
			else if (counter_down == 3'b000)
			 begin
	          counter_down <= 3'b100;
			end  
			else if (counter_down < 4)
			begin 
			    counter_down <= counter_down - 3'b001;
			end 
			  	  

end 

/*//////////////////////////////Array Part Select//////////////////////////////

   1. The next section of this problem can be solved using a variable part select
   2. The part select can either increment or decrement from the variable starting point.
   3. The total number of bits selected is a fixed range. The form of a variable part select is:
   [starting_point_variable +: part_select_size ]
   [starting_point_variable -: part_select_size ]
   {MUX_OUT_reminder,divident[19:16]}
   {MUX_OUT_reminder,divident[15:12]}
   {MUX_OUT_reminder,divident[11:8]}
   {MUX_OUT_reminder,divident[7:4]}
   {MUX_OUT_reminder,divident[3:0]}
   
*/

ROM_INIT #(.DATA_WIDTH(6)) ROM_INIT_inst_1(.sys_clock(sys_clock), .reset_n(reset_n), .divident({MUX_OUT_reminder,divident[counter_down*4 +: 4]}), .quotient(temp_quotient), .reminder(temp_reminder));

always_ff @(posedge sys_clock or negedge reset_n) 
	begin
        //quotient <= divident / 3;
        //reminder <= divident % 3;
		if(!reset_n) 
			begin
			     quotient <= '0;
				 reminder <= '0;
			end 
		else
		begin 
                  quotient[counter_down*4 +: 4] <= temp_quotient;
                  reminder <= temp_reminder;
		end 


    end

endmodule : KB_div3

