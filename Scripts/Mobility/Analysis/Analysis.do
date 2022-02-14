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
use "Data/Mobility/AnalysisData/analysis_GM.dta"

*Installs Needed Programs*
ssc install eventdd, replace
ssc install matsort, replace

*Running regression for a 4(2+2) week window
reg gps_away_from_home doesOpen afterEvent isOpened if (timeToTreat<15 & timeToTreat>-15), cluster(statefips)

*Running regression for a 6(3+3) week window
reg gps_away_from_home doesOpen afterEvent isOpened if (timeToTreat<22 & timeToTreat>-22), cluster(statefips)

collapse gps_away_from_home, by(doesOpen timeToTreat)
gen afterEvent = 0
replace afterEvent = 1 if timeToTreat>-1
gen isOpened = 0
replace isOpened = 1 if (doesOpen==1 & afterEvent==1)
twoway connected gps_away_from_home timeToTreat if (doesOpen==0 & timeToTreat<21), sort || connected gps_away_from_home timeToTreat if (doesOpen==1 & timeToTreat<21), sort


