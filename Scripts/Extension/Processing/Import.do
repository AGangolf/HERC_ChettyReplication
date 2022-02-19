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

*Import Initial Dataset*
use "Data/Extension/InputData/cleanConsumerSpending.dta"

*Merge Datasets*
merge 1:1 date statefips using "Data/Extension/InputData/cleanEmployment.dta"
drop _merge
merge 1:1 date statefips using "Data/Extension/InputData/cleanSB.dta"
drop _merge
merge 1:1 date statefips using "Data/Extension/InputData/cleanMobility.dta"
drop _merge
merge 1:1 date statefips using "Data/Extension/InputData/cleanReopening.dta"
drop _merge

*Save Modified Dataset*
save Data/Extension/IntermediateData/intermediate_E1.dta, replace

