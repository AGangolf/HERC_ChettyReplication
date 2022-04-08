/************************************************
Before running the following file:

	-Download in .csv format the Affinity - Country - Data dataset following the instructions in
	ReadMe.pdf
	
	-Designate the ChettyProject/ as the working directory
	
	-Lines coded in green with asterisks with specific pathways shown as examples
	rather than functional pathways for all users 
	
************************************************
************************************************/

*RUNFORMAT: do filename "sector" donorLimit weeksPrior weeksAfter elimCrit *

cd ~/Projects/HERC_ChettyReplication

clear
set more off

*Import Dataset*
use "Data/Synthetic/IntermediateData/intermediate_SC2.dta"

*Set Beginning Search Date*
local searchDate = `=mdy(04,15,2020)'

*Set Search Weeks Out*
local weeksOut = 10

*Pass Sector Selection*
local sector = "`1'"

*Pass Donor Limit*
local donorLimit = `2'

*Pass Weeks Prior*
local weeksPriorMaster = `3'

*Pass Weeks After*
local weeksAfterMaster = `4'

*Pass Elim Criterion*
local elimCritMaster = `5'

*Implement Event Date Testing*
drop if date<=`searchDate'
local count = 0
local countTemp = 0
local break = 0
forvalues day = `=`searchDate'+2'(1)`=`searchDate'+(7*`weeksOut')' {
	local dayPrior = `day'-1
	use "Data/Synthetic/IntermediateData/intermediate_SC2.dta", replace
	qui levelsof statefips if (date==`day' & `sector'==1), clean separate(,) local(tempA`day')
	qui levelsof statefips if (date==`dayPrior' & `sector'==1), clean separate(,) local(tempB`day')
	if "`tempA`day''" != "" {
		qui keep if inlist(statefips, `tempA`day'')
		if "`tempB`day''" != "" {
			qui drop if inlist(statefips, `tempB`day'')
		}
	}
	qui levelsof statefips, clean separate(,) local(tempC`day')
	if(strlen("`tempC`day''")<100 & strlen("`tempC`day''")>0) {
		local countTemp = `=`count'+1'
		local count = `countTemp'
		qui gen dayTemp = string(`day', "%td")
		di dayTemp[1] + ": " + "`tempC`day''"
		save "Data/Synthetic/IntermediateData/intermediate_SC2_temp.dta", replace
		if `break'==0 {
			do Scripts/Synthetic/Processing/IntermediateProcessing_SC2.do "`sector'" `day' `weeksPriorMaster' `weeksAfterMaster' `elimCritMaster'
			if poolSize[1] < `donorLimit' {
				local break = 1
			}
			else {
				if `count'==1 {
					save Data/Synthetic/IntermediateData/intermediate_SC3_`sector'.dta, replace
				}
				else {
					append using "Data/Synthetic/IntermediateData/intermediate_SC3_`sector'.dta"
					save Data/Synthetic/IntermediateData/intermediate_SC3_`sector'.dta, replace
				}
			}
		}
		use "Data/Synthetic/IntermediateData/intermediate_SC2_temp.dta", replace
		di ""
		qui drop dayTemp
	}
}

use Data/Synthetic/IntermediateData/intermediate_SC3_`sector'.dta, replace
sort eventDate
save Data/Synthetic/IntermediateData/intermediate_SC3_`sector'.dta, replace

*TODO:  Pooled Estimate*
