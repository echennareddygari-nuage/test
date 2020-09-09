#!/bin/bash

## Update all values in the file to point to the correct numbered installers for this deployment.
## Note only include names of objects, extensions (tar.gz or qcow, etc) are automatically added by the unpacking script.

majorVersion=5_4_1
minorVersion=5_4_1_U8

metrozip=nuage-metro-4.0.4

vsdtar=nuage-vsd-qcow2-5.4.1-17
vsdfile=VSD-5.4.1_17
vsctar=nuage-vsc-5.4.1-276
vscfile="single_disk/*"
vstattar=nuage-elastic-5.4.1-46
vstatfile=Nuage-elastic-5.4.1-46
nsgtar=nuage-vns-nsg-5.4.1-279
nsgfile=ncpeimg_5.4.1_279
portalinstaller=nuage-portal-container-6.0.3-59
portalimg=CentOS-7-x86_64-GenericCloud
