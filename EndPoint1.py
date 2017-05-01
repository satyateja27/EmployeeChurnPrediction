import numpy as np
import pandas as pd
import json
from sklearn.cluster import KMeans

# inputs
training_data = 'HR_comma_sep.csv'
data = pd.read_csv(training_data)


from sklearn.cluster import KMeans
kmeans_df= data[data.left==1].drop([ u'number_project',
       u'average_montly_hours', u'time_spend_company', u'Work_accident',
       u'left', u'promotion_last_5years', u'sales', u'salary'],axis = 1)

kmeans = KMeans(n_clusters = 3, random_state = 0).fit(kmeans_df)
#print(kmeans.cluster_centers_)

left=data[data.left == 1]

left['label']=kmeans.labels_
winners_hours_std = np.std(left.average_montly_hours[left.label == 0])
frustrated_hours_std = np.std(left.average_montly_hours[left.label == 1])
bad_match_hours_std = np.std(left.average_montly_hours[left.label == 2])
winners = left[left.label ==0]
frustrated = left[left.label == 1]
bad_match = left[left.label == 2]

def get_pct(df1,df2, value_list,feature):
    pct = []
    for value in value_list:
        pct.append(np.true_divide(len(df1[df1[feature] == value]),len(df2[df2[feature] == value])))
    return pct
columns = ['sales','winners','bad_match','frustrated']
winners_list = get_pct(winners,left,np.unique(left.sales),'sales')
frustrated_list = get_pct(frustrated,left,np.unique(left.sales),'sales')
bad_match_list = get_pct(bad_match,left,np.unique(left.sales),'sales')
output = {}
def get_num(df,value_list,feature):
    for val in value_list:
        if output.has_key(val):
            result=[]
            result = output[val]
            value= np.append(result,np.true_divide(len(df[df[feature] == val]),len(df)))
            output[val]= value.tolist()
        else:
            result = []
            output[val] = np.true_divide(len(df[df[feature] == val]),len(df))

winners_list = get_num(winners,np.unique(left.sales),'sales')
frustrated_list = get_num(frustrated,np.unique(left.sales),'sales')
bad_match_list = get_num(bad_match,np.unique(left.sales),'sales')

print (json.dumps(output))


