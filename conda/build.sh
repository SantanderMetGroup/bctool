mkdir -p ${PREFIX}/bin
cp ${SRC_DIR}/preprocessor.ESGF ${PREFIX}/bin/preprocessor.ESGF
chmod a+x ${PREFIX}/bin/preprocessor.ESGF
ln -s ${PREFIX}/bin/preprocessor.ESGF ${PREFIX}/bin/bctool

mkdir -p ${PREFIX}/share/bctool
cp ${SRC_DIR}/BCtable.* ${PREFIX}/share/bctool

mkdir -p ${PREFIX}/share/bctool/data-download
cp ${SRC_DIR}/data-download/* ${PREFIX}/share/bctool/data-download
cp ${SRC_DIR}/data-download/bctool-download ${PREFIX}/bin/bctool-download
chmod a+x ${PREFIX}/bin/bctool-download
