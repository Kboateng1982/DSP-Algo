timeunit 1ns;
timeprecision 1ns;

module Moving_Average_Filter 
#(parameter FILTER_LENGTH = 512,
			DATA_WIDTH = 16)
(
    input wire clk,
    input wire reset_n,
    input wire [15:0] MA_data_in,
    output logic [15:0] MA_data_out
);


logic [DATA_WIDTH-1:0] buffer [FILTER_LENGTH-1:0];
logic [$clog2(FILTER_LENGTH) + DATA_WIDTH-1:0] sum;
logic [DATA_WIDTH-1:0] average;

integer i;

// The amount of memory allocated for the impulse-response must be the same as the amount of memory allocated for samples of the input_signal
// Instantiate and connect shift register for each impulse response coefficient
// x[k] = x[k-1]
// The memory block that stores the delayed samples of the input signal is called : delay 
logic [DATA_WIDTH-1:0] delay[FILTER_LENGTH-1:0];



 always @(posedge clk or posedge reset_n) 
begin
    if (!reset_n) 
	begin
        for (i = 0; i < FILTER_LENGTH; i = i + 1) 
		begin
            buffer[i] <= '0;
        end
        sum <= '0;
        average <= '0;
		MA_data_out  <= '0;
    end 
	else begin
        // Shift in new data
        buffer[0] <= MA_data_in;
        sum <= sum + MA_data_in - buffer[FILTER_LENGTH-1];

        // Compute the moving average
        average <= sum >> 9; // Shift right by a factor of 9 which is equal to divide by 512

        // Output the average
        MA_data_out <= average;
    end
end
 
endmodule