Store <- read.csv('C:/Users/shiva/Desktop/DPA/Master_Data_Stores_final_version.csv')
liquor <- read.csv('C:/Users/shiva/Desktop/DPA/Iowa_Liquor_Sales.csv')

colnames(liquor)<-c('Invoice/Item Number','Date','Store Number','Store Name','Zip Code','Store Location','County Number','Category','Category Name','Vendor Number','Vendor Name','Item Number','Item Description','Pack','Bottle Volume (ml)','State Bottle Cost','State Bottle Retail','Bottles Sold','Sale (Dollars)','Volume Sold (Litres)','Volume Sold (Gallons)')
colnames(Store)<- c('X','Store Number','Address','Zip Code','City','County','lat','lon')
drop <- c('Address','County Number','County','City','Store Location','Zip Code')
liquor = liquor[,!(names(liquor) %in% drop)]
drop2<- c('X')
Store <- Store[,!(names(Store) %in% drop2)]

new_liquor= merge(x = Store, y = liquor, by = "Store Number", all.x = TRUE)

library(stringdist)
library(reshape)
library(stringi)
library(PGRdup)

levdist <- function(a,b)
{
  stringDist <- stringdistmatrix(a = a, b = b, method = 'lv', useNames = 'strings') 
  stringDist2 <- melt(stringDist)
  t <- stringDist2[order(stringDist2$value, decreasing = FALSE),]
  t <- t[t$value >0,]
  return(t) 
}

a = unique(new_liquor$`Vendor Name`)
b= a

temp <- levdist(a,b)

new_liquor[,"Vendor Name Cleaned"] <- NULL

new_liquor[,"Vendor Name Cleaned"] <- toupper(new_liquor[,"Vendor Name"])
#new_liquor[,"Vendor Name Cleaned"] <- gsub(",","",new_liquor[,"Vendor Name"])
new_liquor[,"Vendor Name Cleaned"] <- gsub("&","AND",new_liquor[,"Vendor Name Cleaned"])



new_liquor[,"Vendor Name Cleaned"]= DataClean(new_liquor[,"Vendor Name Cleaned"], fix.comma = TRUE, fix.semcol = TRUE, fix.col = TRUE,
          fix.bracket = TRUE, fix.punct = TRUE, fix.space = TRUE,
          fix.sep = TRUE, fix.leadzero = TRUE)

a = unique(new_liquor$`Vendor Name Cleaned`)
b= a

temp <- levdist(a,b)
library(tidyverse)
str_view(a, ".CO.")
library(stringr)
length(sort( unique(new_liquor$`Vendor Name Cleaned`)))
sort( unique(new_liquor$`Vendor Number`))

new_liquor[,"Vendor Name Cleaned"] <- gsub("DIS$","DISTILLERY",new_liquor[,"Vendor Name Cleaned"])
new_liquor[,"Vendor Name Cleaned"] <- gsub("COMPANY$","CO",new_liquor[,"Vendor Name Cleaned"])
new_liquor[,"Vendor Name Cleaned"] <- gsub("CORPORATION$","CORP",new_liquor[,"Vendor Name Cleaned"])
new_liquor[,"Vendor Name Cleaned"] <- gsub("SPIRIT$","SPIRITS",new_liquor[,"Vendor Name Cleaned"])
new_liquor[,"Vendor Name Cleaned"] <- gsub("BEVERAGE$","BEVERAGES",new_liquor[,"Vendor Name Cleaned"])
new_liquor[,"Vendor Name Cleaned"] <- gsub("BEVERAGE$","BEVERAGES",new_liquor[,"Vendor Name Cleaned"])
new_liquor[,"Vendor Name Cleaned"] <- gsub("$L$","LLC",new_liquor[,"Vendor Name Cleaned"])
new_liquor[,"Vendor Name Cleaned"] <- gsub("$F$","",new_liquor[,"Vendor Name Cleaned"])

var<- c('Vendor Number','Vendor Name Cleaned')

cat <- unique(new_liquor[var])
cat <- cat[order(cat$`Vendor Name Cleaned`),]

write.csv(cat,'C:/Users/shiva/Desktop/DPA/CAT.csv')

new_liquor['Vendor Number New'] = new_liquor['Vendor Number']

new_liquor[new_liquor[,'Vendor Name Cleaned']=='INFINIUM SPIRITS',]['Vendor Number New']=988
new_liquor[new_liquor[,'Vendor Name Cleaned']=='ROGUE ALES AND SPIRITS',]['Vendor Number New']=989
new_liquor[new_liquor[,'Vendor Name Cleaned']=='RESERVOIR DISTILLERY',]['Vendor Number New']=990



new_liquor[is.na(new_liquor['Vendor Number New']),]['Vendor Number New'] = 0

cat <- hrread.csv('C:/Users/shiva/Desktop/DPA/CAT.csv')
colnames(cat) <- c('Vendor Number New','Vendor Name Cleaned')

new_liquor_clean = merge(x = new_liquor, y = cat, by = "Vendor Number New", all.x = TRUE)
head(new_liquor)

var2<- c('Vendor Number New','Vendor Name Cleaned.y')

cat2 <- unique(new_liquor_clean[var2])

var3 <- c('Invoice/Item Number','Date','Store Number','Store Name','Zip Code','Address','lat','lon','City','County','Category','Category Name','Vendor Number New','Vendor Name Cleaned.y','Item Number','Item Description','Pack','Bottle Volume (ml)','State Bottle Cost','State Bottle Retail','Bottles Sold','Sale (Dollars)','Volume Sold (Litres)','Volume Sold (Gallons)')
new_liquor_clean <- new_liquor_clean[var3]

t <- read.csv('C:/Users/shiva/Desktop/DPA/new_liquor_clean_final.csv')
write.csv(t,'C:/Users/shiva/Desktop/DPA/new_liquor_clean_final.csv')