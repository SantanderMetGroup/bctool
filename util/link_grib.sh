#!/bin/bash 
#
#

#print debug if BCTOOL_DEBUG it's defined
test -n "${BCTOOL_DEBUG}" && set -x
#-e or -o errexit - exit when a command fails
#-u or -o nounset - exit when trying to use undefined variable
#-o pipefail - return the exit code of piped commands that error
set -euo pipefail

if test -z "$1"; then
   echo " " 
   echo " " 
   echo "   Please provide some GRIB data to link"
   echo "   usage: $0 path_to_grib_data/grib_data_file"
   echo " " 
   echo "   Wildcards will be managed by the shell"
   echo " " 
   exit
fi

alpha=(A B C D E F G H I J K L M N O P Q R S T U V W X Y Z)
i1=0
i2=0
i3=0

rm -f GRIBFILE.??? >& /dev/null

for f in $(ls $*)
do
   ln -sf ${f} GRIBFILE.${alpha[$i3]}${alpha[$i2]}${alpha[$i1]}
   i1=$(( ${i1} + 1 ))
   if [ ${i1} -gt 25 ]; then
      i1=0
      i2=$(( ${i2} + 1 ))
      if [ ${i2} -gt 25 ]; then
         i2=0
         i3=$(( ${i3} + 1 ))
         if [ ${i3} -gt 25 ]; then
            echo "RAN OUT OF GRIB FILE SUFFIXES!"
         fi
      fi
   fi
done
