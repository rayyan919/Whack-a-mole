# Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

## Reset signal
#set_property PACKAGE_PIN U18 [get_ports rst]
#set_property IOSTANDARD LVCMOS33 [get_ports rst]

 
 set_property PACKAGE_PIN C17 [get_ports PS2_CLK]
set_property IOSTANDARD LVCMOS33 [get_ports PS2_CLK]

set_property PACKAGE_PIN B17 [get_ports PS2_DATA]
set_property IOSTANDARD LVCMOS33 [get_ports PS2_DATA]

## Oval select switches (3-bit input)

#set_property PACKAGE_PIN V17 [get_ports {oval_select[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {oval_select[0]}]
#set_property PACKAGE_PIN V16 [get_ports {oval_select[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {oval_select[1]}]
#set_property PACKAGE_PIN W16 [get_ports {oval_select[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {oval_select[2]}]

## Enable signal
#set_property PACKAGE_PIN V17 [get_ports fpause]
#set_property IOSTANDARD LVCMOS33 [get_ports fpause]

set_property PACKAGE_PIN P1 [get_ports led]
set_property IOSTANDARD LVCMOS33 [get_ports led]

## Pause signal

#set_property PACKAGE_PIN W15 [get_ports pause]
#set_property IOSTANDARD LVCMOS33 [get_ports pause]

# Output constraints for hsync and vsync

set_property PACKAGE_PIN P19 [get_ports hsync]
set_property IOSTANDARD LVCMOS33 [get_ports hsync]
set_property PACKAGE_PIN R19 [get_ports vsync]
set_property IOSTANDARD LVCMOS33 [get_ports vsync]

# Output constraints for 4-bit red, green, and blue
set_property PACKAGE_PIN J17 [get_ports {red[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {red[0]}]
set_property PACKAGE_PIN H17 [get_ports {red[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {red[1]}]
set_property PACKAGE_PIN G17 [get_ports {red[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {red[2]}]
set_property PACKAGE_PIN D17 [get_ports {red[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {red[3]}]
 

set_property PACKAGE_PIN N18 [get_ports {green[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {green[0]}]
set_property PACKAGE_PIN L18 [get_ports {green[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {green[1]}]
set_property PACKAGE_PIN K18 [get_ports {green[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {green[2]}]
set_property PACKAGE_PIN J18 [get_ports {green[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {green[3]}]

set_property PACKAGE_PIN G19 [get_ports {blue[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {blue[0]}]
set_property PACKAGE_PIN H19 [get_ports {blue[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {blue[1]}]
set_property PACKAGE_PIN J19 [get_ports {blue[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {blue[2]}]
set_property PACKAGE_PIN N19 [get_ports {blue[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {blue[3]}]
 

##score pins

#set_property PACKAGE_PIN W2 [get_ports {score[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {score[0]}]
#set_property PACKAGE_PIN U1 [get_ports {score[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {score[1]}]
#set_property PACKAGE_PIN T1 [get_ports {score[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {score[2]}]
#set_property PACKAGE_PIN R2 [get_ports {score[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {score[3]}]