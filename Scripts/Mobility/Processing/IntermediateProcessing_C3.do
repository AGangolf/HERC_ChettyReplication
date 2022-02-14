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
use "Data/Mobility/IntermediateData/intermediate1_GM3.dta"

*Converts date into a Stata readable format*
generate date = mdy(month, day, year)
format date %td

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

*Specifies Control Date
gen stateofinterest = 3

*Generates standarized event study variable giving time relative to reopening policy
gen timeToTreat = sundays-td(27apr2020)

drop if timeToTreat<-90

*Drops non-treatment and non-control states
drop if !(statefips==10| statefips==17| statefips==31| statefips==35| statefips==42| statefips==46| statefips==51| statefips==55 | statefips==27 | statefips==28)

*Codes in treatment and interaction variables
gen doesOpen = 0
replace doesOpen = 1 if (statefips==27 | statefips==28)
gen afterEvent = 0
replace afterEvent = 1 if timeToTreat>-1
gen isOpened = 0
replace isOpened = 1 if ((statefips==27 | statefips==28) & timeToTreat>-1)

*Save Modified Dataset*
save Data/Mobility/IntermediateData/intermediate2_GM3.dta, replace
