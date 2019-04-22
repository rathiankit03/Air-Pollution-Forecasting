setwd("F:/ADM/Project/Dataset/Experiment")
df1 <- read.csv("DelhiOverallPM25.csv")
head(df1)
tail(df1)
str(df1)


library(dplyr)

ts <- seq.POSIXt(as.POSIXct("2015/03/23",'%d/%m/%y'), as.POSIXct("2019/02/26",'%d/%m/%y'), by="day")

ts <- seq.POSIXt(as.POSIXlt("2015/03/23"), as.POSIXlt("2019/02/26"), by="day")
ts <- format.POSIXct(ts,'%d/%m/%y')
ts

df <- data.frame(timestamp=ts)
str(df)

df$timestamp <- as.character(df$timestamp)
df1$Date <- as.character(df1$Date)

library(plyr)
rbind.fill(df,df1)
 
