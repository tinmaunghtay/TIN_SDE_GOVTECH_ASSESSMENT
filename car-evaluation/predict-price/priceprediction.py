import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.metrics import confusion_matrix
from sklearn.tree import DecisionTreeClassifier
from sklearn.model_selection import train_test_split
from sklearn import metrics

data = pd.read_csv('/car-evaluation/data/car.data', names=['buying_price', 'maint_cost', 'doors', 'person_capacity', 'lug_boot', 'safety', 'class'])
#We can check the first five samples of the data:
print(data.head(5))
#data['class'].value_counts().plot(kind='bar')
#plt.show()
#data['safety'].value_counts().plot(kind='bar')
#plt.show()