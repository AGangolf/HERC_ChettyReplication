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

*Set Parameter if Not Passed*
capture confirm variable `1'
if _rc==198 {
	display `1'
}
else {
	local 1 = 0
	display `1'
}

*Import Dataset*
use "Data/Extension/IntermediateData/intermediate_E2.dta"

*Reopening Date of Interest is 05/01/20*
gen dateOfInterest = mdy(05,01,2020)
order dateOfInterest, after(date)
format dateOfInterest %td

*Convert to Weekly Data According to Parameter Reg (0) or Graph (1)*
gen dow = dow(date)
if (`1'==1) {
	drop if dow!=dow(dateOfInterest)-1
}
else {
	drop if dow!=0
}

*Drop Unnecessary Vars*
keep date statefips spend_all emp merchants_all gps_away_from_home dateOfInterest

*Remove Non-treatment and Non-control States*
drop if statefips==30

*Code Event-study Variable*
gen timeToTreat = date - dateOfInterest

*Code Indicator Variables*
gen doesOpen = 0
replace doesOpen = 1 if (statefips==16 | statefips==40)
gen afterEvent = 0
replace afterEvent = 1 if timeToTreat>0
gen isOpen = 0
replace isOpen = 1 if (doesOpen==1 & afterEvent==1)

*Save Modified Dataset*
save Data/Extension/IntermediateData/intermediate_E3_W2.dta, replace
