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
use "Data/Extension/IntermediateData/intermediate_E1.dta"

*Code Indicator for Any Sector & Any Non-Rec-Industry Sector Open*
gen any_sector = 0
gen any_sector_tight = 0
replace any_sector = 1 if (ent==1 | food==1 | worship==1 | industry==1 | recreation==1 | pcare==1 | retail==1)
replace any_sector_tight = 1 if (ent==1 | food==1 | worship==1 | pcare==1 | retail==1)
order any_sector, after(gps_away_from_home)
order any_sector_tight, after(any_sector)

*NOTE: SD Never Even Closed & DC Weird*

*Save Modified Dataset*
save Data/Extension/IntermediateData/intermediate_E2.dta, replace
