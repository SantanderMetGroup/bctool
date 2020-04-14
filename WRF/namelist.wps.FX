&share
 wrf_core = 'ARW',
 max_dom = 1,
 start_date = '2033-12-30_00:00:00', '2008-12-16_12:00:00', '2008-12-16_12:00:00',
 end_date   = '2033-12-30_00:00:00', '2008-12-20_00:00:00', '2008-12-20_00:00:00',
 interval_seconds = 21600,
 io_form_geogrid = 2,
 debug_level = 0,
 nocolons = .true.,
/

&geogrid
 parent_id         = 1,1,2
 parent_grid_ratio = 1,2,2
 i_parent_start = 1,6,6
 j_parent_start = 1,6,6
 e_we = 127,233,445
 e_sn = 124,227,433
 s_we = 1,
 s_sn = 1,
 geog_data_res = 'modis_30s+2m','modis_30s+30s','modis_30s+30s'
 dx = 0.44000,
 dy = 0.44000,
 map_proj  = 'lat-lon',
 pole_lat  =  39.25,
 pole_lon  =  180,
 geog_data_path = '/oceano/gmeteo/DATA/WRF/wps_topo/geog_WRF381/geog',
 ref_x = 11,
 ref_y = 113,
 ref_lon   = -44.140691,
 ref_lat   =  60.205741,
 stand_lon= -18,
/

&ungrib
 out_format = 'WPS',
! prefix = 'FILE',
 prefix = 'FX',
/

&metgrid
 fg_name = 'FILE', 'PRES'
 constants_name = 'FX:2033-12-30_00', 'SOIL:2033-12-30_00'
 io_form_metgrid = 2,
 PROCESS_ONLY_BDY = 0,
/
