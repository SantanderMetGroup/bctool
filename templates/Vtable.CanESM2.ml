GRIB1| Level| From |  To  | metgrid  |  metgrid | metgrid                                  |
Param| Type |Level1|Level2| Name     |  Units   | Description                              |
-----+------+------+------+----------+----------+------------------------------------------+
  11 | 109  |   *  |      | TT       | K        | Temperature                              |
  33 | 109  |   *  |      | UU       | m s-1    | U                                        |
  34 | 109  |   *  |      | VV       | m s-1    | V                                        |
  52 | 109  |   *  |      | SPECHUMD | kg kg-1  | Specific Humidity                        |
  11 | 105  |   0  |      | TT       | K        | Temperature                              | At 2 m
  52 | 105  |   0  |      | SPECHUMD | kg kg-1  |                                          | At 2 m
     | 105  |   0  |      | RH       | %        | Relative Humidity at 2 m                 | At 2 m
  33 | 105  |   0  |      | UU       | m s-1    | U                                        | At 10 m
  34 | 105  |   0  |      | VV       | m s-1    | V                                        | At 10 m
 172 |  1   |   0  |      | LANDSEA  | 0/1 Flag | Land/Sea flag                            |
 129 |  1   |   0  |      | SOILHGT  | m        | Terrain field of source analysis         |
  31 |  1   |   0  |      | SEAICE   | 0/1 Flag | Sea-Ice-Flag                             |
 141 |  1   |   0  |      | SNOW     | kg m-2   |Water Equivalent of Accumulated Snow Depth|
   1 |  1   |   0  |      | PSFC     | Pa       | Surface Pressure                         |
   2 |  1   |   0  |      | PMSL     | Pa       | Sea-level Pressure                       |
  11 |  1   |   0  |      | SKINTEMP | K        | Sea-Surface Temperature                  | 
  37 |  1   |   0  |      | SST      | K        | Sea-Surface Temperature                  |
 139 | 112  |   0  |  10  | ST000010 | K        | T of 0-10 cm ground layer                |
 170 | 112  |  10  |  40  | ST010040 | K        | T of 10-40 cm ground layer               |
 183 | 112  |  40  | 255  | ST040255 | K        | T of 40-405 cm ground layer              |
  39 | 112  |   0  |  10  | SM000010 | fraction | Soil moisture of 0-10 cm ground layer    |
  40 | 112  |  10  |  40  | SM010040 | fraction | Soil moisture of 10-40 cm ground layer   |
  41 | 112  |  40  | 255  | SM040255 | fraction | Soil moisture of 40-405 cm ground layer  |
-----+------+------+------+----------+----------+------------------------------------------+
