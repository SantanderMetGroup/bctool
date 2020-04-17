#-e or -o errexit - exit when a command fails
#-u or -o nounset - exit when trying to use undefined variable
#-o pipefail - return the exit code of piped commands that error
set -euo pipefail

cd ${WRFDIR} || exit
#
# WPS
#
wget $WGETOPTS https://github.com/WRF-CMake/wps/releases/download/WPS-CMake-4.1.0/wps-cmake-4.1.0-basic_nesting-serial-x64-linux-release.tar.xz
tar xf $TEMPDIR/wps-cmake-4.1.0-basic_nesting-serial-x64-linux-release.tar.xz
cp ../templates/namelist.wps.default-v4.1.0 namelist.wps.default
ln -s ../util/link_grib.csh
(cd .libs; ln -s libgfortran-2e0d59d6.so.5.0.0 libgfortran.so.5)
#
# WRF
#
wget  $WGETOPTS https://github.com/WRF-CMake/wrf/releases/download/WRF-CMake-4.1.4/wrf-cmake-4.1.4-basic_nesting-serial-x64-linux-release.tar.xz
tar xf $TEMPDIR/wrf-cmake-4.1.4-basic_nesting-serial-x64-linux-release.tar.xz 
mv test/em_real/* .
ln -sf main/wrf.exe
ln -sf main/real.exe
