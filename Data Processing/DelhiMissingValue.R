setwd("F:/ADM/Project/Dataset/Experiment/Delhi")

Df <- read.csv("Delhi.csv")
Df$X <- NULL

str(Df)

sapply(Df, function(x) sum(is.na(x)))

## Replacing with zero


Df$Concentration[is.na(Df$Concentration)] <- 0

write.csv(Df, "DelhiZero.csv", row.names = FALSE)


## Replacing with mean value

DfM <- read.csv("Delhi.csv")
DfM$X <- NULL

str(DfM)

sapply(DfM, function(x) sum(is.na(x)))

DfM$Concentration <- ifelse(is.na(DfM$Concentration),
                         ave(DfM$Concentration , FUN = function(x) mean(x, na.rm = TRUE)),
                         DfM$Concentration)

write.csv(DfM, "DelhiMean.csv", row.names = FALSE)


## Replacing with moving average


DfMA<- read.csv("Delhi.csv")
DfMA$X <- NULL

str(DfMA)

sapply(DfMA, function(x) sum(is.na(x)))

DfMA <- imputeTS::na.ma(DfMA, k = 30, weighting = "simple")



write.csv(DfMA, "DelhiMOvingAverage.csv", row.names = FALSE)

