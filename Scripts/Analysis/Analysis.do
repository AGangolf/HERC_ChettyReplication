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

drop if abs(timeToTreat)>14

*Runs Event Study Regression*
*gen eventTime = . 
*replace eventTime = timeToTreat if opener==1
*eventdd spend_all opener openTime reopened, timevar(eventTime) accum ci(rcap) leads(12) lags(26) cluster(statefips) graph_op(ytitle("Consumer Spending") xlabel(-80(20)21))

reg spend_all opener openTime reopened
