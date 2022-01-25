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
use "Data/ConsumerSpending/IntermediateData/intermediate1_C3.dta"

*Converts date into a Stata readable format*
generate date = mdy(month, day, year)
format date %td

*Converts data to weekly w/ mean
/*en sundays = (date - dow(date-1))+6
collapse spend_all, by(sundays statefips)
format sundays %td*/

*Converts data to weekly w/out mean
gen weekday = dow(date)
drop if weekday!=0
gen sundays = date
format sundays %td
drop date
drop weekday
drop year
drop month
drop day
drop freq

*Specifies Control Date
gen stateofinterest = 3

*Generates standarized event study variable giving time relative to reopening policy
gen timeToTreat = sundays-td(27apr2020)

*Normalizes % Change Vals in spend_all_norm
gen spend_all_norm = spend_all
gen id = _n-51
forvalues j = 1(1)51 {
	local temp = spend_all_norm[`j']
	replace spend_all_norm = 0 if id == `j'
	forvalues i = `j'(51)969 {
		replace spend_all_norm = spend_all - `temp' if (id == `i' & `i' != `j')
	}
}
drop id
drop if timeToTreat<-90

*Drops non-treatment and non-control states
drop if !(statefips==17 | statefips==31 | statefips==34 | statefips==42 | statefips==51 | statefips==27 | statefips==28)

*Codes in treatment and interaction variables
gen opener = 0
replace opener = 1 if (statefips==27 | statefips==28)
gen openTime = 0
replace openTime = 1 if timeToTreat>-1
gen reopened = 0
replace reopened = 1 if ((statefips==27 | statefips==28) & timeToTreat>-1)

*Takes treatment and control 
/*
collapse spend_all spend_all_norm, by(sundays opener)
gen stateofinterest = 3
gen timeToTreat = sundays-td(27apr2020)
gen openTime = 0
replace openTime = 1 if timeToTreat>-1
gen reopened = 0
replace reopened = 1 if (opener==1 & openTime==1)*/

*Save Modified Dataset*
save Data/ConsumerSpending/IntermediateData/intermediate2_C3.dta, replace
