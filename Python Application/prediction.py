import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split
import json

data = pd.read_csv('HR_comma_sep.csv')
data['sales'].replace(['sales', 'accounting', 'hr', 'technical', 'support', 'management',
                       'IT', 'product_mng', 'marketing', 'RandD'], [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], inplace=True)
data['salary'].replace(['low', 'medium', 'high'], [0, 1, 2], inplace=True)
label = data.pop('left')
data_train, data_test, label_train, label_test = train_test_split(data, label, test_size = 0.2, random_state = 42)
from sklearn.linear_model import LogisticRegression
logis = LogisticRegression()
logis.fit(data_train, label_train)
logis_score_train = logis.score(data_train, label_train)
#print("Training score: ",logis_score_train)
logis_score_test = logis.score(data_test, label_test)
#print("Testing score: ",logis_score_test)

from sklearn.ensemble import RandomForestClassifier
rfc = RandomForestClassifier()
rfc.fit(data_train, label_train)
rfc_score_train = rfc.score(data_train, label_train)
#print("Training score: ",rfc_score_train)
rfc_score_test = rfc.score(data_test, label_test)
input = [0.45,0.54,2,135,3,0,0,0,0]
prediction = rfc.predict(input)

output = {}
output["prediction"] = prediction
op=json.dumps(output)
parsed = json.loads(op)
print json.dumps(parsed)




#print("Testing score: ",rfc_score_test)
