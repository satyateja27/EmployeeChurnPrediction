import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import json

hr_data = pd.read_csv('HR_comma_sep.csv')
hr_data['dept'] = hr_data['sales']
hr_data.drop(['sales'], axis = 1, inplace = True)
left_data = hr_data[hr_data.left == 1]
left = left_data.groupby('dept').size()
total = hr_data.groupby('dept').size()

depts = []
result = {}

for i in left.keys():
    count = []
    count.append(int(str(left[i])))
    result[i]=count
for i in total.keys():
    count = []
    count = result[i]
    count.append(int(str(total[i])))
    result[i] = count
print (json.dumps(result))

