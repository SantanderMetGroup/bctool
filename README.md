ESGF WRF Lateral Boundary Conditions extractor
==============================================

This tool extracts boundary conditions from GCMs stored under the ESGF DRS.

Usage
-----

`preprocessor.ESGF STARTDATE ENDDATE BASEPATH BCTABLE`

Contents
--------

**prep.sh**
:  Sample driving script that calls the preprocessor and runs WRF chain

**preprocessor.ESGF**
:  is the main script to convert ESGF DRS data to a format readable by the WRF Preprocessing System.

**BCtable**
:  Provides additional of a particular GCM for `preprocessor.ESGF`. See examples.

**BCtable.[tag]**
:  are sample BCtable files for specific GCMs

**Vtable.[tag]**
:  are sample Vtable files (standard WRF Preprocessing System files)

Requirements
------------

**WRF/**
**WRF/geo_em.d01.nc**
**WRF/ungrib**
**WRF/metgrid**
:  Directory with minimal amount of files to run WRF.  In the sample script
   `prep.sh`, this directory is populated by the `wrf_skel` command available
   after `use wrf381`.


Project workflow
----------------
Development follows Git-flow with branches:

 * __master__ as release-only branch
 * __devel__ as main development branch, allowing only merges from task-specific branches

Acknowledgements
----------------

This work is funded by the Copernicus Climate Change Service service contract
2017/C3S_34B_Lot1_CNRS/SC2 (CORDEX4CDS).
