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
import delimited "Data/Reopening/InputData/nyt_reopening_data.csv"

*Reformat Date Variable to ISO*
gen year = floor(timestamp*10^(-10))
gen month = mod(floor(timestamp*10^(-8)),10^2)
gen day = mod(floor(timestamp*10^(-6)),10^2)
gen date = mdy(month, day, year)
format date %td
drop year month day

*Reformat State Variable to FIPS*
gen statefips = 0
replace statefips = 1 if state=="Alabama"
replace statefips = 2 if state=="Alaska"
replace statefips = 4 if state=="Arizona"
replace statefips = 5 if state=="Arkansas"
replace statefips = 6 if state=="California"
replace statefips = 8 if state=="Colorado"
replace statefips = 9 if state=="Connecticut"
replace statefips = 10 if state=="Delaware"
replace statefips = 11 if state=="District of Columbia"
replace statefips = 12 if state=="Florida"
replace statefips = 13 if state=="Georgia"
replace statefips = 15 if state=="Hawaii"
replace statefips = 16 if state=="Idaho"
replace statefips = 17 if state=="Illinois"
replace statefips = 18 if state=="Indiana"
replace statefips = 19 if state=="Iowa"
replace statefips = 20 if state=="Kansas"
replace statefips = 21 if state=="Kentucky"
replace statefips = 22 if state=="Louisiana"
replace statefips = 23 if state=="Maine"
replace statefips = 24 if state=="Maryland"
replace statefips = 25 if state=="Massachusetts"
replace statefips = 26 if state=="Michigan"
replace statefips = 27 if state=="Minnesota"
replace statefips = 28 if state=="Mississippi"
replace statefips = 29 if state=="Missouri"
replace statefips = 30 if state=="Montana"
replace statefips = 31 if state=="Nebraska"
replace statefips = 32 if state=="Nevada"
replace statefips = 33 if state=="New Hampshire"
replace statefips = 34 if state=="New Jersey"
replace statefips = 35 if state=="New Mexico"
replace statefips = 36 if state=="New York"
replace statefips = 37 if state=="North Carolina"
replace statefips = 38 if state=="North Dakota"
replace statefips = 39 if state=="Ohio"
replace statefips = 40 if state=="Oklahoma"
replace statefips = 41 if state=="Oregon"
replace statefips = 42 if state=="Pennsylvania"
replace statefips = 44 if state=="Rhode Island"
replace statefips = 45 if state=="South Carolina"
replace statefips = 46 if state=="South Dakota"
replace statefips = 47 if state=="Tennessee"
replace statefips = 48 if state=="Texas"
replace statefips = 49 if state=="Utah"
replace statefips = 50 if state=="Vermont"
replace statefips = 51 if state=="Virginia"
replace statefips = 53 if state=="Washington"
replace statefips = 54 if state=="West Virginia"
replace statefips = 55 if state=="Wisconsin"
replace statefips = 56 if state=="Wyoming"

*Remove Non-State Territories*
drop if statefips==0

*Save Modified Dataset*
save Data/Reopening/IntermediateData/intermediate_1.dta, replace
