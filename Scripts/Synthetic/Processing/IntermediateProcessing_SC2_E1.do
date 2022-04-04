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
gen dateOfInterest = mdy(04,24,2020)
order dateOfInterest, after(date)
format dateOfInterest %td
local dOI = dateOfInterest[1]

*Set State(s) of Interest*
levelsof statefips if inlist(statefips, 13), clean separate(,) local(treatStates)

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
local treatState = 101
collapse statefips spend_all emp merchants_all gps_away_from_home, by(doesOpen date)
replace statefips=`treatState' if doesOpen==1
drop doesOpen
sort date statefips

*Create Synthetic Controls*
tsset statefips date
ren gps_away_from_home gps
synth spend_all spend_all(`startDate'(1)`dOI'), trunit(`treatState') trperiod(`dOI') keep(~/Projects/HERC_ChettyReplication/Data/Synthetic/IntermediateData/intermediate_SC3_E1_SPEND.dta) replace
synth emp emp(`startDate'(1)`dOI'), trunit(`treatState') trperiod(`dOI') keep(~/Projects/HERC_ChettyReplication/Data/Synthetic/IntermediateData/intermediate_SC3_E1_EMP.dta) replace
synth merchants_all merchants_all(`startDate'(1)`dOI'), trunit(`treatState') trperiod(`dOI') keep(~/Projects/HERC_ChettyReplication/Data/Synthetic/IntermediateData/intermediate_SC3_E1_MOB.dta) replace
synth gps gps(`startDate'(1)`dOI'), trunit(`treatState') trperiod(`dOI') keep(~/Projects/HERC_ChettyReplication/Data/Synthetic/IntermediateData/intermediate_SC3_E1_GPS.dta) replace

*Reshape Synthetic Control Data*
use "Data/Synthetic/IntermediateData/intermediate_SC3_E1_SPEND.dta", clear
drop _Co_Number _W_Weight
ren _Y_treated spend_all1
ren _Y_synthetic spend_all0
reshape long spend_all, i(_time) j(doesOpen)
save Data/Synthetic/IntermediateData/intermediate_SC3_E1_SPEND.dta, replace

use "Data/Synthetic/IntermediateData/intermediate_SC3_E1_EMP.dta", clear
drop _Co_Number _W_Weight
ren _Y_treated emp1
ren _Y_synthetic emp0
reshape long emp, i(_time) j(doesOpen)
save Data/Synthetic/IntermediateData/intermediate_SC3_E1_EMP.dta, replace

use "Data/Synthetic/IntermediateData/intermediate_SC3_E1_MOB.dta", clear
drop _Co_Number _W_Weight
ren _Y_treated merchants_all1
ren _Y_synthetic merchants_all0
reshape long merchants_all, i(_time) j(doesOpen)
save Data/Synthetic/IntermediateData/intermediate_SC3_E1_MOB.dta, replace

use "Data/Synthetic/IntermediateData/intermediate_SC3_E1_GPS.dta", clear
drop _Co_Number _W_Weight
ren _Y_treated gps1
ren _Y_synthetic gps0
reshape long gps, i(_time) j(doesOpen)
save Data/Synthetic/IntermediateData/intermediate_SC3_E1_GPS.dta, replace

*Merge*
use "Data/Synthetic/IntermediateData/intermediate_SC3_E1_SPEND.dta", clear
merge 1:1 _time doesOpen using "Data/Synthetic/IntermediateData/intermediate_SC3_E1_EMP.dta"
drop _merge
merge 1:1 _time doesOpen using "Data/Synthetic/IntermediateData/intermediate_SC3_E1_MOB.dta"
drop _merge
merge 1:1 _time doesOpen using "Data/Synthetic/IntermediateData/intermediate_SC3_E1_GPS.dta"
drop _merge
ren _time date
format date %td
keep date doesOpen spend_all emp merchants_all gps
order date, before(spend_all)
order doesOpen, after(gps)
gen dateOfInterest=`dOI'
order dateOfInterest, after(date)
format dateOfInterest %td

*Define Indicator Variables*
gen afterEvent=0
replace afterEvent=1 if date>=dateOfInterest
gen isOpen=0
replace isOpen=1 if (doesOpen==1 & afterEvent==1)

*Save Modified Dataset*
save Data/Synthetic/IntermediateData/intermediate_SC3_E1.dta, replace

*Run Regressions and Save Matrix Outputs*
reg spend_all doesOpen afterEvent isOpen if (abs(date-dateOfInterest)<=14)
matrix E1_SPEND_2 = r(table)
reg spend_all doesOpen afterEvent isOpen if (abs(date-dateOfInterest)<=21)
matrix E1_SPEND_3 = r(table)
reg emp doesOpen afterEvent isOpen if (abs(date-dateOfInterest)<=14)
matrix E1_EMP_2 = r(table)
reg emp doesOpen afterEvent isOpen if (abs(date-dateOfInterest)<=21)
matrix E1_EMP_3 = r(table)
reg merchants_all doesOpen afterEvent isOpen if (abs(date-dateOfInterest)<=14)
matrix E1_MOB_2 = r(table)
reg merchants_all doesOpen afterEvent isOpen if (abs(date-dateOfInterest)<=21)
matrix E1_MOB_3 = r(table)
reg gps doesOpen afterEvent isOpen if (abs(date-dateOfInterest)<=14)
matrix E1_GPS_2 = r(table)
reg gps doesOpen afterEvent isOpen if (abs(date-dateOfInterest)<=21)
matrix E1_GPS_3 = r(table)

