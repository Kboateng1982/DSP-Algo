# The target frequence is 500MHz. 
# This is the required frequency
create_clock -period 500MHz -name sys_clock [get_ports sys_clock]

# derive clock uncertainty: 
derive_clock_uncertainty

# Cut timing from the reset_n port to all of its destinations: 
set_false_path -from [get_ports reset_n]
