# HERC_ChettyReplication

Section 3: Instructions for reproducing your results

   Check to make sure you are using the correct version of Stata on Mac and Windows which is Stata BE, Version 17 (Intel 64-bit). 
   Download the  folder to your computer 
   
   NOTE: It should be downloaded with the correct hierarchy of folders and files. The folder outline should match the lay out in Section 2. If the correct hierarchy is not implemented the scripts will not run properly. 
   Launch Stata by double clicking on the first script, Import.do, and set your working directory to the HERC_ChettyReplication folder. 

Execute the Import.do command file. 

  This command file: 
  
      -Opens Affinity-State-Daily.csv.
      -It reads the data into Stata and removes needless data. 
      -Saves the modified data in the folder called IntermediateData (a subfolder of Data) in a file called intermediate1_C1.dta, intermediate1_C2.dta,  intermediate1_C3.dta, 

Execute the IntermediateProcessing_C1.do, IntermediateProcessing_C2.do, IntermediateProcessing_C3.do file. 

    This command file:
    
      -Opens the respective intermediate1_Cx.dta (which was created by the Import.do command file and saved in IntermediateData).
      -Creates date, control state identifier, and time to treat variables
      -Saves the modified data in the folder called IntermediateData as intermediate2_Cx.dta (x represents respective control date)
  
 Execute the AppendProcessing.do file. 
 
    This command file:
    
      -Opens the respective intermediate2_Cx.dta (which was created by the IntermediateProcessing_Cx.do command file and saved in IntermediateData).
      -Appends all three intermediate2_Cx.dta together to create one data set for analysis. 
      -Saves the modified data in the folder called AnalysisData (a subfolder of Data) in a file called analysis.dta.
 
 Execute the Analysis.do command file 
 
    This command file:
    
      -Opens the analysis.dta file (which was created by the AppendProcessing.do command file and saved in AnalysisData). 
      -Runs an event study analysis 
      -The results generated by these commands are saved to files that are stored in Results (a sub-folder of Output). 
