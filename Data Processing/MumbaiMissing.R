setwd("F:/ADM/Project/Dataset/Experiment/Mumbai")


df <- read.csv("Mumbai.csv")
sapply(df, function(x) sum(is.na(x)))

boxplot(df$Concentration)


## Replacing with zero

Df <- df

Df$Concentration[is.na(Df$Concentration)] <- 0
sapply(Df, function(x) sum(is.na(x)))

write.csv(Df, "MumbaiZero.csv", row.names = FALSE)


## Replacing with mean value

DfM <- df

str(DfM)

sapply(DfM, function(x) sum(is.na(x)))

DfM$Concentration <- ifelse(is.na(DfM$Concentration),
                            ave(DfM$Concentration , FUN = function(x) mean(x, na.rm = TRUE)),
                            DfM$Concentration)

write.csv(DfM, "MumbaiMean.csv", row.names = FALSE)


## Replacing with moving average


DfMA<- df

sapply(DfMA, function(x) sum(is.na(x)))

DfMA <- imputeTS::na.ma(DfMA, k = 30, weighting = "simple")



write.csv(DfMA, "MumbaiMOvingAverage.csv", row.names = FALSE)

