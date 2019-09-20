#!/bin/bash -e
# prep.sh
#
# Sample script to retrieve ~1 month of data
DATAPATH="/oceano/gmeteo/WORK/ASNA/DATA/CanESM2"
#DATAPATH="/oceano/gmeteo/WORK/zequi/DATASETS/cmip5-cordex4cds-subset/data/"

#cd /oceano/gmeteo/WORK/ASNA/projects/cordex4cds/v1 
./preprocessor.ESGF 2033-12-24_00:00:00 2033-12-30_00:00:00 ${DATAPATH}

cd WRF

use wrf381

rm -f GRIBFILE.*
link_grib.csh ../grbData/fx_*.grb
rm -f FX:*
ln -sf namelist.wps.FX namelist.wps
ungrib.exe >& ungrib.out.FX

rm -f GRIBFILE.*
link_grib.csh ../grbData/soil*.grb
rm -f SOIL:*
ln -sf namelist.wps.SOIL namelist.wps
ungrib.exe >& ungrib.out.SOIL

rm -f GRIBFILE.*
\ls ../grbData/*.grb | grep -v fx | grep -v soil | xargs link_grib.csh
rm -f FILE:*
ln -sf namelist.wps.FILE namelist.wps
ungrib.exe >& ungrib.out.FILE

rm -f PRES*
ln -sf ../grbData/ecmwf_coeffs
calc_ecmwf_p.exe

rm -f met_em*
metgrid.exe

real.exe
mv rsl.error.0000 rsl.error.0000.real
mv rsl.out.0000 rsl.out.0000.real

ulimit -s unlimited
wrf.exe
