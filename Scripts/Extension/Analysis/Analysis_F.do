/************************************************
Before running the following file:

	-Download in .csv format the Affinity - Country - Data dataset following the instructions in
	ReadMe.pdf
	
	-Designate the ChettyProject/ as the working directory
	
	-Lines coded in green with asterisks with specific pathways shown as examples
	rather than functional pathways for all users 
	
************************************************
************************************************/
cd ~/Projects/HERC_ChettyReplication

clear
set more off

*Import Dataset*
use "Data/Extension/AnalysisData/analysis_F.dta"

*Run Regression Scripts*
run "Scripts/Extension/Processing/IntermediateProcessing_E1.do"
run "Scripts/Extension/Processing/IntermediateProcessing_E2_F1.do" 0
run "Scripts/Extension/Processing/IntermediateProcessing_E2_F2.do" 0
run "Scripts/Extension/Processing/IntermediateProcessing_E2_F3.do" 0
run "Scripts/Extension/Processing/AppendProcessing_F.do"

*Run Relevant Regressions*
reg spend_all doesOpen afterEvent isOpen if (abs(timeToTreat)<=14), cluster(statefips)
reg spend_all doesOpen afterEvent isOpen if (abs(timeToTreat)<=21), cluster(statefips)
reg emp doesOpen afterEvent isOpen if (abs(timeToTreat)<=14), cluster(statefips)
reg emp doesOpen afterEvent isOpen if (abs(timeToTreat)<=21), cluster(statefips)
reg merchants_all doesOpen afterEvent isOpen if (abs(timeToTreat)<=14), cluster(statefips)
reg merchants_all doesOpen afterEvent isOpen if (abs(timeToTreat)<=21), cluster(statefips)
reg gps_away_from_home doesOpen afterEvent isOpen if (abs(timeToTreat)<=14), cluster(statefips)
reg gps_away_from_home doesOpen afterEvent isOpen if (abs(timeToTreat)<=21), cluster(statefips)

*Run Graphing Scripts*
run "Scripts/Extension/Processing/IntermediateProcessing_E1.do"
run "Scripts/Extension/Processing/IntermediateProcessing_E2_F1.do" 1
run "Scripts/Extension/Processing/IntermediateProcessing_E2_F2.do" 1
run "Scripts/Extension/Processing/IntermediateProcessing_E2_F3.do" 1
run "Scripts/Extension/Processing/AppendProcessing_F.do"

*Create Relevant Graphs*
collapse spend_all emp merchants_all gps_away_from_home, by(timeToTreat doesOpen)
qui graph twoway line spend_all timeToTreat if (doesOpen==0 & timeToTreat < 40) || line spend_all timeToTreat if (doesOpen==1 & timeToTreat < 40), sort xlab(-70(10)40) name(cs_F,replace) nodraw xline(0) legend(off)
qui graph twoway line emp timeToTreat if (doesOpen==0 & timeToTreat < 40) || line emp timeToTreat if (doesOpen==1 & timeToTreat < 40), sort xlab(-70(10)40) name(emp_F,replace) nodraw xline(0) legend(off)
qui graph twoway line merchants_all timeToTreat if (doesOpen==0 & timeToTreat < 40) || line merchants_all timeToTreat if (doesOpen==1 & timeToTreat < 40), sort xlab(-70(10)40) name(sb_F,replace) nodraw xline(0) legend(off)
qui graph twoway line gps_away_from_home timeToTreat if (doesOpen==0 & timeToTreat < 40) || line gps_away_from_home timeToTreat if (doesOpen==1 & timeToTreat < 40), sort xlab(-70(10)40) name(mob_F,replace) nodraw xline(0) legend(off)
qui graph combine cs_F emp_F sb_F mob_F, name(foodGraph, replace)
