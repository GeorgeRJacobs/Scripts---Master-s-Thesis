#Summary Statistics of MA dataset - Not the Whole County

load("/Users/georgejacobs/Desktop/Hospital Compare Scores - Friedson/DateExcel/HQI_MSR_XWLK/MA_ALL.RData") #Dataset

library(stargazer)
library(plyr)
library(dplyr)
library(ggmap)
library(maps)
library(ggplot2)

#Let's explore the structure of the variables and what they are doing!

ma.reduce <- select(everything.ma.df, -Original_File, -Condition, -Date.x, -.id, -Phone.Number, -Date.y, -city) 
ma <- select(ma.reduce, -X90..CI.Lower.Bound, -X90..CI.Upper.Bound.1, 
	-X90..CI.Lower.Bound.2, -X90..CI.Upper.Bound.3, -X90..CI.Lower.Bound.4,
	-X90..CI.Upper.Bound.5, -X90..CI.Lower.Bound.6, -X90..CI.Upper.Bound.7, 
	-X90..CI.Lower.Bound.8, -X90..CI.Upper.Bound, -X90..CI.Lower.Bound.1, 
	-X90..CI.Upper.Bound.2, -X90..CI.Lower.Bound.3, -X90..CI.Upper.Bound.4, 
	-X90..CI.Lower.Bound.5, -X90..CI.Upper.Bound.6, -X90..CI.Lower.Bound.7, 
	-X90..CI.Upper.Bound.8) 

rm(everything.ma.df, ma.reduce) #Doesn't take up space 

#Remember - SAHIE goes thru 2013 - 2014 is useless

ma <- ma[!ma$year == "2014",] #Removes these observations

#I want that graph of state uninsurance over years - Can add more to this graph later on 
#Let's put that together first

state <- read.csv("/Users/georgejacobs/Desktop/Hospital Compare Scores - Friedson/DateExcel/HQI_MSR_XWLK/STATELEVELUNINSURANCE.csv", stringsAsFactors = F)

p <- ggplot(state, aes(x=factor(YEAR), y=Percent, group=LOCATION)) 
p + geom_line() + labs(title = "Comparison of Uninsurance Rates", x = "Year", y = "Percent Uninsured") + 
	scale_y_continuous(breaks=c(0:18)) + geom_vline(xintercept = 8, colour = "blue") + scale_colour_brewer() + #specify x axis with number for character vector
	annotate("text", x = 14, y = 14, label = "USA", size = 4) + 
	annotate("text", x = 14, y = 6, label = "MA", size = 4) +
	annotate("text", x = 9, y = 12, label = "Health Reform", size = 4)

#Reading in date from excel - copy and paste job FYI

