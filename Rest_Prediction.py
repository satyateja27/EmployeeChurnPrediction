import sys
import os
import shutil
import time
import traceback
import json

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