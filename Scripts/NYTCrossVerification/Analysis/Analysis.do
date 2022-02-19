/************************************************
Before running the following file:

	-Download in .csv format the Affinity - Country - Data dataset following the instructions in
	ReadMe.pdf
	
	-Designate the ChettyProject/ as the working directory
	
	-Lines coded in green with asterisks with specific pathways shown as examples
	rather than functional pathways for all users 
	
************************************************
************************************************/

*Uncomment and modify the following line of code to change working dir
cd ~/Projects/HERC_ChettyReplication

clear
set more off

*Import Original Dataset*
use "Data/NYTCrossVerification/AnalysisData/analysis.dta"

*Generate Indicators For Errenous Obs*
foreach v of varlist ent food worship industry recreation pcare retail {
	gen error_`v' = 0
	replace error_`v' = 1 if (`v'!= d_`v')
}

*Drop all Obs without any error*
gen any_error = 0
replace any_error = 1 if (error_ent == 1 | error_food == 1 | error_worship == 1 | error_industry == 1 | error_recreation == 1 | error_pcare == 1 | error_retail == 1)
drop if any_error==0

*Sort Errenous Obs by State x Date*
sort statefips date
