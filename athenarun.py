import sys
import json

f = open(sys.argv[1], 'r')
j = open("runtime.txt", 'a')
data = json.load(f)
j.write(str(data['Max']['wtime']))
j.write(",")
j.close()
f.close()
