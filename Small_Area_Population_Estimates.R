#Similar script to SAHIE - For SAPIE

setwd("/Users/georgejacobs/Desktop/Hospital Compare Scores - Friedson/DateExcel/HQI_MSR_XWLK/Small Area Population Estimates/SAIPE - POVERTY_INCOME") 

paths <- dir("/Users/georgejacobs/Desktop/Hospital Compare Scores - Friedson/DateExcel/HQI_MSR_XWLK/Small Area Population Estimates/SAIPE - POVERTY_INCOME", pattern = "\\.csv$", full.names = TRUE) #Grabbing the filenames)
names(paths) <- basename(paths) # - Takes filename and creates a column with the name of it inside

library(plyr)

sapie2005 <- read.csv("s2005.csv", stringsAsFactors = F)
sapie2011 <- read.csv("s2011.csv", stringsAsFactors = F)
sapie2012 <- read.csv("s2012.csv", stringsAsFactors = F)
sapie2006 <- read.csv("s2006.csv", stringsAsFactors = F)
sapie2007 <- read.csv("s2007.csv", stringsAsFactors = F)
sapie2008 <- read.csv("s2008.csv", stringsAsFactors = F) #Problem with this read-in - Fortunately - Also have CSVs
sapie2009 <- read.csv("s2009.csv", stringsAsFactors = F)
sapie2010 <- read.csv("s2010.csv", stringsAsFactors = F)
sapie2013 <- read.csv("s2013.csv", stringsAsFactors = F)



library(dplyr) # Remember to load in the dataset you idiot you

#Renaming Variables to Match across years!!!


sapie2013 <- rename(sapie2013, State.FIPS = State.FIPS.Code,  #2013, 2012 have to be recoded a little bit
	County.FIPS = County.FIPS.Code,
	Postal = Postal.Code,
	Poverty.Estimate..Under.Age.18 = Poverty.Estimate..Age.0.17,
	Poverty.Percent..Under.Age.18 = Poverty.Percent..Age.0.17)
	
sapie2012 <- rename(sapie2012, State.FIPS = State.FIPS.Code,  #2013, 2012 have to be recoded a little bit
	County.FIPS = County.FIPS.Code,
	Postal = Postal.Code)

names <- lapply(files, names)

identical(names(sapie2005), names(sapie2006)) #True - Testing if the names are the same across years!!
identical(names(sapie2005), names(sapie2007)) #True
identical(names(sapie2005), names(sapie2008)) #True
identical(names(sapie2005), names(sapie2009)) #True
identical(names(sapie2005), names(sapie2010)) #True
identical(names(sapie2005), names(sapie2011)) #True
identical(names(sapie2005), names(sapie2012)) #False
identical(names(sapie2005), names(sapie2013)) #False

#DANGEROUS

names(sapie2012) <- names(sapie2005) #Assign the names from earlier years to curent years
names(sapie2013) <- names(sapie2005) #Since they are in the same order of columns - this is fine!



files <- list(sapie2005, sapie2006, sapie2007, sapie2008, sapie2009, sapie2010, sapie2011, sapie2012, sapie2013) #rm(paths) to get this to work

#Add year variable

years = list(2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013) #Create the list of years 

years.list <- Map(cbind, files, year = years) #Adding the year variables!!!

master.df.sapie <- rbind.fill(years.list)

save(master.df.sapie, file = "SAPIE_FULL_RBIND.RData")
