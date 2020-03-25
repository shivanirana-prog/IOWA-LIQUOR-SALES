# load transaction data
library(readr)
library(dplyr)
Iowa_Liquor_Sales <- read_csv("Iowa_Liquor_Sales.csv")

liquor=Iowa_Liquor_Sales
summary(liquor)

str(liquor)

# check the names of columns
names(liquor)

# change column names for liquor
names(liquor)[names(liquor) == "Store Number"] <- "Store_Number"
names(liquor)[names(liquor) == "Store Name"] <- "Store_Name"
names(liquor)[names(liquor) == "Zip Code"] <- "Zip_Code"
names(liquor)[names(liquor) == "Store Location"] <- "Store_Location"
names(liquor)[names(liquor) == "County Number"] <- "County_Number"
names(liquor)[names(liquor) == "Category Name"] <- "Category_Name"
names(liquor)[names(liquor) == "Vendor Number"] <- "Vendor_Number"
names(liquor)[names(liquor) == "Vendor Name"] <- "Vendor_Name"
names(liquor)[names(liquor) == "Item Number"] <- "Item_Number"
names(liquor)[names(liquor) == "Item Description"] <- "Item_Description"
names(liquor)[names(liquor) == "Bottle Volume (ml)"] <- "BottleVolumeLitre"
names(liquor)[names(liquor) == "State Bottle Retail"] <- "StateBottleRetail"
names(liquor)[names(liquor) == "Volume Sold (Liters)"] <- "VolumeSold"


liquor2=liquor
attach(liquor2)

#change data type
liquor2$Date = as.Date(liquor2$Date, "%m/%d/%Y")
#convert to factor
col_number <- c(3,7,9,11,13,15)
liquor2[,col_number] <- lapply(liquor2[,col_number] , factor)
str(liquor2)
summary(liquor2)


#---------------------------------------------------------------------------------

# load master data
Iowa_Master <- read_csv("Master_Data_Stores_Cleaned.csv")
master=Iowa_Master[,-1]
View(master)
master2=master

# change data type of master
str(master2)
#covert to factor
col_number <- c(1,2)
master2[,col_number] <- lapply(master2[,col_number] , factor)
str(master2)
summary(master2)

# change column names for master
names(master2)

names(master2)[names(master2) == "Store.Number"] <- "store_number_cleaned"
names(master2)[names(master2) == "Zip.Code"] <- "zip_code_cleaned"
names(master2)[names(master2) == "Store.Location"] <- "store_location_cleaned"
names(master2)[names(master2) == "Address Cleaned"] <- "address_cleaned"
names(master2)[names(master2) == "County Cleaned"] <- "county_cleaned"
names(master2)[names(master2) == "City Cleaned"] <- "city_cleaned"
str(master2)
attach(master2)
View(master2)

#---------------------------------------------------------------------------------

# missing value for zip code in master
sum(is.na(master2$zip_code_cleaned))
master2[rowSums(is.na(master2)) > 0,]

# check for dublicate store number in master2
dublicate_master=as.data.frame(table(master2$store_number_cleaned))
dublicate_master=dublicate_master[dublicate_master$Freq>1,]
View(dublicate_master)
nrow(dublicate_master)

# divide master data into unique store number and dublicate store number
dublicate_storeNum_vector=dublicate_master$Var1
df_dublicate_master= as.data.frame(master2[master2$store_number_cleaned %in% dublicate_storeNum_vector,])
View(df_dublicate_master)
head(df_dublicate_master)
nrow(df_dublicate_master)

names(df_dublicate_master)

for (i in 1:ncol(df_dublicate_master)) {
  uu=length(unique(df_dublicate_master[,i]))
  print(uu)
}

# number of unique values of every column in df_dublicate_master
#"store_number_cleaned" = 112
#"zip_code_cleaned" =89
#"store_location_cleaned"=184 
#"address_cleaned"=152
#"city_cleaned" =84    
#"county_cleaned"=58



unique(df_dublicate_master$store_number_cleaned)
count(df_dublicate_master[,2])

#---------------------------------------------------------------------------------
`%notin%` <- Negate(`%in%`)
df_unique_master=master2[master2$store_number_cleaned %notin% dublicate_storeNum_vector,]
nrow(df_unique_master)

# merge inner join of transaction data with df_unique_master
liquor_unique_transaction=merge(x=liquor2,y=df_unique_master, by.x = "Store_Number", by.y = "store_number_cleaned", all= FALSE)
nrow(liquor_unique_transaction)
#17008755
View(liquor_unique_transaction)


#---------------------------------------------------------------------------------
# check for dublicate store number due to different address

l1= liquor2[liquor2$Store_Number %in% dublicate_storeNum_vector,]
nrow(l1)
View(l1)

l2= as.data.frame(l1  %>% group_by(Store_Number) %>% summarise(max_date=max(Date)))
View(l2)

#--------------------------------
names(l2)[names(l2) == "max_date"] <- "Date"

df <- merge(l1, l2, by = c('Store_Number', 'Date'))
View(df)
length(unique(df$Store_Number))
#112

distinct_df = df %>% distinct(Store_Number)
View(distinct_df)
#--------------------------------

# changing the address of master dublicate
df_dublicate_master2=df_dublicate_master
for (i in 1:nrow(df)) {
  for (j in 1:nrow(df_dublicate_master2)) {
    if (df$Store_Number[i]==df_dublicate_master2$store_number_cleaned[j]){
      df_dublicate_master2$address_cleaned[j]<-df$Address[i]

    }
  }
}
View(df_dublicate_master2)
# df_dublicate_master2 has correct address with respect to store number and date



# now substituting gio location
# clean address in dublicate master2
df_noWhiteSpace=as.data.frame(apply(df_dublicate_master2,2,function(x)gsub('\\s+', '',x)))
df_noWhiteSpace_nocomma= gsub(",","",df_noWhiteSpace$address_cleaned)
df_noWhiteSpace_nocomma_noDot= gsub("\\.","",df_noWhiteSpace_nocomma)
df_master2_noWhiteSpace_nocomma_noDot_upper=toupper(df_noWhiteSpace_nocomma_noDot)


# clean address in dublicate master
df_master_noWhiteSpace=as.data.frame(apply(df_dublicate_master,2,function(x)gsub('\\s+', '',x)))
df_master_noWhiteSpace_nocomma= (gsub(",","",df_master_noWhiteSpace$address_cleaned))
df_master_noWhiteSpace_nocomma_noDot= gsub("\\.","",df_master_noWhiteSpace_nocomma)
df_master_noWhiteSpace_nocomma_noDot_upper=toupper(df_master_noWhiteSpace_nocomma_noDot)

# add df_master_noWhiteSpace_nocomma_noDot_upper to df_dublicate_master
blended_master=cbind(df_dublicate_master,df_master_noWhiteSpace_nocomma_noDot_upper)
View(blended_master)

# add df_master2_noWhiteSpace_nocomma_noDot_upper to df_dublicate_master2
blended_master2=cbind(df_dublicate_master2,df_master2_noWhiteSpace_nocomma_noDot_upper)
View(blended_master2)

for (i in 1:nrow(blended_master2)) {
  for (j in 1:nrow(blended_master)) {
    if (blended_master$df_master_noWhiteSpace_nocomma_noDot_upper[j] == blended_master2$df_master2_noWhiteSpace_nocomma_noDot_upper[i])
      blended_master2$store_location_cleaned[i]=blended_master$store_location_cleaned[j]
  }
}
View(blended_master2)
# blended_master2 has correct gio location and address with respect to store number and date 


for (i in 1:ncol(blended_master2)) {
  u=length(unique(blended_master2[,i]))
  print(u)
}
# number of unique values for following columns
#store_number_cleaned = 112
#zip_code_cleaned = 89
#store_location_cleaned =107
#address_cleaned=112
#city_cleaned=84
#county_cleaned=58
#df_master2_noWhiteSpace_nocomma_noDot_upper=112

# we see that number of store location (gio location) is not correct, need to check, we are missing 5 out of 112
#uniq_blend2_storeNum=unique(blended_master2)
#View(uniq_blend2_storeNum)
attach(blended_master2)
gio_loc1= blended_master2 %>% group_by(store_number_cleaned) %>% count(unique(store_location_cleaned))
gio_loc2=gio_loc1[gio_loc1$n == 1,]
s=unique(gio_loc2$store_number_cleaned)
ss=blended_master2[blended_master2$store_number_cleaned %in% s,]
sss=unique(ss$address_cleaned)

View(ss)

#[1] "188, Parkridge Rd"      "1408 Dakota Street"    
#[3] "1305 E SOUTH STREET"    "414 Clark Street"      
#[5] "222 North Clark Street" "1515 11th Street" 

# predicting latlon for the above 6 address
install.packages("geonames")
library(geonames)
library(ggmap)
register_google(key = "##################", write = TRUE)

lat_lon=function(address){
  c_name=as.data.frame(address)
  g_code=as.data.frame(geocode(address, output = "latlon"))
  total <- cbind(c_name,g_code)
  return(total)
}

'''
sss_latlon=lat_lon(sss)
sss_latlon$lon

# substituting the extracted gio location to blended_master2
gio_loc3=rep(NA,nrow(sss_latlon))
for (i in 1:nrow(sss_latlon)) {
  gio_loc3[i]=sprintf("POINT (%f %f)",sss_latlon$lon[i],sss_latlon$lat[i])
}
sss_latlon= cbind(sss_latlon,gio_loc3)
drops=c("lon","lat")
sss_latlon=sss_latlon[,!(names(sss_latlon) %in% drops)]

# converting data type of address and gio loc in sss_latlon to string
sss_latlon$address=as.character(sss_latlon$address)
sss_latlon$gio_loc3=as.character(sss_latlon$gio_loc3)
str(sss_latlon)


blended_master3=blended_master2
for (i in 1:nrow(blended_master3)) {
  for (j in 1:nrow(sss_latlon)){
    if(blended_master3$address_cleaned[i]==sss_latlon$address[j])
      blended_master3$store_location_cleaned[i]=sss_latlon$gio_loc3[j]
  }
}
View(blended_master3)

# check the unique values of every columns in blended_master3
for (i in 1:ncol(blended_master3)) {
  u=length(unique(blended_master3[,i]))
  print(u)
}
names(blended_master3)
length(unique(blended_master3$store_location_cleaned))
length(unique(blended_master2$store_location_cleaned))

# we see that googole gio code does not work good and since all these confusing gio codes are very close to each other so we select them at random

gio_loc4=c('POINT (-94.728844 42.056889)','POINT(-94.240402 40.710908)','POINT (-92.911908 41.391808)','POINT (-95.684058 42.98282)','POINT (-90.552434 41.825724)')
sss_latlon= cbind(sss_latlon,gio_loc4)

#clean address of sss_latlon
str(sss_latlon)
df_sss_noWhiteSpace=as.data.frame(apply(sss_latlon,2,function(x)gsub('\\s+', '',x)))
df_sss_noWhiteSpace_nocomma= (gsub(",","",df_sss_noWhiteSpace$address))
df_sss_noWhiteSpace_nocomma_noDot= gsub("\\.","",df_sss_noWhiteSpace_nocomma)
df_sss_noWhiteSpace_nocomma_noDot_upper=toupper(df_sss_noWhiteSpace_nocomma_noDot)

cbind(sss_latlon,df_sss_noWhiteSpace_nocomma_noDot_upper)
sss_latlon$gio_loc4=as.character(sss_latlon$gio_loc4)

for (i in 1:nrow(blended_master3)) {
  for (j in 1:nrow(sss_latlon)) {
    if(blended_master3$address_cleaned[i]==sss_latlon$address[j])
      blended_master3$store_location_cleaned[i]= sss_latlon$gio_loc4[j]
  }
  
}
View(blended_master3)

for (i in 1:ncol(blended_master3)) {
  u=length(unique(blended_master3[,i]))
  print(u)
}
#[1] 112
#[1] 89
#[1] 102
#[1] 112
#[1] 84
#[1] 58
#[1] 112
# we see that the unique value of giocode further decreases to 102. We need to investigate

# substituting correct latlon for 3594 Lafayette St and 1824 Hubbell Ave
blended_master3$store_location_cleaned
blended_master3[blended_master3$address_cleaned=='3594 Lafayette St',]$store_location_cleaned= 'POINT (-92.28824 42.47696)'
blended_master3[blended_master3$address_cleaned=='1824 Hubbell Ave',]$store_location_cleaned= 'POINT (-93.58651 41.59632)'
'''
blended_master3=blended_master2

# lets predict giocode with google api
u=unique(blended_master3$address_cleaned)
uu=rep(NA, length(u))
for (i in 1:length(u)) {
  uu[i]=sprintf("%s,IOWA",u[i])
}

uuu=lat_lon(uu)

'''
gio_loc5=rep(NA,nrow(sss_latlon))
for (i in 1:nrow(uuu)) {
  gio_loc5[i]=sprintf("POINT (%f %f)",uuu$lon[i],uuu$lat[i])
}
length(unique(gio_loc5))
'''

# storing lat lon as sepetate columns in u

u=as.data.frame(cbind(u,uuu))

# droping address of uuu
drops=c('address')
u=u[ , !(names(u) %in% drops)]

names(u)[names(u) == "u"] <- "address_cleaned"
blended_master4= merge(blended_master3,u,by='address_cleaned')
View(blended_master4)

# droping old giocode,zip_code_cleaned,city_cleaned,county_cleaned from blended_master4

drops=c('store_location_cleaned','zip_code_cleaned','city_cleaned','county_cleaned')
blended_master4=blended_master4[ , !(names(blended_master4) %in% drops)]
View(blended_master4)

# find unique value of blended_master4
blended_master4= unique(blended_master4)
View(blended_master4)

#-----------------------------------------------------------------------

#combine zipcode, county, city to blended4
df_dublicate_master3=df_dublicate_master
View(df_dublicate_master3)

# dropping store location,address from df_dublicate_master
drops=c('store_location_cleaned','address_cleaned')
df_dublicate_master3=df_dublicate_master3[ , !(names(df_dublicate_master3) %in% drops)]

df_dublicate_master3=unique(df_dublicate_master3)
View(df_dublicate_master3)
#-------------------------------------------------------
length(unique(liquor$Store_Number))


'''
# droping every column from liquor except str number and zipcode to find relation between them

drops=c("Invoice/Item Number","Date", "Store_Name","Address", "City","Store_Location","County_Number","County","Category","Category_Name","Vendor_Number",
        "Vendor_Name","Item_Number","Item_Description","Pack","BottleVolumeLitre","State Bottle Cost","StateBottleRetail","Bottles Sold",
        "Sale (Dollars)","VolumeSold","Volume Sold (Gallons)")
zip_store=liquor[ , !(names(liquor) %in% drops)]

zip_store=unique(zip_store)
View(zip_store)

# concluded that the relation between zip and store is correct in df_dublicate_master3
#--------------------------------------------------------------------

# therefore merging zip of df_dublicate_master3 to blended_master4 based on store num
drops=c("city_cleaned","county_cleaned")
df_dublicate_master31=df_dublicate_master3[ , !(names(df_dublicate_master3) %in% drops)]
blended_master45= merge(df_dublicate_master31,blended_master4,by='store_number_cleaned')
View(blended_master45)

blended_master45=unique(blended_master45)

# merging city and county to blended_master45

# droping every column from liquor except str number and city to find relation between them

drops=c("Invoice/Item Number","Date", "Store_Name","Address", "Zip_Code","Store_Location","County_Number","County","Category","Category_Name","Vendor_Number",
        "Vendor_Name","Item_Number","Item_Description","Pack","BottleVolumeLitre","State Bottle Cost","StateBottleRetail","Bottles Sold",
        "Sale (Dollars)","VolumeSold","Volume Sold (Gallons)")
city_store=liquor[ , !(names(liquor) %in% drops)]

city_store=unique(city_store)
View(city_store)

# clean city to check correct relation
df_city_noWhiteSpace=as.data.frame(apply(city_store,2,function(x)gsub('\\s+', '',x)))
df_city_noWhiteSpace_nocomma= gsub(",","",df_city_noWhiteSpace$City)
df_city_noWhiteSpace_nocomma_noDot= gsub("\\.","",df_city_noWhiteSpace_nocomma)
df_city_master2_noWhiteSpace_nocomma_noDot_upper=toupper(df_city_noWhiteSpace_nocomma_noDot)

city_store=cbind(city_store,df_city_master2_noWhiteSpace_nocomma_noDot_upper)
city_store=unique(city_store)

# dropping city column
drops=c("city")
city_store=liquor[ , !(names(liquor) %in% drops)]
city_store=unique(city_store)

'''

# do reverse gio code to predict city, county, zipcode for respective store number

install.packages("revgeo")
library(revgeo)

# housenumber=1
#"street"=2      
#"city"=3    
#"county"=4  
#"state" =5
#"zip" =6
#"country"=7

city_google=rep(NA,nrow(blended_master4))
zip_google=rep(NA,nrow(blended_master4))
county_google=rep(NA,nrow(blended_master4))
lat_check=rep(NA,nrow(blended_master4))
lon_check=rep(NA,nrow(blended_master4))
attach(blended_master4)

for (i in 1:nrow(blended_master4)) {
  city_google[i]=revgeo(longitude = lon[i], latitude = lat[i],provider = 'google',API = '###############',  output='frame')[3]
  county_google[i]=revgeo(longitude = lon[i], latitude = lat[i],provider = 'google',API = '##################',  output='frame')[4]
  zip_google[i]=revgeo(longitude = lon[i], latitude = lat[i],provider = 'google',API = '#################',  output='frame')[6]
  lat_check[i]=lat[i]
  lon_check[i]=lon[i]
}

#converting list format of zip, city, county to simple vector format
city_google2=rep(NA,nrow(blended_master4))
zip_google2=rep(NA,nrow(blended_master4))
county_google2=rep(NA,nrow(blended_master4))

for (i in 1:nrow(blended_master4)) {
  zip_google2[i]=as.character(unlist(zip_google[i], use.names=FALSE))
  city_google2[i]=as.character(unlist(city_google[i], use.names=FALSE))
  county_google2[i]=as.character(unlist(county_google[i], use.names=FALSE))
}

city_google2[1]
zip_google2[1]
lat_check[1]
lon_check[1]
# merging the city_google, zip_google, county_google to blended_master4
aa=cbind(city_google2,county_google2,zip_google2,lat_check,lon_check)
View(aa)
aaa=cbind(blended_master4,aa)
View(aaa)


# exporting aaa to local as csv
write.csv(aaa,"/Users/amanprasad/Documents/Courses_IIT_Fall_2019/DPA/Project-DPA/aaa.csv", row.names = TRUE)

# we fixed city, zip, but still we need to fix county with respect to store number

# loading file which contain zip and county

zip_county= read_csv("ZIP-COUNTY-FIPS_2010-03.csv")

zip_county2=zip_county

zip_county2=as.data.frame(zip_county2)
View(zip_county2)

names(zip_county2)[names(zip_county2) == "ZIP"] <- "zip_google2"

county_added=merge(aaa,zip_county2,by='zip_google2')
View(county_added)

drops=c('STATE','STCOUNTYFP','CLASSFP')
county_added=county_added[ , !(names(county_added) %in% drops)]
county_added=unique(county_added)
attach(county_added)
# we see that number of record increases to 166, lets investigate 
count_county=county_added %>% group_by(zip_google2) %>% count(COUNTYNAME)


# since we are having trouble in preducting county, we are droping that column from our analysis.
# and since aaa is our final file. So we need to clean it

# dropping columns = df_master2_noWhiteSpace_nocomma_noDot_upper, lat_check, lon_check, county_google2
names(aaa)

drops=c('df_master2_noWhiteSpace_nocomma_noDot_upper','lat_check','lon_check','county_google2')
aaa=aaa[ , !(names(aaa) %in% drops)]
aaa=unique(aaa)
View(aaa)

# renaming the columns
names(aaa)
names(aaa)[names(aaa) == "address_cleaned"] <- "address"
names(aaa)[names(aaa) == "store_number_cleaned"] <- "store_number"
names(aaa)[names(aaa) == "city_google2"] <- "city"
names(aaa)[names(aaa) == "zip_google2"] <- "zip"


dublicate_store_cleaned_Aman=aaa
# exporting aaa to local as csv
write.csv(dublicate_store_cleaned_Aman,"/Users/amanprasad/Documents/Courses_IIT_Fall_2019/DPA/Project-DPA/dublicate_store_cleaned_Aman.csv", row.names = TRUE)








