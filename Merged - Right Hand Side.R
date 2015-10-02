#Putting together the Right Hand Side Variables

load("/Users/georgejacobs/Desktop/Hospital Compare Scores - Friedson/DateExcel/HQI_MSR_XWLK/Small Area Health Insurance Estimates/SAHIE.RData")
load("//Users/georgejacobs/Desktop/Hospital Compare Scores - Friedson/DateExcel/HQI_MSR_XWLK/Small Area Population Estimates/SAIPE - POVERTY_INCOME/SAPIE_FULL_RBIND.RData")
load("/Users/georgejacobs/Desktop/Hospital Compare Scores - Friedson/DateExcel/HQI_MSR_XWLK/Unemployment - By County/Unemployment.RData")

setwd("/Users/georgejacobs/Desktop/Hospital Compare Scores - Friedson/DateExcel/HQI_MSR_XWLK/Merged Datasets") #Where I am putting Right Hand Side Variables

#rename Year to year

master.df.uemp <- rename(master.df.uemp, year = Year) #Making the column names be the same
master.df <- rename(master.df, State.FIPS = StateFIP, #Now we can merge on three different columns
	County.FIPS = CountyFIP)

master.df.sapie$State.FIPS <- as.numeric(master.df.sapie$State.FIPS) #Coercing to a numeric - NAs introduced because of some text in the column
master.df.sapie <- master.df.sapie[!is.na(master.df.sapie$State.FIPS),]

str(master.df.uemp)
str(master.df)
str(master.df.sapie)

unique(master.df.sapie$State.FIPS) #Checking columns for things that shouldn't be there
unique(master.df$State.FIPS)
unique(master.df.uemp$State.FIPS) #Includes Puerto Rico - A Territory
																	#When joining - this shouldn't be joined over 

identical(unique(master.df.sapie$County.FIPS), unique(master.df$County.FIPS))

unique(master.df.sapie$County.FIPS)
unique(master.df.uemp$County.FIPS)
unique(master.df$County.FIPS)

righthandside.df <- left_join(master.df, master.df.sapie) #Looking Good
righthandside.df <- left_join(righthandside.df, master.df.uemp) # FIPS = 0 indicates Country - State respectively - Hence NAs

View(righthandside.df)
View(master.df.sapie)
View(master.df)
View(master.df.uemp)

save(righthandside.df, file = "Righthandsidevariables.RData") # Remember 2005 has more limited data Uninsurance by INC levels


