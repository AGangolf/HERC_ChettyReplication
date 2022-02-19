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
import delimited "Data/ConsumerSpending/InputData/Affinity - State - Daily.csv"

*Reformat Date Variable*
gen date = mdy(month,day,year)
format date %td
order date, first

*Drop Unnecessary Columns*
keep date statefips spend_all

*Drop Unnecessary Dates*
keep if (date>mdy(02,23,2020) & date<mdy(07,02,2020))

*Save Modified Dataset*
save Data/Extension/InputData/cleanConsumerSpending.dta, replace
