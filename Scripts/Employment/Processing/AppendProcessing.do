/************************************************
************************************************
Before running the following file:

	-Designate the ChettyProject/ as the working directory
	
	-Lines coded in green with asterisks with specific pathways shown as examples
	rather than functional pathways for all users 
	
************************************************
************************************************/

clear
set more off


*Selects All Intermediate Data*
use "Data/IntermediateData/intermediate2_C1.dta"
use "Data/IntermediateData/intermediate2_C2.dta"
use "Data/IntermediateData/intermediate2_C3.dta"

*Appends All Data to Create One Set*
append using "Data/IntermediateData/intermediate2_C1.dta"
append using "Data/IntermediateData/intermediate2_C2.dta"

sort stateofinterest

*Save Modified Dataset*
save Data/AnalysisData/analysis.dta, replace