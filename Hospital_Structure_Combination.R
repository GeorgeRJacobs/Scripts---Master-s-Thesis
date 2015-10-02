library(plyr)
library(xlsx)

setwd("/Users/georgejacobs/Desktop/Hospital Compare Scores - Friedson/DateExcel/HQI_MSR_XWLK/Hospital Structure") #Directory holding the excel files



paths <- dir("/Users/georgejacobs/Desktop/Hospital Compare Scores - Friedson/DateExcel/HQI_MSR_XWLK/Hospital Structure", pattern = "\\.csv$", full.names = TRUE) #Grabbing the filenames

names(paths) <- basename(paths) 			# Assign the name of the columns to the actual file name - will be kept 
																			# Check this everytime you run this code!!

#hosp_str.df <- ldply(paths, read.csv, stringsAsFactors=F) #Here is the fun stuff - Putting together the various datasets!
																													#Very slow - run once and Save

#save(hosp_str.df, file = "Hosp_Str_Full.RData") #Save for future loading times - and only work with this
																								#After inspection of course - may have to manually compute csv's first if a problem
load("Hosp_Str_Full.RData")


#Fixing some things

hosp_str.df$Full_Address <- paste(hosp_str.df$Address1, hosp_str.df$Address) #Merging two columns together so that NAs are Removed
hosp_str.df$Hospital.Ownership <- paste(hosp_str.df$Hospital.Owner, hosp_str.df$Hospital.Ownership) #Difference due to Naming over time
hosp_str.df$Emergency.Services <- paste(hosp_str.df$Emergency.Services, hosp_str.df$Emergency.Service) 
hosp_str.df$Provider.Number <- paste(hosp_str.df$Provider.ID, hosp_str.df$Provider.Number) 

#Delete Associated NA values
hosp_str.df$Full_Address <- sub("NA", "", hosp_str.df$Full_Address) #Deletes the Coerced NAs from Paste
hosp_str.df$Hospital.Ownership <- sub("NA", "", hosp_str.df$Hospital.Ownership)
hosp_str.df$Emergency.Services <- sub("NA", "", hosp_str.df$Emergency.Services)
hosp_str.df$Provider.Number <- sub("NA", "", hosp_str.df$Provider.Number)


#More Clean Up

hosp_str.df$Provider.Number <- gsub("'", "", fixed = T, hosp_str.df$Provider.Number) #Deletes the quotation marks on all the Provider.Numbers
hosp_str.df$Provider.Number<- sub("^0", "", hosp_str.df$Provider.Number) #Deletes Leading Zero
hosp_str.df$Provider.Number<- sub("^0", "", hosp_str.df$Provider.Number) #Deletes Leading Zero
grep("^0", hosp_str.df$Provider.Number) # Checking...
grep("'", hosp_str.df$Provider.Number) # Checking...
grep("\\'", hosp_str.df$Provider.Number)

library(stringr) #Wickham's Regular Expression Machine

hosp_str.df[] <- lapply(hosp_str.df, str_trim) # Trims both Leading/Trailing Whitespace

#Getting Rid of Duplicate Columns - DANGEROUS

library(dplyr)

trial <- hosp_str.df %>% #Dangerous - Removing extra columns for greater speeds - Hence why it is a new DF
	select(-Address1, -Provider.ID, -Address, -Emergency.Service, -Hospital.Owner)


#Delete duplicate Rows - Dangerous

trial1 <- trial[!duplicated(trial$Provider.Number),] #This gets rid of duplicates of ID number ONLY
																										 #Maybe possible that things change over time 
																										 #Trial and Error here are important

trial2 <- trial[!duplicated(trial$Hospital.Name),]	 #Different Tactic - 2000 observations bigger

#Example Join - Let's See what Happens

View(hosp_str.df)

#Save File

save(trial1, file = "Hosp_Str_EndofScriptt1.RData")
save(trial2, file = "Hosp_Str_EndofScriptt2.RData")
