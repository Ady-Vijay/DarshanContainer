#!/bin/bash


test=$(($1 * $2))
echo $test

export DARSHAN_LOGPATH=/home/avijayakumar/darshanlogs && python3 ~/scripts/athenaevents.py $2 $1 && export DARSHAN_LOGDIR=/home/avijayakumar/darshanlogs && export DARSHAN_DUMP_CONFIG=1 && ATHENA_CORE_NUMBER=$2 Derivation_tf.py --inputAODFile=/cvmfs/atlas-nightlies.cern.ch/repo/data/data-art/Tier0ChainTests/data18_13TeV.00357772.physics_Main.recon.AOD.r13286/AOD.27654050._000557.pool.root.1 --multiprocess True --sharedWriter True --formats PHYS --outputDAODFile pool.root.1 --CA "all:True" --maxEvents $test --athenaMPUseEventOrders True --athenaopts='--preloadlib=$DARSHAN_LD_PRELOAD'
