filename=tst4run
rm -rf $filename
mkdir $filename
cd $filename

numruns='100 1000 3600'
numproc='1 8 16 32'
for i in ${numruns}; do
	for j in ${numproc}; do
		mkdir $i-$j-"dar"
		cd $i-$j-"dar"
		cp ~/scripts/athenaevents
		cp ~/scripts/run_derivation.sh ~/athena/$filename/$i-$j-"dar"
		./run_derivation.sh $i $j
		cd ~/athena/$filename

		mkdir $i-$j-"nodar"
                cd $i-$j-"nodar"
                cp ~/scripts/athenaevents
                cp ~/scripts/run_nodar.sh ~/athena/$filename/$i-$j-"nodar"
                ./run_nodar.sh $i $j
		cd ~/athena/$filename
	done
done

