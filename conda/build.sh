mkdir -p ${PREFIX}/bin
cp ${SRC_DIR}/preprocessor.ESGF ${PREFIX}/bin/bctool
chmod a+x ${PREFIX}/bin/bctool

mkdir -p ${PREFIX}/share/bctool
cp ${SRC_DIR}/BCtable.* ${PREFIX}/share/bctool
