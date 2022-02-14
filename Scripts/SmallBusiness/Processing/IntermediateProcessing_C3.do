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
use "Data/SmallBusiness/IntermediateData/intermediate1_C3.dta"

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
drop if !(statefips==6 | statefips==9 | statefips==10 | statefips==11 | statefips==17 | statefips==24 | statefips==31 | statefips==35 | statefips==36 | statefips==42 | statefips==46 | statefips==51 | statefips==53 | statefips==55 | statefips==27 | statefips==28)

*Codes in treatment and interaction variables
gen doesOpen = 0
replace doesOpen = 1 if (statefips==27 | statefips==28)
gen afterEvent = 0
replace afterEvent = 1 if timeToTreat>-1
gen isOpened = 0
replace isOpened = 1 if ((statefips==27 | statefips==28) & timeToTreat>-1)

*Takes treatment and control 
/*collapse merchants_all, by(sundays opener)
gen stateofinterest = 3
gen timeToTreat = sundays-td(27apr2020)
gen openTime = 0
replace openTime = 1 if timeToTreat>-1
gen reopened = 0
replace reopened = 1 if (opener==1 & openTime==1)*/

*Save Modified Dataset*
save Data/SmallBusiness/IntermediateData/intermediate2_C3.dta, replace
