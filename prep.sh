#!/bin/bash -xe
# prep.sh
#
# Sample script to retrieve ~1 month of data
model="IPSLCM5"

function setnml(){
  var=$1
  value=$2
  nml=${3:-WRF/namelist.input}
  sed -i -e 's/^\ *'${var}'\ *=.*$/'${var}' = '${value}',/' ${nml}
}

case ${model} in
  CanESM2)
    DATAPATH="/oceano/gmeteo/WORK/ASNA/DATA/CanESM2"
    BCTABLE="BCtable.CanESM"
    VTABLE="Vtable.CanESM2.ml"
    setnml start_hour 00
    setnml end_day 30
    setnml end_hour 00
    setnml num_metgrid_levels 36
    setnml num_metgrid_soil_levels 3
    cp WRF/namelist.wps.FILE WRF/namelist.wps.METGRID
    ;;
  IPSLCM5)
    DATAPATH="/oceano/gmeteo/WORK/zequi/DATASETS/cmip5-cordex4cds-subset/data/cmip5/output1/IPSL/IPSL-CM5A-MR/rcp85"
    BCTABLE="BCtable.IPSLCM5"
    VTABLE="Vtable.IPSLCM5"
    setnml start_hour 03
    setnml end_day 29
    setnml end_hour 21
    setnml num_metgrid_levels 40
    setnml num_metgrid_soil_levels 4
    setnml start_date "'2033-12-30_03:00:00'" WRF/namelist.wps.FILE
    setnml interval_seconds 10800 WRF/namelist.wps.FILE
    cp WRF/namelist.wps.FILE WRF/namelist.wps.METGRID
    setnml interval_seconds 21600 WRF/namelist.wps.METGRID
    ;;
  *) echo "Unknown model: ${model}"; exit ;;
esac

./preprocessor.ESGF 2033-12-24_00:00:00 2033-12-30_00:00:00 ${DATAPATH} ${BCTABLE}

cd WRF
ln -sf ungrib/Variable_Tables/${VTABLE} Vtable

use wrf381

rm -f GRIBFILE.*
link_grib.csh ../BCdata/fx_*.grb
rm -f FX:*
ln -sf namelist.wps.FX namelist.wps
ungrib.exe >& ungrib.out.FX

rm -f GRIBFILE.*
link_grib.csh ../BCdata/soil*.grb
rm -f SOIL:*
ln -sf namelist.wps.SOIL namelist.wps
ungrib.exe >& ungrib.out.SOIL

rm -f GRIBFILE.*
\ls ../BCdata/*.grb | grep -v fx | grep -v soil | xargs link_grib.csh
rm -f FILE:*
ln -sf namelist.wps.FILE namelist.wps
ungrib.exe >& ungrib.out.FILE

rm -f PRES*
ln -sf ../BCdata/ecmwf_coeffs
calc_ecmwf_p.exe

rm -f met_em*
ln -sf namelist.wps.METGRID namelist.wps
metgrid.exe

real.exe
mv rsl.error.0000 rsl.error.0000.real
mv rsl.out.0000 rsl.out.0000.real

ulimit -s unlimited
wrf.exe
