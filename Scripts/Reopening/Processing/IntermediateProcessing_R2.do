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
import delimited "Data/Reopening/InputData/manual_reopening_data.csv"

*Reformat Date Variable*
gen newDate = date(date, "YMD")
format newDate %td
drop date
ren newDate date
order date, first
drop if date==.

*Save Modified Dataset*
save Data/Reopening/IntermediateData/intermediate_man.dta, replace
