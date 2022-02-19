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
use "Data/Reopening/IntermediateData/intermediate_2.dta"

*Restrict Date Range*
drop if date==mdy(07,01,2020)

*Merge Datasets*
merge 1:1 date statefips using Data/NYTCrossVerification/IntermediateData/intermediate_V1.dta
drop _merge

*Save Modified Dataset*
save Data/NYTCrossVerification/AnalysisData/analysis.dta, replace

