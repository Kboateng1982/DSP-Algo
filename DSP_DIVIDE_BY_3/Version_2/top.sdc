# The target frequence is 500MHz. 
# This is the required frequency
create_clock -period 500MHz -name sys_clock [get_ports sys_clock]