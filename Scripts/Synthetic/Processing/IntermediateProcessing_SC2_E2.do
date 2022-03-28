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

*Set Parameter if Not Passed*
capture confirm variable `1'
if _rc==198 {
	display `1'
}
else {
	local 1 = 0
	display `1'
}

*Import Dataset*
use "Data/Synthetic/IntermediateData/intermediate_SC2.dta"

*Set Start Date*
local startDate = mdy(03,30,2020)

*Set Reopening Date of Interest*
gen dateOfInterest = mdy(05,01,2020)
order dateOfInterest, after(date)
format dateOfInterest %td
local dOI = dateOfInterest[1]

*Set State(s) of Interest*
levelsof statefips if inlist(statefips,19,38,48), clean separate(,) local(treatStates)

*Remove control states which reopened the same sector within three weeks of treatment*
drop if (!inlist(statefips, `treatStates') & date>=dateOfInterest & date<=dateOfInterest+21 & ent==1)
levelsof statefips if date==dateOfInterest+21, local(contList) clean separate(,)
gen keepState=0
replace keepState=1 if inlist(statefips, `contList')
drop if keepState==0

*Drop Unnecessary Vars*
keep date statefips spend_all emp merchants_all gps_away_from_home dateOfInterest

*Code Indicator Variables*
gen doesOpen = runiform()
replace doesOpen = 1 if inlist(statefips, `treatStates')

*Consolidate Treated States*
local treatState = 102
collapse statefips spend_all emp merchants_all gps_away_from_home, by(doesOpen date)
replace statefips=`treatState' if doesOpen==1
drop doesOpen
sort date statefips

*Create Synthetic Controls*
tsset statefips date
ren gps_away_from_home gps
synth spend_all spend_all(`startDate'(1)`dOI'), trunit(`treatState') trperiod(`dOI') keep(~/Projects/HERC_ChettyReplication/Data/Synthetic/IntermediateData/intermediate_SC3_E2_SPEND.dta) replace
synth emp emp(`startDate'(1)`dOI'), trunit(`treatState') trperiod(`dOI') keep(~/Projects/HERC_ChettyReplication/Data/Synthetic/IntermediateData/intermediate_SC3_E2_EMP.dta) replace
synth merchants_all merchants_all(`startDate'(1)`dOI'), trunit(`treatState') trperiod(`dOI') keep(~/Projects/HERC_ChettyReplication/Data/Synthetic/IntermediateData/intermediate_SC3_E2_MOB.dta) replace
synth gps gps(`startDate'(1)`dOI'), trunit(`treatState') trperiod(`dOI') keep(~/Projects/HERC_ChettyReplication/Data/Synthetic/IntermediateData/intermediate_SC3_E2_GPS.dta) replace

*Merge Synthetic Controls*
use "Data/Synthetic/IntermediateData/intermediate_SC3_E2_SPEND.dta", clear
ren _Y_treated spend_all_treated
ren _Y_synthetic spend_all_synthetic
merge 1:1 _time using "Data/Synthetic/IntermediateData/intermediate_SC3_E2_EMP.dta"
drop _merge
ren _Y_treated emp_treated
ren _Y_synthetic emp_synthetic
merge 1:1 _time using "Data/Synthetic/IntermediateData/intermediate_SC3_E2_MOB.dta"
drop _merge
ren _Y_treated merchants_all_treated
ren _Y_synthetic merchants_all_synthetic
merge 1:1 _time using "Data/Synthetic/IntermediateData/intermediate_SC3_E2_GPS.dta"
drop _merge
ren _Y_treated gps_treated
ren _Y_synthetic gps_synthetic
ren _time date
format date %td
keep date spend_all_treated spend_all_synthetic emp_treated emp_synthetic merchants_all_treated merchants_all_synthetic gps_treated gps_synthetic
order date, before(spend_all_treated)
gen dateOfInterest=`dOI'
order dateOfInterest, after(date)

*Save Modified Dataset*
save Data/Synthetic/IntermediateData/intermediate_SC3_E2.dta, replace
