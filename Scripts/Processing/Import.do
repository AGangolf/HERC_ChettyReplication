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
import delimited "Data/InputData/Affinity - State - Daily.csv"

*Drops Irrelevant Columns*
drop spend_aap
drop spend_acf
drop spend_aer
drop spend_apg
drop spend_durables
drop spend_nondurables
drop spend_grf
drop spend_gen
drop spend_hic
drop spend_hcs
drop spend_inpersonmisc
drop spend_remoteservices
drop spend_sgh
drop spend_tws
drop spend_retail_w_grocery
drop spend_retail_no_grocery
drop spend_all_incmiddle
drop spend_all_q1
drop spend_all_q2
drop spend_all_q3
drop spend_all_q4
drop provisional

*Keeps only Relevant Data Ranges*
keep if year == 2020
*keep if (month==1 & day>12) | month == 2 | month == 3 | month == 4 | month == 5
keep if (month==1 & day>25) | month == 2 | month == 3 | month == 4 | month == 5

*Save Modified Dataset*
/*save Data/IntermediateData/intermediate0_P1.dta, replace
keep if month == 2 | month == 3 | month == 4 | month == 5
save Data/IntermediateData/intermediate0_P2.dta, replace*/
save Data/IntermediateData/intermediate1_C1.dta, replace
save Data/IntermediateData/intermediate1_C2.dta, replace
save Data/IntermediateData/intermediate1_C3.dta, replace

