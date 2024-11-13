# Renee Obringer
# 24 September 2024
# Read in NARR NetCDF files

rm(list=ls())

library(ncdf4)
library(CFtime)

setwd('/Users/rqo5125/Library/Mobile Documents/com~apple~CloudDocs/Documents/Research/data/NARR/rawnetcdffiles/windspeed')

# get list of file names
filenames <- list.files(pattern="*.nc", full.names=F)

# lat/lon pairs
all_locations <- list(c(36.1435, -114.4144))

# create list of new csv file names
newfilenames <- c('vwind_narr.csv')
                  
for (l in 1:length(all_locations)) {
  # initialize variables
  variable <- data.frame(Date = as.Date(character()), vwind_mPs = numeric())
  location <- all_locations[[l]]
  
  for (i in 37:57) {
    # upload netcdf file
    ncin <- nc_open(filenames[i])
    #print(ncin)
    
    # data dimensions - change variable 
    data_dims <- ncin$var$vwnd$varsize
    
    # extract dates
    cf <- CFtime(ncin$dim$time$units, ncin$dim$time$calendar, ncin$dim$time$vals)
    ncdates <- CFtimestamp(cf)
    
    # extract the lat/lon grids 
    lats <- ncvar_get(ncin, varid = 'lat', start = c(1,1), count = c(data_dims[1],data_dims[2]))
    lons <- ncvar_get(ncin, varid = 'lon', start = c(1,1), count = c(data_dims[1],data_dims[2]))
    lons <- ifelse(lons>0,lons-360,lons)
    
    # find closest point 
    distance <- (lats-location[1])**2+(lons-location[2])**2
    closest_point <- which(distance == min(distance), arr.ind = TRUE)
    
    # extract variable over points of interest 
    output <- ncvar_get(ncin, varid = 'vwnd', start = c(closest_point[1],closest_point[2],1), count = c(1,1,data_dims[3]))
    
    # close the file
    nc_close(ncin)
    
    # convert variables to dataframe
    fulldata <- data.frame(Date = ncdates, vwind_mPs = output)
    
    # append to final dataframe
    variable <- rbind(variable, fulldata)
  }
  
  # save data frame as csv
  write.csv(variable, newfilenames[l])
}
