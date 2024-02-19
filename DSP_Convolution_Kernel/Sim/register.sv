module register
#(parameter DATA_WIDTH=32)
(
	input wire signed [DATA_WIDTH-1:0] datain,
	input wire sys_clock,
	input wire reset_n,
	input wire en_i,
	output logic signed [DATA_WIDTH-1:0] dataout
);

always_ff@ (posedge sys_clock or negedge reset_n)
	if (!reset_n)
	begin 
		dataout <= '0;
	end 
	else if (en_i) 
    begin 	
		dataout <= datain;
	end 

endmodule