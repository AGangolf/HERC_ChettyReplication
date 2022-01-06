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
use "Data/IntermediateData/intermediate1_C1.dta"

*Converts date into a Stata readable format*
generate date = mdy(month, day, year)
format date %td

*Specifies Control Date
gen stateofinterest = 1

*Generates standarized event study variable giving time relative to reopening policy
gen timeToTreat = date-td(20apr2020)

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

*Shifts % Change (Annais)
*sort statefips timeToTreat
*gen pChangeNew = .
*local j = 1
*foreach i in "1" "2" "4" "5" "6" "8" "9" "10" "11" "12" "13" "15" "16" "17" "18" "19" "20" "21" "22" "23" "24" "25" "26" "27" "28" "29" "30" "31" "32" "33" "34" "35" "36" "37" "38" "39" "40" "41" "42" "44" "45" "46" "47" "48" "49" "50" "51" "53" "54" "55" "56"{
*replace pChangeNew = spend_all[_n] - spend_all[`j'] if statefips == `i'
*local j = `j' + 121
*}

*Save Modified Dataset*
save Data/IntermediateData/intermediate2_C1.dta, replace
