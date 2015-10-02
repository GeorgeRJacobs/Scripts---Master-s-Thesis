library(dplyr)

setwd("/Users/georgejacobs/Desktop/Hospital Compare Scores - Friedson/DateExcel/HQI_MSR_XWLK")



#save(raw, file = "raw.Rdata")


#Loading in the dataset

load("/Users/georgejacobs/Desktop/Hospital Compare Scores - Friedson/DateExcel/HQI_MSR_XWLK/raw.Rdata")


#Cleaning - There are some weird headings on Measure.Name for some reason
#Regular expression searching for this heading that is weird.

msr$Measure.Name <- sub(".*png>", "", msr$Measure.Name)


#Looking a subset to backwards code in from before! - AMI, SCIP, ETC

test <- msr
test <- test[is.na(test$Measure.Code),]
raw3 <- msr[!is.na(msr$Measure.Code),]
View(raw3)
#Weird Naming on the Levels

test$Condition <- sub("Children&#8217;s Asthma Care", "ChildrensAsthmaCare", test$Condition)
test$Condition <- sub("Heart Attack.*Care", "HeartAttack", test$Condition)
test$Condition <- sub("Heart Attack", "HeartAttack", test$Condition)
test$Condition <- sub("Heart Failure Care", "HeartFailure", test$Condition)
test$Condition <- sub("Heart Failure", "HeartFailure", test$Condition)
test$Condition <- sub("Pneumonia Care", "Pneumonia", test$Condition)
test$Condition <- sub("Surgical Infection Prevention", "Surgical", test$Condition)
test$Condition <- factor(test$Condition)
levels(test$Condition)

#Have to split data on condition - different coding for those different condition

test.l <- split(test, test$Condition)

#Now Test is split based on the empty levels in 2005 - going to add measure codes now
#We now have a list structure that is split on the Condition type 


##########################BACKCODING####################################




####################################################################################################
#Formatting of the data before assignment of values!!
####################################################################################################
test.l$HeartAttack$Measure.Code<- as.character(test.l$HeartAttack$Measure.Code)
test.l$Surgical$Measure.Code<- as.character(test.l$Surgical$Measure.Code)
test.l$Pneumonia$Measure.Code<- as.character(test.l$Pneumonia$Measure.Code)
####################################################################################################

####################################################################################################
#Let's start backcoding - using documentation in 03012009 - By type of Condition - I love lists!!

#####################################################################
########################Heart Attack#################################
#####################################################################

ami1 <- grep(".*Aspirin at Arrival", test.l$HeartAttack$Measure.Name)
ami2 <- grep(".*Aspirin at Discharge", test.l$HeartAttack$Measure.Name)
ami3 <- grep(".*ACE.*", test.l$HeartAttack$Measure.Name)
ami4 <- grep(".*Adult.*Counseling", test.l$HeartAttack$Measure.Name)
ami4a <- grep("Heart Attack Patients Given Smoking Cessation.*", test.l$HeartAttack$Measure.Name)
ami4b <- grep("Patients Given Smoking Cessation Advice/Counseling.*", test.l$HeartAttack$Measure.Name)
ami5 <- grep(".*Beta Blocker at Discharge", test.l$HeartAttack$Measure.Name)
ami6 <- grep(".*Beta Blocker at Arrival", test.l$HeartAttack$Measure.Name)
ami7 <- grep(".*Fibrinolytic Medication Within 30 Minutes Of Arrival", test.l$HeartAttack$Measure.Name)
ami7b <- grep(".*Thrombolytic.*", test.l$HeartAttack$Measure.Name)
ami8b <- grep(".*PCI Within 120 Minutes Of Arrival", test.l$HeartAttack$Measure.Name)
ami8d <- grep("Heart Attack Patients Given PCI Within 90 Minutes.*", test.l$HeartAttack$Measure.Name)
ami8c <- grep(".*PTCA.*", test.l$HeartAttack$Measure.Name)
ami9 <- grep(".*mortality", test.l$HeartAttack$Measure.Name)

#Actual Code Changes!!---------------------------------------------------------------
#################################################################################################

test.l$HeartAttack$Measure.Code[ami1] <- "AMI-1"
test.l$HeartAttack$Measure.Code[ami2] <- "AMI-2"
test.l$HeartAttack$Measure.Code[ami3] <- "AMI-3"
test.l$HeartAttack$Measure.Code[ami4] <- "AMI-4"
test.l$HeartAttack$Measure.Code[ami4a] <- "AMI-4"
test.l$HeartAttack$Measure.Code[ami4b] <- "AMI-4"
test.l$HeartAttack$Measure.Code[ami5] <- "AMI-5"
test.l$HeartAttack$Measure.Code[ami6] <- "AMI-6"
test.l$HeartAttack$Measure.Code[ami7] <- "AMI-7A"
test.l$HeartAttack$Measure.Code[ami7b] <- "AMI-7A"
test.l$HeartAttack$Measure.Code[ami8c] <- "AMI-8A"
test.l$HeartAttack$Measure.Code[ami8b] <- "AMI-8A"
test.l$HeartAttack$Measure.Code[ami8d] <- "AMI-8A"
test.l$HeartAttack$Measure.Code[ami9] <- "AMI-9"

#####################################################################
#________________________Heart Failure_______________________________
#####################################################################

hf3 <- grep("Patients Given ACE Inhibitor or ARB for Left Ventricular Systolic Dysfunction", test.l$HeartFailure$Measure.Name)
hf3b <- grep(".*ACE.*", test.l$HeartFailure$Measure.Name)
hf2 <- grep("Patients Given An Evaluation of Left Ventricular Systolic (LVS) Function", test.l$HeartFailure$Measure.Name)
hf2b <- grep(".*Left Ventricular Function.*", test.l$HeartFailure$Measure.Name)
hf2c <- grep(".*Evaluation of Left Ventricular.*", test.l$HeartFailure$Measure.Name)
hf1 <- grep(".*Discharge Instructions", test.l$HeartFailure$Measure.Name)
hf4 <- grep(".*Smoking.*", test.l$HeartFailure$Measure.Name)

#Actual Code Changes!!---------------------------------------------------------------
#####################################################################################

test.l$HeartFailure$Measure.Code[hf3] <- "HF-3"
test.l$HeartFailure$Measure.Code[hf3b] <- "HF-3"
test.l$HeartFailure$Measure.Code[hf2] <- "HF-2"
test.l$HeartFailure$Measure.Code[hf2b] <- "HF-2"
test.l$HeartFailure$Measure.Code[hf2c] <- "HF-2"
test.l$HeartFailure$Measure.Code[hf1] <- "HF-1"
test.l$HeartFailure$Measure.Code[hf4] <- "HF-4"

#####################################################################
#________________________Surgery_______________________________######
#####################################################################

SCIP1 <- grep(".*Before Incision", test.l$Surgical$Measure.Name)
test.l$Surgical$Measure.Name <- sub("Surgery Patients who Received the Appropriate.*", "Surgery Patients Who Received the Appropriate Preventative Antibiotic(s) for Their Surgery", test.l$Surgical$Measure.Name)
SCIP2 <- grep("Surgery Patients Who Received the Appropriate.*", test.l$Surgical$Measure.Name)
SCIP3<- grep(".*Stopped Within 24 hours After Surgery", test.l$Surgical$Measure.Name)
SCIPv1 <- grep("Surgery Patients Whose Doctors Ordered Treatments to Prevent Blood Clots.*", test.l$Surgical$Measure.Name)
SCIPv2<- grep("Surgery Patients Who Received Treatment To Prevent Blood Clots Within 24 Hours Before or After Selected Surgeries to Prevent Blood Clots", test.l$Surgical$Measure.Name)

#Actual Code Changes!!---------------------------------------------------------------
#####################################################################################

test.l$Surgical$Measure.Code[SCIP1] <- "SCIP-INF-1"
test.l$Surgical$Measure.Code[SCIP2] <- "SCIP-INF-2"
test.l$Surgical$Measure.Code[SCIP3] <- "SCIP-INF-3"
test.l$Surgical$Measure.Code[SCIPv1] <- "SCIP-VTE-1"
test.l$Surgical$Measure.Code[SCIPv2] <- "SCIP-VTE-2"

#####################################################################################
#####################################################################################
#Formatting and Viewing of the Data Points!!!



#####################################################################
#________________________Pneumonia_______________________________#### Aside: Regex can't read captured groups () THe more you know!
#####################################################################

PN1a <- grep("Oxygenation Assessment", test.l$Pneumonia$Measure.Name)
PN7 <- grep("Pneumonia Patients Assessed and Given Influenza Vaccination", test.l$Pneumonia$Measure.Name)
PN2 <- grep("Patients Assessed and Given Pneumococcal Vaccination", test.l$Pneumonia$Measure.Name)
PN2a<- grep("Pneumococcal Vaccination", test.l$Pneumonia$Measure.Name)
PN5c <- grep("Patients Given Initial Antibiotic.*within 6 Hours After Arrival", test.l$Pneumonia$Measure.Name)
PN5b <- grep("Patients Given Initial Antibiotic.*within 4 Hours After Arrival", test.l$Pneumonia$Measure.Name)
PN5 <- grep("Initial Antibiotic Timing", test.l$Pneumonia$Measure.Name)
PN1 <- grep("Patients Given Oxygenation Assessment", test.l$Pneumonia$Measure.Name)
PN4 <- grep(".*Patients Given.*Smoking Cessation.*", test.l$Pneumonia$Measure.Name)
PN4a <- grep(".*Adult Smoking Cessation.*", test.l$Pneumonia$Measure.Name)
PN6 <- grep("Patients Given the Most Appropriate Initial Antibiotic.*", test.l$Pneumonia$Measure.Name)
PN3b <- grep(".*Patients Whose Initial Emergency Room Blood Culture Was Performed Prior to the Administration of the First Hospital Dose of Antibiotics", test.l$Pneumonia$Measure.Name)
PN3ba <- grep("Patients Having a Blood Culture Performed Prior to.*Hospital", test.l$Pneumonia$Measure.Name)
PN3bb <- grep(".*Patients Whose Initial Emergency Room Blood Culture Was Performed Prior To The Administration Of The First Hospital Dose Of Antibiotics", test.l$Pneumonia$Measure.Name)
PN3bc <- grep("Blood Cultures Performed Before First Antibiotic Received", test.l$Pneumonia$Measure.Name)


#Actual Code Changes!!---------------------------------------------------------------
#####################################################################################

test.l$Pneumonia$Measure.Code[PN7] <- "PN-7"
test.l$Pneumonia$Measure.Code[PN2] <- "PN-2"
test.l$Pneumonia$Measure.Code[PN2a] <- "PN-2"
test.l$Pneumonia$Measure.Code[PN5] <- "PN-5"
test.l$Pneumonia$Measure.Code[PN5b] <- "PN-5b"
test.l$Pneumonia$Measure.Code[PN5c] <- "PN-5c"
test.l$Pneumonia$Measure.Code[PN1] <- "PN-1"
test.l$Pneumonia$Measure.Code[PN4] <- "PN-4"
test.l$Pneumonia$Measure.Code[PN4a] <- "PN-4"
test.l$Pneumonia$Measure.Code[PN6] <- "PN-6"
test.l$Pneumonia$Measure.Code[PN3b] <- "PN-3b"
test.l$Pneumonia$Measure.Code[PN3ba] <- "PN-3b"
test.l$Pneumonia$Measure.Code[PN3bb] <- "PN-3b"
test.l$Pneumonia$Measure.Code[PN3bc] <- "PN-3b"
test.l$Pneumonia$Measure.Code[PN1a] <- "PN-1"

#####################################################################
#######____________________Children Asthma___________________########
#####################################################################

CAC1 <- grep(".*Children Who Received Reliever Medication While Hospitalized for Asthma", test.l$ChildrensAsthmaCare$Measure.Name)
CAC2 <- grep(".*Children Who Received Systemic Corticosteroid Medication.*While Hospitalized for Asthma", test.l$ChildrensAsthmaCare$Measure.Name)


#Actual Code Changes!!---------------------------------------------------------------
#####################################################################################

test.l$ChildrensAsthmaCare$Measure.Code[CAC1] <- "CAC-1"
test.l$ChildrensAsthmaCare$Measure.Code[CAC2] <- "CAC-2"

#####################################################################################
#####################################################################################
#Formatting and Viewing of the Data Points!!!



View(test.l$HeartAttack[is.na(test.l$HeartAttack$Measure.Code),]) 
View(test.l$HeartFailure[is.na(test.l$HeartFailure$Measure.Code),])
View(test.l$Surgical[is.na(test.l$Surgical$Measure.Code),])
View(test.l$Pneumonia[is.na(test.l$Pneumonia$Measure.Code),])
View(test.l$ChildrensAsthmaCare[is.na(test.l$ChildrensAsthmaCare$Measure.Code),])


#Saving of the Backcoding Work!!!!!!!!!!!!!!!!!!!!
#Always at the end of the script!!!!!!1

library(data.table)
comp <- rbindlist(test.l)

View(comp)
comp <- as.data.frame(comp)
all <- rbind(raw3, comp)
View(all)

#Checking all Dates are there!
all.na <- all[is.na(all$Date),]
all.nna <- all[!is.na(all$Date),]
View(all.na)
View(all.nna)

all$Datet <- as.Date(all$Date , format = "%m/%d/%y")
all 
all <- arrange(all, desc(Datet))



#ball.na <- all[all$Date=="4/17/14",] #RECHECK
#all.na$Date <- "4/17/14"
#all.na$Date <- as.Date(all.na$Date,  format = "%d/%m/%y")


##^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#Looks like 2014/04/01 (4/17) does not have a date - Also Provider.Number is wrong


#Recombine Dataset!

#All <- rbind(all.na, all.nna)
#View(All[is.na(All$Date),]) #Check to see if any are missing!!!!!

#All <- arrange(All, desc(Date))

#View(All)

save(all, file = "bcoded.Rdata") # Not 100% Done
#write.dta(all, file = "MSR.dta")
