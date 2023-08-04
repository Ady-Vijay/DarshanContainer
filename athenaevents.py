import sys

nrepeats=int(int(sys.argv[2])/100)
with open("athenamp_eventorders.txt.Derivation","w") as f:
    for i in range(0,int(sys.argv[1])):
        print(str(i)+':'+','.join([str(x) for x in range(0,100)]*nrepeats),file=f)
