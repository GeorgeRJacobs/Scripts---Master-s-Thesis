library(dplyr)



setwd("/Users/georgejacobs/Desktop/Hospital Compare Scores - Friedson/DateExcel/HQI_MSR_XWLK/Hospital Structure")
#setwd("/Users/georgejacobs/Desktop/Hospital Compare Scores - Friedson/DateExcel/HQI_MSR_XWLK")


#Loading in the dataset - bcoded.RData

load("/Users/georgejacobs/Desktop/Hospital Compare Scores - Friedson/DateExcel/HQI_MSR_XWLK/bcoded.Rdata")


#HouseKeeping - Removed some things bothering Friedson - Wants the code "Ready to Compute"
all$Measure.Code <- gsub("-" , "_", all$Measure.Code)
all$Sample <- sub("\\spatients", "", all$Sample)
all$Score <- sub("%", "", all$Score)

#Code from the Hospital Structure Combination Script

all$Provider.Number <- gsub("'", "", all$Provider.Number) #Deletes the quotation marks on all the Provider.Numbers
all$Provider.Number<- sub("^0", "", all$Provider.Number) #Deletes Leading Zero
grep("\\<0", all$Provider.Number) # Checking...
grep("'", all$Provider.Number) # Checking...
grep("\\'", all$Provider.Number)

library(stringr) #Wickham's Regular Expression Machine

all[] <- lapply(all, str_trim) # Trims both Leading/Trailing Whitespace

#all$na <- NA USEFUL CHECK HERE
#all$na[all$Score == ""] <- "1"
#all$na[!all$Score == ""] <- "0"
#all$na <- as.numeric(all$na)

#Noticed that the Provider Numbers didn't come over 100% Properly
#Need to make sure they Match across years

#Use the Hospital Structure CSV to attach correct Numbers!

#Saving files

#Treating the Sample Number as Numeric - Obviously NAs will be coerced
#all$Sample <- as.numeric(all$Sample)
#all$Score <- as.numeric(all$Score)

summary(all.test.ami1$Score)
#Plots
View(table(all$Measure.Code, all$Datet)) #Gives an Idea of what is there by year - Check Zeros and why they are there
																				 #Fucking Gold Man

all$Measure.Code <- sub("AMI_7A", "AMI_7a", all$Measure.Code)
all$Measure.Code <- sub("AMI_8A", "AMI_8a", all$Measure.Code)
all$Measure.Code <- sub("PN_3B", "PN_3b", all$Measure.Code)
all$Measure.Code <- sub("PN_5c", "PN_5", all$Measure.Code)
all$Measure.Code <- sub("PN_5b", "PN_5", all$Measure.Code)
all$Measure.Code <- sub("PN_5C", "PN_5", all$Measure.Code)
all$Measure.Code <- sub("OP_3b", "OP_3", all$Measure.Code)
all$Measure.Code <- sub("SCIP-CARD-2", "SCIP_CARD_2", all$Measure.Code)
all$Measure.Code <- sub("SCIP_CARD-2", "SCIP_CARD_2", all$Measure.Code)
all$Measure.Code <- sub("SCIP-INF-2", "SCIP_INF_2", all$Measure.Code)
all$Measure.Code <- sub("SCIP-INF-1", "SCIP_INF_1", all$Measure.Code)
all$Measure.Code <- sub("SCIP-INF-10", "SCIP_INF_10", all$Measure.Code)

#Have to code in the Footnotes here
#one <- grep("1", all$Footnote)
#all$Score[one] <- NA

#Checking the values
unique(all$Measure.Code)
all[is.na(all$Measure.Code),]
all[is.na(all$Measure.Name),]
names(all)

library(ggplot2)

unique(all$Score)

all.test.ami1 <- all[all$Measure.Code == "PN_6",]
summary(all.test.ami1)
View(all.test.ami1)
all.test.ami1 <- all.test.ami1[all.test.ami1$Date == "4/17/14" | all.test.ami1$Date == "9/1/05",] #First and Last Dates 
View(table(all.test.ami1$Score, all.test.ami1$Date, exclude = NULL))

ggplot(all.test.ami1, aes(Score, colour = Datet)) +
  geom_density()

save(all, file = "CombinedMeasure.RData")
rm(list = ls())




