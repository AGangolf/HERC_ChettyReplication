/************************************************
************************************************
**# Bookmark #1
Before running the following file:

	-Designate the ChettyProject/ as the working directory
	
	-Lines coded in green with asterisks with specific pathways shown as examples
	rather than functional pathways for all users 
	
************************************************
************************************************/


clear
set more off 
use "Data/ConsumerSpending/AnalysisData/analysis.dta"

*Runs Relevant Regressions
reg spend_all doesOpen afterEvent isOpen if (timeToTreat<22 & timeToTreat>-23), cluster(statefips)

*Cleans Data for Graphing
collapse spend_all, by(doesOpen timeToTreat)
drop if (timeToTreat>21 | timeToTreat<-90)

*Graphs Data
twoway connected spend_all timeToTreat if doesOpen==0, sort xlab(-80(10)20) || connected spend_all timeToTreat if doesOpen==1, sort xlab(-80(10)20)

