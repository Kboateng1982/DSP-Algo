module security_1
(

input 	wire 		[3:0] 	keypad,
input 	wire 				front_door,
input   wire    			rear_door,
input   wire    			window,
input   wire    			reset_n,
input   wire    			sys_clk,
output  logic    			alarm_siren,
output  logic    			is_armed,
output  logic    			is_wait_delay

); 


// Internal variable for counting up till 100 clock cycles
logic  [7:0]    upcount;

// sensors[2:0] – 3-bit internal signal formed by concatenating the inputs - front_door,
// rear_door and window. If any of the 3 bits in this signal goes high, the alarm would be
// triggered after a delay of 100 clock cycles.
logic [2:0]     sensors;
logic 		    count_done, start_count; 

// One-hot-0  State Machine Encoding
typedef enum logic  [2:0]  
{
	DISARMED 		= 3'b000,
	ARMED    		= 3'b001,
	WAIT_DELAY 		= 3'b010,
	ALARM 			= 3'b100
}   state_t; 

// Definition of internal state variables 
state_t current_state, next_state;   

// Definition of the Current State Logic --- Sequential Logic
always_ff @ (posedge sys_clk or negedge reset_n)
begin
		if (!reset_n)
			begin 
				current_state<=DISARMED; 
			end 
		else
			begin
				current_state<=next_state; 
			end 
end 

// Next State Logic -- Combinational Logic
always_comb
begin
	case (current_state)
	DISARMED: 
	     if (keypad == 4'b0011)
		 begin 
		     next_state = ARMED;
			 {alarm_siren, is_armed, is_wait_delay} = 3'b000;
		 end 

		 else 
		 begin 
		     next_state = DISARMED;
			 {alarm_siren, is_armed, is_wait_delay} = 3'b000;
		 end 
			 
	ARMED: 
		 if (sensors != 3'b000) 
		 begin 
		     next_state = WAIT_DELAY;
             {alarm_siren, is_armed, is_wait_delay} = 3'b010;
		end 

		 else 
		 begin 
		     next_state = ARMED;
             {alarm_siren, is_armed, is_wait_delay} = 3'b010;
         end 
			 
    WAIT_DELAY:
		 if (keypad == 4'b1100) 
		 begin 
		     next_state = DISARMED;
	         {alarm_siren, is_armed, is_wait_delay} = 3'b001;
		 end 
			 
		 else if (count_done)
		 begin 
		     next_state = ALARM;
		    {alarm_siren, is_armed, is_wait_delay} = 3'b001;
         end 
		 
		 else 
		 begin 
		     next_state = WAIT_DELAY;
             {alarm_siren, is_armed, is_wait_delay} = 3'b001;
		 end 
          
			 
	 ALARM: 
	    if (keypad == 4'b1100) 
		begin 
		     next_state = DISARMED;
             {alarm_siren, is_armed, is_wait_delay} = 3'b100;
		end
        else 
		begin 
		     next_state = ALARM;
             {alarm_siren, is_armed, is_wait_delay} = 3'b100;
        end 
	 default:
            next_state = DISARMED;

	endcase 

end 
/*
sensors[2:0] – 3-bit internal signal formed by concatenating the inputs - front_door,
rear_door and window. If any of the 3 bits in this signal goes high, the alarm would be
triggered after a delay of 100 clock cycles
*/

assign sensors = {front_door,rear_door,window};  

assign start_count =   ((next_state == WAIT_DELAY) & (current_state == ARMED)) ? '1 : '0;  

// The upcounter counts from 0 to 99
always_ff @ (posedge sys_clk or negedge reset_n)
begin
      if (!reset_n) 
		begin
					    upcount <= '0;
		end 
	  
	  else 
		begin 
					if(start_count)
						upcount <= '0;
					else if (upcount == 8'd99)
						upcount <= '0; //Increment Counter
					else if (current_state == WAIT_DELAY)
						upcount <= upcount + 8'b00000001; //Incremend Counter
		end 
end 

assign count_done = (upcount == 8'd99) ? '1 : '0;

endmodule : security_1