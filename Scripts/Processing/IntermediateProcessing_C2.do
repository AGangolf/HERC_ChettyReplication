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
use "Data/IntermediateData/intermediate1_C2.dta"

*Converts date into a Stata readable format*
generate date = mdy(month, day, year)
format date %td

*Specifies Control Date
gen stateofinterest = 2

*Generates standarized event study variable giving time relative to reopening policy
gen timeToTreat = date-td(24apr2020)

*Drops redundant date vars
drop year
drop month
drop day

*Normalizes % Change Vals in spend_all_norm
gen spend_all_norm = spend_all
gen id = _n
forvalues j = 1(1)51 {
	local temp = spend_all_norm[`j']
	replace spend_all_norm = 0 if id == `j'
	forvalues i = `j'(51)6171 {
		replace spend_all_norm = spend_all_norm - `temp' if (id == `i' & `i' != `j')
	}
}
drop id

*Save Modified Dataset*
save Data/IntermediateData/intermediate2_C2.dta, replace
