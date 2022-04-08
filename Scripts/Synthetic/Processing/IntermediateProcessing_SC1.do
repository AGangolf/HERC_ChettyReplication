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
use "Data/Extension/IntermediateData/intermediate_E2.dta"

*Clean Dataset*
drop if date>`=mdy(09,01,2020)'

*Save Modified Dataset*
save Data/Synthetic/IntermediateData/intermediate_SC2.dta, replace

