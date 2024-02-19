// Initialize ROM in SystemVerilog to read all of the input signal data converted into Binary
// Author : Kwadwo Boateng
// Data : 8-10-2021

timeunit 1ns;
timeprecision 1ns;

module ROM_INIT 
#(
    parameter DATA_WIDTH = 20, // ROM Data word width 
	parameter ROM_DEPTH  = 64 // Maximum number of words
)
(
    input      wire   sys_clock,   // this is the main system clock
	input      wire   reset_n,
	input      wire  [DATA_WIDTH-1:0] divident,
    output     logic [3:0] quotient,       // this is the data output of the ROM 
	output     logic [1:0] reminder       // this is the data output of the ROM 
);


wire [3:0] quotient_rom[0:ROM_DEPTH-1];
wire [1:0] reminder_rom[0:ROM_DEPTH-1]; 

genvar i;
generate
    for (i = 0; i < 64; i=i+1) 
	begin : rom_init
        assign quotient_rom[i] = i / 3;
        assign reminder_rom[i] = i % 3;        
    end
endgenerate

assign quotient = quotient_rom[divident];
assign reminder = reminder_rom[divident];
  
    
endmodule : ROM_INIT 