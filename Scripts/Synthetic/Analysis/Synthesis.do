/************************************************
Before running the following file:

	-Download in .csv format the Affinity - Country - Data dataset following the instructions in
	ReadMe.pdf
	
	-Designate the ChettyProjett/ as the working directory
	
	-Lines coded in green with asterisks with specific pathways shown as examples
	rather than functional pathways for all users 
	
************************************************
************************************************/
cd ~/Projects/HERC_ChettyReplication

clear
set more off

do "/Users/seross/Projects/HERC_ChettyReplication/Scripts/Extension/Analysis/Analysis_E.do"
do "/Users/seross/Projects/HERC_ChettyReplication/Scripts/Extension/Analysis/Analysis_F.do"
do "/Users/seross/Projects/HERC_ChettyReplication/Scripts/Extension/Analysis/Analysis_W.do"
do "/Users/seross/Projects/HERC_ChettyReplication/Scripts/Extension/Analysis/Analysis_I.do"
do "/Users/seross/Projects/HERC_ChettyReplication/Scripts/Extension/Analysis/Analysis_Rec.do"
do "/Users/seross/Projects/HERC_ChettyReplication/Scripts/Extension/Analysis/Analysis_Ret.do"

