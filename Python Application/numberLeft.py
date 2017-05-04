import numpy as np
import pandas as pd
import json

training_data = 'HR_comma_sep.csv'
data = pd.read_csv(training_data)

left  = data[data['left']==1]
stay = data[data['left']==0]

leftStats = left.mean()
stayStats = stay.mean()

output ={}

for i in stayStats.keys():
    output[i] = str(stayStats[i])

for i in leftStats.keys():
    result = []
    result.append(output[i])
    result.append(str(leftStats[i]))
    output[i] = result

print json.dumps(output)

