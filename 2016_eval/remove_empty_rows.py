# Removing rows with zeros in them
import pandas as pd

df = pd.read_csv('youth_2016.csv')

df = df.replace(0, pd.np.nan).dropna(axis=0, how='any')

df.to_csv('clean_youth_2016.csv')