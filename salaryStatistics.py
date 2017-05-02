import numpy as np
import pandas as pd
from scipy.stats import mode,skew,skewtest
from sklearn.preprocessing import StandardScaler,LabelEncoder
from sklearn.ensemble import RandomForestClassifier
from sklearn.cross_validation import StratifiedKFold,train_test_split
def set_threshold(x):
    if x['satisfaction_level']>0.5:
        x['satisfy_new']=1.0
    else:
        x['satisfy_new']=0.0
    return x
data = pd.read_csv("HR_comma_sep.csv")
train,test=train_test_split(data,train_size=0.95,test_size=0.05)
forest=RandomForestClassifier(n_estimators=100,n_jobs=-1)
forest.fit(train.drop(['left','salary','sales'],1),train['left'])
train=train.apply(lambda x:set_threshold(x),1)
train.drop('satisfy_new',1,inplace=True)
train['number_project'].value_counts()
result = pd.crosstab(train['time_spend_company'],train['left'])
print result.to_json()


