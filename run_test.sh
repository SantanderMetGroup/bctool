#!/bin/bash
#
# prep.sh
#
# Sample script to retrieve ~1 month of data

#set -x
#use cdo
#use nco
source activate NCLtoPY
source ./util/debug_options.sh

./util/check_requirements.sh || exit 1

model="MPIESM12LR"
sformateddate='2005-12-31_00:00:00'     # Initial date to process as YYYY-MM-DD_HH:MM:SS (Ex. 1983-08-27_00:00:00)
eformateddate='2006-01-02_00:00:00'     # end date to process

case ${model} in
  CanESM2)
    BCTABLE="BCtable.CanESM2"
    VTABLE="Vtable.CanESM2.ml"
    ;;
  IPSLCM5)
    BCTABLE="BCtable.IPSLCM5"
    VTABLE="Vtable.IPSLCM5"
    ;;
  MPIESM12LR)
    BCTABLE="BCtable.MPIESM12LR"
    VTABLE="Vtable.IPSLCM5" # Same vars as IPSLCM5
    ;;
  *) echo "Unknown model: ${model}"; exit ;;
esac

./preprocessor.ESGF ${sformateddate} ${eformateddate} ${BCTABLE}
test $? -eq 0 || exit 1

# Running WPS and WRF
HOMEDIR=`pwd`
WRFDIR=${WRFDIR:-WRF}
./util/deploy_WRF_CMake_binaries.sh ${WRFDIR}
cd $HOMEDIR/$WRFDIR


# Functions for updating namelists
function format_date(){
  if [ $varfrs == "start" ] ; then
    date=$sformateddate
  elif [ $varfrs == "end" ] ; then
    date=$eformateddate
  fi
  year=`echo $date | awk -F'-' '{ print $1 }'`
  month=`echo $date | awk -F'-' '{ print $2 }'`
  day=`echo $date | awk -F'-' '{ print $3 }' | awk -F'_' '{ print $1 }'`
  hour=`echo $date | awk -F'_' '{ print $2 }' | awk -F':' '{ print $1 }'`
}


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
  if [ $var == "start_date" ]; then
    sed -i -e 's@^\ *'${varkey}'\ *=.*$@'${varkey}' = "'${sformateddate}'",@' ${nml}
  elif [ $var == "end_date" ]; then
    sed -i -e 's@^\ *'${varkey}'\ *=.*$@'${varkey}' = "'${eformateddate}'",@' ${nml}
  fi  
  varfrs=${var%%_*}
  varsec=${var##*_}
  if [ $varfrs == "start" ] || [ $varfrs == "end" ] && [ $varsec != "date" ]; then
    format_date
    for vartime in year month day hour ; do
      if [ $varsec == $vartime ] ; then
	eval arg=\$$vartime
        sed -i -e 's@^\ *'${varkey}'\ *=.*$@'${varkey}' = '${arg}',@' ${nml}
      fi
    done
  fi
}														

function updatenml(){
  update=$1
  nml=${2:-namelist.input}
  echo "update=" $update
  grep -v '^#' ${update} | while read key value; do
    setnml "${key}" "${value}" ${nml}
  done
}

#
#  WPS
#
ln -sf ../templates/${VTABLE} Vtable

cp namelist.wps.default namelist.wps.FILE
updatenml ../templates/delta/namelist.wps.COMMON namelist.wps.FILE

for nmlsuffix in FILE
do
  nmlmodel="../templates/delta/namelist.wps.${nmlsuffix}.${model}"
  test -e ${nmlmodel} && updatenml ${nmlmodel} namelist.wps.${nmlsuffix}
done

test -f metgrid/METGRID.TBL.default || mv metgrid/METGRID.TBL metgrid/METGRID.TBL.default
ln -sf ../../templates/METGRID.TBL metgrid/METGRID.TBL

rm -f GRIBFILE.*
rm -f FILE:*
./link_grib.sh ../BCdata/*.grb
ln -sf namelist.wps.FILE namelist.wps
./ungrib.exe >& ungrib_FILE.out

rm -f PRES*
ln -sf ../BCdata/ecmwf_coeffs
export LD_LIBRARY_PATH=.libs # badly linked so in wps-cmake-v4.1.0
./util/calc_ecmwf_p.exe >& calc_ecmwf_p.out

rm -f met_em*
ln -sf ../templates/geo_em__EUR-44_WPS410.d01.nc geo_em.d01.nc
./metgrid.exe >& metgrid.out

#--------------------------------------------------------------------------
#  real + WRF
#--------------------------------------------------------------------------

updatenml ../templates/delta/namelist.input.COMMON
nmlmodel="../templates/delta/namelist.input.${model}"
test -e ${nmlmodel} && updatenml ${nmlmodel}
ulimit -s unlimited

./real.exe >& real.out
./wrf.exe >& wrf.out
