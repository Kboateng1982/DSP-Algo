//-----------------------------------------------------
// Design Name : sp_ram8x16
// File Name   : sp_ram8x16.sv
// Function    : Synchronous read write single port-RAM 
//-----------------------------------------------------

timeunit 1ns;
timeprecision 100ps;

`define clock_period 10

module sp_ram8x16_tb();

logic wclk;
logic [2:0] addr;
logic [15:0] d_in;
logic we;
logic [15:0] d_out;

// sp_ram8x16 module instantiation 
sp_ram8x16    sp_ram8x16_inst (.*);

// Initialize All Inputs
initial 
begin
	wclk = '0;
	addr = '0;
	d_in = '0;
	we 	 = '1;
end

initial wclk = '1;
always #(`clock_period/2) wclk = !wclk;

integer outfile0,outfile1,outfile2,outfile3; //file descriptors

initial 
begin
	//$vcdplusfile("top.vpd");
    //$vcdpluson(0, sp_ram8x16_tb);
    //$vcdplusmemon();
    
    //The $fopen function opens a file and returns a multi-channel descriptor in the format of an unsized integer. 
    outfile0=$fopen("/p/psg/data/kboateng/FILE_IO/my_input.txt","r");   //"r" means reading and "w" means writing
    outfile1=$fopen("A_write_dec.txt","w");
    outfile2=$fopen("A_write_bin.txt","w");
    outfile3=$fopen("A_write_hex.txt","w");
    
    //read the contents of the file A_hex.txt as hexadecimal values into register "A".
    while (! $feof(outfile0)) 
	begin //read until an "end of file" is reached.
	    // The variable d_in is used to storing each line of file.
        $fscanf(outfile0,"%h\n",d_in); //scan each line and get the value as an hexadecimal
    //Write the read value into text files.
        $fdisplay(outfile1,"%d",d_in); //write as decimal
        $fdisplay(outfile2,"%b",d_in); //write as binary
        $fdisplay(outfile3,"%h",d_in); //write as hexadecimal
        #11 addr = addr + 1 ;
    end 
    //once reading and writing is finished, close all the files.
    $fclose(outfile0);
    $fclose(outfile1);
    $fclose(outfile2);
    $fclose(outfile3);
    //wait and then stop the simulation.
    #100;
    $finish;
end    
endmodule : sp_ram8x16_tb
