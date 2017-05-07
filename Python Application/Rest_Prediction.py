import sys
import os
import shutil
import time
import traceback
import json
import numpy as np
import warnings
warnings.filterwarnings("ignore")

from flask import Flask, request, jsonify,Response
from flask_cors import CORS, cross_origin
import pandas as pd
from sklearn.externals import joblib

app = Flask(__name__)
CORS(app)

# inputs
training_data = 'HR_comma_sep.csv'
model_directory = 'model'
model_file_name = '%s/model.pkl' % model_directory
model_columns_file_name = '%s/model_columns.pkl' % model_directory

# These will be populated at training time
model_columns = None
clf = None


@app.route('/getFeatureImportance',methods=['GET'])
def getFeatureImportance():
    import numpy as np
    import pandas as pd
    from sklearn.preprocessing import MinMaxScaler, LabelEncoder
    from sklearn.model_selection import train_test_split, StratifiedKFold
    from sklearn.tree import DecisionTreeClassifier
    import json

    def rank_satisfaction(employee):
        level = "unknown"
        if employee.satisfaction_level < 0.45:
            level = 'low'
        elif employee.satisfaction_level < 0.75:
            level = 'medium'
        else:
            level = 'high'
        return level

    hr_df = pd.read_csv('HR_comma_sep.csv')
    hr_df['satisfaction'] = hr_df.apply(rank_satisfaction, axis=1)
    y = hr_df.satisfaction.copy()
    X = hr_df.copy()
    X = X.drop(["left", "satisfaction_level", "satisfaction"], axis=1)

    le_sales = LabelEncoder()
    le_salary = LabelEncoder()
    le_satisfaction = LabelEncoder()
    le_sales.fit(X.sales)
    le_salary.fit(X.salary)
    le_satisfaction.fit(y)
    X.sales = le_sales.transform(X.sales)
    X.salary = le_salary.transform(X.salary)
    y = le_salary.transform(y)
    y = np.float32(y)
    min_max_scaler = MinMaxScaler()
    X = min_max_scaler.fit_transform(X)
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42, stratify=y)
    happiness_decision_tree = DecisionTreeClassifier()

    # Stratify split and train on 5 folds
    skf = StratifiedKFold(n_splits=5)
    counter = 1
    for train_fold, test_fold in skf.split(X_train, y_train):
        happiness_decision_tree.fit(X_train[train_fold], y_train[train_fold])
        print(str(counter) + ": ", happiness_decision_tree.score(X_train[test_fold], y_train[test_fold]))
        counter += 1
        features_order = ['last_evaluation', 'number_project', 'average_montly_hours',
                          'time_spend_company', 'Work_accident', 'promotion_last_5years', 'sales', 'salary']
    output = {key: val for key, val in zip(features_order, happiness_decision_tree.feature_importances_)}
    return Response(json.dumps(output), mimetype='application/json')


@app.route('/getGoodEmployeeChurn',methods=['GET'])
def getGoodEmployeeChurn():
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
    result = good_employees_still_working_df.head(100).groupby('department').size()

    output = {}

    for i in result.keys():
        output[i] = int(str(result[i]))
    return Response(json.dumps(output), mimetype='application/json')

@app.route('/getMeanData',methods=['GET'])
def getMeanData():
    import numpy as np
    import pandas as pd
    import json

    training_data = 'HR_comma_sep.csv'
    data = pd.read_csv(training_data)

    left = data[data['left'] == 1]
    stay = data[data['left'] == 0]

    leftStats = left.mean()
    stayStats = stay.mean()

    output = {}

    for i in stayStats.keys():
        output[i] = str(stayStats[i])

    for i in leftStats.keys():
        result = []
        result.append(output[i])
        result.append(str(leftStats[i]))
        output[i] = result

    return Response(json.dumps(output),mimetype='application/json')


@app.route('/train', methods=['GET'])
def train():

    from sklearn.ensemble import RandomForestClassifier as rf

    df = pd.read_csv(training_data)
    df['sales'].replace(['sales', 'accounting', 'hr', 'technical', 'support', 'management',
                           'IT', 'product_mng', 'marketing', 'RandD'], [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], inplace=True)

    df['salary'].replace(['low', 'medium', 'high'], [0, 1, 2], inplace=True)
    label = df.pop('left')

    global model_columns
    model_columns = list(df.columns)
    joblib.dump(model_columns, model_columns_file_name)

    global clf
    clf = rf()
    start = time.time()
    clf.fit(df, label)
    print 'Trained in %.1f seconds' % (time.time() - start)
    print 'Model training score: %s' % clf.score(df, label)

    joblib.dump(clf, model_file_name)

    return 'Success'


@app.route('/getEmpByDept', methods=['GET'])
def getEmpByDept():
    import numpy as np
    import pandas as pd
    import json
    from sklearn.cluster import KMeans

    # inputs
    training_data = 'HR_comma_sep.csv'
    data = pd.read_csv(training_data)

    from sklearn.cluster import KMeans
    kmeans_df = data[data.left == 1].drop([u'number_project',
                                           u'average_montly_hours', u'time_spend_company', u'Work_accident',
                                           u'left', u'promotion_last_5years', u'sales', u'salary'], axis=1)

    kmeans = KMeans(n_clusters=3, random_state=0).fit(kmeans_df)
    # print(kmeans.cluster_centers_)

    left = data[data.left == 1]

    left['label'] = kmeans.labels_
    winners_hours_std = np.std(left.average_montly_hours[left.label == 0])
    frustrated_hours_std = np.std(left.average_montly_hours[left.label == 1])
    bad_match_hours_std = np.std(left.average_montly_hours[left.label == 2])
    winners = left[left.label == 0]
    frustrated = left[left.label == 1]
    bad_match = left[left.label == 2]

    def get_pct(df1, df2, value_list, feature):
        pct = []
        for value in value_list:
            pct.append(np.true_divide(len(df1[df1[feature] == value]), len(df2[df2[feature] == value])))
        return pct

    columns = ['sales', 'winners', 'bad_match', 'frustrated']
    winners_list = get_pct(winners, left, np.unique(left.sales), 'sales')
    frustrated_list = get_pct(frustrated, left, np.unique(left.sales), 'sales')
    bad_match_list = get_pct(bad_match, left, np.unique(left.sales), 'sales')
    output = {}

    def get_num(df, value_list, feature):
        for val in value_list:
            if output.has_key(val):
                result = []
                result = output[val]
                value = np.append(result, np.true_divide(len(df[df[feature] == val]), len(df)))
                output[val] = value.tolist()
            else:
                result = []
                output[val] = np.true_divide(len(df[df[feature] == val]), len(df))

    winners_list = get_num(winners, np.unique(left.sales), 'sales')
    frustrated_list = get_num(frustrated, np.unique(left.sales), 'sales')
    bad_match_list = get_num(bad_match, np.unique(left.sales), 'sales')

    return json.dumps(output)
@app.route('/getSalaryStats',methods=['GET'])
def getSalaryStats():
    import numpy as np
    import pandas as pd
    import json
    df = pd.read_csv("HR_comma_sep.csv")
    current = df[df.left == 0]
    left = df[df.left == 1]
    currentStats = pd.crosstab([current.sales], current.salary)
    leftStats = pd.crosstab([left.sales], left.salary)
    currentMap = {}
    rightMap = json.loads(currentStats.to_json())
    currentMap[0] = rightMap
    leftMap = json.loads(leftStats.to_json())
    currentMap[1] = leftMap
    return Response(json.dumps(currentMap), mimetype='application/json')
@app.route('/getPromotionStats',methods=['GET'])
def getPromotionStats():
    import numpy as np
    import pandas as pd
    import json

    df = pd.read_csv("HR_comma_sep.csv")
    based_onpromotion = df.groupby('sales')[['promotion_last_5years']].count()
    promotion = json.loads(based_onpromotion.reset_index().to_json(orient='records'))
    output = {}
    for key in promotion:
        output[key['sales']] = key['promotion_last_5years']
    return Response(json.dumps(output),  mimetype='application/json')

@app.route('/getProjectStats',methods=['GET'])
def getProjectStats():
    import numpy as np
    import pandas as pd
    from scipy.stats import mode, skew, skewtest
    from sklearn.preprocessing import StandardScaler, LabelEncoder
    from sklearn.ensemble import RandomForestClassifier
    from sklearn.cross_validation import StratifiedKFold, train_test_split
    def set_threshold(x):
        if x['satisfaction_level'] > 0.5:
            x['satisfy_new'] = 1.0
        else:
            x['satisfy_new'] = 0.0
        return x

    data = pd.read_csv("HR_comma_sep.csv")
    train, test = train_test_split(data, train_size=0.95, test_size=0.05)
    forest = RandomForestClassifier(n_estimators=100, n_jobs=-1)
    forest.fit(train.drop(['left', 'salary', 'sales'], 1), train['left'])
    train = train.apply(lambda x: set_threshold(x), 1)
    train.drop('satisfy_new', 1, inplace=True)
    train['number_project'].value_counts()
    result = pd.crosstab(train['number_project'], train['left'], )
    return result.to_json()

@app.route('/getTimeSpendCompany',methods=['GET'])
def getTimeSpendCompany():
    import numpy as np
    import pandas as pd
    from scipy.stats import mode, skew, skewtest
    from sklearn.preprocessing import StandardScaler, LabelEncoder
    from sklearn.ensemble import RandomForestClassifier
    from sklearn.cross_validation import StratifiedKFold, train_test_split
    def set_threshold(x):
        if x['satisfaction_level'] > 0.5:
            x['satisfy_new'] = 1.0
        else:
            x['satisfy_new'] = 0.0
        return x

    data = pd.read_csv("HR_comma_sep.csv")
    train, test = train_test_split(data, train_size=0.95, test_size=0.05)
    forest = RandomForestClassifier(n_estimators=100, n_jobs=-1)
    forest.fit(train.drop(['left', 'salary', 'sales'], 1), train['left'])
    train = train.apply(lambda x: set_threshold(x), 1)
    train.drop('satisfy_new', 1, inplace=True)
    train['number_project'].value_counts()
    result = pd.crosstab(train['time_spend_company'], train['left'])
    return result.to_json()


@app.route('/getDeptTrends', methods=['GET'])
def getDeptTrends():
    #Libraries
    import pandas as pd
    import matplotlib.pyplot as plt
    import numpy as np
    import json
    #Read CSV into Pandas
    hr_data = pd.read_csv('HR_comma_sep.csv')
    hr_data['dept'] = hr_data['sales']
    hr_data.drop(['sales'], axis=1, inplace=True)
    left_data = hr_data[hr_data.left == 1]
    left = left_data.groupby('dept').size()
    total = hr_data.groupby('dept').size()
    #Result JSON Decleration
    depts = []
    result = {}
    #Result JSON Generation
    for i in left.keys():
        count = []
        count.append(int(str(left[i])))
        result[i] = count
    for i in total.keys():
        count = []
        count = result[i]
        count.append(int(str(total[i])))
        result[i] = count
    return Response(json.dumps(result),  mimetype='application/json')

@app.route('/predict', methods=['POST'])
def predict():
    if clf:
        try:
            json_ = request.json
            input = []
            input.append(json_['satisfaction_level'])
            input.append(json_["last_evaluation"])
            input.append(json_["number_project"])
            input.append(json_["average_montly_hours"])
            input.append(json_["time_spend_company"])
            input.append(json_["Work_accident"])
            input.append(json_["promotion_last_5years"])
            input.append(json_["sales"])
            input.append(json_["salary"])
            print input
            prediction = list(clf.predict(input))
            print str(prediction)
            return json.dumps({"prediction":int(str(prediction[0])),"input":json_})

        except Exception, e:

            return jsonify({'error': str(e), 'trace': traceback.format_exc()})
    else:
        print 'train first'
        return 'no model here'

if __name__ == '__main__':
    try:
        port = int(sys.argv[1])
    except Exception, e:
        port = 80

    try:
        clf = joblib.load(model_file_name)
        print 'model loaded'
        model_columns = joblib.load(model_columns_file_name)
        print 'model columns loaded'

    except Exception, e:
        print 'No model here'
        print 'Train first'
        print str(e)
        clf = None

    app.run(host='0.0.0.0', port=port, debug=True)