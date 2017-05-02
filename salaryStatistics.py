import numpy as np
import pandas as pd
import json

df = pd.read_csv("HR_comma_sep.csv")
based_onpromotion = df.groupby('sales')[['promotion_last_5years']].count()
promotion = json.loads(based_onpromotion.reset_index().to_json(orient='records'))
output = {}

for key in promotion:
    output[key['sales']] = key['promotion_last_5years']

print json.dumps(output)


