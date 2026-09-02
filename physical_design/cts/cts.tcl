set init_top_cell C2S0306
set_global report_timing_format {instance arc net cell slew delay arrival required} 

source /home/scl_shuttle_8_3/tapeout/pnr/cts/config.tcl
create_ccopt_clock_tree_spec -file /home/scl_shuttle_8_3/tapeout/pnr/cts/${init_top_cell}_ccopt.spec 
source /home/scl_shuttle_8_3/tapeout/pnr/cts/${init_top_cell}_ccopt.spec 
ctd_win -id before_ccopt 

set_ccopt_property -delay_corner max_delay -net_type top   target_max_trans 2 
set_ccopt_property -delay_corner min_delay -net_type top   target_max_trans 2 
set_ccopt_property -delay_corner max_delay -net_type trunk target_max_trans 2 
set_ccopt_property -delay_corner min_delay -net_type trunk target_max_trans 2 
set_ccopt_property -delay_corner max_delay -net_type leaf  target_max_trans 2 
set_ccopt_property -delay_corner min_delay -net_type leaf  target_max_trans 2 

set_ccopt_property -skew_group MAIN_CLK/all  -delay_corner min_delay target_skew 1.0
set_ccopt_property  -delay_corner min_delay target_skew 1.0 
set_ccopt_property source_driver pc3d01/CIN -clock_tree MAIN_CLK

 
set_ccopt_property balance_mode full 
ccopt_design -cts 
ctd_win -id full_mode 

report_ccopt_clock_trees -summary -file /home/scl_shuttle_8_3/tapeout/pnr/cts/${init_top_cell}_clock_trees.rpt 
report_ccopt_skew_groups -summary -file /home/scl_shuttle_8_3/tapeout/pnr/cts/${init_top_cell}_skew_group.rpt 
reportCongestion -overflow -hotSpot > /home/scl_shuttle_8_3/tapeout/pnr/cts/${init_top_cell}_congestion.rpt
