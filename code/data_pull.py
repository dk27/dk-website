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

url = "https://api.spacexdata.com/v3/launches"
r = requests.get(url)
spacexdata = json.loads(r.text)
print(len(spacexdata))
print(spacexdata)
