# Climate-EnergyNexus_PowerPlants

Code and data for working with renewable energy generation and climate data at the power plant-level. The results from the analysis are currently under review. 

Two categories of data were collected: renewable energy generation data and climate data. The renewable energy generation data (folder: `data/EIAdata`) includes energy generation data for geothermal, hydroelectric, solar, and wind power obtained from the US Energy Information Administration. The climate data (folder: `data/NARRdata`) were obtained from the North American Regional Reanalysis. All data were collected between 2023 and 2024.

We conducted some post-processing and created figures using R version 4.1.2. This file (`figurecode.R`) was last run on 25 September 2024. In order to run the R code, the following R packages are required, with the version we used in parentheses: 

*  cowplot (v1.1.1)
*  dplyr (v1.0.10)
*  ggplot2 (v3.4.0)
*  lubridate (v1.9.0)
*  purrr (v0.3.5)
*  readxl (v1.4.1)
*  rnaturalearth (v0.1.0)
*  sf (v1.0-6)

To run the R code, users need to update the path to the folder downloaded or cloned from this repository. This change can be made on line 19 of `figurecode.R`. Once this path is changed, the data directories will be assigned automatically after running lines 22-23 in `figurecode.R`. The post-processing code can be found in lines 25-68 and the figure code can be found in lines 69-242.
