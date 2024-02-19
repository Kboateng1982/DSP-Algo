// Design an FSM that can detect when it has received the serial input sequence "01010"
// Author : Kwadwo Boateng

timeunit 1ns;
timeprecision 100ps;

module sequence_detector 
( 
  input wire clk,
  input wire reset_n,
  input wire din,
  output logic z
);


// Define states
typedef enum logic [2:0] 
{
    state_1,
    state_2,
    state_3,
	state_4,
	state_5,
    state_6
} state_t;

// State registers for road 1 and road 2
state_t state;

// Define the State Update Sequential Logic

always_ff @(posedge clk, negedge reset_n)
begin
     if (!reset_n)
	    begin 
				state <= state_1;
		end 
	else 
	    begin 
			case (state)
			state_1 : begin 
			        if (din) begin 
					    state <= state_1;
					end 
					else begin 
						state <= state_2;
					end 
			end 
			state_2 : begin 
			        if (din) begin 
					    state <= state_3;
					end 
					else begin 
						state <= state_2;
					end 
			end 			
			state_3 : begin 
			        if (din) begin 
					    state <= state_1;
					end 
					else begin 
						state <= state_4;
					end 
			end 			
			state_4 : begin 
			        if (din) begin 
					    state <= state_5;
					end 
					else begin 
						state <= state_1;
					end 
			end 			
			state_5 : begin 
			        if (din) begin 
					    state <= state_1;
					end 
					else begin 
						state <= state_6;
					end 
			end			
			state_6 : begin 
			        if (din) begin 
					    state <= state_1;
					end 
					else begin 
						state <= state_2;
					end 
			end
            
            default :   state <= state_1; 			
			endcase 
		end 
end 


// Define the output combinational logic 
assign z = (state == state_6) ? 1 : 0; 


endmodule : sequence_detector
