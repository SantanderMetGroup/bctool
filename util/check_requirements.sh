#!/bin/bash 
#
# Check availability of command dependencies

#print debug if BCTOOL_DEBUG it's defined
test -n "${BCTOOL_DEBUG}" && set -x
#-e or -o errexit - exit when a command fails
#-u or -o nounset - exit when trying to use undefined variable
#-o pipefail - return the exit code of piped commands that error
set -euo pipefail

commands="wget tar xz wget sed grep cdo ncdump"
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
