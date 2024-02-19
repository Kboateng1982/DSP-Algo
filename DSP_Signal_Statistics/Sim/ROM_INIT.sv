// Initialize ROM in SystemVerilog to read all of the input signal data converted into Binary
// Author : Kwadwo Boateng
// Data : 8-10-2021

timeunit 1ns;
timeprecision 1ns;

module ROM_INIT 
#(
    parameter DATA_WIDTH = 32, // ROM Data word width 
	parameter ROM_DEPTH  = 512, // Maximum number of words
	parameter ADDR_WIDTH_BITS = $clog2(ROM_DEPTH) //ROM Address bits width
)
(
    input      wire   sys_clock,   // this is the main system clock
    input      wire  [ADDR_WIDTH_BITS-1:0] addr_i, // this is the ROM address bits 
    output     logic signed [DATA_WIDTH-1:0] data_o       // this is the data output of the ROM 
);


(* ram_style = "block" *) reg [DATA_WIDTH-1:0] mem_array[0:ROM_DEPTH-1];


initial
begin
   $readmemb("mem_initialization_vlog.mem", mem_array); 
end 

always_ff @ (posedge sys_clock)
begin

    data_o <= mem_array[addr_i];

end 
    
endmodule : ROM_INIT