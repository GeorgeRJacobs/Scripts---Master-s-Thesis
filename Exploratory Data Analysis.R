#Exploratory - Playing Around with the Data
library(plyr)
library(dplyr)
library(psych)


load("/Users/georgejacobs/Desktop/Hospital Compare Scores - Friedson/DateExcel/HQI_MSR_XWLK/Hospital Structure/Lefthandside.RData")

lefthandside.df$Datet <- as.Date(lefthandside.df$Datet, "%Y-%m-%d")
library(lubridate)
lefthandside.df$Year <- format(lefthandside.df$Datet, "%Y") 

year <- lefthandside.df %>% group_by(Provider.Number, Year, Measure.Code) %>% #Creates a year category, and this is how you aggregate
	summarise(Average_Score = mean(Score))

lefthandside.df$na <- NA
lefthandside.df$na[is.na(lefthandside.df$Score)] <- "1"
lefthandside.df$na[!is.na(lefthandside.df$Score)] <- "0"

lefthandside.df$na <- as.numeric(lefthandside.df$na)

save(lefthandside.df, file = "Lefthandsidevars.RData")
table(lefthandside.df$na, lefthandside.df$Datet) #Shows the NA values



#Perform a by the measure approach

hf_1 <- lefthandside.df[lefthandside.df$Measure.Code == "HF_1", ]
cn <- hf_1[hf_1$State == "CT",]
ma <- hf_1[hf_1$State == "MA",]

table(ma$Provider.Number , ma$Datet)

t <- hf_1[!is.na(hf_1$Score),]

table(hf_1$na, hf_1$Datet) #Shows the NA values
View(table(hf_1$Provider.Number, hf_1$na))


describeBy(hf_1, hf_1$Datet) #Library(psych) very nifty
describeBy(cn, cn$Datet) #Library(psych) very nifty

d <- hf_1 %>% group_by(Provider.Number, Year) %>%
	summarise(AVG = mean(Score))

e <- hf_1 %>% group_by(Year) %>%
	summarise(AVG = mean(Score))

View(hf_1)

#Creating Pictures of the Distribution
library(ggplot2)

hist(s2005$Score)
hist(s2008$Score)
hist(s2013$Score)

s2005 <- hf_1[hf_1$Year == "2005",] #Set Y labels to the same Length!
s2008 <- hf_1[hf_1$Year == "2008",]
s2013 <- hf_1[hf_1$Year == "2013",]

hist(s2005$Score, ylim = c(0,4000))
hist(s2008$Score, ylim = c(0,4000))
hist(s2013$Score, ylim = c(0,4000))

ggplot(s2005 , aes(x=s2005$Score, fill=s2005$Year))+geom_histogram()
ggplot(s2008 , aes(x=s2008$Score, fill=s2008$Year))+geom_histogram()
