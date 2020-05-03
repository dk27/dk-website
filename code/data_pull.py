# import commonly used libraries
import pypyodbc 
import pymysql 
import pandas as pd
import requests, json

# use pandas library to import a csv file
import pandas as pd
# skiprows option allows us to skip empty rows
df = pd.read_csv("GDP.csv", skiprows = 4)
# drop empty columns
drop_col = [2,5]
df = df.drop(df.columns[drop_col], axis = 1)
# create a list with column names
columns = ['CountryCode', 'Rank', 'CountryName', 'GDP']
# rename columns 
df.columns = columns
# check what our data frame looks like 
df.head()
# almost there! We just need to get rid of NaN records.
# we can try dropna function which would drop rows where at least one element is NA
df = df.dropna()

# relational databases
import pypyodbc
import pymysql
import cx_Oracle

# pypyodbc
conn_mssql = pypyodbc.connect("DRIVER={SQL Server};SERVER=server_name;UID=user_name;PWD=password;DATABASE=db")
cursor_mssql = conn_mssql.cursor()
query = ("select * from table_name")
cursor_mssql.execute(query)
# convert the output into a dataframe
df = pd.DataFrame(cursor_mssql.fetchall())
# pymysql
conn_mysql = pymysql.connect(host='host_name', user='user', password = 'pwd', db = 'db')
cursor_mysql = conn_mysql.cursor()
cursor_mysql.execute(query)
df = pd.DataFrame(cursor_mysql.fetchall())
# Oracle

# API

# import libraries
import requests, json, xmlToDict
import pandas as pd

url = "https://api.openaq.org/v1/countries"
# use get function from requests library to make a GET request
# No Authentication or parameters are required for this API
r = requests.get(url)
print(r) # returns Response[200] which indicates a successful response
# to view the actual response, we can use .text method which will return the response as a string
print(type(r.text)) # returns class 'str'
# loads function in json package allows us to convert a string to a dictionary
country_data = json.loads(r.text)
# view the response
print(country_data)
# pring first dictionary in the results array
print(country_data['results'][0])
# print value of "name" key in the results of the above query
print(country_data['results'][0]['name'])
# convert results list of dictionaries into a pandas data frame
df = pd.DataFrame(country_data['results'])

import xmltodict
xml = """<?xml version="1.0" encoding="UTF-8"?><products><product><name>Dom quixote de La Mancha</name><quantity>12</quantity><category>Book</category></product><product><name>Hamlet</name><quantity>3</quantity><category>Book</category></product><product><name>War and Peace</name><quantity>7</quantity><category>Book</category></product><product><name>Moby Dick</name><quantity>14</quantity><category>Book</category></product></products>"""
xml_json = xmltodict.parse(xml) 
# first element in the list
xml_json['products']['product'][0]
# OrderedDict([('name', 'Dom quixote de La Mancha'), ('quantity', '12'), ('category', 'Book')])

# extract name in 1st element
xml_json['products']['product'][0]['name']
# 'Dom quixote de La Mancha'










