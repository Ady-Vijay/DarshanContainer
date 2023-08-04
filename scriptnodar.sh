filename=6runodar
rm -rf $filename
mkdir $filename
cd $filename

numruns='100 1000 3600'
numproc='1 8 16 32'
for i in ${numruns}; do
	for j in ${numproc}; do
		mkdir $i-$j
		cd $i-$j
		cp ~/scripts/athenaevents
		cp ~/scripts/run_nodar.sh ~/athena/$filename/$i-$j
		./run_nodar.sh $i $j
		cd ~/athena/$filename
	done
done

cd ~/athena
filename2=6runodarContainer
rm -rf $filename2
mkdir $filename2
cd $filename2


setupATLAS -c centos7

for i in ${numruns}; do
	for j in ${numproc}; do
                mkdir $i-$j
		cd $i-$j
                cp ~/scripts/run_nodar.sh ~/athena/$filename2/$i-$j
                ./run_nodar.sh $i $j
                cd ~/athena/$filename2
        done
done

