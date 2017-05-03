import numpy as np
import pandas as pd
import json

training_data = 'HR_comma_sep.csv'
data = pd.read_csv(training_data)
print data.isnull().values.any()

salary_labels = {'low':0,'medium':1,'high':2}
data['salary'] = data['salary'].map(salary_labels)

data.rename(columns={'sales': 'department'}, inplace=True)

department_labels = {'sales':0,'accounting':1,'hr':2, 'technical':3, 'support':4,
                     'management':5, 'IT':6, 'product_mng':7, 'marketing':8, 'RandD':9}
data['department'] = data['department'].map(department_labels)
data.loc[data['satisfaction_level'] < .2, 'satisfaction_bins'] = 0
data.loc[(data['satisfaction_level'] >= .2) & (data['satisfaction_level'] < .4), 'satisfaction_bins'] = 1
data.loc[(data['satisfaction_level'] >= .4) & (data['satisfaction_level'] < .6), 'satisfaction_bins'] = 2
data.loc[(data['satisfaction_level'] >= .6) & (data['satisfaction_level'] < .8), 'satisfaction_bins'] = 3
data.loc[data['satisfaction_level'] >= .8, 'satisfaction_bins'] = 4

data.loc[data['last_evaluation'] < .2, 'evaluation_bins'] = 0
data.loc[(data['last_evaluation'] >= .2) & (data['last_evaluation'] < .4), 'evaluation_bins'] = 1
data.loc[(data['last_evaluation'] >= .4) & (data['last_evaluation'] < .6), 'evaluation_bins'] = 2
data.loc[(data['last_evaluation'] >= .6) & (data['last_evaluation'] < .8), 'evaluation_bins'] = 3
data.loc[data['last_evaluation'] >= .8, 'evaluation_bins'] = 4
left_data = data[data.left == 1]
print left_data

result={}
numberLeft=left_data.groupby('number_project').size()
#print numberLeft.keys()
print numberLeft.to_json
for i in numberLeft.keys():
    result[int(str(i))] = int(str(numberLeft[i]))
#print json.dumps(result)


