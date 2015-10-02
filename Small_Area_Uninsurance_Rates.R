#This is the script for loading .txt files and cleaning them up
#This script will work once the files are cleaned - Saved also is a dictionary


setwd("/Users/georgejacobs/Desktop/Hospital Compare Scores - Friedson/DateExcel/HQI_MSR_XWLK/Small Area Health Insurance Estimates") 

paths <- dir("/Users/georgejacobs/Desktop/Hospital Compare Scores - Friedson/DateExcel/HQI_MSR_XWLK/Small Area Health Insurance Estimates", pattern = "\\.TXT$", full.names = TRUE) #Grabbing the filenames

names(paths) <- basename(paths)
library(plyr)

sahie2005 <- read.table("SAHIE2005.TXT")
sahie2011 <- read.table("SAHIE2011.TXT")
sahie2012 <- read.table("SAHIE2012.TXT")
sahie2006 <- read.table("SAHIE2006.TXT")
sahie2007 <- read.table("SAHIE2007.TXT")
sahie2008 <- read.table("SAHIE2008.TXT") #Problem with this read-in - Fortunately - Also have CSVs
sahie2009 <- read.table("SAHIE2009.TXT")
sahie2010 <- read.table("SAHIE2010.TXT")
sahie2013 <- read.table("SAHIE2013.TXT")


#files <- ldply(paths, read.table) #Brings in All .txt Files - Gives them common columns  - By HAND
																	#Need to check the columns should be the same !!!!!!!

#Now we have all the years read-in 
#Begin work on matching them up on columns

#Assigning Names to Columns 

#2005 has a limited number of early measures - Rest of group has more
library(dplyr)
sahie2005$year <- 2005
sahie2005 <- rename(sahie2005, StateFIP = V1, #Assigning Column Names to 2005 - Then Arrange Year to First Column
	CountyFIP = V2, 
	GeoCat = V3, 
	AgeCat = V4,
	RaceCat = V5,
	SexCat = V6,
	IPRCat = V7,
	PopCat = V8,
	NumberInsured = V9,
	InsuredMOE = V10,
	NumberUninsured = V11,
	Uninsured_MOE = V12,
	PercentUnInsuredDemGroupAllIncLev = V13, #Not coded the same as the other years - need to check on this
	PIDGAIL_MOE = V14)

sahie2005 <- select(sahie2005, year, everything()) #Moves Year to the front - which is good!

years_notdoneyet <- list(s2008 = sahie2008, s2006 = sahie2006, s2007 = sahie2007, s2009 = sahie2009, s2010 = sahie2010, s2011 = sahie2011, s2012 = sahie2012, s2013 = sahie2013) #Creating a list of Data.Frames

renames <- lapply(years_notdoneyet, rename, StateFIP = V1, #Assigning Column Names to 2006 - 2013 - Then Arrange Year to First Column
	CountyFIP = V2,                                          #Skipping 2008 - Working on that afterwards
	GeoCat = V3, 
	AgeCat = V4,
	RaceCat = V5,
	SexCat = V6,
	IPRCat = V7,
	PopCat = V8,
	NumberInsured = V9,
	InsuredMOE = V10,
	NumberUninsured = V11,
	Uninsured_MOE = V12,
	Population_Demgroup_IncLevel = V13,
	PopDemGroup_MOE = V14,
	PercentInsuredDemoGroup_IncLevel = V15,
	PIDG_MOE = V16,
	PercentUnInsuredDemoGroup_IncLevel = V17,
	PUIDGMOE = V18,
	PercentInsuredDemGroupAllIncLev = V19,
	PIDGAIL_MOE = V20,
	PercentUnInsuredDemGroupAllIncLev = V21,
	PIDGAIL_MOE = V22
	)

renames$s2006$year <- 2006 # Generating the Year Variables for the Data here
renames$s2007$year <- 2007
renames$s2009$year <- 2009
renames$s2010$year <- 2010
renames$s2011$year <- 2011
renames$s2012$year <- 2012
renames$s2013$year <- 2013
renames$s2008$year <- 2008

#Move on to 2008 - what to do with it? - Coerced NAs for those values - Don't know why they are blank

years = list(2008, 2006, 2007, 2009, 2010, 2011, 2012, 2013)
years.list <- Map(cbind, renames, year = years) #Doing this twice - two different ways!

master.df <- rbind.fill(years.list) # Master Data.Frame missing 2005

master.df <- rbind.fill(master.df, sahie2005)

master.df <- arrange(master.df, year)

save(master.df, file = "SAHIE.RData")
