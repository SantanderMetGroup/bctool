tag=$1
target="WRF.${tag}"
mkdir $target || exit

mv WRF/FX* WRF/FILE* WRF/PRES* WRF/GRIBFILE.* $target/
mv WRF/wrfrst* WRF/wrfout* WRF/wrfbdy* WRF/wrfinput* WRF/wrflowinp* $target/
mv WRF/ecmwf_coeffs WRF/met_em.* WRF/namelist.output WRF/rsl.* $target/
mv WRF/ungrib.out* WRF/ungrib.log WRF/logfile.log WRF/metgrid.log $target/
