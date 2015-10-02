library(tidyr)
library(plyr)
library(foreign)
library(dplyr)

setwd("/Users/georgejacobs/Desktop/Hospital Compare Scores - Friedson/DateExcel/HQI_MSR_XWLK") #Path has to start with the forward slash - The more you know!

#Go month by month - and row bind the like files together
#Once the first is added - tidy up with tidyr and then you can run the code on the full sample of data
#This is the best idea I can think of right now.

#Found in the TIDYR vignette - grab all the names in the directory which conform to that regular expression 
paths <- dir("/Users/georgejacobs/Desktop/Hospital Compare Scores - Friedson/DateExcel/HQI_MSR_XWLK", pattern = "\\.csv$", full.names = TRUE)

#Once we have the paths - we need to name each element in the vector with the name of the file
names(paths) <- basename(paths) # Check this everytime you run this code!!

#lets read them in with ldply - laaply's cousin
read.data <- function(file){
  dat <- read.csv(file,header=T,sep=",", stringsAsFactors=FALSE)
  dat$fname <- file
  return(dat)
}

msr <- ldply(paths, read.csv,stringsAsFactors=F)


save(msr.test, file ="msrtest.RData") #I know this is the correct thing!
#Have to append with Tidy datasets- starting in 2014-07-17!!

#^ Auto creates columns where present - Do not need to Tidy Individually!!!

#For some reason - specific file date 4.11 didn't copy over properly
#Merge column to the other one!!

msr$Date[is.na(msr$Date)] <- "4/1/11" #Check this to understand what is going on!
na <- msr[is.na(msr$Date),] #A check there is no NA values present in the selection!
#Removes the column we do not want!!!!

#Gets rid of leading/trailing "'" - Super awesome Regular Expressions!

msr$Provider.Number <- gsub("'", "", msr$Provider.Number) # Nope

msr <- msr %>% select(-State)

names(msr)

save(msr, file = "raw.Rdata")


