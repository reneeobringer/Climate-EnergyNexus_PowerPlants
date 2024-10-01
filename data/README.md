There are two folders with data: `EIAdata` has the generation files from the US Energy Information Administration and `NARRdata` has the climate data files from the North American Regional Reanalysis. There are also two post-processed files: `allplantdata.csv` which has the power plant data and `allnarrdata.zip` which is a compressed folder with the combined NARR data file for every power plant and variable. These post-processed files were generated using `figurecode.R` and then used in creating the figures later in that same script. Below the variables are listed for each post-processed file. 

Variables in `allplantdata.csv`:

* `plant_code` - EIA-assigned plant code
* `month` - month (1-12)
* `year` - year (2011-2022)
* `net_gen` - net generation reported to EIA (MWh)
* `source` - type of power plant (WAT = hydroelectric, SUN = solar, GEO = geothermal, WND = wind)
* `nameplate_capacity_mw` - power plant capacity reported to EIA (MW)
* `lat` - latitude of the plant (degrees N)
* `lon` - longitude of the plant (degrees E)
* `State` - postal code of the state that each power plant is located in

Variables in `allnarrdata.csv` (compressed in `allnarrdata.zip`): 

* `plant_code` - EIA-assigned plant code
* `month` - month (1-12)
* `year` - year (2011-2022)
* `acpcp_min` - minimum convective precipitation accumulation (kg/m^2)
* `acpcp_max` - maximum convective precipitation accumulation (kg/m^2)
* `acpcp_avg` - average convective precipitation accumulation (kg/m^2)
* `air_min` - minimum air temperature (K)
* `air_max` - maximum air temperature (K)
* `air_avg` - average air temperature (K)
* `albedo_min` - minimum albedo (%)
* `albedo_max` - maximum albedo (%)
* `albedo_avg` - average albedo (%)
* `apcp_min` - minimum precipitation amount (kg/m^2)
* `apcp_max` - maximum precipitation amount (kg/m^2)
* `apcp_avg` - average precipitation amount (kg/m^2)
* `dpt_min` - minimum dew point temperature (K)
* `dpt_max` - maximum dew point temperature (K)
* `dpt_avg` - average dew point temperature (K)
* `pottmp_min` - minimum potential temperature (K)
* `pottmp_max` - maximum potential temperature (K)
* `pottmp_avg` - average potential temperature (K)
* `rhum_min` - minimum relative humidity (%)
* `rhum_max` - maximum relative humidity (%)
* `rhum_avg` - average relative humidity (%)
* `tcdc_min` - minimum total cloud cover (%)
* `tcdc_max` - maximum total cloud cover (%)
* `tcdc_avg` - average total cloud cover (%)
* `uwnd_min` - minimum u-component of wind speed (m/s)
* `uwnd_max` - maximum u-component of wind speed (m/s)
* `uwnd_avg` - average u-component of wind speed (m/s)
* `vwnd_min` - minimum v-component of wind speed (m/s)
* `vwnd_max` - maximum v-component of wind speed (m/s)
* `vwnd_avg` - average v-component of wind speed (m/s)

The EIA data was collected at the monthly level. The NARR data was collected at the daily level and aggregated to monthly values. All data were collected for the time period between 2011 and 2022.
