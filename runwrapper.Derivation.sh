#! /bin/sh
# Customised environment
athena.py --preloadlib=$ATLASMKLLIBDIR_PRELOAD/libimf.so:$DARSHAN_LD_PRELOAD:$ATLASMKLLIBDIR_PRELOAD/libintlc.so.5 --CA runargs.Derivation.py
