BCtable
=======

BCtable is an ASCII formatted file to customize the way `preprocessor.ESGF`
processes variables. It allows selecting a particular version of a variable and
select it from a particular realm at a particular frequency. Additionally, the
variables can be filtered (see [Filters](#filters) below).

Format
------

The file starts with a set of keyword-value pairs used to set some mandatory
metadata (model, experiment) along with any other extra keywords. A blank line
separates the keyword-value header from the variable table itself. Variable
processing lines start after a line beginning with at least three dashes
(`---`).  This is a sample BCtable file:

```
data_path /oceano/gmeteo/DATA/CMIP5/output1/IPSL/IPSL
project cmip5
institute IPSL
model IPSL-CM5A-MR
experiment rcp85
product output1
era_interim_path /oceano/gmeteo/DATA/ECMWF/INTERIM/Analysis

abbr    grib ltype version   ensemble freq realm  table   filter
------- ---- ----- --------- -------- ---- ------ ------- ----------------- 
sftlf    172  1    v20111119  r0i0p0  fx   atmos  fx      only_ic|is_land_mask|percent2one|set_start_time|rename(fx_sftlf)
orog     129  1    v20111119  r0i0p0  fx   atmos  fx      only_ic|set_start_time|rename(fx_orog)
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

*data_path* is the path to a directory containing model data for a particular
GCM. It should point to the directory where the
`<experiment>/<frequency>/<realm>/...` structure lives.

The `grib` and `ltype` columns in the variable section should match those in
the WRF Vtable used.

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
   temperature). These variables are only required as initial conditions and are
   therefore only needed for the model spin up. They are not used along the
   boundaries. The path to the ERA-Interim data MUST be set in the header
   (*era_interim_path*, see example above)

Most filters take an input stream, process it, and send out the result as an
output stream to be used by the next filter. This is a list of available filters:

**celsius2K**
:  Unit conversion from Celsius degrees to Kelvin units.

**convert2grb**
:  Converts the stream to GRIB format

**day_to_6h**
:  Temporal interpolation in time from daily to 6-hourly frequency. Recommended
   only for slow-varying fields (SST, sea ice, ...).

**is_land_mask**
:  This filter flags the current variable as the land mask. This sets this
   variable to be used for land masking.

**maskregion**
:  Masks (in practice, crops, due to missing value compression) a given region.
   The default in `preprocessor.ESGF` is the EURO-CORDEX domain.

**only_ic**
:  Tags a variable as only for initial conditions. This makes the processor
   to skip files for different years.

**percent2one**
:  Unit conversion from percentage (0 to 100) to values between 0 and 1. Common
   for fractional land masks or sea ice cover.

**remapnn**
:  Regridding to the land mask grid by nearest neighbour interpolation.

**rename(_name_)**
:  Renames a variable. Useful to avoid overwriting files when the same variable
   is processed twice. E.g. skin temperature might contain SST values over the
   sea.

**ringregion**
:  Masks only the boundaries of a given region, further reducing the file
   size by removing data not only outside the domain, but also in the interior
   of the domain. This option is not usable by WRF when sst_update is active
   and/or a rotated lat-lon projection is in use. In practice, this is unusable
   for regional climate simulations with WRF, but it could be usable by other
   models.

**sea_masked**
:  The field is defined only over the sea. Mask out all land points according
   to the variable flagged as *is_land_mask*.

**set_extension(_ext_)**
:  Changes (or sets) the extension _ext_ to the output data.

**set_grb_code**
:  For grib streams (i.e. after the *convert2grb* filter), sets the grib
   variable code indicated in the table.

**set_grb_ltype**
:  For grib streams (i.e. after the *convert2grb* filter), sets the grib
   level type indicated in the table.

**set_hybrid_levels**
:  For grib streams (i.e. after the *convert2grb* filter), converts the
   hybrid vertical levels coordinate to GRIB conventions.

**set_start_time**
:  Sets the date and time of the stream to the start date and time of the
   selected period. Usually applied to constant fields (orog, sftlf) or to
   initial conditions (soil variables).

**shift_time(_shift_)**
:  Shifts the time axis by _shift_. This can be useful when a variable is
   defined over a time period and the time coordinate does not match the others.
   An example could be SLP averaged e.g. between 00:00 and 06:00 and stored as
   time 03:00. If other variables are stored at 00:00, 06:00 and so on, a time
   shift such as `shift_time(-3hour)` can be applied. This is not an optimal
   solution since averaged variables should NOT be used as input for an RCM, which
   expects instantaneous fields.

**split_soil_mois_grb**
:  This is ad-hoc filter to split the soil moisture information into a single
   file for each level. Grib output is assumed.

**split_soil_temp_grb**
:  This is ad-hoc filter to split the soil temperature information into a
   single file for each level. Grib output is assumed.
