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



url = "https://api.spacexdata.com/v3/launches"
r = requests.get(url)
spacexdata = json.loads(r.text)
print(len(spacexdata))
print(spacexdata)
