#!/bin/bash -x
# prep.sh
#
# Sample script to retrieve ~1 month of data

#print debug if BCTOOL_DEBUG it's defined
test -n "${BCTOOL_DEBUG}" && set -x
#-e or -o errexit - exit when a command fails
#-u or -o nounset - exit when trying to use undefined variable
#-o pipefail - return the exit code of piped commands that error
set -euo pipefail

./util/check_requirements.sh || exit 1

model="CanESM2"

case ${model} in
  CanESM2)
    BCTABLE="BCtable.CanESM2"
    VTABLE="Vtable.CanESM2.ml"
    ;;
  IPSLCM5)
    BCTABLE="BCtable.IPSLCM5"
    VTABLE="Vtable.IPSLCM5"
    ;;
  *) echo "Unknown model: ${model}"; exit ;;
esac

function setnml(){
  var=$1
  value=$2
  nml=${3:-namelist.input}
  varsec=${var%%.*}
  varkey=${var##*.}
  grep -q -E "\ *${varkey}\ *=" ${nml}
  if [ $? -eq 0 ]; then
    sed -i -e 's@^\ *'${varkey}'\ *=.*$@'${varkey}' = '${value}',@' ${nml}
  else
    sed -i -e 's@^\ *'\&${varsec}'\ *$@ \&'${varsec}'\n'${varkey}' = '${value}',@' ${nml}
  fi
}

function updatenml(){
  update=$1
  nml=${2:-namelist.input}
  grep -v '^#' ${update} | while read key value; do
    setnml "${key}" "${value}" ${nml}
  done
}

./preprocessor.ESGF 2033-12-30_00:00:00 2034-01-04_00:00:00 ${BCTABLE}

WRFDIR=${WRFDIR:-WRF}
bash util/deploy_WRF_CMake_binaries.sh ${WRFDIR}

cd $WRFDIR
#
#  WPS
#
ln -sf ../templates/${VTABLE} Vtable

cp namelist.wps.default namelist.wps.FILE
updatenml ../templates/delta/namelist.wps.COMMON namelist.wps.FILE
cp namelist.wps.FILE namelist.wps.FX
cp namelist.wps.FILE namelist.wps.SOIL
cp namelist.wps.FILE namelist.wps.METGRID
updatenml ../templates/delta/namelist.wps.FX namelist.wps.FX
updatenml ../templates/delta/namelist.wps.SOIL namelist.wps.SOIL

for nmlsuffix in FILE FX SOIL METGRID
do
  nmlmodel="../templates/delta/namelist.wps.${nmlsuffix}.${model}"
  test -e ${nmlmodel} && updatenml ${nmlmodel} namelist.wps.${nmlsuffix}
done

test -f metgrid/METGRID.TBL.default || mv metgrid/METGRID.TBL metgrid/METGRID.TBL.default
ln -sf ../../templates/METGRID.TBL metgrid/METGRID.TBL

rm -f GRIBFILE.*
./link_grib.sh ../BCdata/fx_*.grb
rm -f FX:*
ln -sf namelist.wps.FX namelist.wps
./ungrib.exe >& ungrib_FX.out

rm -f GRIBFILE.*
./link_grib.sh ../BCdata/soil*.grb
rm -f SOIL:*
ln -sf namelist.wps.SOIL namelist.wps
./ungrib.exe >& ungrib_SOIL.out

rm -f GRIBFILE.*
\ls ../BCdata/*.grb | grep -v fx | grep -v soil | xargs ./link_grib.sh
rm -f FILE:*
ln -sf namelist.wps.FILE namelist.wps
./ungrib.exe >& ungrib_FILE.out

rm -f PRES*
ln -sf ../BCdata/ecmwf_coeffs
export LD_LIBRARY_PATH=.libs # badly linked so in wps-cmake-v4.1.0
./util/calc_ecmwf_p.exe >& calc_ecmwf_p.out

rm -f met_em*
ln -sf namelist.wps.METGRID namelist.wps
ln -sf ../templates/geo_em__EUR-44_WPS410.d01.nc geo_em.d01.nc
./metgrid.exe >& metgrid.out
#
#  real + WRF
#
updatenml ../templates/delta/namelist.input.COMMON
updatenml ../templates/delta/namelist.input.${model}
./real.exe >& real.out

ulimit -s unlimited
./wrf.exe >& wrf.out
