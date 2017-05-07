import numpy as np
import pandas as pd
import json
from sklearn import tree
import pydotplus
# inputs
training_data = 'HR_comma_sep.csv'
df = pd.read_csv(training_data)
df['sales'].replace(['sales', 'accounting', 'hr', 'technical', 'support', 'management',
                     'IT', 'product_mng', 'marketing', 'RandD'], [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], inplace=True)

df['salary'].replace(['low', 'medium', 'high'], [0, 1, 2], inplace=True)
label = df.pop('left')
clf = tree.DecisionTreeClassifier()
clf = clf.fit(df, label)

dot_data = tree.export_graphviz(clf, out_file=None)
graph = pydotplus.graph_from_dot_data(dot_data)
graph.write_pdf("HRAnalytics.pdf")



