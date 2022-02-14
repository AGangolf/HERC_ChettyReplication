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
use "Data/Employment/AnalysisData/analysis.dta"

twoway line emp timeToTreat if (doesOpen==0 & statefips==6 & stateofinterest==1 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==9 & stateofinterest==1 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==10 & stateofinterest==1 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==11 & stateofinterest==1 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==12 & stateofinterest==1 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==17 & stateofinterest==1 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==18 & stateofinterest==1 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==23 & stateofinterest==1 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==24 & stateofinterest==1 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==29 & stateofinterest==1 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==31 & stateofinterest==1 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==35 & stateofinterest==1 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==41 & stateofinterest==1 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==42 & stateofinterest==1 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==1 & statefips==45 & stateofinterest==1 & abs(timeToTreat)<23), lcolor(red) || line emp timeToTreat if (doesOpen==0 & statefips==46 & stateofinterest==1 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==51 & stateofinterest==1 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==53 & stateofinterest==1 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==55 & stateofinterest==1 & abs(timeToTreat)<23)|| line emp timeToTreat if (doesOpen==0 & statefips==1 & stateofinterest==1 & abs(timeToTreat)<23), lcolor(green)|| line emp timeToTreat if (doesOpen==0 & statefips==2 & stateofinterest==1 & abs(timeToTreat)<23), lcolor(green)|| line emp timeToTreat if (doesOpen==0 & statefips==3 & stateofinterest==1 & abs(timeToTreat)<23), legend(off) lcolor(green) name(g1b,replace)

twoway line emp timeToTreat if (doesOpen==0 & statefips==6 & stateofinterest==1 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==9 & stateofinterest==1 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==10 & stateofinterest==1 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==11 & stateofinterest==1 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==12 & stateofinterest==1 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==17 & stateofinterest==1 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==18 & stateofinterest==1 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==23 & stateofinterest==1 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==24 & stateofinterest==1 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==29 & stateofinterest==1 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==31 & stateofinterest==1 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==35 & stateofinterest==1 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==41 & stateofinterest==1 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==42 & stateofinterest==1 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==1 & statefips==45 & stateofinterest==1 & abs(timeToTreat)<23), lcolor(red) || line emp timeToTreat if (doesOpen==0 & statefips==46 & stateofinterest==1 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==51 & stateofinterest==1 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==53 & stateofinterest==1 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==55 & stateofinterest==1 & abs(timeToTreat)<23)|| line emp timeToTreat if (doesOpen==0 & statefips==1 & stateofinterest==1 & abs(timeToTreat)<23), lcolor(green)|| line emp timeToTreat if (doesOpen==0 & statefips==2 & stateofinterest==1 & abs(timeToTreat)<23), lcolor(green)|| line emp timeToTreat if (doesOpen==0 & statefips==3 & stateofinterest==1 & abs(timeToTreat)<23), legend(off) lcolor(green) name(g1,replace)

twoway line emp timeToTreat if (doesOpen==0 & statefips==2 & stateofinterest==2 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==6 & stateofinterest==2 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==9 & stateofinterest==2 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==10 & stateofinterest==2 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==11 & stateofinterest==2 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==12 & stateofinterest==2 & abs(timeToTreat)<23), lcolor(blue) ||  line emp timeToTreat if (doesOpen==1 & statefips==13 & stateofinterest==2 & abs(timeToTreat)<23), lcolor(red) || line emp timeToTreat if (doesOpen==0 & statefips==17 & stateofinterest==2 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==18 & stateofinterest==2 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==22 & stateofinterest==2 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==24 & stateofinterest==2 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==29 & stateofinterest==2 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==31 & stateofinterest==2 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==35 & stateofinterest==2 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==42 & stateofinterest==2 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==46 & stateofinterest==2 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==51 & stateofinterest==2 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==53 & stateofinterest==2 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==55 & stateofinterest==2 & abs(timeToTreat)<23), legend(off) lcolor(blue) name(g2,replace)

twoway line emp timeToTreat if (doesOpen==0 & statefips==6 & stateofinterest==3 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==9 & stateofinterest==3 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==10 & stateofinterest==3 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==11 & stateofinterest==3 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==17 & stateofinterest==3 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==24 & stateofinterest==3 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==1 & statefips==27 & stateofinterest==3 & abs(timeToTreat)<23), lcolor(red) || line emp timeToTreat if (doesOpen==1 & statefips==28 & stateofinterest==3 & abs(timeToTreat)<23), lcolor(red) || line emp timeToTreat if (doesOpen==0 & statefips==31 & stateofinterest==3 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==35 & stateofinterest==3 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==46 & stateofinterest==3 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==51 & stateofinterest==3 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==53 & stateofinterest==3 & abs(timeToTreat)<23), lcolor(blue) || line emp timeToTreat if (doesOpen==0 & statefips==55 & stateofinterest==3 & abs(timeToTreat)<23), legend(off) lcolor(blue) name(g3,replace)

graph combine g1 g2 g3
/*
collapse emp, by(doesOpen timeToTreat)
drop if (timeToTreat>21 | timeToTreat<-90)

*Graphs Data
twoway connected emp timeToTreat if doesOpen==0, sort xlab(-80(10)20) || connected emp timeToTreat if doesOpen==1, sort xlab(-80(10)20)

