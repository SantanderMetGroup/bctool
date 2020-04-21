#!/bin/bash 
#
#
source util/debug_options.sh

WRFDIR=${1:-WRF}

TEMPDIR=${PWD}/temp
mkdir -p $TEMPDIR || exit
WGETOPTS="--no-verbose --continue --directory-prefix=$TEMPDIR"

mkdir -p ${WRFDIR}
cd ${WRFDIR} || exit
#
# WPS
#
wget ${WGETOPTS} https://github.com/WRF-CMake/wps/releases/download/WPS-CMake-4.1.0/wps-cmake-4.1.0-basic_nesting-serial-x64-linux-release.tar.xz
tar xf ${TEMPDIR}/wps-cmake-4.1.0-basic_nesting-serial-x64-linux-release.tar.xz
cp ../templates/namelist.wps.default-v4.1.0 namelist.wps.default
ln -sf ../util/link_grib.sh
#
# WRF
#
wget  ${WGETOPTS} https://github.com/WRF-CMake/wrf/releases/download/WRF-CMake-4.1.4/wrf-cmake-4.1.4-basic_nesting-serial-x64-linux-release.tar.xz
tar xf ${TEMPDIR}/wrf-cmake-4.1.4-basic_nesting-serial-x64-linux-release.tar.xz 
mv test/em_real/* .
ln -sf main/wrf.exe
ln -sf main/real.exe
