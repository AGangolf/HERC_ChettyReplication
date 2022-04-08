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

*Import Dataset*
use "Data/Synthetic/IntermediateData/intermediate_SC2.dta"

*Set Start Date*
local startDate = mdy(03,30,2020)

*Pass Sector Selection*
local sector = "`1'"

*Pass Reopening Date of Interest*
local dOI = `2'

*Implement Event Date Testing*
if `3'==1 {
	drop if date<=`=mdy(04,15,2020)'
	forvalues day = `=mdy(04,17,2020)'(1)`=mdy(06,01,2020)' {
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
			qui gen dayTemp = string(`day', "%td")
			di dayTemp[1] + ": " + "`tempC`day''"
			di ""
			qui drop dayTemp
		}
	}
	break
}
else {
	*Reimport Dataset*
	use "Data/Synthetic/IntermediateData/intermediate_SC2.dta", replace
	
	*Determine Treated States*
	levelsof statefips if (date==`2' & `sector'==1), clean separate(,) local(tempA)
	levelsof statefips if (date==(`2'-1) & `sector'==1), clean separate(,) local(tempB)
	keep if inlist(statefips, `tempA')
	if "`tempB'" != "" {
		drop if inlist(statefips, `tempB')
	}
	levelsof statefips, clean separate(,) local(treatStates)

	*Reimport Dataset Again*
	use "Data/Synthetic/IntermediateData/intermediate_SC2.dta", replace

	*Set Reopening Date of Interest as Variable*
	gen dateOfInterest = `dOI'
	order dateOfInterest, after(date)
	format dateOfInterest %td
	
	*Set Reopening Date as String Local*
	gen dOITemp = string(dateOfInterest, "%td")
	local dOIString = dOITemp[1]
	drop dOITemp

	*Remove control states which reopened the same sector within three weeks of treatment*
	drop if (!inlist(statefips, `treatStates') & date>=dateOfInterest & date<=dateOfInterest+21 & `sector'==1)
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
	synth spend_all spend_all(`startDate'(1)`dOI'), trunit(`treatState') trperiod(`dOI') keep(~/Projects/HERC_ChettyReplication/Data/Synthetic/IntermediateData/intermediate_SC3_`sector'`dOIString'_SPEND.dta) replace
	synth emp emp(`startDate'(1)`dOI'), trunit(`treatState') trperiod(`dOI') keep(~/Projects/HERC_ChettyReplication/Data/Synthetic/IntermediateData/intermediate_SC3_`sector'`dOIString'_EMP.dta) replace
	synth merchants_all merchants_all(`startDate'(1)`dOI'), trunit(`treatState') trperiod(`dOI') keep(~/Projects/HERC_ChettyReplication/Data/Synthetic/IntermediateData/intermediate_SC3_`sector'`dOIString'_MOB.dta) replace
	synth gps gps(`startDate'(1)`dOI'), trunit(`treatState') trperiod(`dOI') keep(~/Projects/HERC_ChettyReplication/Data/Synthetic/IntermediateData/intermediate_SC3_`sector'`dOIString'_GPS.dta) replace
	
	*Reshape Synthetic Control Data*
	use "Data/Synthetic/IntermediateData/intermediate_SC3_`sector'`dOIString'_SPEND.dta", clear
	drop _Co_Number _W_Weight
	ren _Y_treated spend_all1
	ren _Y_synthetic spend_all0
	reshape long spend_all, i(_time) j(doesOpen)
	save Data/Synthetic/IntermediateData/intermediate_SC3_`sector'`dOIString'_SPEND.dta, replace

	use "Data/Synthetic/IntermediateData/intermediate_SC3_`sector'`dOIString'_EMP.dta", clear
	drop _Co_Number _W_Weight
	ren _Y_treated emp1
	ren _Y_synthetic emp0
	reshape long emp, i(_time) j(doesOpen)
	save Data/Synthetic/IntermediateData/intermediate_SC3_`sector'`dOIString'_EMP.dta, replace

	use "Data/Synthetic/IntermediateData/intermediate_SC3_`sector'`dOIString'_MOB.dta", clear
	drop _Co_Number _W_Weight
	ren _Y_treated merchants_all1
	ren _Y_synthetic merchants_all0
	reshape long merchants_all, i(_time) j(doesOpen)
	save Data/Synthetic/IntermediateData/intermediate_SC3_`sector'`dOIString'_MOB.dta, replace

	use "Data/Synthetic/IntermediateData/intermediate_SC3_`sector'`dOIString'_GPS.dta", clear
	drop _Co_Number _W_Weight
	ren _Y_treated gps1
	ren _Y_synthetic gps0
	reshape long gps, i(_time) j(doesOpen)
	save Data/Synthetic/IntermediateData/intermediate_SC3_`sector'`dOIString'_GPS.dta, replace

	*Merge*
	use "Data/Synthetic/IntermediateData/intermediate_SC3_`sector'`dOIString'_SPEND.dta", clear
	merge 1:1 _time doesOpen using "Data/Synthetic/IntermediateData/intermediate_SC3_`sector'`dOIString'_EMP.dta"
	drop _merge
	merge 1:1 _time doesOpen using "Data/Synthetic/IntermediateData/intermediate_SC3_`sector'`dOIString'_MOB.dta"
	drop _merge
	merge 1:1 _time doesOpen using "Data/Synthetic/IntermediateData/intermediate_SC3_`sector'`dOIString'_GPS.dta"
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
	save Data/Synthetic/IntermediateData/intermediate_SC3_`sector'`dOIString'.dta, replace

	*Run Regressions and Save Matrix Outputs*
	reg spend_all doesOpen afterEvent isOpen if (abs(date-dateOfInterest)<=14)
	matrix `sector'`dOIString'_SPEND_2 = r(table)
	reg spend_all doesOpen afterEvent isOpen if (abs(date-dateOfInterest)<=21)
	matrix `sector'`dOIString'_SPEND_3 = r(table)
	reg emp doesOpen afterEvent isOpen if (abs(date-dateOfInterest)<=14)
	matrix `sector'`dOIString'_EMP_2 = r(table)
	reg emp doesOpen afterEvent isOpen if (abs(date-dateOfInterest)<=21)
	matrix `sector'`dOIString'_EMP_3 = r(table)
	reg merchants_all doesOpen afterEvent isOpen if (abs(date-dateOfInterest)<=14)
	matrix `sector'`dOIString'_MOB_2 = r(table)
	reg merchants_all doesOpen afterEvent isOpen if (abs(date-dateOfInterest)<=21)
	matrix `sector'`dOIString'_MOB_3 = r(table)
	reg gps doesOpen afterEvent isOpen if (abs(date-dateOfInterest)<=14)
	matrix `sector'`dOIString'_GPS_2 = r(table)
	reg gps doesOpen afterEvent isOpen if (abs(date-dateOfInterest)<=21)
	matrix `sector'`dOIString'_GPS_3 = r(table)
}
