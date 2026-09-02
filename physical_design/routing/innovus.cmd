#######################################################
#                                                     
#  Innovus Command Logging File                     
#  Created on Mon Jul 27 14:56:19 2026                
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
restoreDesign /home/scl_shuttle_8_3/tapeout/pnr/cts/C2S0306_cts.enc.dat C2S0306
setDrawView fplan
encMessage warning 1
encMessage debug 0
encMessage info 1
fit
zoomOut
fit
setNanoRouteMode -quiet -routeInsertAntennaDiode 1
setNanoRouteMode -quiet -routeAntennaCellName ADIODE
setNanoRouteMode -quiet -routeWithTimingDriven 1
setNanoRouteMode -quiet -routeWithSiDriven 1
setNanoRouteMode -quiet -routeTdrEffort 6
setNanoRouteMode -quiet -routeTopRoutingLayer 6
setNanoRouteMode -quiet -routeBottomRoutingLayer 1
setNanoRouteMode -quiet -drouteEndIteration default
setNanoRouteMode -quiet -routeWithTimingDriven true
setNanoRouteMode -quiet -routeWithSiDriven true
routeDesign -globalDetail
verifyConnectivity
verify_drc
timeDesign -postRoute
timeDesign -postRoute -hold
checkFPlan -reportUtil
reportRoute
verifyConnectivity -type special
verify_PG_short
help checkPGConnectivity
setDrawView ameba
setDrawView place
setRouteMode -earlyGlobalHonorMsvRouteConstraint false -earlyGlobalRoutePartitionPinGuide true
setEndCapMode -reset
setEndCapMode -boundary_tap false
setNanoRouteMode -quiet -routeAntennaCellName {}
setUsefulSkewMode -maxSkew false -noBoundary false -useCells {dl03d2 buffd1 bufbd2 buffd7 dl01d1 bufbd1 bufbd3 dl01d2 bufbd4 dl02d4 dl04d4 buffd4 bufbdk bufbda buffd3 dl01d4 dl02d1 dl04d2 dl03d4 dl02d2 buffda bufbdf dl03d1 buffd2 bufbd7 dl04d1 inv0d4 invbdf invbd7 inv0d0 invbd2 invbd4 inv0d7 inv0d1 invbdk inv0da invbda inv0d2} -maxAllowedDelay 1
setOptMode -effort high -powerEffort none -leakageToDynamicRatio 1 -reclaimArea true -simplifyNetlist true -allEndPoints true -setupTargetSlack 0 -holdTargetSlack 0.2999 -maxDensity 0.8 -drcMargin 0 -usefulSkew true
setOptMode -fixCap false -fixTran false -fixFanoutLoad false
optDesign -postRoute -incr
optDesign -postRoute -hold -incr
verifyConnectivity
verify_drc
setOptMode -fixCap true -fixTran true -fixFanoutLoad true
optDesign -postRoute
optDesign -postRoute -hold
verify_drc
selectWire 1484.1000 1214.1800 1524.7000 1214.4600 5 u_crypto_synth_top/u_top/u_rsa/core_inst/result_mem/FE_OFN536_FE_DBTN12_n_9920
fit
fit
fit
fit
setDrawView ameba
setDrawView fplan
setDrawView place
setLayerPreference violation -isVisible 1
violationBrowser -all -no_display_false -displayByLayer
report_constraint -drv
report_constraint -all_violators
ecoChangeCell -inst u_crypto_synth_top/u_top/u_rsa/core_inst/result_mem/g451026 -cell mx02d2
ecoChangeCell -inst u_crypto_synth_top/u_top/u_rsa/core_inst/result_mem/g456868 -cell mx02d2
ecoChangeCell -inst u_crypto_synth_top/u_top/u_rsa/core_inst/result_mem/g455165 -cell mx02d2
ecoChangeCell -inst u_crypto_synth_top/u_top/u_rsa/core_inst/result_mem/g645879 -cell oai22d2
ecoRoute
timeDesign -postRoute
timeDesign -postRoute -hold
report_constraint -all_violators
verify_drc
violationBrowser -all -no_display_false -displayByLayer
verifyProcessAntenna
violationBrowser -all -no_display_false -displayByLayer
setNanoRouteMode -drouteFixAntenna true
setNanoRouteMode -routeInsertAntennaDiode true
setNanoRouteMode -routeAntennaCellName adiode
getNanoRouteMode -quiet -routeWithTimingDriven
setSIMode -acceptableWNS same -fixDRC 1 -fixHoldIncludeXtalkSetup 0
setOptMode -fixCap false -fixTran false -fixFanoutLoad false
setDelayCalMode -engine default -siAware true
optDesign -postRoute -incr
violationBrowser -all -no_display_false -displayByLayer
verifyProcessAntenna
violationBrowser -all -no_display_false -displayByLayer
verify_drc
violationBrowser -all -no_display_false -displayByLayer
redirect -quiet {set honorDomain [getAnalysisMode -honorClockDomains]} > /dev/null
timeDesign -postRoute -hold -pathReports -slackReports -numPaths 500 -prefix C2S0306_postRoute -outDir timingReports
getFillerMode -quiet
addFiller -cell feedth feedth3 feedth9 -prefix FILLER
saveDesign C2S0306_route.enc
