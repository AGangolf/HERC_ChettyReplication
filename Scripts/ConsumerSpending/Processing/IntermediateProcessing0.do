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


*Select First Set of Intermediate Data*
use "Data/ConsumerSpending/IntermediateData/intermediate0_P1.dta"

*Remove non-January data
drop if !(month==1)

*Average January data
collapse spend_all, by(statefips)

*Restore original variables
gen freq = "m"
gen year=2020
gen month=1
gen day=1

append using "Data/ConsumerSpending/IntermediateData/intermediate0_P2.dta"

*Save Modified Dataset*
save Data/ConsumerSpending/IntermediateData/intermediate1_C1.dta, replace
save Data/ConsumerSpending/IntermediateData/intermediate1_C2.dta, replace
save Data/ConsumerSpending/IntermediateData/intermediate1_C3.dta, replace

