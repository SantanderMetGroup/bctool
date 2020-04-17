tag=$1
target="WRF.${tag}"
mkdir $target || exit

mv WRF/FX_* WRF/FILE_* WRF/SOIL_* WRF/PRES_* WRF/GRIBFILE.* $target/
mv WRF/wrfrst* WRF/wrfout* WRF/wrfbdy* WRF/wrfinput* WRF/wrflowinp* $target/
mv WRF/ecmwf_coeffs WRF/met_em.* WRF/namelist.wps.* WRF/namelist.output WRF/rsl.* $target/
mv WRF/*.log WRF/*.out $target/
