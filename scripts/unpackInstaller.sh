#!/bin/bash

# Script to unpack the tar.gz installers and place in the correct locations for Metro to run.

# source should be updated to correct path of 
# ie source /home/centos/scripts/packages/5_4_1U4.sh

source packages/5_4_1U8.sh 

## END OF EDIT SECTION

rootdir="/home/software/"
unpackdir="$rootdir/VNS/$minorVersion/unzipped"
installerdir="$rootdir/installers/$majorVersion"

# Create Directory Structure
mkdir -p $unpackdir
mkdir -p $unpackdir/vns/nsg
mkdir -p $unpackdir/vns/portal
mkdir -p $unpackdir/vsd/qcow2
mkdir -p $unpackdir/vsd/migration
mkdir -p $unpackdir/vstat
mkdir -p $unpackdir/vsc/single_disk

# Unpack file
tar -C $unpackdir/vsd/qcow2/ -zxf $installerdir/$vsdtar.tar.gz $vsdfile.qcow2
tar -C $unpackdir/vsc/ -zxf $installerdir/$vsctar.tar.gz single_disk/*
tar -C $unpackdir/vstat/ -zxf $installerdir/$vstattar.tar.gz $vstatfile.qcow2
tar -C $unpackdir/vns/nsg/ -zxf $installerdir/$nsgtar.tar.gz $nsgfile.*
cp $installerdir/$portalinstaller.tar.gz $unpackdir/vns/portal/
cp $installerdir/$portalimg.qcow2 $unpackdir/vns/portal/
unzip $rootdir/installers/metroae/$metrozip.zip -d /home/centos/
