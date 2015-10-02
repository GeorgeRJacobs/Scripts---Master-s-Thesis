#This is the script for loading .csv files and cleaning them up
#This script will work once the files are cleaned - Saved also is a dictionary


setwd("/Users/georgejacobs/Desktop/Hospital Compare Scores - Friedson/DateExcel/HQI_MSR_XWLK/Unemployment - By County") 

paths <- dir("/Users/georgejacobs/Desktop/Hospital Compare Scores - Friedson/DateExcel/HQI_MSR_XWLK/Unemployment - By County", pattern = "\\.csv$", full.names = TRUE) #Grabbing the filenames

names(paths) <- basename(paths)
library(plyr)
require(dplyr)

uemp05 <- read.csv("laucnty05.csv", header = T)
uemp11 <- read.csv("laucnty11.csv", header = T)
uemp12 <- read.csv("laucnty12.csv", header = T)
uemp06 <- read.csv("laucnty06.csv", header = T)
uemp07 <- read.csv("laucnty07.csv", header = T)
uemp08 <- read.csv("laucnty08.csv", header = T) 
uemp09 <- read.csv("laucnty09.csv", header = T)
uemp10 <- read.csv("laucnty10.csv", header = T)
uemp13 <- read.csv("laucnty13.csv", header = T)
uemp14 <- read.csv("laucnty14.csv", header = T)

identical(names(uemp05), names(uemp06)) #True - Testing if the names are the same across years!!
identical(names(uemp05), names(uemp07)) #True
identical(names(uemp05), names(uemp08)) #True
identical(names(uemp05), names(uemp09)) #True
identical(names(uemp05), names(uemp10)) #True
identical(names(uemp05), names(uemp11)) #True
identical(names(uemp05), names(uemp12)) #True
identical(names(uemp05), names(uemp13)) #True
identical(names(uemp05), names(uemp14)) #True

files.l <- list(s2005 = uemp05,
	s2006 = uemp06, 
	s2007 = uemp07, 
	s2008 = uemp08, 
	s2009 = uemp09, 
	s2010 = uemp10, 
	s2011 = uemp11, 
	s2012 = uemp12, 
	s2013 = uemp13, 
	s2014 = uemp14) 


ChangeNames <- function(x) {
    x <- x %>% rename(UEMPRATE = X..., #Making the coding for the column names!
	LAUS.Code = Code,
  State.FIPS = Code.1,
	County.FIPS = Code.2,
	Labor.Force = Force)
  return(x)
}

files.l <- lapply(files.l, ChangeNames)
files.l <- lapply(files.l, select, -X)

master.df.uemp <- rbind.fill(files.l)

#Remove Trailing Remarks on the Data.Frame

master.df.uemp <- master.df.uemp[!is.na(master.df.uemp$State.FIPS),]

View(master.df.uemp)

save(master.df.uemp, file = "Unemployment.RData")

