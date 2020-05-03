Store <- read.csv('C:/Users/shiva/Desktop/DPA/Master_Data_Stores.csv')
m <- read.csv('C:/Users/shiva/Desktop/DPA/Master_Data_Stores.csv')
library(stringdist)
library(reshape)
library(stringi)

levdist <- function(a,b) # Function to find Punctuations and spelling mistakes using levenshtein distance 
{
  stringDist <- stringdistmatrix(a = a, b = b, method = 'lv', useNames = 'strings') 
  stringDist2 <- melt(stringDist)
  t <- stringDist2[order(stringDist2$value, decreasing = FALSE),]
  t <- t[t$value >0,]
  return(t) 
}

# Clean Address
a = unique(Store$Address)
b= a

temp <- levdist(a,b)


temp[temp[,'value']==1,]

Store[,"Address Cleaned"] <- stri_trans_totitle(Store$Address)
a = unique(Store$`Address Cleaned`)
b= a

temp <- levdist(a,b)


temp[temp[,'value']==1,]

Store[,"Address Cleaned"] <- gsub(",","",Store[,"Address Cleaned"])
a = unique(Store$`Address Cleaned`)
b= a

temp <- levdist(a,b)


temp[temp[,'value']==1,]

Store[,"Address Cleaned"] <- gsub("[.]","",Store[,"Address Cleaned"])
a = unique(Store$`Address Cleaned`)
b= a

temp <- levdist(a,b)


temp[temp[,'value']==1,]

Store[,"Address Cleaned"] <- gsub("\\s+"," ",Store[,"Address Cleaned"])
a = unique(Store$`Address Cleaned`)
b= a


Store[,"Address Cleaned"] <- gsub("2424 Sw 9th St # 1","2424 Sw 9th St #1",Store[,"Address Cleaned"])
a = unique(Store$`Address Cleaned`)
b= a
temp <- levdist(a,b)


temp[temp[,'value']==1,]

# Clean City

a = unique(Store$City)
b= a

temp <- levdist(a,b)
temp[temp[,'value']==1,]

Store[,"City Cleaned"] <- stri_trans_totitle(Store$City)

a = unique(Store$`City Cleaned`)
b= a

temp <- levdist(a,b)
temp <- temp[temp[,'value']==1,]

Store[,"City Cleaned"] <- gsub('Otumwa','Ottumwa',Store[,"City Cleaned"])
Store[,"City Cleaned"] <- gsub('Kellog$','Kellogg',Store[,"City Cleaned"])
Store[,"City Cleaned"] <- gsub('Guttenburg','Guttenberg',Store[,"City Cleaned"])
Store[,"City Cleaned"] <- gsub('Grand Mounds$','Grand Mound',Store[,"City Cleaned"])
Store[,"City Cleaned"] <- gsub('Clearlake','Clear Lake',Store[,"City Cleaned"])
Store[,"City Cleaned"] <- gsub("Arnold's Park",'Arnolds Park',Store[,"City Cleaned"])

#https://www.alphalists.com/list/alphabetical-list-iowa-cities for refering city names

a = unique(Store$`City Cleaned`)
b= a

temp <- levdist(a,b)
temp <- temp[temp[,'value']==1,]


#Clean County
a = unique(Store$County)
b= a

temp <- levdist(a,b)
Store[,"County Cleaned"] <- stri_trans_totitle(Store$County)
#temp[temp[,'value']==1,]
a = unique(Store$`County Cleaned`)
b= a

temp <- levdist(a,b)
temp[temp[,'value']==1,]

Store[,"County Cleaned"] <- gsub('Buena Vist$','Buena Vista',Store[,"County Cleaned"])
Store[,"County Cleaned"] <- gsub('Cerro Gord$','Cerro Gordo',Store[,"County Cleaned"])
Store[,"County Cleaned"] <- gsub('Obrien',"O'brien",Store[,"County Cleaned"])
#Store[,"County Cleaned"] <- gsub('Black','Black Hawk',Store[,"County Cleaned"])
#Store[,"County Cleaned"] <- gsub('Buena','Buena Vista',Store[,"County Cleaned"])
#Store[,"County Cleaned"] <- gsub('Cerro','Cerro Gordo',Store[,"County Cleaned"])

a = unique(Store$`County Cleaned`)
b= a

temp <- levdist(a,b)
temp[temp[,'value']==1,]

#Clean Zipcode

a = unique(as.character(df$Store.Location))
b= a

temp <- levdist(a,b)
temp[temp[,'value'] > 5,]

#Drop old city 'Address','City','County','X' columns
n <- c('Address','City','County','X')
Store <- Store[ , !(names(Store) %in% n)]
nrow(unique(Store))

# convert zip code to numeric 
Store['Zip.Code'] <- as.numeric(levels(Store$Zip.Code))[Store$Zip.Code]

# Get only distinct rows in final dataset 

library(plyr)
library(dplyr)
Store_Cleaned <- distinct(Store)


# Store Cleaned Data in CSV
write.csv(Store_Cleaned,'C:/Users/shiva/Desktop/DPA/Store_Cleaned.csv')

