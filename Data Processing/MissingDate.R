setwd("F:/ADM/Project/Dataset/Experiment/Mumbai")

library(readxl)
library(DataExplorer)
library(lubridate)
library(tidyverse)
library(forcats)
library(glue)
#library(rnn)

#install.packages("devtools")
library(devtools)
# devtools::install_github("rstudio/reticulate")
# devtools::install_github("rstudio/tensorflow")
# devtools::install_github("rstudio/keras")

library(tensorflow)
library(keras)
#install_keras()

df1 <- read.csv("MumbaiOver.csv")
str(df1)

#Correcting data type and adding missing dates
df1$Concentration <- as.numeric(df1$Concentration)

df1$Date <- as.character(df1$Date)
df1$Date <- dmy(df1$Date)
df1
df1 <- df1 %>%
            mutate(Date = as.Date(Date)) %>%
            complete(Date = seq.Date(min(Date), max(Date), by="day"))


#Replacing NA Values
df1$Parameter[is.na(df1$Parameter)] <- ""


# #Normailizing values
# 
# for (i in 1:nrow(df1)) {
#   df1$Concentration[i] <- (df1$Concentration[i] - mean(df1$Concentration)) / sd(df1$Concentration)
# }


df2 <- df1$Concentration[!df1$Concentration %in% boxplot.stats(df1$Concentration)$out]

df2 <- df2[complete.cases(df2)]


# colnames(df2) <- "Concentration"


diffed <- diff(df2,differences = 1)

lag_transform <- function(x, k= 1){
  
  lagged =  c(rep(NA, k), df2[1:(length(x)-k)])
  DF = as.data.frame(cbind(lagged, x))
  colnames(DF) <- c( paste0('x-', k), 'x')
  DF[is.na(DF)] <- 0
  return(DF)
}


supervised <- lag_transform(diffed, 1)

head(supervised)


N = nrow(supervised)
n = round(N *0.7, digits = 0)
train = supervised[1:n, ]
test  = supervised[(n+1):N,  ]


scale_data = function(train, test, feature_range = c(0, 1)) {
  x = train
  fr_min = feature_range[1]
  fr_max = feature_range[2]
  std_train = ((x - min(x) ) / (max(x) - min(x)  ))
  std_test  = ((test - min(x) ) / (max(x) - min(x)  ))
  
  scaled_train = std_train *(fr_max -fr_min) + fr_min
  scaled_test = std_test *(fr_max -fr_min) + fr_min
  
  return( list(scaled_train = as.vector(scaled_train), scaled_test = as.vector(scaled_test) ,scaler= c(min =min(x), max = max(x))) )
  
}


Scaled = scale_data(train, test, c(-1, 1))


y_train = Scaled$scaled_train[, 2]
x_train = Scaled$scaled_train[, 1]

y_test = Scaled$scaled_test[, 2]
x_test = Scaled$scaled_test[, 1]


invert_scaling = function(scaled, scaler, feature_range = c(0, 1)){
  min = scaler[1]
  max = scaler[2]
  t = length(scaled)
  mins = feature_range[1]
  maxs = feature_range[2]
  inverted_dfs = numeric(t)
  
  for( i in 1:t){
    X = (scaled[i]- mins)/(maxs - mins)
    rawValues = X *(max - min) + min
    inverted_dfs[i] <- rawValues
  }
  return(inverted_dfs)
}


dim(x_train) <- c(length(x_train), 1, 1)

X_shape2 = dim(x_train)[2]

X_shape3 = dim(x_train)[3]
batch_size = 1 
units = 1 

model <- keras_model_sequential() 
model%>%
  layer_lstm(units, batch_input_shape = c(batch_size, X_shape2, X_shape3), stateful= TRUE)%>%
  layer_dense(units = 1)







#write.csv(df1,"CO_Jaipur.csv", row.names = FALSE)

View(df1)


