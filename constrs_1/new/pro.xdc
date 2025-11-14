# =====================
# Clock (100 MHz)
# =====================
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

# =====================
# Reset Button (Center)
# =====================
set_property PACKAGE_PIN U18 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]

# =====================
# UART RX (from Arduino TX)
# =====================
set_property PACKAGE_PIN G3 [get_ports rx]
set_property IOSTANDARD LVCMOS33 [get_ports rx]

# =====================
# Switches SW[3:0] for setpoint (24°C to 39°C)
# =====================
set_property PACKAGE_PIN V17 [get_ports {mode_switch}]
set_property IOSTANDARD LVCMOS33 [get_ports {mode_switch}]
# Setpoint down button 
set_property PACKAGE_PIN W19 [get_ports btn_down]
set_property IOSTANDARD LVCMOS33 [get_ports btn_down]
# setpoint up button
set_property PACKAGE_PIN T17 [get_ports btn_up]
set_property IOSTANDARD LVCMOS33 [get_ports btn_up]

# =====================
# PWM Output: Fan (ENB)
# =====================
set_property PACKAGE_PIN L2 [get_ports pwm_fan]
set_property IOSTANDARD LVCMOS33 [get_ports pwm_fan]

# =====================
# PWM Output: Lamp (ENA)
# =====================
set_property PACKAGE_PIN J1 [get_ports pwm_lamp]
set_property IOSTANDARD LVCMOS33 [get_ports pwm_lamp]

# =====================
# Lamp Direction Control (IN1/IN2)
# =====================
set_property PACKAGE_PIN J2 [get_ports in1]
set_property PACKAGE_PIN G2 [get_ports in2]
set_property IOSTANDARD LVCMOS33 [get_ports {in1 in2}]

# =====================
# Fan Direction Control (IN3/IN4)
# =====================
set_property PACKAGE_PIN H1 [get_ports in3]
#set_property PACKAGE_PIN K2 [get_ports in4]
set_property IOSTANDARD LVCMOS33 [get_ports {in3}]

#7 segment display
set_property PACKAGE_PIN W7 [get_ports {seg[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[0]}]
set_property PACKAGE_PIN W6 [get_ports {seg[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[1]}]
set_property PACKAGE_PIN U8 [get_ports {seg[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[2]}]
set_property PACKAGE_PIN V8 [get_ports {seg[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[3]}]
set_property PACKAGE_PIN U5 [get_ports {seg[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[4]}]
set_property PACKAGE_PIN V5 [get_ports {seg[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[5]}]
set_property PACKAGE_PIN U7 [get_ports {seg[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[6]}]

set_property PACKAGE_PIN V7 [get_ports dp]							
	set_property IOSTANDARD LVCMOS33 [get_ports dp]

set_property PACKAGE_PIN U2 [get_ports {an[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {an[0]}]
set_property PACKAGE_PIN U4 [get_ports {an[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {an[1]}]
set_property PACKAGE_PIN V4 [get_ports {an[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {an[2]}]
set_property PACKAGE_PIN W4 [get_ports {an[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {an[3]}]
