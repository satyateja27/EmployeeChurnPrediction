import pandas as  pd
import numpy as np
import json
from sklearn.metrics import confusion_matrix

import warnings
warnings.filterwarnings("ignore")

training_data = 'HR_comma_sep.csv'
hr_data = pd.read_csv(training_data)
hr_data['dept']= hr_data['sales']
hr_data.drop(['sales'],axis=1, inplace=True)
hr_data.head()

salary_dict = {'low': 30000, 'medium': 60000, 'high': 90000}
hr_data['salary_estimate'] = hr_data['salary'].map(salary_dict)

eval_mean= hr_data['last_evaluation'].mean()
eval_std= np.std(hr_data['last_evaluation'])

hr_data['performance(standard units)']= (hr_data['last_evaluation']- eval_mean)/eval_std

def performance_label(row):
    peformance = row['performance(standard units)']
    if peformance >= 1:
        result = "Above average"
    else:
        result = "Below Average"
    return(result)
hr_data['performance label']= hr_data.apply(performance_label,axis=1)

left_dict ={1: 'left', 0: 'stayed'}
hr_data['left(as_string']= (hr_data['left'].map(left_dict))

columns = (hr_data.columns)
num_columns = (hr_data._get_numeric_data().columns)


sep_hr_data = hr_data
#sep_hr_data['Performance cluster'] = sep_hr_data['left(as_string)'] + ' : ' + sep_hr_data['performance label']

#sep_hr_pivot = sep_hr_data.pivot_table(index= (['Performance cluster']), values =num_columns, aggfunc=np.mean)
#sep_hr_pivot.transpose()

#sep_hr_data[['Performance cluster', 'average_montly_hours']].boxplot(by = 'Performance cluster')
#sep_hr_data[['Performance cluster', 'number_project']].boxplot(by = 'Performance cluster')

#columns = ['left','average_montly_hours', 'number_project','time_spend_company']

aa_sep_hr_data = sep_hr_data[(sep_hr_data['performance label']=='Above Average')]
ab_sep_hr_data = sep_hr_data[(sep_hr_data['performance label']!='Above Average')]
average_corr = ab_sep_hr_data.corr()
above_average_corr = aa_sep_hr_data.corr().loc[columns].transpose()
below_average_corr = ab_sep_hr_data.corr().loc[columns].transpose()
#above_average_corr

left_data = sep_hr_data[sep_hr_data.left == 1]

total_count=sep_hr_data.dept.value_counts()
print (total_count)


a= (set(sep_hr_data.dept))
b= ((total_count.sort_values(ascending=False)))

#print (a)
#print (b)



total_left=left_data.dept.value_counts()
#print (json.dumps((total_left))
percent_left = (left_data.dept.value_counts()/ sep_hr_data.dept.value_counts() * 100, 2)

#print (percent_left)
#print('Percentage of employees that left by department \n\n', percent_left.sort_values(ascending = False))




