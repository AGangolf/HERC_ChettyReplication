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

*Import Original Dataset*
use "Data/Reopening/AnalysisData/analysis.dta"

*Drop Unnecessary Dates*
keep if (date>mdy(02,23,2020) & date<=mdy(12,31,2020))

*Re-Sort to Match Standard*
sort date statefips

*Save Modified Dataset*
save Data/Extension/InputData/cleanReopening.dta, replace
