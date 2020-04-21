#!/bin/bash
# Shell settings
# 
# set
#          -e : abort execution on error
#          -u : abort execution on undefined variable
#          -x : show shell-expanded commands
# -o pipefail : abort execution on error in pipe command
set -uo pipefail
BCTOOL_DEBUG=${BCTOOL_DEBUG:-0}
test "${BCTOOL_DEBUG}" -ne 0 && set -x
