This repo contains .R and .py files for the project Iowa Liquor Sales.

Overview
The Iowa Alcoholic Beverages Division is the alcoholic beverage control authority for the U.S. state of Iowa. This division regulates the alcohol traffic and has a monopoly on the wholesaling of alcoholic beverages in the state.
Our models are about making suggestions to The Iowa Alcoholic Beverages Division regarding reducing inventory costs and give insights into sale patterns of Alcohol at each county in Iowa. We intend to deliver the following objectives:
1. 	Predict the sale of liquor volume
2. 	Identify the top liquor brands sold and assess their popularity
3. 	Make suggestions for locations of delivery pads to reduce inventory costs.
4. 	Investigate sale trends based on public events and holidays in IOWA
5. 	Find the most common brands of liquor sold together at each county
 
Model No.1: Time series Model
We aim at making a good Time Series model in order to  forecast category wise Liquor sales. This will help the Iowa state administration to figure out what kind of liquor has more chances to be sold in the coming time. For this purpose we need to estimate and eliminate the trend and seasonal components in the time series data. Find if our series is stationary or non-stationary, and then make a choice of appropriate model.

Model No.2: Apriori Classification
It will help us find the association between the brands of liquor purchased by liquor stores in each county. We want to find the most common liquor brands mostly bought together at the county level by the stores and help us assess popularity and dependency among these liquor brands.

Model No.3: Clustering
We want to make suggestions to the Iowa Alcoholic Beverages Division to build some delivery pads near the areas with high concentration of liquor shops. We will use latitude and longitude of store locations to group all the stores in short distance from each other into a single cluster and identify these localities in each county to suggest nearby locations for delivery pads.

Model No.4: Linear Regression
Use demographic data to check the relation between per capita income and liquor volume sold in a county and we will choose the top county in terms of liquor sales and find what are the top brands sold in that county using regression.

Data Source
We are using following data:
1. IOWA Liquor Sales data
Website: https://data.iowa.gov/Sales-Distribution/Iowa-Liquor-Sales/m3tr-qhgy/data
           
Data Overview:
This dataset contains the spirits purchase information of Iowa Class “E” liquor licensees by product and date of purchase from January 1, 2012 to current. Class E liquor license, for grocery stores, liquor stores, convenience stores, etc., allows commercial establishments to sell liquor for off-premises consumption in original unopened containers.
Along with the date this dataset contains information on the name, kind, price, quantity, and location of sale of individual containers or packages of containers of alcoholic beverages.
 
Columns Description:
·   Invoice/Item Number: Concatenated invoice and line number associated with the liquor order.
·   Date: Date of Order
·   Store Number: Unique number assigned to the store who ordered the liquor.
·   Store Name: Name of store who ordered the liquor.
·   Address: Address of the store who ordered the liquor.
·   City: City where the store who ordered the liquor is located
·   Zip Code: Zip code where the store who ordered the liquor is located
·   Location: Location of store who ordered the liquor. The Address, City, State and Zip Code are geocoded to provide geographic coordinates. Accuracy of geocoding is dependent on how well the address is interpreted and the completeness of the reference data used.
·   Country Number: Iowa county number for the county where store who ordered the liquor is located
·   Country: County where the store who ordered the liquor is located
·   Category: Category code associated with the liquor ordered
·   Category Name: Category of the liquor ordered.
·   Vendor Number: The vendor number of the company for the brand of liquor ordered
·   Vendor Name: The vendor name of the company for the brand of liquor ordered
·   Item Number: Item number for the individual liquor product ordered.
·   Item Description: Description of the individual liquor product ordered.
·   Pack: The number of bottles in a case for the liquor ordered
·   Bottle Volume: Volume of each liquor bottle ordered in milliliters.
·   State Bottle Cost: The amount that Alcoholic Beverages Division paid for each bottle of liquor ordered
·   State Bottle Retail: The amount the store paid for each bottle of liquor ordered
·   Bottle Sold: The number of bottles of liquor ordered by the store
·   Sale (Dollar): Total cost of liquor order (number of bottles multiplied by the state bottle retail)
·   Volume Sold (litre): Total volume of liquor ordered in liters. (i.e. (Bottle Volume (ml) x Bottles Sold)/1,000)
·   Volume Sold (Gallon): Total volume of liquor ordered in gallons. (i.e. (Bottle Volume (ml) x Bottles Sold)/3785.411784)

2. Demographic Data: United States

Website: https://apps.bea.gov/iTable/index_regional.cfm

Data Overview:
The data describes the Per capita income for every state of united states and their respective county in dollars for the year 2016, 2017 and 2018 and their percentage change from the preceding period.
 
Column Description:
·  States: State of US
·  County: Name of the county under the respective state
·  Per capita personal income: Per capita income of the county and states
·  Percent change from preceding period: Percent change in Per capita income from previous year