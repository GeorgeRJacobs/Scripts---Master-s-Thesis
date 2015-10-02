library(dplyr)

#all$Provider.Number <- as.numeric(all$Provider.Number)
#Hstr$Provider.Number <- as.numeric(Hstr$Provider.Number)

load("/Users/georgejacobs/Desktop/Hospital Compare Scores - Friedson/DateExcel/HQI_MSR_XWLK/Hospital Structure/CombinedMeasure.RData")
load("/Users/georgejacobs/Desktop/Hospital Compare Scores - Friedson/DateExcel/HQI_MSR_XWLK/Hospital Structure/Hosp_Str_EndofScriptt1.RData")
load("/Users/georgejacobs/Desktop/Hospital Compare Scores - Friedson/DateExcel/HQI_MSR_XWLK/Hospital Structure/Hosp_Str_EndofScriptt2.RData")

all$na <- NA #USEFUL CHECK HERE
all$na[all$Score == ""] <- "1"
all$na[!all$Score == ""] <- "0"
all$na <- as.numeric(all$na)

all_str.D <- left_join(all, trial1, by="Provider.Number")
#all_str.E <- left_join(all, trial2, by="Hospital.Name")
View(all_str.D)

#There are some NA's, Looking at the reason why - Probably Hospitals that Don't Exist in the Study in 2014

na <- all_str.D[is.na(all_str.D$Hospital.Name.y),]
full <- all_str.D[!is.na(all_str.D$Hospital.Name.y),]

na$Provider.Number <- sub("50768", "050768", na$Provider.Number) #By Hand - Recodes That I matched Myself
na$Provider.Number <- sub("30128", "030128", na$Provider.Number) #Still there are Some Hospitals that are missing
na$Provider.Number <- sub("30129", "030129", na$Provider.Number)
na$Provider.Number <- sub("50125", "050215", na$Provider.Number)
na$Provider.Number <- sub("50077", "050270", na$Provider.Number)
na$Provider.Number <- sub("50125", "050215", na$Provider.Number)
na$Provider.Number <- sub("50747", "050535", na$Provider.Number)
na$Provider.Number <- sub("50125", "050215", na$Provider.Number)
na$Provider.Number <- sub("50217", "050217", na$Provider.Number)
na$Provider.Number <- sub("50125", "050215", na$Provider.Number)
na$Provider.Number <- sub("50539", "050539", na$Provider.Number)
na$Provider.Number <- sub("50550", "050550", na$Provider.Number)
na$Provider.Number <- sub("50125", "050215", na$Provider.Number)
na$Provider.Number <- sub("50744", "050744", na$Provider.Number)
na$Provider.Number <- sub("50125", "050215", na$Provider.Number)
na$Provider.Number <- sub("450700", "451361", na$Provider.Number)
na$Provider.Number <- sub("450665", "451364", na$Provider.Number)
na$Provider.Number <- sub("440143", "441309", na$Provider.Number)
na$Provider.Number <- sub("390005", "391308", na$Provider.Number)
na$Provider.Number <- sub("360267", "360084", na$Provider.Number)
na$Provider.Number <- sub("360128", "361329", na$Provider.Number)
na$Provider.Number <- sub("030129", "30129", na$Provider.Number)
na$Provider.Number <- sub("30128", "030128", na$Provider.Number)

na <- rename(na, Hospital.Name = Hospital.Name.x)
na2 <- left_join(na, trial1, by = "Provider.Number")
View(na2) #It worked

names(na2)
names(full)
na2 <- na2[ , !duplicated(colnames(na2))]
na2 <- na2 %>% select(-.id.y)
na2 <- select(na2, -(Hospital.Name.y:Full_Address.x))

na2 <- rename(na2, Address2 = Address2.y, 
	Address3 = Address3.y,
	City = City.y,
	State = State.y,
	ZIP.Code = ZIP.Code.y,
	County.Name = County.Name.y,
	Phone.Number = Phone.Number.y,
	Hospital.Type = Hospital.Type.y,
	Accreditation = Accreditation.y,
	Date.y = Date,
	Hospital.Ownership = Hospital.Ownership.y,
	Emergency.Services = Emergency.Services.y,
	Full_Address = Full_Address.y) 
	
full <- full %>% rename(.id = .id.y) %>% select(-Hospital.Name.y)

lefthandside.df <- rbind(full, na2)
lefthandside.df$Measure.Name <- gsub("[[:punct:]]", "", lefthandside.df$Measure.Name)

setwd("/Users/georgejacobs/Desktop/Hospital Compare Scores - Friedson/DateExcel/HQI_MSR_XWLK/Hospital Structure/")
save(lefthandside.df, file = "/Users/georgejacobs/Desktop/Hospital Compare Scores - Friedson/DateExcel/HQI_MSR_XWLK/Hospital Structure/Lefthandside.RData") #Full Right Hand Side Variables!!!!
ls()

