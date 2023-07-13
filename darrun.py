import sys
import darshan

report = darshan.DarshanReport(sys.argv[1], read_all=True)
j = open("runtime.txt", 'a')
report.info()
j.write(str(report.metadata["job"]["run_time"]))
j.write(",")
j.close()

