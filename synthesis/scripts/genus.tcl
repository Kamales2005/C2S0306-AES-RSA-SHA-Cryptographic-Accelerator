##############################################################################
# Project Setup
##############################################################################

set TOP_MODULE C2S0306
set DESIGN $TOP_MODULE
set GEN_EFF medium
set MAP_OPT_EFF high
set clockname PCLK

set DATE [clock format [clock seconds] -format "%b%d-%T"]

set _OUTPUTS_PATH outputs
set _REPORTS_PATH reports
set _LOG_PATH logs
set LOG_PATH logs${DATE}

##############################################################################
# Library Setup (UNCHANGED)
##############################################################################

set_db / .init_lib_search_path {/opt/sclpdkv3/scl180/stdcell/fs120/6M1L/liberty/lib_flow_ff /opt/sclpdkv3/scl180/stdcell/fs120/6M1L/liberty/lib_flow_ss}

set_db / .init_hdl_search_path {
    /home/scl_shuttle_8_3/tapeout/Crypto_Accelerator_Pad_Synthesis/rtl
    /home/scl_shuttle_8_3/tapeout/Crypto_Accelerator_Pad_Synthesis/rtl/common
}

set_db auto_ungroup none
set_db / .information_level 7

set_db / .library {
    /opt/sclpdkv3/scl180/stdcell/fs120/6M1L/liberty/lib_flow_ss/tsl18fs120_scl_ss.lib
    /opt/sclpdkv3/scl180/iopad/cio150/6M1L/liberty/tsl18cio150_max.lib
    /opt/sclpdkv3/scl180/stdcell/fs120/6M1L/liberty/lib_flow_ff/tsl18fs120_scl_ff.lib
    /opt/sclpdkv3/scl180/iopad/cio150/6M1L/liberty/tsl18cio150_min.lib
}

read_libs \
-max_libs {
    /opt/sclpdkv3/scl180/stdcell/fs120/6M1L/liberty/lib_flow_ss/tsl18fs120_scl_ss.lib
    /opt/sclpdkv3/scl180/iopad/cio150/6M1L/liberty/tsl18cio150_max.lib
} \
-min_libs {
    /opt/sclpdkv3/scl180/stdcell/fs120/6M1L/liberty/lib_flow_ff/tsl18fs120_scl_ff.lib
    /opt/sclpdkv3/scl180/iopad/cio150/6M1L/liberty/tsl18cio150_min.lib
}

##############################################################################
# Read RTL
##############################################################################

puts "Load RTL"

read_hdl -f rtl_files_top.f

##############################################################################
# Elaborate
##############################################################################

puts "Elaborate Design"

elaborate $DESIGN

puts "Runtime & Memory after read_hdl"

time_info Elaboration

check_design -unresolved

##############################################################################
# Read Constraints
##############################################################################

read_sdc constraints/crypto_constraints.sdc

##############################################################################
# Path Adjustments
##############################################################################

path_adjust -from [all_inputs]   -to [all_outputs]  -delay -1300 -name PA_I2O
path_adjust -from [all_inputs]   -to [all_register] -delay -1500 -name PA_I2C
path_adjust -from [all_register] -to [all_outputs]  -delay -1500 -name PA_C2O
path_adjust -from [all_register] -to [all_register] -delay -1500 -name PA_C2C

report_timing -lint -verbose

puts "The number of exceptions is [llength [vfind design:$DESIGN -exception *]]"

##############################################################################
# Create Output Directories
##############################################################################

if {![file exists ${_OUTPUTS_PATH}]} {
    file mkdir ${_OUTPUTS_PATH}
    puts "Creating directory ${_OUTPUTS_PATH}"
}

if {![file exists ${_REPORTS_PATH}]} {
    file mkdir ${_REPORTS_PATH}
    puts "Creating directory ${_REPORTS_PATH}"
}

##############################################################################
# Generic Synthesis
##############################################################################

set_db lp_power_analysis_effort high

set_db syn_generic_effort $GEN_EFF

syn_generic

puts "Runtime & Memory after syn_generic"

time_info GENERIC

report_dp > $_REPORTS_PATH/generic/${DESIGN}_datapath.rpt

write_snapshot -outdir $_REPORTS_PATH -tag generic

write_hdl > ${_OUTPUTS_PATH}/${DESIGN}_generic.v

write_sdc > ${_OUTPUTS_PATH}/${DESIGN}_generic.sdc

##############################################################################
# Technology Mapping
##############################################################################

set_db / .syn_map_effort high

syn_map

puts "Runtime & Memory after syn_map"

time_info MAPPED

write_snapshot -outdir $_REPORTS_PATH -tag map

report_summary -directory $_REPORTS_PATH

report_dp > $_REPORTS_PATH/map/${DESIGN}_datapath.rpt

write_hdl > ${_OUTPUTS_PATH}/${DESIGN}_map.v

write_sdc > ${_OUTPUTS_PATH}/${DESIGN}_map.sdc

write_do_lec \
-revised_design fv_map \
-log_file ${LOG_PATH}/rtl2intermediate.lec.log \
> ${_OUTPUTS_PATH}/rtl2intermediate.lec.do

##############################################################################
# Optimization
##############################################################################

set_db / .syn_opt_effort high

syn_opt

write_snapshot -outdir $_REPORTS_PATH -tag syn_opt

report_summary -directory $_REPORTS_PATH

puts "Runtime & Memory after syn_opt"

time_info OPT

write_snapshot -outdir $_REPORTS_PATH -tag final

report_summary -directory $_REPORTS_PATH

##############################################################################
# Outputs
##############################################################################

write_hdl > ${_OUTPUTS_PATH}/${DESIGN}_incremental.v

write_sdc > ${_OUTPUTS_PATH}/${DESIGN}_incremental.sdc

write_sdf \
-version 2.1 \
-recrem split \
-setuphold merge_when_paired \
-edges check_edge \
> ${_OUTPUTS_PATH}/${DESIGN}.sdf

##############################################################################
# LEC
##############################################################################

set _LOG_PATH ./logs
set _OUTPUTS_PATH ./outputs

write_do_lec \
-golden_design fv_map \
-revised_design ${_OUTPUTS_PATH}/${DESIGN}_incremental.v \
-log_file ${_LOG_PATH}/intermediate2final.lec.log \
> ${_OUTPUTS_PATH}/intermediate2final.lec.do

write_do_lec \
-revised_design fv_map \
-log_file ${_LOG_PATH}/rtl2intermediate.lec.log \
> ${_OUTPUTS_PATH}/rtl2intermediate.lec.do

##############################################################################
# Finish
##############################################################################

puts "Final Runtime & Memory."

time_info FINAL

puts "============================"
puts "Synthesis Finished ........."
puts "============================"

gui_show
