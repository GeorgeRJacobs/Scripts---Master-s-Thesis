#Merge of the Lefthandside Vars with the Right Hand Side Stuff

load("/Users/georgejacobs/Desktop/Hospital Compare Scores - Friedson/DateExcel/HQI_MSR_XWLK/Joined_Lefthand_FIPS.RData")
load("/Users/georgejacobs/Desktop/Hospital Compare Scores - Friedson/DateExcel/HQI_MSR_XWLK/Merged Datasets/Righthandsidevariables.RData")

#Treat Fips codes as Numeric to make the merge easier!

lf_fips_done.df$statefips <- as.numeric(lf_fips_done.df$statefips)
lf_fips_done.df$countyfips <- as.numeric(lf_fips_done.df$countyfips)

#

unique(righthandside.df$year)
unique(lf_fips_done.df$Year)

lf_fips_done.df$Year <- as.Date(lf_fips_done.df$Datet, "%Y-%m-%d")
lf_fips_done.df$Year <- format(lf_fips_done.df$Year, "%Y")

library(dplyr)
names(righthandside.df)
names(lf_fips_done.df)

#Renaming some columns here

lf <- rename(lf_fips_done.df, State.FIPS = statefips,
	County.FIPS = countyfips,
	year = Year) 

righthandside.df$year <- as.character(righthandside.df$year)
unique(righthandside.df$year) #Checking the different values

#Reduce down number of columns for later on Left Hand Side Variables

lf.reduce.df <- select(lf, -Original_File, -Condition, -Date.x, -.id, -Phone.Number, -Date.y, -city) 
rf.reduce.df <- select(righthandside.df, -X90..CI.Lower.Bound, -X90..CI.Upper.Bound.1, 
	-X90..CI.Lower.Bound.2, -X90..CI.Upper.Bound.3, -X90..CI.Lower.Bound.4,
	-X90..CI.Upper.Bound.5, -X90..CI.Lower.Bound.6, -X90..CI.Upper.Bound.7, 
	-X90..CI.Lower.Bound.8, -X90..CI.Upper.Bound, -X90..CI.Lower.Bound.1, 
	-X90..CI.Upper.Bound.2, -X90..CI.Lower.Bound.3, -X90..CI.Upper.Bound.4, 
	-X90..CI.Lower.Bound.5, -X90..CI.Upper.Bound.6, -X90..CI.Lower.Bound.7, 
	-X90..CI.Upper.Bound.8) 

setwd("/Users/georgejacobs/Desktop")
write.csv(lf.reduce.df, file = "lefthand_final.csv")
write.csv(rf.reduce.df, file = "righthand_final.csv")  #For Friedson and Me

write.table(lf.reduce.df, file = "lefthand_final.txt", sep="\t") #Tab delimited
write.table(rf.reduce.df, file = "righthand_final.txt", sep="\t")

#MA - FIP = 25

lf.ma.df <- subset(lf, lf$State.FIPS == 25)
unique(lf$State.FIPS)



#everything.ma.df <-  merge(x = lf, y = righthandside.df, all.x = TRUE) #Massive File - Why it sucks
everything.ma.df <- left_join(lf.ma.df, righthandside.df)

save(everything.ma.df, file = "/Users/georgejacobs/Desktop/Hospital Compare Scores - Friedson/DateExcel/HQI_MSR_XWLK/MA_ALL.RData")
