library(readr)
Iowa_Liquor_Sales <- read_csv("Iowa_Liquor_Sales.csv", 
                              col_types = cols(Date = col_date(format = "%m/%d/%Y")))
View(Iowa_Liquor_Sales)

liquor=Iowa_Liquor_Sales
summary(liquor)



#sampling data into trainig and testing
train=sample(1:nrow(liquor),nrow(liquor)/2)
test=(-train)
y=liquor[24]
y.test=y[test]

liquor_train=liquor[train,]
names(liquor_train)
liquor_train=liquor_train[,-c(1,4,10,12,14)]
names(liquor_train)
liquor_test=liquor[test,]
View(liquor_train)
summary(liquor_train)

#covert to factor
col_number <- c(2,4,5,7,8,9,10,11)
liquor_train[,col_number] <- lapply(liquor_train[,col_number] , factor)
str(liquor_train)



# check correlation
liquor_train_cor= liquor_train[,c(12,13,14,15,17,18)]
cor(liquor_train_cor)
cor.plot(liquor_train_cor)

# removing correlated columns sales dollar and volume sold litre
head(liquor_train_cor)
#cor.plot(liquor_train_cor[,-(6)])
liquor_train_cor=liquor_train_cor[,-5]
liquor_train_cor=liquor_train_cor[,-3]
cor.plot(liquor_train_cor)
# we are left with "Pack" "Bottle Volume (ml)" "State Bottle Retail" "Sale (Dollars)"

summary(liquor_train_cor)

# study distribution in all the above cont var
hist(liquor_train_cor$Pack)
hist(liquor_train_cor$`Bottle Volume (ml)`)
hist(liquor_train_cor$`State Bottle Retail`)
hist(liquor_train_cor$`Volume Sold (Liters)`)

# number of missing values
liq_na=liquor_train_cor[rowSums(is.na(liquor_train_cor)) > 0,]
head(liquor_train_cor)

#convert Bottle Volume (ml) to litre
liquor_train_cor$`Bottle Volume (ml)`=(liquor_train_cor$`Bottle Volume (ml)`)/1000
summary(liquor_train_cor)

# change column names
names(liquor_train_cor)[names(liquor_train_cor) == "Bottle Volume (ml)"] <- "BottleVolumeLitre"

names(liquor_train_cor)[names(liquor_train_cor) == "State Bottle Retail"] <- "StateBottleRetail"

names(liquor_train_cor)[names(liquor_train_cor) == "Volume Sold (Liters)"] <- "VolumeSold"

head(liquor_train_cor)

# fill missing value in State Bottle Retail with 
install.packages("mice")
library(mice)
imputed_Data <- mice(liquor_train_cor, m=5, maxit = 50, method = 'pmm', seed = 500)
md.pattern(liquor_train_cor)

liq_na$StateBottleRetail=imputed_Data$imp$StateBottleRetail$`5`

liquor_train_cor[rowSums(is.na(liquor_train_cor)) > 0,]=liq_na

sum(is.na(liquor_train_cor$StateBottleRetail))

# check for outliers for Pack
boxplot(liquor_train_cor$Pack)

outliers_pack <- boxplot(liquor_train_cor$Pack, plot=FALSE)$out
length(outliers_pack)
summary(outliers_pack)
summary(liquor_train_cor$StateBottleRetail)
#liquor_train_cor <- liquor_train_cor[-which(liquor_train_cor$Pack %in% outliers_pack),]
boxplot(liquor_train_cor$Pack)
sum(liquor_train_cor$Pack %in% outliers_pack)
length(liquor_train_cor$Pack)

# outlier for BottleVolume
boxplot(liquor_train_cor$BottleVolume)

outliers_BottleVolume <- boxplot(liquor_train_cor$BottleVolume, plot=FALSE)$out
length(outliers_BottleVolume)
summary(outliers_BottleVolume)
summary(liquor_train_cor$BottleVolume)
length(liquor_train_cor$BottleVolume[liquor_train_cor$BottleVolume==summary(outliers_BottleVolume)[6]])

length(liquor_train_cor$BottleVolume)


'''
# study categorical variable
cat_liq=liquor_train[,c(2,4,5,7,8,9,10)]

# find unique values in store number
apply(cat_liq, 2, function(x) length(unique(x)))

# Create the contigency table
#tbl = table(cat_liq$City,cat_liq$`Zip Code`)
#tbl
'''
# In practice, we use R's builtin method for this
#chisq.test(tbl)
#chisq.test(x = cat_liq$City, y = cat_liq$`Zip Code`
#           , simulate.p.value = TRUE
#           , B = 1000000)

'''

# number of missing values
na_cat_col=c()
for (i in 1:ncol(cat_liq)){
  print(colnames(cat_liq)[i])
  na_cat_col[i]=sum(is.na(cat_liq[i]))
  print(na_cat_col[i])
  
}

# rows with missing values
liq_na_cat=cat_liq[rowSums(is.na(cat_liq)) > 0,]


# change column names
names(liq_na_cat)[names(liq_na_cat) == "Store Number"] <- "StoreNumber"

names(liq_na_cat)[names(liq_na_cat) == "Zip Code"] <- "ZipCode"

names(liq_na_cat)[names(liq_na_cat) == "County Number"] <- "CountyNumber"

names(liq_na_cat)[names(liq_na_cat) == "Vendor Number"] <- "VendorNumber"

names(liq_na_cat)[names(liq_na_cat) == "Item Number"] <- "ItemNumber"

head(liq_na_cat)

# fill missing value for categorical variable 
install.packages("mice")
library(mice)
imputed_Data_cat <- mice(liq_na_cat, m=5, maxit = 10, method = "polyreg")
md.pattern(liq_na_cat)

# try in small data for imputation
liq_na_cat_sample=liq_na_cat[1:20,]

imputed_Data_cat2 <- mice(liq_na_cat_sample, m=5, maxit = 10, method = "polyreg")
liq_na$StateBottleRetail=imputed_Data_cat2$imp$City$`5`

nrow(liq_na_cat)
#liq_na$StateBottleRetail=imputed_Data$imp$StateBottleRetail$`5`

#liquor_train_cor[rowSums(is.na(liquor_train_cor)) > 0,]=liq_na

#sum(is.na(liquor_train_cor$StateBottleRetail))


str(liq_na_cat)

'''
