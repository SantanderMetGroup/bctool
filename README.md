ESGF WRF Lateral Boundary Conditions extractor
==============================================

This tool extracts boundary conditions from Global Climate Models (GCMs) stored
under the Earth System Grid Federation (ESGF) Data Reference Syntax (DRS) to
nest a regional climate model (RCM). Initially developed for the
[Weather Research and Forecasting](https://www.mmm.ucar.edu/weather-research-and-forecasting-model)
(WRF) model, its filter processing system could, in principle, be adapted or
extended to provide suitable input for other RCMs.

Main features
-------------

While the ESGF has provided a common data and metadata format for the storage
of GCM output data, the access to RCM boundary data from the ESGF is still
hampered by the granularity of datasets and files, the frequency of the
available data, the masking of the fields, their units, or the final format
required for a given RCM. In this context, this tool provides:

 * Cropping of the global fields, leading to a downweight of the files to be
   downloaded of about one order of magnitude (e.g. for the EURO-CORDEX
   domain).
 * Temporal interpolation to fill data gaps 
 * Masking of sea-only and land-only fields
 * Format transformations (e.g. to GRIB, as required by the WRF WPS)
 * Fixing of the model level coordinates for the GRIB format
 * Units transformation
 * Management of alternative sources for mandatory input initial conditions

This is **NOT** a general user tool. Its main design concept is to run
co-located by the actual data on a filesystem mounted in the same host and
following the ESGF DRS (i.e. typically, an ESGF node)

Usage
-----

The main script to convert ESGF DRS data to a format readable by the WRF
Preprocessing System is [preprocessor.ESGF](preprocessor.ESGF):

```bash
preprocessor.ESGF STARTDATE ENDDATE BCTABLE
```

where:

 * *STARTDATE* and *ENDDATE* delimit the time period to be retrieved, formatted
   as e.g. 2033-12-24T00:00:00

 * *BCTABLE* is an ASCII text formatted file, specifying the variables to read
   and how to process them (see [README_BCtable](README_BCtable.md)).

The output generated by this script consists of a new directory `BCdata`
located in the current working directory and containing the data retrieved and
processed.

Test
----

A test of the tool is included in [prep.sh](prep.sh). WRF is automagically deployed and
run by this script, given a proper [BCtable](README_BCtable.md) (examples are
provided, but paths need to be adjusted) is in place.

Contents
--------

The package includes, apart from **preprocessor.ESGF**, which is the main
script to convert ESGF DRS data to a format readable by the WRF Preprocessing
System, the following files:

**BCtable.[tag]**
:  are sample BCtable files for specific GCMs. They provide additional details
   of a particular GCM run for `preprocessor.ESGF`. See
   [README_BCtable](README_BCtable.md) file for details on the syntax of these
   files.

**prep.sh**
:  Sample driving script that calls the preprocessor and runs WRF chain

**templates/**
:  Contains files intended to replace model files (Vtables, static domain
   files, model configuration namelists) in order to the example in `prep.sh`.

**templates/delta**
:  Contains 'delta' files. Extra changes to be applied on top of full templates
   for particular processing stages or GCMs.

**util/**
:  Utilities to manage the tool tests

**util/deploy_WRF_CMake_binaries.sh**
:  Automagically deploys a working WPS/WRF version under a WRF/ directory.
   Pre-compiled binaries are obtained from
   https://github.com/WRF-CMake/wrf/releases

**util/clean_WRF_dir.sh TAG**
:  Moves WPS/WRF output to a `WRF.[TAG]` directory and cleans the test `WRF` dir.

Requirements
------------

**Climate Data Operators (CDO)**
:  This tool is available at https://code.mpimet.mpg.de/projects/cdo. It can be
   installed via `conda install -c conda-forge cdo`. The tool has been tested
   with cdo v1.9.6 (20190208)

**WRF/**
:  Directory with minimal amount of files to run WRF.  In the sample script
   `prep.sh`, this directory is populated by means of `util/deploy_WRF_CMake_binaries.sh` 

Project workflow
----------------
Development follows Git-flow with branches:

 * __master__ as release-only branch
 * __devel__ as main development branch, allowing only merges from task-specific branches

TO-DO
-----
 
 * Improve land-sea masking to extend fields such as SST towards the
   coastline of the RCM higher resolution landmask.

 * Improve soil data processing filters. They are currently ad-hoc for
   specific models.

Acknowledgements
----------------

This work is funded by the Copernicus Climate Change Service service contract
2017/C3S_34B_Lot1_CNRS/SC2 (CORDEX4CDS).
