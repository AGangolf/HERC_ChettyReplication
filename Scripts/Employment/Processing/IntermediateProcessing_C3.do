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
use "Data/Employment/IntermediateData/intermediate1_C3.dta"

*Converts date into a Stata readable format*
generate date = mdy(month, day, year)
format date %td

*Converts data to weekly w/ mean
gen sundays = (date - dow(date-1))+6
collapse emp emp_incq1 emp_incq4, by(sundays statefips)
format sundays %td

/*Converts data to weekly w/out mean
gen weekday = dow(date)
drop if weekday!=0
gen sundays = date
format sundays %td
drop date
drop weekday
drop year
drop month
drop day
drop freq*/

*Specifies Control Date
gen stateofinterest = 3

*Generates standarized event study variable giving time relative to reopening policy
gen timeToTreat = sundays-td(27apr2020)

*Drops non-treatment and non-control states
drop if !(statefips==6 | statefips==9 | statefips==10 | statefips==11 | statefips==17 |  statefips==24 |  statefips==31 | statefips==35 | statefips==46 | statefips==51 | statefips==53 | statefips==55 | statefips==27 | statefips==28)

*Codes in treatment and interaction variables
gen doesOpen = 0
replace doesOpen = 1 if (statefips==27 | statefips==28)
gen afterEvent = 0
replace afterEvent = 1 if timeToTreat>-1
gen isOpen = 0
replace isOpen = 1 if ((statefips==27 | statefips==28) & timeToTreat>-1)

*Save Modified Dataset*
save Data/Employment/IntermediateData/intermediate2_C3.dta, replace
