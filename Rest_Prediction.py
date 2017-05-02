import sys
import os
import shutil
import time
import traceback
import json
import numpy as np
import warnings
warnings.filterwarnings("ignore")

from flask import Flask, request, jsonify
import pandas as pd
from sklearn.externals import joblib

app = Flask(__name__)

# inputs
training_data = 'HR_comma_sep.csv'
model_directory = 'model'
model_file_name = '%s/model.pkl' % model_directory
model_columns_file_name = '%s/model_columns.pkl' % model_directory

# These will be populated at training time
model_columns = None
clf = None

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
    return json.dumps(result)

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