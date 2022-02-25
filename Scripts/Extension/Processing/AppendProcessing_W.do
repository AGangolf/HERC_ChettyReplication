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
use "Data/Extension/IntermediateData/intermediate_E3_W1.dta"

*Append Datasets*
append using "Data/Extension/IntermediateData/intermediate_E3_W2.dta"
append using "Data/Extension/IntermediateData/intermediate_E3_W3.dta"

*Save Modified Dataset*
save Data/Extension/AnalysisData/analysis_W.dta, replace
