#Zip Code to County Fips Merge 

library(foreign)
library(plyr)
library(dplyr)

#Load in the Left Hand Data Set!

load("/Users/georgejacobs/Desktop/Hospital Compare Scores - Friedson/DateExcel/HQI_MSR_XWLK/Hospital Structure/Lefthandside.RData")

fips.dta <- read.dta("/Users/georgejacobs/Desktop/Hospital Compare Scores - Friedson/DateExcel/HQI_MSR_XWLK/ZiptoCountyFips.dta")

#Pare down dataset for easier merge - Removing extraneous columns

lf_fips.df <- select(lefthandside.df, - Measure.Name, -Address2, -Address3, -Full_Address)
names(lf_fips.df)[1] <- "Original_File"
names(lf_fips.df)[3] <- "Hospital_Name"
names(lf_fips.df)[15] <- "zipcode"

#Here we do the merge

unique(lf_fips.df$zipcode)
unique(fips.dta$zipcode)

#Need to add leading zeros to zip codes in lf_fips.df

library(stringr)
lf_fips.df$zipcode <- str_pad(lf_fips.df$zipcode, width = 5, pad = "0") #Adds leading zeros if to left if number less than 5

#Merge 

lf_fips_done.df <- left_join(lf_fips.df, fips.dta)

save(lf_fips_done.df, file = "/Users/georgejacobs/Desktop/Hospital Compare Scores - Friedson/DateExcel/HQI_MSR_XWLK/Joined_Lefthand_FIPS.RData")
