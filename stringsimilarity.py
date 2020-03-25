#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Mar 22 22:53:02 2020

@author: saptarshimaiti
"""

#import pandas_profiling as pp

import pandas as pd

#pip install python-Levenshtein

import Levenshtein as lvnstn

import re

import reverse_geocoder as rg 

import gc



df = pd.read_csv('/Users/saptarshimaiti/Desktop/Data Preparation And Analysis/Project/Iowa_Liquor_Sales_Cleaned_v2.csv', low_memory = False)

#report = pp.ProfileReport(df)

#del report

pd.set_option('display.max_columns', 500)

#report.to_file('profile_report_v1.html')

cities = df['City'].unique()

counties = df['County'].unique()


cities_dict = {}
cities_dict['Primary City'] = []
cities_dict['Secondary City'] = []
cities_dict['Similarity'] = []



def citySimilarity(cities):
    for city in cities:
    
        for city_sim in cities:
            similarity = lvnstn.distance(city, city_sim)
            cities_dict['Primary City'].append(city)
            cities_dict['Secondary City'].append(city_sim)
            cities_dict['Similarity'].append(similarity)

citySimilarity(cities)    

        
df_similarity = pd.DataFrame.from_dict(cities_dict, orient='index').T

df_similarity = df_similarity.drop_duplicates()

df_similarity[df_similarity['Similarity'] == 2]

        
coordinates = df['Store Location'].unique()


for coordinate in coordinates:
    
    longitude, latitude = re.sub(r' ',",",re.sub(r'\)',"",re.sub(r'POINT \(',"", coordinate))).split(',')
    city = rg.search((latitude, longitude))[0]['name']
    df.loc[(df['City'] != city) & (df['Store Location'] == coordinate), 'City'] = city
    
    

 
cities = df['City'].unique()

counties = df['County'].unique()


cities_dict = {}
cities_dict['Primary City'] = []
cities_dict['Secondary City'] = []
cities_dict['Similarity'] = []



def citySimilarity(cities):
    for city in cities:
    
        for city_sim in cities:
            similarity = lvnstn.distance(city, city_sim)
            cities_dict['Primary City'].append(city)
            cities_dict['Secondary City'].append(city_sim)
            cities_dict['Similarity'].append(similarity)

citySimilarity(cities)    

df_similarity_tst = pd.DataFrame.from_dict(cities_dict, orient='index').T

df_similarity_tst = df_similarity_tst.drop_duplicates()

df_similarity_tst[df_similarity_tst['Similarity'] == 1]

#-------------- County ----------#

county_dict = {}
county_dict['Primary County'] = []
county_dict['Secondary County'] = []
county_dict['Similarity'] = []



def countySimilarity(counties):
    for county in counties:
        for county_sim in counties:
            similarity = lvnstn.distance(county, county_sim)
            county_dict['Primary County'].append(county)
            county_dict['Secondary County'].append(county_sim)
            county_dict['Similarity'].append(similarity)

countySimilarity(counties) 

df_similarity = pd.DataFrame.from_dict(county_dict, orient='index').T

df_similarity = df_similarity.drop_duplicates()

df_similarity[df_similarity['Similarity'] == 1]



for coordinate in coordinates:
    
    longitude, latitude = re.sub(r' ',",",re.sub(r'\)',"",re.sub(r'POINT \(',"", coordinate))).split(',')
    county = re.sub(r' County',"",rg.search((latitude, longitude))[0]['admin2'])
    df.loc[(df['County'] != county) & (df['Store Location'] == coordinate), 'County'] = county
    
df.to_csv(r'/Users/saptarshimaiti/Desktop/Data Preparation And Analysis/Project/Iowa_Liquor_Sales_Cleaned_v3.csv', index = False, header=True)
gc.collect()