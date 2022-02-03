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
import delimited "Data/ConsumerSpending/InputData/Affinity - State - Daily.csv"

*Drops Irrelevant Columns*
drop spend_aap spend_acf spend_aer spend_apg spend_durables spend_nondurables spend_grf spend_gen spend_hic spend_hcs spend_inpersonmisc spend_remoteservices spend_sgh spend_tws spend_retail_w_grocery spend_retail_no_grocery spend_all_incmiddle spend_all_q1 spend_all_q2 spend_all_q3 spend_all_q4 provisional

*Keeps only Relevant Data Ranges*
keep if year == 2020
keep if (month==1 & day>25) | month == 2 | month == 3 | month == 4 | month == 5

*Save Modified Dataset*
save Data/ConsumerSpending/IntermediateData/intermediate1_C1.dta, replace
save Data/ConsumerSpending/IntermediateData/intermediate1_C2.dta, replace
save Data/ConsumerSpending/IntermediateData/intermediate1_C3.dta, replace

