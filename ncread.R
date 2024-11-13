# Renee Obringer
# 24 September 2024
# reading netcdf files
# more information: https://www.e-education.psu.edu/meteo810/content/l7_p5.html

rm(list=ls())

library(ncdf4)
library(CFtime)

#setwd("/Users/rqo5125/Library/Mobile Documents/com~apple~CloudDocs/Documents/Research/data/streamflow/FutureStreams/")
#setwd('/Users/rqo5125/Downloads')
setwd('/Users/rqo5125/Library/Mobile Documents/com~apple~CloudDocs/Documents/Research/data/NARR/rawnetcdffiles/windspeed')

# get list of file names
filenames <- list.files(pattern="*.nc", full.names=F)

# lat/lon pairs
all_locations <- list(c(36.1435,	-114.4144), c(33.8887, -112.2801), c(33.5819, -111.2532), 
                      c(33.8273, -111.6273), c(33.5422, -111.4365), c(33.6865, -111.1235),
                      c(33.9858, -111.7212), c(33.5703, -111.5245), c(39.5480, -105.0704),
                      c(39.1964, -105.2853), c(38.9797, -105.3575), c(39.941944, -105.372778),
                      c(39.4267, -105.1343), c(38.9909, -105.9054), c(39.6092, -106.0611),
                      c(39.6288, -105.0704), c(39.8277, -105.2465), c(40.015278, -106.210278))

# Puerto Rico:
#list(c(18.35, -67.24),c(18.2, -67.1),c(18.06, -67.13),c(18.01, -66.93),c(18.27, -66.87),c(18.46, -66.93),
#     c(18.47, -67.13),c(18.32, -66.95),c(18.42, -66.88),c(18.43, -66.64),c(18.43, -66.56),c(18.46, -66.38),
#     c(18.45, -66.28),c(18.34, -66.24),c(18.4, -66.48),c(18.35, -66.8),c(18.3, -66.75),c(18.16, -66.79),
#     c(18.2, -66.6),c(18.2, -66.28),c(18.08, -66.15),c(18.23, -66.11),c(18.32, -66.32),c(18.28, -66.53),
#     c(18.01, -66.79),c(18.08, -66.62),c(18.04, -66.48),c(18, -66.38),c(18.11, -66.36),c(18.03, -66.27),
#     c(18, -66.13),c(18.05, -66.02),c(18.43, -66.23),c(18.36, -66.18),c(18.44, -66.15),c(18.34, -66.11),
#     c(18.32, -66.06),c(18.38, -66.04),c(18.34, -66),c(18.35, -65.95),c(18.2, -66.05),c(18.06, -65.86),
#     c(18.24, -65.91),c(18.24, -65.76),c(18.31, -65.66),c(18.32, -65.81),c(18.42, -65.9),c(18.13, -65.44))

# streamflow:
# list(c(33.6194, -110.9208), c(34.0731, -111.7156), c(36.0153, -114.7378), c(35.7736, -113.3628),
# c(38.9933, -105.9391), c(39.1628, -105.3097), c(39.8209, -105.2611), c(39.9566, -105.3824),
# c(40.0002, -106.1804), c(39.5667, -106.0489), c(38.993348, -105.8941), c(39.2600, -105.2214), 
# c(39.945621, -105.3568), c(40.0359, -106.2050), c(39.6256, -106.0658))

# reservoirs:
# list(c(36.1435,	-114.4144), c(33.8887, -112.2801), c(33.5819, -111.2532), 
#      c(33.8273, -111.6273), c(33.5422, -111.4365), c(33.6865, -111.1235),
#      c(33.9858, -111.7212), c(33.5703, -111.5245), c(39.5480, -105.0704),
#      c(39.1964, -105.2853), c(38.9797, -105.3575), c(39.941944, -105.372778),
#      c(39.4267, -105.1343), c(38.9909, -105.9054), c(39.6092, -106.0611),
#      c(39.6288, -105.0704), c(39.8277, -105.2465), c(40.015278, -106.210278))

# create list of new csv file names
newfilenames <- c('lakemead_vwind_narr.csv', 'lakepleasant_vwind_narr.csv', 'apache_vwind_narr.csv',
                  'bartlett_vwind_narr.csv', 'canyon_vwind_narr.csv', 'roosevelt_vwind_narr.csv',
                  'horseshoe_vwind_narr.csv', 'saguaro_vwind_narr.csv', 'chatfield_vwind_narr.csv', 
                  'cheesman_vwind_narr.csv', 'elevenmile_vwind_narr.csv', 'gross_vwind_narr.csv',
                  'strontia_vwind_narr.csv', 'antero_vwind_narr.csv', 'dillon_vwind_narr.csv',
                  'marston_vwind_narr.csv', 'ralston_vwind_narr.csv', 'williamsfork_vwind_narr.csv')
                  
# Puerto Rico: 
#c('pr_01_vwind.csv', 'pr_02_vwind.csv', 'pr_03_vwind.csv', 'pr_04_vwind.csv', 'pr_05_vwind.csv', 'pr_06_vwind.csv', 
#  'pr_07_vwind.csv', 'pr_08_vwind.csv', 'pr_09_vwind.csv', 'pr_10_vwind.csv', 'pr_11_vwind.csv', 'pr_12_vwind.csv',
#  'pr_13_vwind.csv', 'pr_14_vwind.csv', 'pr_15_vwind.csv', 'pr_16_vwind.csv', 'pr_17_vwind.csv', 'pr_18_vwind.csv', 
#  'pr_19_vwind.csv', 'pr_20_vwind.csv', 'pr_21_vwind.csv', 'pr_22_vwind.csv', 'pr_23_vwind.csv', 'pr_24_vwind.csv',
#  'pr_25_vwind.csv', 'pr_26_vwind.csv', 'pr_27_vwind.csv', 'pr_28_vwind.csv', 'pr_29_vwind.csv', 'pr_30_vwind.csv', 
#  'pr_31_vwind.csv', 'pr_32_vwind.csv', 'pr_33_vwind.csv', 'pr_34_vwind.csv', 'pr_35_vwind.csv', 'pr_36_vwind.csv',
#  'pr_37_vwind.csv', 'pr_38_vwind.csv', 'pr_39_vwind.csv', 'pr_40_vwind.csv', 'pr_41_vwind.csv', 'pr_42_vwind.csv', 
#  'pr_43_vwind.csv', 'pr_44_vwind.csv', 'pr_45_vwind.csv', 'pr_46_vwind.csv', 'pr_47_vwind.csv', 'pr_48_vwind.csv')

  
# streamflow:
#c('roosevelt_inflow_ipsl.csv', 'horseshoe_inflow_ipsl.csv', 'lakemead_outflow_ipsl.csv', 'lakemead_inflow_ipsl.csv',
# 'antero_inflow_ipsl.csv', 'cheesman_inflow_ipsl.csv', 'ralsten_inflow_ipsl.csv', 'gross_inflow_ipsl.csv',
# 'williamsfork_inflow_ipsl.csv', 'dillon_inflow_ipsl.csv', 'antero_outflow_ipsl.csv', 'cheesman_outflow_ipsl.csv', 
# 'gross_outflow_ipsl.csv', 'williamsfork_outflow_ipsl.csv', 'dillon_outflow_psl.csv')

# reservoirs:
# c('lakemead_windspeed_hadgem.csv', 'lakepleasant_windspeed_hadgem.csv', 'apache_windspeed_hadgem.csv',
# 'bartlett_windspeed_hadgem.csv', 'canyon_windspeed_hadgem.csv', 'roosevelt_windspeed_ipsl.csv',
# 'horseshoe_windspeed_hadgem.csv', 'saguaro_windspeed_hadgem.csv', 'chatfield_windspeed_hadgem.csv', 
# 'cheesman_windspeed_hadgem.csv', 'elevenmile_windspeed_hadgem.csv', 'gross_windspeed_hadgem.csv',
# 'strontia_windspeed_hadgem.csv', 'antero_windspeed_hadgem.csv', 'dillon_windspeed_hadgem.csv',
# 'marston_windspeed_hadgem.csv', 'ralston_windspeed_hadgem.csv', 'williamsfork_windspeed_hadgem.csv')

for (l in 1:length(all_locations)) {
  # initialize variables
  variable <- data.frame(Date = as.Date(character()), vwind_mPs = numeric())#, ModelRun = character()) 
  location <- all_locations[[l]]
  
  for (i in 37:57) {
    # upload netcdf file
    ncin <- nc_open(filenames[i])
    #print(ncin)
    
    # data dimensions - change variable (NARR Only)
    data_dims <- ncin$var$vwnd$varsize
    
    # extract dates
    cf <- CFtime(ncin$dim$time$units, ncin$dim$time$calendar, ncin$dim$time$vals)
    ncdates <- CFtimestamp(cf)
    
    # extract the lat/lon grids (NARR Only)
    lats <- ncvar_get(ncin, varid = 'lat', start = c(1,1), count = c(data_dims[1],data_dims[2]))
    lons <- ncvar_get(ncin, varid = 'lon', start = c(1,1), count = c(data_dims[1],data_dims[2]))
    lons <- ifelse(lons>0,lons-360,lons)
    
    # find closest point (NARR Only)
    distance <- (lats-location[1])**2+(lons-location[2])**2
    closest_point <- which(distance == min(distance), arr.ind = TRUE)
    
    # extract variable over points of interest
    #output <- ncvar_get(ncin, varid = "discharge", 
    #                    start = c(which.min(abs(ncin$dim$longitude$vals - location[2])),
    #                              which.min(abs(ncin$dim$latitude$vals - location[1])), 1), 
    #                    count = c(1,1,-1))
    
    # extract variable over points of interest (NARR Only)
    output <- ncvar_get(ncin, varid = 'vwnd', start = c(closest_point[1],closest_point[2],1), count = c(1,1,data_dims[3]))
    
    # create a standard line plot to check results
    #plot(output,type="n")
    #lines(output,lwd=2,lty=1,col="red")
    
    # close the file
    nc_close(ncin)
    
    # create label variable
    #modelrun <- sub(".*miroc_", "", filenames[i])
    #modelrun <- sub("_(1|2).*", "", modelrun)
    
    # convert variables to dataframe
    fulldata <- data.frame(Date = ncdates, vwind_mPs = output)#, ModelRun = rep(modelrun, length(output)))
    
    # append to final dataframe
    variable <- rbind(variable, fulldata)
  }
  
  # save data frame as csv
  write.csv(variable, newfilenames[l])
}
