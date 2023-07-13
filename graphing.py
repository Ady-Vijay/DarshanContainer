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

athavg=[]
daravg=[]
athstd=[]
darstd=[]
ath100 = []
ath1000 = []
dar100 = []
dar1000 = []

for i in range(4):
	ath100.append(ath[i])
	ath1000.append(ath[i+4])
	dar100.append(dar[i])
	dar1000.append(dar[i+4])

athavg.append(numpy.average(ath100))
athavg.append(numpy.average(ath1000))
daravg.append(numpy.average(dar100))
daravg.append(numpy.average(dar1000))

athstd.append(numpy.std(ath100))
athstd.append(numpy.std(ath1000))
darstd.append(numpy.std(dar100))
darstd.append(numpy.std(dar1000))

x = [100,1000]

diff=[]
for i in range(len(athavg)):
	print(daravg[i])
	print(athavg[i])
	diff.append(daravg[i]-athavg[i])

fig,ax = plt.subplots(2,1,figsize = (14, 10),sharex=True,gridspec_kw={'height_ratios': [1.75, 1],'hspace':0})
ax[0].scatter(x,athavg,color='red',label="Inside Container")
ax[0].scatter(x,daravg,color='blue', label="Outside Container")
leg = ax[0].legend();
ax[1].scatter(x, diff)
ax[1].axhline(y = 0, linestyle = '-')
ax[0].errorbar(x,athavg, yerr=athstd,color = 'red')
ax[0].errorbar(x,daravg, yerr=darstd,color = 'blue')
ax[0].errorbar(x,athavg, yerr=athstd,color = 'red')

ax[0].title("Runtime of Athena with and without a Container(Singularity)")
ax[1].set_xlabel('Number of Events')
ax[0].set_ylabel('Runtime(sec)')
ax[1].set_ylabel('Difference in Runtime(sec)')

fig.subplots_adjust(left = 0.09, right = 0.5, bottom =0.02, top=0.58, wspace=0.4)

ax[0].grid()
ax[1].grid()
fig.savefig("test.png")
plt.scatter(x,athavg)
plt.scatter(x, daravg, marker = ">")
plt.errorbar(x,athavg, yerr = athstd)
plt.errorbar(x,daravg, yerr = darstd)
plt.savefig("graph.png")
