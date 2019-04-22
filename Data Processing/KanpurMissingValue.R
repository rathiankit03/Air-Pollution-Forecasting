setwd("F:/ADM/Project/Dataset/Experiment/Kanpur")
df <- read.csv("KanpurZero.csv")

## Handling Outliers
boxplot(df$Concentration)
df[df$Concentration > 500, 2] <- 0

OutVals = boxplot.stats(DataframeName$Total)$out 
DataframeName <- DataframeName [!(DataframeName %in% OutVals )] 

write.csv(df,"KanpurZero.csv", row.names = FALSE)

# Replacing 0 value with NA
sapply(df, function(x) sum(is.na(x)))

df$Concentration <- ifelse(df$Concentration == 0,
                           NA,
                           df$Concentration)


## Replacing with mean value

DfM <- df


str(DfM)

sapply(DfM, function(x) sum(is.na(x)))

DfM$Concentration <- ifelse(is.na(DfM$Concentration),
                            ave(DfM$Concentration , FUN = function(x) mean(x, na.rm = TRUE)),
                            DfM$Concentration)

write.csv(DfM, "KanpurMean.csv", row.names = FALSE)

boxplot(DfM$Concentration)


## Replacing with moving average


DfMA<- df


str(DfMA)

sapply(DfMA, function(x) sum(is.na(x)))

DfMA <- imputeTS::na.ma(DfMA, k = 30, weighting = "simple")



write.csv(DfMA, "KanpurMOvingAverage.csv", row.names = FALSE)


boxplot(DfMA$Concentration)

