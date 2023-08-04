import matplotlib.pyplot as plt
import sys
import numpy

f = open(sys.argv[1], 'r')
j = open(sys.argv[2], 'r')

for lines in f:
        a = lines.split(',')
for lines in j:
        b = lines.split(',')
ath = []
dar = []
for i in range(len(a)-1):
        ath.append(float(a[i]))
        dar.append(float(b[i]))

