#!/bin/bash
#
# prep.sh
#
# Sample script to retrieve ~1 month of data

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

# Running preprocessor.ESGF
./preprocessor.ESGF ${sformateddate} ${eformateddate} ${BCTABLE}
test $? -eq 0 || exit 1

#--------------------------------------------------------------------------
# Functions for setting the namelist.wps and namlist.input
#--------------------------------------------------------------------------
function setnml(){
  var=$1
  value=$2
  nml=${3:-namelist.input}
  varsec=${var%%.*}
  varkey=${var##*.}
  grep -q -E "\ *${varkey}\ *=" ${nml}
  if [ $? -eq 0 ]; then  
    sed -i -e 's@^\ *'${varkey}'\ *=.*$@'${varkey}' = '${value}',@' ${nml}
    
    # Updating start and end date of the simulation run
    if [[ ${var%%_*} == @(start|end) ]]; then
      case "$(echo ${var%%_*})" in
        start) date="$sformateddate";;
        end) date="$eformateddate";;
      esac
      read year month day hour trash <<< `echo ${date} | tr '_T:-' '    '`
      for sufix in year month day hour date; do
        if [ ${var##*_} == $sufix ] ; then
          eval arg=\$$sufix
          sed -i -e 's@^\ *'${varkey}'\ *=.*$@'${varkey}' = '${arg}',@' ${nml}
        fi
      done
    fi
  else
    sed -i -e 's@^\ *'\&${varsec}'\ *$@ \&'${varsec}'\n'${varkey}' = '${value}',@' ${nml}
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

#--------------------------------------------------------------------------
#  Downloading and preparing WPS and WRF binaries
#--------------------------------------------------------------------------
HOMEDIR=`pwd`
WRFDIR=${WRFDIR:-WRF}
./util/deploy_WRF_CMake_binaries.sh ${WRFDIR}
cd $HOMEDIR/$WRFDIR

#--------------------------------------------------------------------------
#  Running WPS
#--------------------------------------------------------------------------
# Setting the namelist.wps
cp namelist.wps.default namelist.wps
updatenml ../templates/delta/namelist.wps.COMMON namelist.wps
nmlmodel="../templates/delta/namelist.wps.${model}" 
test -e ${nmlmodel} && updatenml ${nmlmodel} namelist.wps

# Linking Vtable for the corresponing model
ln -sf ../templates/${VTABLE} Vtable

# Setting the correct METGRID.TBL
test -f metgrid/METGRID.TBL.default || mv metgrid/METGRID.TBL metgrid/METGRID.TBL.default
ln -sf ../../templates/METGRID.TBL metgrid/METGRID.TBL

# Linking the grib files
rm -f GRIBFILE.*
./link_grib.sh ../BCdata/*.grb

# Running ungrib.exe
rm -f FILE:*
./ungrib.exe >& ungrib_FILE.out

# Interpolation from model to pressure levels
rm -f PRES*
ln -sf ../BCdata/ecmwf_coeffs
export LD_LIBRARY_PATH=.libs # badly linked so in wps-cmake-v4.1.0
./util/calc_ecmwf_p.exe >& calc_ecmwf_p.out

# Running metgrid.exe
rm -f met_em*
ln -sf ../templates/geo_em__EUR-44_WPS410.d01.nc geo_em.d01.nc
./metgrid.exe >& metgrid.out

#--------------------------------------------------------------------------
#  Running real + WRF
#--------------------------------------------------------------------------
# Setting the namelist.input
updatenml ../templates/delta/namelist.input.COMMON
nmlmodel="../templates/delta/namelist.input.${model}"
test -e ${nmlmodel} && updatenml ${nmlmodel}
ulimit -s unlimited

./real.exe >& real.out
./wrf.exe >& wrf.out
