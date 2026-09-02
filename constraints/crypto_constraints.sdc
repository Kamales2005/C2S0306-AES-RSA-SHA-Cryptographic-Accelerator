############################################################
# SDC Constraints - Crypto Accelerator
############################################################

#########################
# Units
#########################

set_units -time 1.0ns
set_units -capacitance 1.0pF

#########################
# Parameters
#########################

set CLOCK_PERIOD 58
set CLOCK_NAME MAIN_CLK

set CLOCK_SKEW_SETUP [expr $CLOCK_PERIOD*0.025]
set CLOCK_SKEW_HOLD  [expr $CLOCK_PERIOD*0.025]

set CLOCK_MINRISE [expr $CLOCK_PERIOD*0.125]
set CLOCK_MAXRISE [expr $CLOCK_PERIOD*0.20]

set CLOCK_MINFALL [expr $CLOCK_PERIOD*0.125]
set CLOCK_MAXFALL [expr $CLOCK_PERIOD*0.20]

set MIN_PORT 0.20
set MAX_PORT 0.50

############################################################
# Clock
############################################################

create_clock \
-name $CLOCK_NAME \
-period $CLOCK_PERIOD \
-waveform {0 5} \
[get_ports main_clk_pad]

############################################################
# Virtual Clock
############################################################

create_clock \
-name vir_main_clk_i \
-period $CLOCK_PERIOD

############################################################
# Clock Latency
############################################################

set_clock_latency -source -max 0.25 -late \
[get_ports main_clk_pad]

set_clock_latency -source -min 0.10 -late \
[get_ports main_clk_pad]

set_clock_latency -source -max 0.15 -early \
[get_ports main_clk_pad]

set_clock_latency -source -min 0.10 -early \
[get_ports main_clk_pad]

############################################################
# Clock Transition
############################################################

set_clock_transition -rise -min $CLOCK_MINRISE \
[get_ports main_clk_pad]

set_clock_transition -rise -max $CLOCK_MAXRISE \
[get_ports main_clk_pad]

set_clock_transition -fall -min $CLOCK_MINFALL \
[get_ports main_clk_pad]

set_clock_transition -fall -max $CLOCK_MAXFALL \
[get_ports main_clk_pad]

############################################################
# Clock Uncertainty
############################################################

set_clock_uncertainty -setup $CLOCK_SKEW_SETUP \
[get_ports main_clk_pad]

set_clock_uncertainty -hold $CLOCK_SKEW_HOLD \
[get_ports main_clk_pad]

############################################################
# Input Transition
############################################################

#########################
# Max Input Transition
#########################

set_input_transition -max $MAX_PORT [get_ports PRESETn_pad]
set_input_transition -max $MAX_PORT [get_ports PSEL_pad]
set_input_transition -max $MAX_PORT [get_ports PENABLE_pad]
set_input_transition -max $MAX_PORT [get_ports PWRITE_pad]

set_input_transition -max $MAX_PORT [get_ports PADDR_pad[7]]
set_input_transition -max $MAX_PORT [get_ports PADDR_pad[6]]
set_input_transition -max $MAX_PORT [get_ports PADDR_pad[5]]
set_input_transition -max $MAX_PORT [get_ports PADDR_pad[4]]
set_input_transition -max $MAX_PORT [get_ports PADDR_pad[3]]
set_input_transition -max $MAX_PORT [get_ports PADDR_pad[2]]
set_input_transition -max $MAX_PORT [get_ports PADDR_pad[1]]
set_input_transition -max $MAX_PORT [get_ports PADDR_pad[0]]

set_input_transition -max $MAX_PORT [get_ports SER_DATA_pad]
set_input_transition -max $MAX_PORT [get_ports SHIFT_EN_pad]

#########################
# Min Input Transition
#########################

set_input_transition -min $MIN_PORT [get_ports PRESETn_pad]
set_input_transition -min $MIN_PORT [get_ports PSEL_pad]
set_input_transition -min $MIN_PORT [get_ports PENABLE_pad]
set_input_transition -min $MIN_PORT [get_ports PWRITE_pad]

set_input_transition -min $MIN_PORT [get_ports PADDR_pad[7]]
set_input_transition -min $MIN_PORT [get_ports PADDR_pad[6]]
set_input_transition -min $MIN_PORT [get_ports PADDR_pad[5]]
set_input_transition -min $MIN_PORT [get_ports PADDR_pad[4]]
set_input_transition -min $MIN_PORT [get_ports PADDR_pad[3]]
set_input_transition -min $MIN_PORT [get_ports PADDR_pad[2]]
set_input_transition -min $MIN_PORT [get_ports PADDR_pad[1]]
set_input_transition -min $MIN_PORT [get_ports PADDR_pad[0]]

set_input_transition -min $MIN_PORT [get_ports SER_DATA_pad]
set_input_transition -min $MIN_PORT [get_ports SHIFT_EN_pad]

############################################################
# Input Delay
############################################################

#########################
# Max Input Delay
#########################

set_input_delay -clock vir_main_clk_i -max 2.0 -add_delay [get_ports PRESETn_pad]
set_input_delay -clock vir_main_clk_i -max 2.0 -add_delay [get_ports PSEL_pad]
set_input_delay -clock vir_main_clk_i -max 2.0 -add_delay [get_ports PENABLE_pad]
set_input_delay -clock vir_main_clk_i -max 2.0 -add_delay [get_ports PWRITE_pad]

set_input_delay -clock vir_main_clk_i -max 2.0 -add_delay [get_ports PADDR_pad[7]]
set_input_delay -clock vir_main_clk_i -max 2.0 -add_delay [get_ports PADDR_pad[6]]
set_input_delay -clock vir_main_clk_i -max 2.0 -add_delay [get_ports PADDR_pad[5]]
set_input_delay -clock vir_main_clk_i -max 2.0 -add_delay [get_ports PADDR_pad[4]]
set_input_delay -clock vir_main_clk_i -max 2.0 -add_delay [get_ports PADDR_pad[3]]
set_input_delay -clock vir_main_clk_i -max 2.0 -add_delay [get_ports PADDR_pad[2]]
set_input_delay -clock vir_main_clk_i -max 2.0 -add_delay [get_ports PADDR_pad[1]]
set_input_delay -clock vir_main_clk_i -max 2.0 -add_delay [get_ports PADDR_pad[0]]

set_input_delay -clock vir_main_clk_i -max 2.0 -add_delay [get_ports SER_DATA_pad]
set_input_delay -clock vir_main_clk_i -max 2.0 -add_delay [get_ports SHIFT_EN_pad]

#########################
# Min Input Delay
#########################

set_input_delay -clock vir_main_clk_i -min 0.5 -add_delay [get_ports PRESETn_pad]
set_input_delay -clock vir_main_clk_i -min 0.5 -add_delay [get_ports PSEL_pad]
set_input_delay -clock vir_main_clk_i -min 0.5 -add_delay [get_ports PENABLE_pad]
set_input_delay -clock vir_main_clk_i -min 0.5 -add_delay [get_ports PWRITE_pad]

set_input_delay -clock vir_main_clk_i -min 0.5 -add_delay [get_ports PADDR_pad[7]]
set_input_delay -clock vir_main_clk_i -min 0.5 -add_delay [get_ports PADDR_pad[6]]
set_input_delay -clock vir_main_clk_i -min 0.5 -add_delay [get_ports PADDR_pad[5]]
set_input_delay -clock vir_main_clk_i -min 0.5 -add_delay [get_ports PADDR_pad[4]]
set_input_delay -clock vir_main_clk_i -min 0.5 -add_delay [get_ports PADDR_pad[3]]
set_input_delay -clock vir_main_clk_i -min 0.5 -add_delay [get_ports PADDR_pad[2]]
set_input_delay -clock vir_main_clk_i -min 0.5 -add_delay [get_ports PADDR_pad[1]]
set_input_delay -clock vir_main_clk_i -min 0.5 -add_delay [get_ports PADDR_pad[0]]

set_input_delay -clock vir_main_clk_i -min 0.5 -add_delay [get_ports SER_DATA_pad]
set_input_delay -clock vir_main_clk_i -min 0.5 -add_delay [get_ports SHIFT_EN_pad]

############################################################
# Output Delay
############################################################

#########################
# Max Output Delay
#########################

set_output_delay -clock vir_main_clk_i -max 2.0 -add_delay [get_ports PREADY_pad]
set_output_delay -clock vir_main_clk_i -max 2.0 -add_delay [get_ports PSLVERR_pad]
set_output_delay -clock vir_main_clk_i -max 2.0 -add_delay [get_ports SER_OUT_pad]
set_output_delay -clock vir_main_clk_i -max 2.0 -add_delay [get_ports SHIFT_OUT_EN_pad]

#########################
# Min Output Delay
#########################

set_output_delay -clock vir_main_clk_i -min 0.5 -add_delay [get_ports PREADY_pad]
set_output_delay -clock vir_main_clk_i -min 0.5 -add_delay [get_ports PSLVERR_pad]
set_output_delay -clock vir_main_clk_i -min 0.5 -add_delay [get_ports SER_OUT_pad]
set_output_delay -clock vir_main_clk_i -min 0.5 -add_delay [get_ports SHIFT_OUT_EN_pad]

############################################################
# Output Load
############################################################

set_load 5 [get_ports PREADY_pad]
set_load 5 [get_ports PSLVERR_pad]
set_load 5 [get_ports SER_OUT_pad]
set_load 5 [get_ports SHIFT_OUT_EN_pad]

############################################################
# False Paths
############################################################

set_false_path \
-from [get_ports PRESETn_pad] \
-to [all_registers]

############################################################
# Group Paths
############################################################

group_path -name I2R \
-from [all_inputs] \
-to [all_registers]

group_path -name R2O \
-from [all_registers] \
-to [all_outputs]

group_path -name R2R \
-from [all_registers] \
-to [all_registers]

group_path -name I2O \
-from [all_inputs] \
-to [all_outputs]
