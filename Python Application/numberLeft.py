import mysql.connector as sql
import pandas as pd
import numpy as np
import json

db_connection = sql.connect(host='hranalytics.czcxvxuswvxe.us-west-1.rds.amazonaws.com',
                            database='EmployeeChurnPrediction', user='Sjspartan16', password='Sjspartan16')
df = pd.read_sql('SELECT * FROM employee', con=db_connection)

def run_cv(X, y, clf_class, method, **kwargs):
    from sklearn.model_selection import cross_val_predict

    # Initialize a classifier with key word arguments
    clf = clf_class(**kwargs)

    predicted = cross_val_predict(clf, X, y, cv=3, method=method)

    return predicted

leave_df = pd.read_csv('HR_comma_sep.csv')
col_names = leave_df.columns.tolist()
print("Column names:")
print (col_names)

y = leave_df['left']
to_drop = ['salary', 'left']
leave_feat_space = leave_df.drop(to_drop, axis=1)
features = leave_feat_space.columns
from sklearn import preprocessing
le_sales = preprocessing.LabelEncoder()
le_sales.fit(leave_feat_space["sales"])
leave_feat_space["sales"] = le_sales.transform(leave_feat_space.loc[:, ('sales')])
X = leave_feat_space.as_matrix().astype(np.float)
scaler = preprocessing.StandardScaler()
X = scaler.fit_transform(X)
from sklearn.svm import SVC
from sklearn.ensemble import RandomForestClassifier as RF
from sklearn.neighbors import KNeighborsClassifier as KNN
from sklearn import metrics

def accuracy(y, predicted):
    # NumPy interprets True and False as 1. and 0.
    return metrics.accuracy_score(y, predicted)

from sklearn.metrics import confusion_matrix
y = np.array(y)
class_names = np.unique(y)
confusion_matrices = [
    ("Support Vector Machines", confusion_matrix(y, run_cv(X, y, SVC, method='predict'))),
    ("Random Forest", confusion_matrix(y, run_cv(X, y, RF, method='predict'))),
    ("K-Nearest-Neighbors", confusion_matrix(y, run_cv(X, y, KNN, method='predict'))),
]

pred_prob = run_cv(X, y, RF, n_estimators=10, method='predict_proba', )

pred_leave = pred_prob[:, 1]
is_leave = y == 1

counts = pd.value_counts(pred_leave)
true_prob = {}
for prob in counts.index:
    true_prob[prob] = np.mean(is_leave[pred_leave == prob])
    true_prob = pd.Series(true_prob)

counts = pd.concat([counts, true_prob], axis=1).reset_index()
counts.columns = ['pred_prob', 'count', 'true_prob']
pred_prob_df = pd.DataFrame(pred_prob)
pred_prob_df.columns = ['prob_not_leaving', 'prob_leaving']
all_employees_pred_prob_df = pd.concat([df, pred_prob_df], axis=1)
good_employees_still_working_df = all_employees_pred_prob_df[(all_employees_pred_prob_df["last_evaluation"] >= 0.7)]
good_employees_still_working_df.sort_values(by='prob_leaving', ascending=False, inplace=True)
result = good_employees_still_working_df.head(100)

print result