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
import delimited "Data/Employment/InputData/Employment - State - Daily.csv"

*Drops Irrelevant Columns*
drop emp_incq2 emp_incq3 emp_incmiddle emp_incbelowmed emp_incabovemed emp_ss40 emp_ss60 emp_ss65 emp_ss70

*Keeps only Relevant Data Ranges*
keep if year == 2020
keep if (month==1 & day>25) | month == 2 | month == 3 | month == 4 | month == 5

*Save Modified Dataset*
save Data/Employment/IntermediateData/intermediate1_C1.dta, replace
save Data/Employment/IntermediateData/intermediate1_C2.dta, replace
save Data/Employment/IntermediateData/intermediate1_C3.dta, replace

