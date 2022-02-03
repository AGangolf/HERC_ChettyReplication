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
use "Data/Employment/AnalysisData/analysis.dta"

*Runs Relevant Regressions
reg emp doesOpen afterEvent isOpen if (timeToTreat<22 & timeToTreat>-22), cluster(statefips)
reg emp_incq1 doesOpen afterEvent isOpen if (timeToTreat<15 & timeToTreat>-15), cluster(statefips)
reg emp_incq4 doesOpen afterEvent isOpen if (timeToTreat<15 & timeToTreat>-15), cluster(statefips)

*Cleans Data for Graphing
collapse emp, by(doesOpen timeToTreat)
drop if (timeToTreat>21 | timeToTreat<-90)

*Graphs Data
twoway connected emp timeToTreat if doesOpen==0, sort xlab(-80(10)20) || connected emp timeToTreat if doesOpen==1, sort xlab(-80(10)20)

