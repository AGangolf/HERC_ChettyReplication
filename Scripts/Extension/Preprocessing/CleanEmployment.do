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
import delimited "Data/Employment/InputData/Employment Combined - State - Daily.csv"

*Reformat Date Variable*
gen date = mdy(month,day,year)
format date %td
order date, first

*Drop Unnecessary Columns*
ren emp_combined emp
*ren emp_combined_inclow emp_incq1
*ren emp_combined_inchigh emp_incq4
*keep date statefips emp emp_incq1 emp_incq4
keep date statefips emp

*Drop Unnecessary Dates*
keep if (date>mdy(02,23,2020) & date<mdy(07,02,2020))

*Save Modified Dataset*
save Data/Extension/InputData/cleanEmployment.dta, replace
