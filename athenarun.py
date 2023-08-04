import sys
import json

f = open(sys.argv[1], 'r')
j = open(sys.argv[2], 'a')
data = json.load(f)
j.write(str(data['Max']['wtime']))
j.write(",")
j.close()
f.close()
