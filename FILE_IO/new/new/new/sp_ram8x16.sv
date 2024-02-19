//-----------------------------------------------------
// Design Name : sp_ram8x16
// File Name   : sp_ram8x16.sv
// Function    : Synchronous read (read through) write single port-RAM 
//-----------------------------------------------------
module sp_ram8x16 
# (	parameter DATA_WIDTH = 16 ,
	parameter ADDR_WIDTH = 3 ,
	parameter RAM_DEPTH = 1 << ADDR_WIDTH
)

(
input 		wire 					wclk, // Clock Input
input 		wire [ADDR_WIDTH-1:0] 	addr, // Address Input
input 		wire [DATA_WIDTH-1:0] 	d_in, // INPUT Data 
input       wire                    we, // Write Enable/Read Enable
output      logic [DATA_WIDTH-1:0]    d_out // Output Data 
); 

//--------------Internal variables---------------- 
logic [DATA_WIDTH-1:0] mem_array [0:RAM_DEPTH-1];
// Variable to hold the registered read address
logic [ADDR_WIDTH-1:0] read_a; 

//--------------Code Starts Here------------------ 
// Memory Write Block 
// Write Operation : When we = 1
always_ff @ (posedge wclk)
begin : MEM_WRITE
   if (we) 
   begin
       mem_array[addr] <= d_in;
	   read_a <= addr;  
   end
end

// Continuous assignment implies read returns NEW data.
// This is the natural behavior of the TriMatrix memory
// blocks in Single Port mode.  
assign d_out = mem_array[read_a]; 

endmodule : sp_ram8x16 