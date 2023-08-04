# Run arguments file auto-generated on Fri Jul 21 12:26:48 2023 by:
# JobTransform: Derivation
# Version: $Id: trfExe.py 792052 2017-01-13 13:36:51Z mavogel $
# Import runArgs class
from PyJobTransforms.trfJobOptions import RunArguments
runArgs = RunArguments()
runArgs.trfSubstepName = 'Derivation' 

runArgs.perfmon = 'fastmonmt'
runArgs.formats = ['PHYS']
runArgs.maxEvents = 800

 # Input data
runArgs.inputAODFile = ['/cvmfs/atlas-nightlies.cern.ch/repo/data/data-art/Tier0ChainTests/data18_13TeV.00357772.physics_Main.recon.AOD.r13286/AOD.27654050._000557.pool.root.1']
runArgs.inputAODFileType = 'AOD'
runArgs.inputAODFileNentries = 6011
runArgs.AODFileIO = 'input'

 # Output data
runArgs.outputDAOD_PHYSFile = 'DAOD_PHYS.pool.root.1'
runArgs.outputDAOD_PHYSFileType = 'AOD'

 # Extra runargs

 # Extra runtime runargs

 # Literal runargs snippets

 # AthenaMP Options. nprocs = 8
runArgs.athenaMPWorkerTopDir = 'athenaMP-workers-Derivation-DerivationFramework'
runArgs.athenaMPOutputReportFile = 'athenaMP-outputs-Derivation-DerivationFramework'
runArgs.athenaMPEventOrdersFile = 'athenamp_eventorders.txt.Derivation'
runArgs.athenaMPCollectSubprocessLogs = True
runArgs.athenaMPStrategy = 'SharedQueue'
runArgs.athenaMPReadEventOrders = True
runArgs.sharedWriter = True

 # Executor flags
runArgs.totalExecutorSteps = 0

 # Threading flags
runArgs.nprocs = 8
runArgs.threads = 0
runArgs.concurrentEvents = 0

 # Import skeleton and execute it
from DerivationFrameworkConfiguration.DerivationSkeleton import fromRunArgs
fromRunArgs(runArgs)
