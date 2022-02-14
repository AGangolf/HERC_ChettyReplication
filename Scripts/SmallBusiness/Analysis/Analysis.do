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
use "Data/SmallBusiness/AnalysisData/analysis.dta"

reg merchants_all doesOpen afterEvent isOpened if (timeToTreat<21 & timeToTreat>-21), cluster(statefips)

/*collapse merchants_all, by(doesOpen timeToTreat)
gen afterEvent = 0
replace afterEvent = 1 if timeToTreat>-1
gen isOpened = 0
replace isOpened = 1 if (doesOpen==1 & afterEvent==1)
reg merchants_all doesOpen afterEvent isOpened if !(abs(timeToTreat)>14)
twoway connected merchants_all timeToTreat if (doesOpen==0 & timeToTreat<21), sort || connected merchants_all timeToTreat if (doesOpen==1 & timeToTreat<21), sort
