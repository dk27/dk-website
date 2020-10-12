sql_app = {}

// table 1
sql_app.provinces = [
    {'id':1, 'name': 'Newfoundland and Labrador', 'code': 'NL', 'region': 'Atlantic'},
    {'id':2, 'name': 'Prince Edward Island', 'code': 'PE', 'region': 'Atlantic'},
    {'id':3, 'name': 'Nova Scotia', 'code': 'NS', 'region': 'Atlantic'},
    {'id':4, 'name': 'New Brunswick', 'code': 'NB', 'region': 'Atlantic'},
    {'id':5, 'name': 'Quebec', 'code': 'QC', 'region': 'Quebec'},
    {'id':6, 'name': 'Ontario', 'code': 'ON', 'region': 'Ontario'},
    {'id':7, 'name': 'Manitoba', 'code': 'MB', 'region': 'Prairies'},
    {'id':8, 'name': 'Saskatchewan', 'code': 'SK', 'region': 'Prairies'},
    {'id':9, 'name': 'Alberta', 'code': 'AB', 'region': 'Prairies'},
    {'id':10, 'name': 'British Columbia', 'code': 'BC', 'region': 'British Columbia'},
    {'id':11, 'name': 'Yukon', 'code': 'YT', 'region': 'Territories'},
    {'id':12, 'name': 'Northwest Territories', 'code': 'NT', 'region': 'Territories'},
    {'id':13, 'name': 'Nunavut', 'code': 'NU', 'region': 'Territories'}
]

sql_app.capitals = [
    {'id':1, 'capital': 'St.Johns', 'population': 519716, 'area': 370514.08},
    {'id':2, 'capital': 'Charlottetown', 'population': 142907, 'area': 5686.03},
    {'id':3, 'capital': 'Halifax', 'population': 923598, 'area': 52942.27},
    {'id':4, 'capital': 'Fredericton', 'population': 747101, 'area': 71388.81},
    {'id':5, 'capital': 'Quebec City', 'population': 8164361, 'area': 1356625.27},
    {'id':6, 'capital': 'Toronto', 'population': 13448494, 'area': 908699.33},
    {'id':7, 'capital': 'Winnipeg', 'population': 1278365, 'area': 552370.99},
    {'id':8, 'capital': 'Regina', 'population': 1098352, 'area': 588243.54},
    {'id':9, 'capital': 'Edmonton', 'population': 4067175, 'area': 640330.46},
    {'id':10, 'capital': 'Victoria', 'population': 4648055, 'area': 933503.01},
    {'id':11, 'capital': 'Whitehorse', 'population': 35874, 'area': 474712.68},
    {'id':12, 'capital': 'Yellowknife', 'population': 41786, 'area': 1143793.86},
    {'id':13, 'capital': 'Iqaluit', 'population': 35944, 'area': 1877778.53}
]

sql_app.show_tables = function(input_string){
    input_string = input_string.toLowerCase()
    input_string = input_string.replace(/\s+/g,' ').trim();
    if (input_string == "show tables;" || input_string == "show tables") {
        console.log(sql_app.provinces);
        console.log(sql_app.capitals);
    }
    else (
        console.log("Did you spell your statement correctly?")
    )
}

$(function() {

});

