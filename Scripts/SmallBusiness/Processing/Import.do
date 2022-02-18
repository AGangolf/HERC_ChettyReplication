/************************************************
Before running the following file:

	-Download in .csv format the Womply - State - Daily dataset following the instructions in
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
import delimited "Data/SmallBusiness/InputData/Womply - State - Daily.csv"

*Drops Irrelevant Columns*
drop revenue_all
drop revenue_inchigh
drop revenue_inclow
drop revenue_incmiddle
drop revenue_ss40
drop revenue_ss60
drop revenue_ss65
drop revenue_ss70
drop revenue_food_accommodation
drop revenue_retail
drop merchants_inchigh
drop merchants_inclow
drop merchants_incmiddle
drop merchants_ss40
drop merchants_ss60
drop merchants_ss65
drop merchants_ss70
drop merchants_food_accommodation
drop merchants_retail

*Keeps only Relevant Data Ranges*
keep if year == 2020

*keep if (month==1 & day>12) | month == 2 | month == 3 | month == 4 | month == 5
keep if (month==1 & day>25) | month == 2 | month == 3 | month == 4 | month == 5

*Saves all intermediate files
save Data/SmallBusiness/IntermediateData/intermediate1_C1.dta, replace
save Data/SmallBusiness/IntermediateData/intermediate1_C2.dta, replace
save Data/SmallBusiness/IntermediateData/intermediate1_C3.dta, replace
