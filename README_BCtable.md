BCtable
=======

Format
------

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
:  TBD

**time_slice**
:  Takes the requested time period from a variable and makes ir
   available for further filtering.

**use_era_interim**
:  TBD

Most filters take an input stream, process it, and send out the result as an
output stream to be used by the next filter. This is a list of available filters:

**convert2grb**
:  TBD

**day_to_6h**
:  TBD

**fixed_to_6h**
:  TBD

**is_land_mask**
:  TBD

**maskregion**
:  TBD

**percent2one**
:  TBD

**remapnn**
:  TBD

**rename**
:  TBD

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

