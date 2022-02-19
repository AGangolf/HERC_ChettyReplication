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

*Import Intermediate Dataset*
use "Data/Reopening/IntermediateData/intermediate_2.dta"

*Append Manually Generated Dataset*
append using "Data/Reopening/IntermediateData/intermediate_man.dta"

*Sort New Dataset*
sort statefips date

*Drop Medical Sector*
drop medical

*Save Modified Dataset*
save Data/Reopening/AnalysisData/analysis.dta, replace
