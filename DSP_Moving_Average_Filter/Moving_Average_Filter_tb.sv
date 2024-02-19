timeunit 1ns;
timeprecision 1ns;

`define clock_period 10

localparam FILTER_LENGTH = 512;
localparam DATA_WIDTH = 16;

module Moving_Average_Filter_tb();
    logic clk;
    logic reset_n;
    logic [15:0] MA_data_in;
    logic MA_data_out_ready;
    logic [15:0] MA_data_out;

	// We instantiate the ROM_INIT file into our Test Bench
    Moving_Average_Filter    Moving_Average_Filter_inst (.*);
	initial clk = '1;
    always #(`clock_period/2) clk = !clk;

    // Do test
integer i,j; // this is an index for the loop counter

(* ram_style = "block" *) reg [DATA_WIDTH-1:0] input_x_n_lut_rom[0:FILTER_LENGTH-1];
//logic [DATA_WIDTH-1:0] input_x_n_lut_rom[0:FILTER_LENGTH-1];
initial
begin :  input_x_n_lut_initalization
   $readmemb("mem_initialization_vlog.mem", input_x_n_lut_rom); 
end 


initial 
	begin
	  $vcdplusfile("Moving_Average_Filter.vpd");
      $vcdpluson(0, Moving_Average_Filter_tb);
      $vcdplusmemon();
	   
	   // ensure that all input signals are set to zero 
	   reset_n = '0;
	   MA_data_in = '0;
	   
	   // After 20ns bring the system out of reset 
	   #(`clock_period*2); 
	   reset_n = 1'b1;  // finish the reset
	   
	   	for(j = 0; j < FILTER_LENGTH; j = j + 1)
		begin: generate_input_address
			MA_data_in  <= input_x_n_lut_rom[j];
			#(`clock_period);
		end
     
       #(`clock_period*FILTER_LENGTH*FILTER_LENGTH);
	   $finish;
    end
endmodule : Moving_Average_Filter_tb