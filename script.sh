filename=5run
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
		cp ~/scripts/run_derivation.sh ~/athena/$filename/$i-$j
		./run_derivation.sh $i $j
		cp ~/darshanlogs/$(date +%Y)/$(date +%-m)/$(date +%-d)/avijayak_python* ~/athena/$filename/$i-$j
		rm -rf ~/darshanlogs/$(date +%Y)/$(date +%-m)/$(date +%-d)
		mkdir ~/darshanlogs/$(date +%Y)/$(date +%-m)/$(date +%-d)
		cd ~/athena/$filename
	done
done

cd ~/athena
filename2=5runContainer
rm -rf $filename2
mkdir $filename2
cd $filename2


setupATLAS -c centos7

for i in ${numruns}; do
	for j in ${numproc}; do
                mkdir $i-$j
		cd $i-$j
                cp ~/scripts/run_derivation.sh ~/athena/$filename2/$i-$j
                ./run_derivation.sh $i $j
                cp ~/darshanlogs/$(date +%Y)/$(date +%-m)/$(date +%-d)/avijayak_python* ~/athena/$filename2/$i-$j
                rm -rf ~/darshanlogs/$(date +%Y)/$(date +%-m)/$(date +%-d)
                mkdir ~/darshanlogs/$(date +%Y)/$(date +%-m)/$(date +%-d)
                cd ~/athena/$filename2
        done
done
