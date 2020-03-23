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

df = pd.read_csv('/Users/saptarshimaiti/Desktop/Data Preparation And Analysis/Project/Iowa_Liquor_Sales_Cleaned_v1.csv')

#report = pp.ProfileReport(df)

#del report

pd.set_option('display.max_columns', 500)

#report.to_file('profile_report_v1.html')

cities = df['City'].unique()

counties = df['County'].unique()





