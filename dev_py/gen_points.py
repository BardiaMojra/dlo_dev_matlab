import matplotlib.pyplot as plt
import numpy as np
import math

import pandas as pd
import plotly.express as px

np.random.seed(19680801) # Fixing random state for reproducibility
numPoints = 100000
r = 100
x_max = r
x_min = 0
y_max = r
y_min = -r
z_max = r
z_min = -r

Xs = list()
Ys = list()
Zs = list()

for i in range(numPoints):
    x = np.random.uniform(x_min, x_max)
    y_max = math.sqrt( r**2 - x**2 )
    y = np.random.uniform(y_min, y_max)
    z_max = math.sqrt( r**2 - y**2 )
    z = np.random.uniform(z_min, z_max)

    Xs.append(x)
    Ys.append(y)
    Zs.append(z)


df = np.vstack((Xs,Ys,Zs)).transpose()
df = pd.DataFrame(df, columns=(['x','y','z']))


fig = px.scatter_3d(df, x='x', y='y', z='z')
fig.show()
