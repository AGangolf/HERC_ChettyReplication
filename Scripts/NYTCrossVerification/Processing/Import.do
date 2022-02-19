/************************************************
Before running the following file:

	-Download in .csv format the Affinity - Country - Data dataset following the instructions in
	ReadMe.pdf
	
	-Designate the ChettyProject/ as the working directory
	
	-Lines coded in green with asterisks with specific pathways shown as examples
	rather than functional pathways for all users 
	
************************************************
************************************************/

*Uncomment and modify the following line of code to change working dir
cd ~/Projects/HERC_ChettyReplication

clear
set more off

*Import Original Dataset*
use "Data/NYTCrossVerification/InputData/reopening.dta"

*Recode Date and Delete Vars*
tostring date, replace format(%20.0f)
drop v1
gen newDate = date(date, "YMD")
format newDate %td
drop date
ren newDate date
order date, first

*Reformat State Variable to FIPS*
gen statefips = 0
replace statefips = 1 if state=="AL"
replace statefips = 2 if state=="AK"
replace statefips = 4 if state=="AZ"
replace statefips = 5 if state=="AR"
replace statefips = 6 if state=="CA"
replace statefips = 8 if state=="CO"
replace statefips = 9 if state=="CT"
replace statefips = 10 if state=="DE"
replace statefips = 11 if state=="DC"
replace statefips = 12 if state=="FL"
replace statefips = 13 if state=="GA"
replace statefips = 15 if state=="HI"
replace statefips = 16 if state=="ID"
replace statefips = 17 if state=="IL"
replace statefips = 18 if state=="IN"
replace statefips = 19 if state=="IA"
replace statefips = 20 if state=="KS"
replace statefips = 21 if state=="KY"
replace statefips = 22 if state=="LA"
replace statefips = 23 if state=="ME"
replace statefips = 24 if state=="MD"
replace statefips = 25 if state=="MA"
replace statefips = 26 if state=="MI"
replace statefips = 27 if state=="MN"
replace statefips = 28 if state=="MS"
replace statefips = 29 if state=="MO"
replace statefips = 30 if state=="MT"
replace statefips = 31 if state=="NE"
replace statefips = 32 if state=="NV"
replace statefips = 33 if state=="NH"
replace statefips = 34 if state=="NJ"
replace statefips = 35 if state=="NM"
replace statefips = 36 if state=="NY"
replace statefips = 37 if state=="NC"
replace statefips = 38 if state=="ND"
replace statefips = 39 if state=="OH"
replace statefips = 40 if state=="OK"
replace statefips = 41 if state=="OR"
replace statefips = 42 if state=="PA"
replace statefips = 44 if state=="RI"
replace statefips = 45 if state=="SC"
replace statefips = 46 if state=="SD"
replace statefips = 47 if state=="TN"
replace statefips = 48 if state=="TX"
replace statefips = 49 if state=="UT"
replace statefips = 50 if state=="VT"
replace statefips = 51 if state=="VA"
replace statefips = 53 if state=="WA"
replace statefips = 54 if state=="WV"
replace statefips = 55 if state=="WI"
replace statefips = 56 if state=="WY"

*Remove Non-State Territories*
drop if statefips==0

*Delete Vars*
drop state
order statefips, after(date)

*Rename Indicators*
ren outdoorandrecreation d_recreation
ren foodanddrink d_food
ren entertainment d_ent
ren housesofworship d_worship
ren industries d_industry
ren personalcare d_pcare
drop medical
ren ret d_retail

*Save Modified Dataset*
save Data/NYTCrossVerification/IntermediateData/intermediate_V1.dta, replace

