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
import delimited "Data/Mobility/InputData/Google Mobility - State - Daily.csv"

*Drops Irrelevant Columns*
keep year month day statefips gps_away_from_home

*Keeps only Relevant Data Ranges*
keep if year == 2020
keep if (month==1 & day>25) | month == 2 | month == 3 | month == 4 | month == 5

*Save Modified Dataset*
save Data/Mobility/IntermediateData/intermediate1_GM1.dta, replace
save Data/Mobility/IntermediateData/intermediate1_GM2.dta, replace
save Data/Mobility/IntermediateData/intermediate1_GM3.dta, replace

