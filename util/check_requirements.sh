#!/bin/bash 
#
# Check availability of command dependencies

source util/debug_options.sh

commands="wget tar xz wget sed grep cdo ncdump ncks"
failed=false

for comm in ${commands}
do
  command -v ${comm} > /dev/null 2>&1
  if [ $? -ne 0 ]; then
     echo >&2 "Error: The command < ${comm} > is required, but it is not available."
     failed=true
  fi
done

if ${failed}; then
   echo >&2 "Error: there were missing dependencies. Aborting ..."
   exit 1
fi
