BCtable
=======

BCtable is an ASCII formatted file to customize the way `preprocessor.ESGF`
processes variables. It allows selecting a particular version of a variable and
select it from a particular realm at a particular frequency. Additionally, the
variables can be filtered (see [Filters](#Filters) below).

Format
------

The file starts with a set of keyword-value pairs used to set some mandatory
metadata (model, experiment) along with any other extra keywords. A blank line
separates the keyword-value header from the variable table itself. Valiable
processing lines start after a line beginninng with at least three dashes
(`---`).  This is a sample BCtable file:

```
project cmip5
institute IPSL
model IPSL-CM5A-MR
experiment rcp85
product output1

abbr    grib ltype version   ensemble freq realm  table   filter
------- ---- ----- --------- -------- ---- ------ ------- ----------------- 
sftlf    172  1    v20111119  r0i0p0  fx   atmos  fx      is_land_mask|percent2one|set_start_time|rename(fx_sftlf)
orog     129  1    v20111119  r0i0p0  fx   atmos  fx      set_start_time|rename(fx_orog)
ta       11   109  v20111119  r1i1p1  6hr  atmos  6hrLev  set_hybrid_levels
ua       33   109  v20111119  r1i1p1  6hr  atmos  6hrLev  set_hybrid_levels
va       34   109  v20111119  r1i1p1  6hr  atmos  6hrLev  set_hybrid_levels
hus      52   109  v20111119  r1i1p1  6hr  atmos  6hrLev  set_hybrid_levels
ps       1    1    v20111119  r1i1p1  6hr  atmos  6hrLev  
psl      2    1    v20111119  r1i1p1  6hr  atmos  6hrPlev 
sic      31   1    v20111119  r1i1p1  day  seaIce day     remapnn|sea_masked|day_to_6h
tos      37   1    v20111119  r1i1p1  day  ocean  day     remapnn|sea_masked|day_to_6h
soil139  139  112  v20120430  r1i1p1  mon  land   Lmon    BEGIN|use_era_interim|maskregion|fixed_to_6h|set_extension(grb)|END
soil170  170  112  v20120430  r1i1p1  mon  land   Lmon    BEGIN|use_era_interim|maskregion|fixed_to_6h|set_extension(grb)|END
soil183  183  112  v20120430  r1i1p1  mon  land   Lmon    BEGIN|use_era_interim|maskregion|fixed_to_6h|set_extension(grb)|END
soil236  236  112  v20120430  r1i1p1  mon  land   Lmon    BEGIN|use_era_interim|maskregion|fixed_to_6h|set_extension(grb)|END
soil39   39   112  v20120430  r1i1p1  mon  land   Lmon    BEGIN|use_era_interim|maskregion|fixed_to_6h|set_extension(grb)|END
soil40   40   112  v20120430  r1i1p1  mon  land   Lmon    BEGIN|use_era_interim|maskregion|fixed_to_6h|set_extension(grb)|END
soil41   41   112  v20120430  r1i1p1  mon  land   Lmon    BEGIN|use_era_interim|maskregion|fixed_to_6h|set_extension(grb)|END
soil42   42   112  v20120430  r1i1p1  mon  land   Lmon    BEGIN|use_era_interim|maskregion|fixed_to_6h|set_extension(grb)|END
```
Lines can be commented out by using a `#` symbol. 

Filters
-------

Filters are simple processing units that can be combined in a pipe to
accomplish the required transformations for a given variable. There might be
additional filters (beyond those shown in the BCtable) defined in the
`prefilter` and `postfilter` variables in `preprocessor.ESGF`. These apply to
all variables. Per-variable filters defined in the BCtable are executed in
between the common pre- and post-filters. To avoid the use of the common pre-
and/or post-filters for a particular variable, the special tags `BEGIN` and/or
`END`, respectively, can be used.

There are 2 special filters that can be used at the beginning of a pipe. They
create a stream of data from the files stored following the ESGF DRS:

**only_closest_to_sdate**
:  Take only the time record closest to the start date of the period requested.
   This is intended for constant fields or those used only as initial
   conditions (e.g. soil data).

**time_slice**
:  Takes the requested time period from a variable and makes it
   available for further filtering. This is the default starting filter in
   `preprocessor.ESGF`. To override it in the BCtable, use the BEGIN keyword
   followed by other start filter (e.g. `BEGIN|use_era_interim`).

**use_era_interim**
:  Use ERA-Interim data to replace a missing soil variable (moisture and or
   temperature). These variable are only required as initial conditions and are
   therefore only needed for the model spin up. They are not used along the
   boundaries.

Most filters take an input stream, process it, and send out the result as an
output stream to be used by the next filter. This is a list of available filters:

**convert2grb**
:  Converts the stream to GRIB format

**day_to_6h**
:  Temporal interpolation in time from daily to 6-hourly frequency. Recommended
   only for slow-varying fields (SST, sea ice, ...).

**fixed_to_6h**
:  TBD

**is_land_mask**
:  This filter flags the current variable as the land mask. This sets this
   variable to be used for land masking.

**maskregion**
:  Masks (in practice, crops, due to missing value compression) a given region.
   The default in `preprocessor.ESGF` is the EURO-CORDEX domain.

**percent2one**
:  Unit convesion from percent to values between 0 and 1. Common for fractional
   land masks.

**remapnn**
:  Regridding to the land mask grid by nearest neigbour interpolation.

**rename**
:  Renames a variable. Useful to avoid overwriting files when the same variable
   is processed twice. E.g. skin temperature might contain SST values over the
   sea.

**ringregion**
:  TBD

**sea_masked**
:  TBD

**set_extension**
:  TBD

**set_grb_code**
:  TBD

**set_grb_ltype**
:  TBD

**set_hybrid_levels**
:  TBD

**set_start_time**
:  TBD

**split_soil_mois_grb**
:  TBD

**split_soil_temp_grb**
:  TBD

