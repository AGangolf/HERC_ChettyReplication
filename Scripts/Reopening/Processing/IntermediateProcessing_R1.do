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

*Import Intermediate Dataset*
use "Data/Reopening/IntermediateData/intermediate_1.dta"

*Remove Duplicate Obs for Each Date*
collapse statefips, by(state status sector details date)

*Remove Non-Reopened Sectors*
drop if !(status=="Reopened" || status=="Open")
drop status details state

*Aggregate Retail, Retail and Beauty, and Retail Stores Sectors*
replace sector="Retail" if (sector=="Retail and beauty" || sector=="Retail stores")

*Generate Indicator Variables for each Sector being Open*
gen ent = .
replace ent = 1 if sector=="Entertainment"
gen food = .
replace food=1 if sector=="Food and drink"
gen worship = .
replace worship=1 if sector=="Houses of worship"
gen industry = .
replace industry = 1 if sector=="Industries"
gen medical = .
replace medical = 1 if sector=="Medical"
gen recreation = .
replace recreation = 1 if sector=="Outdoor and recreation"
gen pcare = .
replace pcare = 1 if sector=="Personal care"
gen retail = .
replace retail = 1 if sector=="Retail"

*Aggregate the obs for each sector by date & state into each state by date*
collapse ent food worship industry medical recreation pcare retail, by(date statefips)

*Replace missing indicator values with zero*
foreach v of varlist ent food worship industry medical recreation pcare retail {
	replace `v' = 0 if `v'==.
}

*Generates obs for state x dates with no reopen sectors*
gen timeSince = date - mdy(4,30,2020)
forvalues x = 0(1)62 {
	foreach state of numlist 1 2 4 5 6 8 9 10 11 12 13 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 44 45 46 47 48 49 50 51 53 54 55 56 {
		count if statefips==`state' & timeSince==`x'
		if r(N) == 0 {
			local new = _N + 1
			set obs `new'
			replace date = mdy(04,30,2020)+`x' if _n == `new'
			replace statefips = `state' if _n == `new'
			foreach v of varlist ent food worship industry medical recreation pcare retail {
				replace `v' = 0 if _n == `new'
			}			
		}
	}
}

*Cleans scraper errors. For each state and sector, checks if the preceding and following dates' obs are equal; if so, verifies that the middle date's obs matches.  For example, "0 1 0" for some sector on three dates would become "0 0 0".*
drop timeSince
gen timeSince = date - mdy(4,30,2020)
foreach state of numlist 1 2 4 5 6 8 9 10 11 12 13 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 44 45 46 47 48 49 50 51 53 54 55 56 {
	forvalues x = 1(1)61 {
		foreach sector of varlist ent food worship industry medical recreation pcare retail {
		mkmat `sector' if (statefips==`state' & timeSince==`x'), matrix(valueMat)
		local val = valueMat[1,1]
		mkmat `sector' if (statefips==`state' & timeSince==`x'-1), matrix(preMat)
		local preVal = preMat[1,1]
		mkmat `sector' if (statefips==`state' & timeSince==`x'+1), matrix(postMat)
		local postVal = postMat[1,1]
			if (`preVal' == `postVal' & `val'!=`preVal') {
				replace `sector'=`preVal' if (statefips==`state' & timeSince==`x')
			}
		}
	}
}

*Drops unnecessary variable and sorts*
drop timeSince
sort statefips date

*Save Modified Dataset*
save Data/Reopening/IntermediateData/intermediate_2.dta, replace
