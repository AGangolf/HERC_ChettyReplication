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
use "Data/Employment/IntermediateData/intermediate1_C2.dta"

*Converts date into a Stata readable format*
generate date = mdy(month, day, year)
format date %td

*Converts data to weekly w/ mean
gen sundays = (date - dow(date-1))+6+4
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
gen stateofinterest = 2

*Generates standarized event study variable giving time relative to reopening policy
gen timeToTreat = sundays-td(24apr2020)

*Drops non-treatment and non-control states
drop if !(statefips==6 | statefips==9 | statefips==10 | statefips==11 | statefips==12 | statefips==17 | statefips==18 | statefips==22 | statefips==24 | statefips==29 | statefips==31 | statefips==35 | statefips==42 | statefips==46 | statefips==51 | statefips==53 | statefips==55 | statefips==2 | statefips==13)

*Codes in treatment and interaction variables
gen doesOpen = 0
replace doesOpen = 1 if (statefips==2 | statefips==13)
gen afterEvent = 0
replace afterEvent = 1 if timeToTreat>-1
gen isOpen = 0
replace isOpen = 1 if ((statefips==2 | statefips==13) & timeToTreat>-1)

*Save Modified Dataset*
save Data/Employment/IntermediateData/intermediate2_C2.dta, replace
