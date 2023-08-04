#!/bin/bash
localdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# export DARSHAN_BASE_DIR=/software/centos7/soft/darshan/3.2.1/
# export DARSHAN_BASE_DIR=/lcrc/group/ATLAS/users/rwang/Argonne_computing/PPS-CCE/darshan/build_darshan/darshan-3.4.0-pre1
# export DARSHAN_BASE_DIR=/lcrc/group/ATLAS/users/rwang/Argonne_computing/PPS-CCE/darshan/build_darshan/dev-fork-child-issue786
# export DARSHAN_LOG_DIR=$($DARSHAN_BASE_DIR/bin/darshan-config --log-path)

export DARSHAN_BASE_DIR=$DARSHAN_INSTALLEDDIR
export DARSHAN_LOGDIR=$localdir/../../darshanlogs/
export DARSHAN_LOG_DIR=$DARSHAN_LOGDIR

athena=$1
nevents_per_proc=$2 #5
nproc=$3 #32
sharedWriter=$4 #False
proc=$5
format=$6 #'PHYSLITE' #'PHYSLITE'
parallelCompression=$7
# workdir=Derivation/Athena_23_0_12/$proc

workdir=Derivation/test/$proc


case ${proc} in
"data")
    # inputfile='/lcrc/group/ATLAS/users/rwang/Argonne_computing/data/data22_13p6TeV/AOD.*.pool.root.1'
    # '/lcrc/group/ATLAS/users/rwang/Argonne_computing/data/data18_13TeV/AOD.27655096._000359.pool.root.1'
    inputfile='/cvmfs/atlas-nightlies.cern.ch/repo/data/data-art/Tier0ChainTests/data18_13TeV.00357772.physics_Main.recon.AOD.r13286/AOD.27654050._000557.pool.root.1'
;;
"Jpsimumu")
    inputfile='/cvmfs/atlas-nightlies.cern.ch/repo/data/data-art/ISF_Validation/mc21_13p6TeV.801164.P8B_A14_CTEQ6L1_bb_Jpsi1S_mu6mu4.merge.EVNT.e8453_e8455.29328730._000257.pool.root.1'
;;
"ttbar")
    inputfile="/cvmfs/atlas-nightlies.cern.ch/repo/data/data-art/DerivationFrameworkART/mc20_13TeV.410470.PhPy8EG_A14_ttbar_hdamp258p75_nonallhad.recon.AOD.e6337_s3681_r13167"
esac
# export DARSHAN_DEFAULT_NPROCS=7
nevents=$(($nproc * $nevents_per_proc))
subfolder=$(date +'%Y/%m/%d')
logfolder=$DARSHAN_LOG_DIR/${subfolder//"/0"/"/"}
# PROG=athena_sim
# export DARSHAN_LOGFILE=$DARSHAN_LOG_DIR/$(date +'%y/%m/%d')/${PROG}.darshan
# rm -f ${DARSHAN_LOGFILE}
export DARSHAN_ENABLE_NONMPI=1

mkdir -p workdir/$workdir
cp $localdir/env.conf workdir/$workdir/
export DARSHAN_CONFIG_PATH=$localdir/env.conf 
export DARSHAN_DUMP_CONFIG=1
# export DARSHAN_JOBID=PBS_JOBID

case ${athena} in
"athenaMP")
    #--- athenaMP ---
    echo $format
    workdir=workdir/$workdir/athenaMP_${format//_/-}_${nproc}_${nevents_per_proc}_${sharedWriter}_${parallelCompression}
    cmd="--sharedWriter ${sharedWriter}"
    if ${sharedWriter}
    then
        cmd+=" --parallelCompression ${parallelCompression}"
    fi
    echo "working in $workdir"
    #(mkdir -p $workdir && cd $workdir && rm -rf * && ATHENA_CORE_NUMBER=${nproc} Reco_tf.py --inputAODFile ${inputfile} --outputDAODFile art.pool.root --reductionConf ${reductionConf} --maxEvents ${nevents} --multiprocess True ${cmd} --imf False --preExec 'from AthenaCommon.DetFlags import DetFlags; DetFlags.detdescr.all_setOff(); DetFlags.BField_setOn(); DetFlags.digitize.all_setOff(); DetFlags.detdescr.Calo_setOn(); DetFlags.simulate.all_setOff(); DetFlags.pileup.all_setOff(); DetFlags.overlay.all_setOff();' --postExec 'from DerivationFrameworkJetEtMiss.JetCommon import swapAlgsInSequence; swapAlgsInSequence(topSequence,"jetalg_ConstitModCorrectPFOCSSKCHS_GPFlowCSSK", "UFOInfoAlgCSSK" )' --athenaopts=' --stdcmalloc --preloadlib=$DARSHAN_BASE_DIR/lib/libdarshan.so --keep-configuration' 2>&1 |tee $localdir/$workdir.log)
    (mkdir -p $workdir && cd $workdir && rm -rf * && python3 $localdir/athenamp_eventorders.py $nproc $nevents_per_proc && LD_PRELOAD=$DARSHAN_BASE_DIR/lib/libdarshan.so ATHENA_CORE_NUMBER=${nproc} Derivation_tf.py --inputAODFile=${inputfile} --maxEvents ${nevents} --athenaMPUseEventOrders True --multiprocess True  --athenaMPMergeTargetSize "DAOD_*:0" --formats ${format//_/ } --outputDAODFile pool.root.1 --CA "all:True" --postExec "default:cfg.getService(\"AthMpEvtLoopMgr\").ExecAtPreFork=[\"AthCondSeq\"];" --multithreadedFileValidation True --imf False ${cmd} 2>&1 |tee $localdir/$workdir.log)
    # (mkdir -p $workdir && cd $workdir && rm -rf * && python3 $localdir/athenamp_eventorders.py $nproc $nevents_per_proc && ATHENA_CORE_NUMBER=${nproc} Derivation_tf.py --inputAODFile=${inputfile} --maxEvents ${nevents} --athenaMPUseEventOrders True --multiprocess True  --athenaMPMergeTargetSize "DAOD_*:0" --formats ${format//_/ } --outputDAODFile pool.root.1 --CA "all:True" --postExec "default:cfg.getService(\"AthMpEvtLoopMgr\").ExecAtPreFork=[\"AthCondSeq\"];" --multithreadedFileValidation True --imf False --athenaopts=' --preloadlib=$DARSHAN_BASE_DIR/lib/libdarshan.so' ${cmd} 2>&1 |tee $localdir/$workdir.log) #--skipEvents $((6936-$nevents_per_proc))
    if ! ${sharedWriter}
    then
        for f in ${format//_/ }
        do
            (cd $workdir && DAODMerge_tf.py --inputDAOD_${f}File DAOD_${f}.pool.root.* --outputDAOD_${f}_MRGFile DAOD_${f}.pool.root  --imf False --perfmon none --athenaopts=' --preloadlib=$DARSHAN_BASE_DIR/lib/libdarshan.so' 2>&1 |tee -a $localdir/$workdir.log)
        done
    fi
    # --AMITag p5440
``;;
"athenaMT")
    #--- athenaMT ---
    workdir=workdir/$workdir/athenaMT_${format}_${nproc}_${nevents_per_proc}_${sharedWriter}
    echo "working in $workdir"
    (mkdir -p $workdir && cd $workdir && rm -rf * && ATHENA_CORE_NUMBER=${nproc} Reco_tf.py --inputAODFile ${inputfile} --outputDAODFile art.pool.root --reductionConf ${reductionConf} --maxEvents ${nevents} --imf False --multithreaded True --sharedWriter ${sharedWriter}  --preExec 'from AthenaCommon.DetFlags import DetFlags; DetFlags.detdescr.all_setOff(); DetFlags.BField_setOn(); DetFlags.digitize.all_setOff(); DetFlags.detdescr.Calo_setOn(); DetFlags.simulate.all_setOff(); DetFlags.pileup.all_setOff(); DetFlags.overlay.all_setOff();' --postExec 'from DerivationFrameworkJetEtMiss.JetCommon import swapAlgsInSequence; swapAlgsInSequence(topSequence,"jetalg_ConstitModCorrectPFOCSSKCHS_GPFlowCSSK", "UFOInfoAlgCSSK" )' --athenaopts=' --stdcmalloc --preloadlib=$DARSHAN_BASE_DIR/lib/libdarshan.so --keep-configuration' 2>&1 |tee $localdir/${workdir}.log)
esac

# (cd FullG4_ttbar && athena.py --preloadlib=$DARSHAN_BASE_DIR/lib/libdarshan.so runargs.EVNTtoHITS.py SimuJobTransforms/skeleton.EVGENtoHIT_ISF.py 2>&1 |tee log.EVNTtoHITS)

ls -ltrh $logfolder
for file in $(find $logfolder -type f -name '*.darshan')
do
    echo $file
    (cd $logfolder &&\
    python3 -m darshan summary $file
    $DARSHAN_BASE_DIR/bin/darshan-parser --show-incomplete --base --perf $file > $file.txt && \
    $DARSHAN_BASE_DIR/bin/darshan-job-summary.pl $file)
    mv -f ${file//.darshan/*} $workdir
done



# LD_PRELOAD="$DARSHAN_BASE_DIR/lib/libdarshan.so" 
# (cd FullG4_ttbar && rm -rf * && ATHENA_PROC_NUMBER=$nproc Sim_tf.py --postInclude "default:RecJobTransforms/UseFrontier.py" --preExec "EVNTtoHITS:simFlags.SimBarcodeOffset.set_Value_and_Lock(200000)" "EVNTtoHITS:simFlags.TRTRangeCut=30.0;simFlags.TightMuonStepping=True" --preInclude "EVNTtoHITS:SimulationJobOptions/preInclude.BeamPipeKill.py,SimulationJobOptions/preInclude.FrozenShowersFCalOnly.py" --physicsList=FTFP_BERT_ATL_VALIDATION --randomSeed=2357 --DBRelease="all:current" --conditionsTag "default:OFLCOND-MC16-SDR-14" --geometryVersion="default:ATLAS-R2-2016-01-00-01_VALIDATION" --runNumber=700403 --DataRunNumber=284500 --simulator=FullG4 --truthStrategy=MC15aPlus  --inputEVNTFile "/cvmfs/atlas-nightlies.cern.ch/repo/data/data-art/SimCoreTests/valid1.410000.PowhegPythiaEvtGen_P2012_ttbar_hdamp172p5_nonallhad.evgen.EVNT.e4993.EVNT.08166201._000012.pool.root.1" --outputHITSFile "test.HITS.pool.root" --maxEvents ${nevents}  --imf False --asetup AtlasOffline,21.0.15 --athenaopts='--nprocs='${nproc}' --preloadlib=/lcrc/group/ATLAS/users/rwang/Argonne_computing/PPS-CCE/darshan/build_darshan/darshan-3.4.0-pre1/lib/libdarshan.so')
