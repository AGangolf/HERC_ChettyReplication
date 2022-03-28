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

*Run Regression Scripts*
run "Scripts/Extension/Processing/IntermediateProcessing_E1.do"

*Import Dataset*
use "Data/Extension/AnalysisData/analysis_panel.dta"

didreg (spend_all) (any_sector), time(date)
