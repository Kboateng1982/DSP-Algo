// Problem Statement :
/* Objectives
After completing this lab, you will be able to:
• Model mem_array by using procedural assignments
• Write RTL description using non-blocking procedural assignment
• Verify the logic structure
Introduction
The mem module is initially an 8-bit wide mem_array with 16 words. Later, you may choose to create a
deeper structure to hold more content. This submodule will be created using a two-dimensional
array of a Verilog reg data type and procedural assignment statements. 

*/
timeunit 1ns;
timeprecision 1ns;

module mem_led_driver

#(
    parameter DATA_WIDTH = 8, // mem_array Data word width 
	parameter mem_array_DEPTH  = 16, // Maximum number of words
	parameter ADDR_WIDTH_BITS = $clog2(mem_array_DEPTH) //Ceiling log2N
)


(
   input 		wire  						sys_clk,
   input 		wire  						reset,
   input      	wire  [ADDR_WIDTH_BITS-1:0] addr_i, // this is the mem_array address bits 
   output 		logic [DATA_WIDTH-1:0]      led_out
);

(* ram_style = "block" *)  reg [DATA_WIDTH-1:0] mem_array [mem_array_DEPTH-1:0];

always_ff @(posedge sys_clk or negedge reset) 
begin
    if (!reset) 
	begin
        led_out <= 8'b0;      // Initial state for road 1
    end
	
	else 
	begin
		mem_array['b0000] <= 'b0000_0001; // led value = 1 
		mem_array['b0001] <= 'b0000_0010; // led value = 2
		mem_array['b0010] <= 'b0000_0100; // led value = 4
		mem_array['b0011] <= 'b0000_1000; // led value = 8
		mem_array['b0100] <= 'b0001_0000; // led value = 16
		mem_array['b0101] <= 'b0010_0000; // led value = 32
		mem_array['b0110] <= 'b0100_0000; // led value = 64
		mem_array['b0111] <= 'b1000_0000; // led value = 128
		mem_array['b1000] <= 'b1111_1111; // Led value = 255
		mem_array['b1001] <= 'b1111_1110; // Led value = 254
		mem_array['b1010] <= 'b1111_1100; // Led value = 252
		mem_array['b1011] <= 'b1111_1000; // Led value = 248
		mem_array['b1100] <= 'b1111_0000; // Led value = 240
		mem_array['b1101] <= 'b1110_0000; // Led value = 224
		mem_array['b1110] <= 'b1100_0000; // Led value = 192
		mem_array['b1111] <= 'b1000_0000; // Led value = 128
    end 

end 


always_ff @ (posedge sys_clk)
begin
	led_out <= mem_array[addr_i];
end  

endmodule : mem_led_driver
