/************************************************
************************************************
**# Bookmark #1
Before running the following file:

	-Designate the ChettyProject/ as the working directory
	
	-Lines coded in green with asterisks with specific pathways shown as examples
	rather than functional pathways for all users 
	
************************************************
************************************************/


clear
set more off 
use "Data/AnalysisData/analysis.dta"

*Installs Needed Programs*
ssc install eventdd, replace
ssc install matsort, replace

*Runs Event Study Regression*
eventdd spend_all date statefips, timevar(timeToTreat) ci(rcap) baseline(-86) cluster(statefips) graph_op(ytitle("Consumer Spending") xlabel(-80(20)21))
