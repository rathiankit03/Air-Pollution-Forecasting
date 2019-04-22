setwd("F:/ADM/Project/Dataset/Experiment/Jaipur")

df <- read.csv("Jaipur.csv")
df

library(lubridate)

#Month and Year

df$month <- month(as.POSIXct(df$Date, format = "%d-%m-%Y"))
df$year <- year(as.POSIXct(df$Date, format = "%d-%m-%Y"))


str(df)
df$month <- as.factor(df$month)
df$year <- as.factor(df$year)

#Mean

library(dplyr)

df <- df %>% group_by(month,year) %>% mutate(PM2.5 = mean(Concentration))
df


df$Date<- NULL
df$Concentration <- NULL

summary(df)

#Aggrgate by month and year

a <- aggregate(df$PM2.5, by=list(Category=df$month,df$year), FUN=mean)
a$City <- "Jaipur"
a$Type <- "Tier-2"
a

setwd("F:/ADM/Project/Dataset/Experiment/Comparison")
write.csv(a, file = "Jaipur.csv", row.names = F)


###

Delhi <- read.csv("Delhi.csv")
Delhi$City <- NULL
Delhi$Type <- NULL

Kanpur <- read.csv("Kanpur.csv")
Kanpur$City <- NULL
Kanpur$Type <- NULL

Mumbai <- read.csv("Mumbai.csv")
Mumbai$City <- NULL
Mumbai$Type <- NULL

Ghaziabad <- read.csv("Ghaziabad.csv")
Ghaziabad$City <- NULL
Ghaziabad$Type <- NULL

Banglore <- read.csv("Banglore.csv")
Banglore$City <- NULL
Banglore$Type <- NULL

Chennai <- read.csv("Chennai.csv")
Chennai$City <- NULL
Chennai$Type <- NULL

Pune <- read.csv("Pune.csv")
Pune$City <- NULL
Pune$Type <- NULL

Jaipur <- read.csv("Jaipur.csv")
Jaipur$City <- NULL
Jaipur$Type <- NULL


colnames(Delhi) <- c("Month", "Year", "Delhi")
colnames(Mumbai) <- c("Month", "Year", "Mumbai")
colnames(Kanpur) <- c("Month", "Year", "Kanpur")
colnames(Ghaziabad) <- c("Month", "Year", "Ghaziabad")
colnames(Banglore) <- c("Month", "Year", "Banglore")
colnames(Chennai)  <- c("Month", "Year", "Chennai")
colnames(Pune) <- c("Month", "Year", "Pune")
colnames(Jaipur) <- c("Month", "Year", "Jaipur")




overall <- Reduce(function(x, y) merge(x, y, all=TRUE), list(Delhi, Mumbai, Kanpur, Ghaziabad,
                                                             Banglore,Chennai,Pune,Jaipur))

head(overall)





write.csv(overall, file = "overall.csv", row.names = F)
