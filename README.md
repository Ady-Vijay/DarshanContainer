# Darshan Container Runtime

  The goal of the code in the above project is to measure the runtimes of Athena instrumented with Darshan both inside and outside Singularity.
  Using the above code to create the graph below to see the time delay between these different environments. 

![Screenshot from 2023-07-13 11-26-04](https://github.com/Ady-Vijay/DarshanContainer/assets/48223544/f6512d09-73b9-4979-8236-245edc9577b3)

## Script.sh

script.sh is used to run the Athena program itself. It isolates the files that are needed to calculate the runtime through either the log files of Darshan or Athena itself. Both have looked identical so far and the consistency of Athena's naming system makes athenarun more favorable to extract each runtime. All the needed logfiles go into folders inside the assign filename under the file named **maxEventsPerNproc-Nproc**. 

## Darrun.py

darrun.py is used to extract runtime from Darshan log files. 

## athenarun.py 

athenarun.py is used to extract runtime from the prmon.log.Derivation.json file.

## run_derivation.sh

run_derivation.sh is used to run Athena with Darshan instrumentation. It takes 2 inputs the first one being maxEventsPerNproc and the second being Nproc. run_derivation is run by script.sh

## graphing.py

graphing.py saves to test.png currently. Works better through the .ipynb version that will be uploaded after first dataset comes out.
