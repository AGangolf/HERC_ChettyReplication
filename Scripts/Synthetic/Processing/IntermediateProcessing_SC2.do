/************************************************
	   Before running the following file:

	   -Download in .csv format the Affinity - Country - Data dataset following the instructions in
	   ReadMe.pdf

	   -Designate the ChettyProject/ as the working directory

	   -Lines coded in green with asterisks with specific pathways shown as examples
	   rather than functional pathways for all users 

	   ************************************************
   ************************************************/
   
*RUNFORMAT: do filename "sector" `=mdy(month,day,year)' weeksPrior weeksAfter elimCrit *

cd ~/Projects/HERC_ChettyReplication

clear
set more off

*Import Dataset*
use "Data/Synthetic/IntermediateData/intermediate_SC2.dta"

*Set Significance Level*
local alpha = 0.10

*Pass Sector Selection*
local sector = "`1'"

*Pass Reopening Date of Interest*
local dOI = `2'

*Pass Weeks Prior*
local startDate = `dOI'-`=`3'*7'

*Pass Weeks After*
local endDate = `dOI'+`=`4'*7'

*Pass Elim Criterion*
local elimCrit = `5'

*Determine Treated States*
levelsof statefips if (date==`2' & `sector'==1), clean separate(,) local(tempA)
levelsof statefips if (date==(`2'-1) & `sector'==1), clean separate(,) local(tempB)
keep if inlist(statefips, `tempA')
if "`tempB'" != "" {
	drop if inlist(statefips, `tempB')
}
levelsof statefips, clean separate(,) local(treatStates)

*Return to Dataset*
use "Data/Synthetic/IntermediateData/intermediate_SC2.dta", replace

*Set Reopening Date of Interest as Variable*
gen dateOfInterest = `dOI'
order dateOfInterest, after(date)
format dateOfInterest %td

*Set Reopening Date as String Local*
gen dOITemp = string(dateOfInterest, "%td")
local dOIString = dOITemp[1]
drop dOITemp

*Remove control states which reopened the same sector within elimCrit weeks of treatment*
if `elimCrit'!=0 {
	drop if (!inlist(statefips, `treatStates') & date>=dateOfInterest & date<=dateOfInterest+`=7*`elimCrit'' & `sector'==1)
	levelsof statefips if date==dateOfInterest+`=7*`elimCrit'', local(contList) clean separate(,)
	gen keepState=0
	replace keepState=1 if inlist(statefips, `contList')
	drop if keepState==0
}

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

*Variable For Least Statefips Value*
local firstState = statefips[1]

*Variable For Donor Pool Size*
levelsof statefips, clean separate(,) local(poolTemp)
local poolSize = strlen("`poolTemp'") - strlen(subinstr("`poolTemp'", ",", "", .))

*Save Reference Temp dta File*
save Data/Synthetic/IntermediateData/intermediate_SC3_temp.dta, replace


*Loop through every treated and control state*
levelsof statefips, local(statesToLoop)
foreach state of local statesToLoop {
	*Return to reference dta*
	use Data/Synthetic/IntermediateData/intermediate_SC3_temp.dta, replace

	*Create Synthetic Controls for each Outcome Var using this from Start Date through dOI as Predictor*
	*Each Synth Control is saved into its own dta*
	tsset statefips date
	ren gps_away_from_home gps
	synth spend_all spend_all(`startDate'(1)`dOI'), trunit(`state') trperiod(`dOI') resultsperiod(`startDate'(1)`endDate') keep(~/Projects/HERC_ChettyReplication/Data/Synthetic/IntermediateData/intermediate_SC3_`sector'`dOIString'_`state'_SPEND.dta) replace
	synth emp emp(`startDate'(1)`dOI'), trunit(`state') trperiod(`dOI') resultsperiod(`startDate'(1)`endDate') keep(~/Projects/HERC_ChettyReplication/Data/Synthetic/IntermediateData/intermediate_SC3_`sector'`dOIString'_`state'_EMP.dta) replace
	synth merchants_all merchants_all(`startDate'(1)`dOI'), trunit(`state') trperiod(`dOI') resultsperiod(`startDate'(1)`endDate') keep(~/Projects/HERC_ChettyReplication/Data/Synthetic/IntermediateData/intermediate_SC3_`sector'`dOIString'_`state'_MOB.dta) replace
	synth gps gps(`startDate'(1)`dOI'), trunit(`state') trperiod(`dOI') resultsperiod(`startDate'(1)`endDate') keep(~/Projects/HERC_ChettyReplication/Data/Synthetic/IntermediateData/intermediate_SC3_`sector'`dOIString'_`state'_GPS.dta) replace

	*SPENDALL: Reformat synth file and generate mean percentage change treatment effect under _est*
	use "Data/Synthetic/IntermediateData/intermediate_SC3_`sector'`dOIString'_`state'_SPEND.dta", clear
	ren _Y_treated spend_all_treated
	ren _Y_synthetic spend_all_synthetic
	gen spend_all_diff = spend_all_treated - spend_all_synthetic
	mean spend_all_diff if (_time>=`dOI' & _time<=`endDate')
	local spend_all_est_num = r(table)[1,1]
	mean spend_all_synthetic if (_time>=`dOI' & _time<=`endDate')
	local spend_all_est_den = abs(r(table)[1,1])
	gen spend_all_est = `spend_all_est_num' / `spend_all_est_den'

	*Merge spending file with employment*
	merge 1:1 _time using "Data/Synthetic/IntermediateData/intermediate_SC3_`sector'`dOIString'_`state'_EMP.dta"
	drop _merge

	*EMP: Reformat synth file and generate mean percentage change treatment effect under _est*
	ren _Y_treated emp_treated
	ren _Y_synthetic emp_synthetic
	gen emp_diff = emp_treated - emp_synthetic
	mean emp_diff if (_time>=`dOI' & _time<=`endDate')
	local emp_est_num = r(table)[1,1]
	mean emp_synthetic if (_time>=`dOI' & _time<=`endDate')
	local emp_est_den = abs(r(table)[1,1])
	gen emp_est = `emp_est_num' / `emp_est_den'

	*Merge spending & emp file with merchants_all*
	merge 1:1 _time using "Data/Synthetic/IntermediateData/intermediate_SC3_`sector'`dOIString'_`state'_MOB.dta"
	drop _merge

	*MERCHANTS: Reformat synth file and generate mean percentage change treatment effect under _est*
	ren _Y_treated merchants_all_treated
	ren _Y_synthetic merchants_all_synthetic
	gen merchants_all_diff = merchants_all_treated - merchants_all_synthetic
	mean merchants_all_diff if (_time>=`dOI' & _time<=`endDate')
	local merchants_all_est_num = r(table)[1,1]
	mean merchants_all_synthetic if (_time>=`dOI' & _time<=`endDate')
	local merchants_all_est_den = abs(r(table)[1,1])
	gen merchants_all_est = `merchants_all_est_num' / `merchants_all_est_den'

	*Merge existing file with gps*
	merge 1:1 _time using "Data/Synthetic/IntermediateData/intermediate_SC3_`sector'`dOIString'_`state'_GPS.dta"
	drop _merge

	*GPS: Reformat synth file and generate mean percentage change treatment effect under _est*
	ren _Y_treated gps_treated
	ren _Y_synthetic gps_synthetic
	gen gps_diff = gps_treated - gps_synthetic
	mean gps_diff if (_time>=`dOI' & _time<=`endDate')
	local gps_est_num = r(table)[1,1]
	mean gps_synthetic if (_time>=`dOI' & _time<=`endDate')
	local gps_est_den = abs(r(table)[1,1])
	gen gps_est = `gps_est_num' / `gps_est_den'

	*Cleanup final formatting*
	ren _time date
	format date %td
	keep date spend_all_treated spend_all_synthetic spend_all_diff spend_all_est emp_treated emp_synthetic emp_diff emp_est merchants_all_treated merchants_all_synthetic merchants_all_diff merchants_all_est gps_treated gps_synthetic gps_diff gps_est
	order date, before(spend_all_treated)
	gen dateOfInterest=`dOI'
	format dateOfInterest %td
	order dateOfInterest, after(date)
	gen treatedState = `state'
	order treatedState, before(dateOfInterest)

	*If this is first loop, save synths into orig dta*
	*Else, append new synths to orig dta*
	if(treatedState[1]==`firstState') {
		save Data/Synthetic/IntermediateData/intermediate_SC3_`sector'`dOIString'.dta, replace
	}
	else {
		append using "Data/Synthetic/IntermediateData/intermediate_SC3_`sector'`dOIString'.dta"
		save Data/Synthetic/IntermediateData/intermediate_SC3_`sector'`dOIString'.dta, replace
	}
}

*Consolidate Estimated Treatment Effect By State Treated*
sort treatedState date
collapse spend_all_est emp_est merchants_all_est gps_est, by(treatedState)

*Generate Percentile Ranks for each if the _est vars*
egen spend_all_rank = rank(spend_all_est)
gen spend_all_perc = spend_all_rank / (_N + 1)
drop spend_all_rank
egen emp_rank = rank(emp_est)
gen emp_perc = emp_rank / (_N + 1)
drop emp_rank
egen merchants_all_rank = rank(merchants_all_est)
gen merchants_all_perc = merchants_all_rank / (_N + 1)
drop merchants_all_rank
egen gps_rank = rank(gps_est)
gen gps_perc = gps_rank / (_N + 1)
drop gps_rank

*Generate Point-estimate & CI for SPENDALL*
save Data/Synthetic/IntermediateData/intermediate_SC3_`sector'`dOIString'.dta, replace
keep if treatedState==`treatState'
local center = spend_all_est[1]
use Data/Synthetic/IntermediateData/intermediate_SC3_`sector'`dOIString'.dta, replace
drop if (spend_all_perc>(1-(`alpha'/2)) | spend_all_perc<(`alpha'/2))
sort spend_all_perc
local upBound = spend_all_est[_N]
local lowBound = spend_all_est[1]
use Data/Synthetic/IntermediateData/intermediate_SC3_`sector'`dOIString'.dta, replace
gen spend_all_lower = `center' - abs(`upBound')
gen spend_all_upper = `center' + abs(`lowBound')

*Generate Point-estimate & CI for EMP*
save Data/Synthetic/IntermediateData/intermediate_SC3_`sector'`dOIString'.dta, replace
keep if treatedState==`treatState'
local center = emp_est[1]
use Data/Synthetic/IntermediateData/intermediate_SC3_`sector'`dOIString'.dta, replace
drop if (emp_perc>(1-(`alpha'/2)) | emp_perc<(`alpha'/2))
sort emp_perc
local upBound = emp_est[_N]
local lowBound = emp_est[1]
use Data/Synthetic/IntermediateData/intermediate_SC3_`sector'`dOIString'.dta, replace
gen emp_lower = `center' - abs(`upBound')
gen emp_upper = `center' + abs(`lowBound')

*Generate Point-estimate & CI for MERCHANTS*
save Data/Synthetic/IntermediateData/intermediate_SC3_`sector'`dOIString'.dta, replace
keep if treatedState==`treatState'
local center = merchants_all_est[1]
use Data/Synthetic/IntermediateData/intermediate_SC3_`sector'`dOIString'.dta, replace
drop if (merchants_all_perc>(1-(`alpha'/2)) | merchants_all_perc<(`alpha'/2))
sort merchants_all_perc
local upBound = merchants_all_est[_N]
local lowBound = merchants_all_est[1]
use Data/Synthetic/IntermediateData/intermediate_SC3_`sector'`dOIString'.dta, replace
gen merchants_all_lower = `center' - abs(`upBound')
gen merchants_all_upper = `center' + abs(`lowBound')

*Generate Point-estimate & CI for GPS*
save Data/Synthetic/IntermediateData/intermediate_SC3_`sector'`dOIString'.dta, replace
keep if treatedState==`treatState'
local center = gps_est[1]
use Data/Synthetic/IntermediateData/intermediate_SC3_`sector'`dOIString'.dta, replace
drop if (gps_perc>(1-(`alpha'/2)) | gps_perc<(`alpha'/2))
sort gps_perc
local upBound = gps_est[_N]
local lowBound = gps_est[1]
use Data/Synthetic/IntermediateData/intermediate_SC3_`sector'`dOIString'.dta, replace
gen gps_lower = `center' - abs(`upBound')
gen gps_upper = `center' + abs(`lowBound')
save Data/Synthetic/IntermediateData/intermediate_SC3_`sector'`dOIString'.dta, replace

*Format Final dta Results*
keep if treatedState==`treatState'
drop treatedState
gen sect = "`sector'"
gen eventDate = `dOI'
gen weeksPrior = `3'
gen weeksAfter = `4'
gen poolSize = `poolSize'
gen elimCrit = 	`elimCrit'
order sect eventDate weeksPrior weeksAfter poolSize elimCrit spend_all_est spend_all_perc spend_all_lower spend_all_upper emp_est emp_perc emp_lower emp_upper merchants_all_est merchants_all_perc merchants_all_lower merchants_all_upper gps_est gps_perc gps_lower gps_upper
format eventDate %td
save Data/Synthetic/IntermediateData/intermediate_SC3_`sector'`dOIString'.dta, replace
