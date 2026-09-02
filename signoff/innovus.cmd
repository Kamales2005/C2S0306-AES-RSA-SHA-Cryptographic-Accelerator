#######################################################
#                                                     
#  Innovus Command Logging File                     
#  Created on Tue Jul 28 15:23:32 2026                
#                                                     
#######################################################

#@(#)CDS: Innovus v20.14-s095_1 (64bit) 04/19/2021 14:41 (Linux 2.6.32-431.11.2.el6.x86_64)
#@(#)CDS: NanoRoute 20.14-s095_1 NR210411-1939/20_14-UB (database version 18.20.547) {superthreading v2.13}
#@(#)CDS: AAE 20.14-s018 (64bit) 04/19/2021 (Linux 2.6.32-431.11.2.el6.x86_64)
#@(#)CDS: CTE 20.14-s027_1 () Apr 13 2021 21:29:07 ( )
#@(#)CDS: SYNTECH 20.14-s017_1 () Mar 25 2021 13:07:27 ( )
#@(#)CDS: CPE v20.14-s080
#@(#)CDS: IQuantus/TQuantus 20.1.1-s460 (64bit) Fri Mar 5 18:46:16 PST 2021 (Linux 2.6.32-431.11.2.el6.x86_64)

set_global _enable_mmmc_by_default_flow      $CTE::mmmc_default
suppressMessage ENCEXT-2799
getVersion
win
encMessage warning 0
encMessage debug 0
encMessage info 0
is_common_ui_mode
restoreDesign /home/scl_shuttle_8_3/tapeout/pnr/routing/C2S0306_route_filler.enc.dat C2S0306
setDrawView fplan
encMessage warning 1
encMessage debug 0
encMessage info 1
reset_parasitics
extractRC
rcOut -spef C2S0306.spef -rc_corner rc_best
getMultiCpuUsage -localCpu
get_verify_drc_mode -disable_rules -quiet
get_verify_drc_mode -quiet -area
get_verify_drc_mode -quiet -layer_range
get_verify_drc_mode -check_ndr_spacing -quiet
get_verify_drc_mode -check_only -quiet
get_verify_drc_mode -check_same_via_cell -quiet
get_verify_drc_mode -exclude_pg_net -quiet
get_verify_drc_mode -ignore_trial_route -quiet
get_verify_drc_mode -max_wrong_way_halo -quiet
get_verify_drc_mode -use_min_spacing_on_block_obs -quiet
get_verify_drc_mode -limit -quiet
set_verify_drc_mode -disable_rules {} -check_ndr_spacing auto -check_only default -check_same_via_cell false -exclude_pg_net false -ignore_trial_route false -ignore_cell_blockage false -use_min_spacing_on_block_obs auto -report C2S0306.drc.rpt -limit 1000
verify_drc
set_verify_drc_mode -area {0 0 0 0}
verifyConnectivity -type all -error 1000 -warning 50
checkDesign -io -netlist -physicalLibrary -powerGround -tieHilo -timingLibrary -spef -floorplan -place -outdir checkDesign
streamOut C2S0306.gds -mapFile streamout_innovous_6M1L.map -libName DesignLib -units 1000 -mode ALL
saveNetlist -includePowerGround ./signoff/C2S0306_withpg.v
saveNetlist ./signoff/C2S0306_withoutpg.v
write_sdf -version 2.1 -edges noedge -recrem split -setuphold merge_when_paired ./signoff/C2S0306.sdf
selectMarker 61.0000 61.0000 2879.0000 2879.0000 -1 3 7
setLayerPreference violation -isVisible 1
violationBrowser -all -no_display_false -displayByLayer
deselectAll
selectMarker 61.0000 61.0000 2879.0000 2879.0000 -1 3 7
violationBrowserClose
zoomBox -1865.71500 1146.60000 4805.71400 4380.60000
zoomBox -1865.71500 1793.40000 4805.71400 5027.40000
fit
zoomIn
zoomIn
zoomIn
zoomIn
zoomIn
zoomIn
zoomIn
zoomIn
zoomIn
zoomOut
zoomOut
zoomOut
zoomOut
zoomOut
fit
zoomIn
zoomIn
zoomIn
zoomIn
zoomIn
deselectAll
selectMarker 61.0000 61.0000 2879.0000 2879.0000 -1 3 7
deselectAll
selectMarker 61.0000 61.0000 2879.0000 2879.0000 -1 3 7
setLayerPreference violation -isVisible 1
violationBrowser -all -no_display_false -displayByLayer
violationBrowserClose
