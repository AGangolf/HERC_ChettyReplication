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


*Select Intermediate Data*
use "Data/IntermediateData/intermediate1_C3.dta"

*Converts date into a Stata readable format*
generate date = mdy(month, day, year)
format date %td

*Specifies Control Date
gen stateofinterest = 3

*Generates standarized event study variable giving time relative to reopening policy
gen timeToTreat = date-td(27apr2020)

*Save Modified Dataset*
save Data/IntermediateData/intermediate2_C3.dta, replace