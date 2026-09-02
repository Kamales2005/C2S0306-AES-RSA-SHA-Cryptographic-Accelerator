#######################################################
#                                                     
#  Innovus Command Logging File                     
#  Created on Mon Jul 27 12:27:36 2026                
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
restoreDesign /home/scl_shuttle_8_3/tapeout/pnr/power_planning/C2S0306_power.enc.dat C2S0306
setDrawView fplan
encMessage warning 1
encMessage debug 0
encMessage info 1
setRouteMode -earlyGlobalHonorMsvRouteConstraint false -earlyGlobalRoutePartitionPinGuide true
setEndCapMode -reset
setEndCapMode -boundary_tap false
setNanoRouteMode -quiet -droutePostRouteSpreadWire 1
setNanoRouteMode -quiet -timingEngine {}
setUsefulSkewMode -maxSkew false -noBoundary false -useCells {dl03d2 buffd1 bufbd2 buffd7 dl01d1 bufbd1 bufbd3 dl01d2 bufbd4 dl02d4 dl04d4 buffd4 bufbdk bufbda buffd3 dl01d4 dl02d1 dl04d2 dl03d4 dl02d2 buffda bufbdf dl03d1 buffd2 bufbd7 dl04d1 inv0d4 invbdf invbd7 inv0d0 invbd2 invbd4 inv0d7 inv0d1 invbdk inv0da invbda inv0d2} -maxAllowedDelay 1
setPlaceMode -reset
setPlaceMode -congEffort high -timingDriven 1 -clkGateAware 1 -powerDriven 0 -ignoreScan 1 -reorderScan 1 -ignoreSpare 0 -placeIOPins 0 -moduleAwareSpare 0 -preserveRouting 1 -rmAffectedRouting 0 -checkRoute 0 -swapEEQ 0
setPlaceMode -fp false
place_design
fit
redirect -quiet {set honorDomain [getAnalysisMode -honorClockDomains]} > /dev/null
timeDesign -preCTS -pathReports -drvReports -slackReports -numPaths 500 -prefix C2S0306_preCTS -outDir timingReports
setOptMode -fixCap true -fixTran true -fixFanoutLoad true
optDesign -preCTS
selectWire 374.8800 816.5400 2565.0400 818.0200 1 VSS_CORE
saveDesign C2S0306_placement.enc
