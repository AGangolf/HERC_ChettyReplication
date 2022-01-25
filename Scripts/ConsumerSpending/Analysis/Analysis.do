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
use "Data/ConsumerSpending/AnalysisData/analysis.dta"

*Installs Needed Programs*
ssc install eventdd, replace
ssc install matsort, replace

*drop if abs(timeToTreat)>14

*Runs Event Study Regression*
*gen eventTime = . 
*replace eventTime = timeToTreat if opener==1*eventdd spend_all opener openTime reopened, timevar(eventTime) accum ci(rcap) leads(12) lags(26) cluster(statefips) graph_op(ytitle("Consumer Spending") xlabel(-80(20)21))

reg spend_all opener openTime reopened if (timeToTreat<25 & timeToTreat>-21), cluster(statefips)
/*collapse spend_all spend_all_norm, by(opener timeToTreat)
gen openTime = 0
replace openTime = 1 if timeToTreat>-1
gen reopened = 0
replace reopened = 1 if (opener==1 & openTime==1)
reg spend_all opener openTime reopened if !(abs(timeToTreat)>14)
twoway connected spend_all_norm timeToTreat if (opener==0 & timeToTreat<21), sort || connected spend_all_norm timeToTreat if (opener==1 & timeToTreat<21), sort

