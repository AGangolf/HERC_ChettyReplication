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
use "Data/Mobility/IntermediateData/intermediate2_GM1.dta"
use "Data/Mobility/IntermediateData/intermediate2_GM2.dta"
use "Data/Mobility/IntermediateData/intermediate2_GM3.dta"

*Appends All Data to Create One Set*
append using "Data/Mobility/IntermediateData/intermediate2_GM1.dta"
append using "Data/Mobility/IntermediateData/intermediate2_GM2.dta"

sort stateofinterest

*Save Modified Dataset*
save Data/Mobility/AnalysisData/analysis_GM.dta, replace
