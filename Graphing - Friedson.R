#Script for Histograms - R - Missing Values Analysis 
library(dplyr)
file.choose()

load("/Users/georgejacobs/Desktop/Hospital Compare Scores - Friedson/DateExcel/HQI_MSR_XWLK/Hospital Structure/Lefthandside.RData")
str(lefthandside.df)

unique(lefthandside.df$Score)
lefthandside.df$Score[lefthandside.df$Score == "Too few cases"] <- ""
lefthandside.df$Score[lefthandside.df$Score == "Not Available"] <- ""
lefthandside.df$Score[lefthandside.df$Score == "N/A"] <- ""



lefthandside.df$na <- NA
lefthandside.df$na[lefthandside.df$Score == ""] <- "1"
lefthandside.df$na[!lefthandside.df$Score == ""] <- "0"
lefthandside.df$na <- as.numeric(lefthandside.df$na)

lefthandside.df$Score <- as.numeric(lefthandside.df$Score)

lefthandside.df$Score <- as.numeric(lefthandside.df$Score) #28.7 NA for ALL values!!

library(psych)
describeBy(lefthandside.df$na, lefthandside.df$Measure.Code) #Some Measures are more likely to have NA than others!!!

unique(lefthandside.df$Measure.Code) #All should be accounted for !


#Average for Each Measure and Year

lefthandside.df$Datet <- as.Date(lefthandside.df$Datet, format = "%Y-%m-%d")
lefthandside.df$Year <- format(lefthandside.df$Datet, "%Y")

lf.df <- lefthandside.df %>% group_by(Measure.Code, Year, Provider.Number) %>%
	summarise(Average_Score = mean(Score, na.rm = T)) %>%
	arrange(Provider.Number)

lf.df <- as.data.frame(lf.df)
lf.df$Year <- factor(lf.df$Year) #So we can graph the Kernel Densities - needs as plain Data.Frame

library(Kmisc)
setwd("/Users/georgejacobs/Desktop/")
a <- describeBy(lefthandside.df$na, lefthandside.df$Measure.Code, mat =T) #NAs by Measure Code Matrix
library(reshape2)
b <- lefthandside.df %>% group_by(Measure.Code, Year) %>%
	summarise(Count = n()) #NAs by Measure Code Matrix

c <- lefthandside.df %>% group_by(Measure.Code, Datet) %>%
	summarise(Count = n()) #NAs by Measure Code Matrix

setwd("/Users/georgejacobs/Desktop/Hospital Compare Scores - Friedson/DateExcel/HQI_MSR_XWLK")
c <- dcast(c, Measure.Code ~ Datet)
b <- dcast(b, Measure.Code ~ Year) #Rocks
write.csv(c, file = "Matrix_qtr.csv")
write.csv(b, file = "Matrix_year.csv") 
write.csv(a, file = "matrix_na.csv")
#Graphs - Histograms for Each Measure

#AMI Scores

AMI_1 <- lf.df[lf.df$Measure.Code == "AMI_1", ]
AMI_10 <- lf.df[lf.df$Measure.Code == "AMI_10", ]
AMI_2 <- lf.df[lf.df$Measure.Code == "AMI_2", ]
AMI_3 <- lf.df[lf.df$Measure.Code == "AMI_3", ]
AMI_4 <- lf.df[lf.df$Measure.Code == "AMI_4", ]
AMI_5 <- lf.df[lf.df$Measure.Code == "AMI_5", ]
AMI_6 <- lf.df[lf.df$Measure.Code == "AMI_6", ]
AMI_7a <- lf.df[lf.df$Measure.Code == "AMI_7a", ]
AMI_8a <- lf.df[lf.df$Measure.Code == "AMI_8a", ]


#Heart Failures
HF_1 <- lf.df[lf.df$Measure.Code == "HF_1", ]
HF_2 <- lf.df[lf.df$Measure.Code == "HF_2", ]
HF_3 <- lf.df[lf.df$Measure.Code == "HF_3", ]
HF_4 <- lf.df[lf.df$Measure.Code == "HF_4", ]

#HEART ATTACK - NEW
OP_1 <- lf.df[lf.df$Measure.Code == "OP_1", ]
OP_2 <- lf.df[lf.df$Measure.Code == "OP_2", ]
OP_3 <- lf.df[lf.df$Measure.Code == "OP_3", ]
OP_4 <- lf.df[lf.df$Measure.Code == "OP_4", ]
OP_5 <- lf.df[lf.df$Measure.Code == "OP_5", ]
OP_7 <- lf.df[lf.df$Measure.Code == "OP_7", ]

#PNEUMONIA
PN_1 <- lf.df[lf.df$Measure.Code == "PN_1", ]
PN_2 <- lf.df[lf.df$Measure.Code == "PN_2", ]
PN_3b <- lf.df[lf.df$Measure.Code == "PN_3b", ]
PN_4 <- lf.df[lf.df$Measure.Code == "PN_4", ]
PN_5 <- lf.df[lf.df$Measure.Code == "PN_5", ]
PN_6 <- lf.df[lf.df$Measure.Code == "PN_6", ]
PN_7 <- lf.df[lf.df$Measure.Code == "PN_7", ]

#SURGICAL

SCIP_CARD_2 <- lf.df[lf.df$Measure.Code == "SCIP_CARD_2", ]
SCIP_INF_1 <- lf.df[lf.df$Measure.Code == "SCIP_INF_1", ]
SCIP_INF_2 <- lf.df[lf.df$Measure.Code == "SCIP_INF_2", ]
SCIP_INF_3 <- lf.df[lf.df$Measure.Code == "SCIP_INF_3", ]
SCIP_INF_4 <- lf.df[lf.df$Measure.Code == "SCIP_INF_4", ]
SCIP_INF_6 <- lf.df[lf.df$Measure.Code == "SCIP_INF_6", ]
SCIP_INF_9 <- lf.df[lf.df$Measure.Code == "SCIP_INF_9", ]
SCIP_VTE_1 <- lf.df[lf.df$Measure.Code == "SCIP_VTE_1", ]
SCIP_VTE_2 <- lf.df[lf.df$Measure.Code == "SCIP_VTE_2", ]

STK_1 <- lf.df[lf.df$Measure.Code == "STK_1", ]

#Group into Year Categories for each Measure

#AUTOMATIC FUNCTION FOR DOING THIS PROCESS EVERYTIME

hist.graph.george <- function (data.frame.g) {
s2005 <- data.frame.g[data.frame.g$Year == "2005",]
s2006 <- data.frame.g[data.frame.g$Year == "2006",] #Set Y labels to the same Length!
s2008 <- data.frame.g[data.frame.g$Year == "2008",]
s2010 <- data.frame.g[data.frame.g$Year == "2010",]
s2012 <- data.frame.g[data.frame.g$Year == "2012",]
s2014 <- data.frame.g[data.frame.g$Year == "2014",]
par(mfrow=c(3,2))
hist(s2005$Average_Score, ylim = c(0,2000))
hist(s2006$Average_Score, ylim = c(0,2000))
hist(s2008$Average_Score, ylim = c(0,2000))
hist(s2010$Average_Score, ylim = c(0,2000))
hist(s2012$Average_Score, ylim = c(0,2000))
hist(s2014$Average_Score, ylim = c(0,2000)) }

#Kernel Plot Density Estimate Function
kernel.george <- function(data.frame.g) {
m <-  ggplot(data.frame.g, aes(x = Average_Score, colour = Year, group = Year))
m + geom_density(fill = NA) + coord_cartesian(xlim=c(70, 110))
}

kernel.george.small <- function(data.frame.g) {
m <-  ggplot(data.frame.g, aes(x = Average_Score, colour = Year, group = Year))
m + geom_density(fill = NA) + coord_cartesian(xlim=c(90, 102))
}

#Can use lapply to make graphs! MORE IMPORTANTLY - SHOULD USE FOR LOOP SINCE NOT RETURNING A VALUE FROM LAPPLY HACKY SOLUTION
a <- list(AMI_1, AMI_10, AMI_2, AMI_3, AMI_4, AMI_5, AMI_6, AMI_7a, AMI_8a)
b <- list(HF_1, HF_4, HF_2, HF_3)
d <- list(OP_1, OP_2, OP_3, OP_4, OP_5, OP_7)
e <- list(PN_1, PN_2, PN_3b, PN_4, PN_5, PN_6, PN_7)
f <- list(SCIP_CARD_2, SCIP_INF_1, SCIP_INF_2, SCIP_INF_3, SCIP_INF_4, SCIP_INF_6, SCIP_INF_9, SCIP_VTE_1, SCIP_VTE_2)


kernel.george(a) #AMI
kernel.george(b) #HF
kernel.george(c) #OP
kernel.george(d) #PN
kernel.george(e) #Surgical
