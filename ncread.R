# Renee Obringer
# 24 September 2024
# Read in NARR NetCDF files

rm(list=ls())

library(readxl)
library(ncdf4)
library(CFtime)

# Set the directory with NetCDF files downloaded from NARR
netcdfdir <- '    '

# Set the path to the cloned github repository
path <- '    ' 

# get list of file names
setwd(netcdfdir)
filenames <- list.files(pattern="*.nc", full.names=F)

# lat/lon pairs
all_locations <- read_excel(paste(path, '/miscellaneousfiles/REF_LAT_LON.xlsx', sep = ''))

# create new csv file name
newfilename <- 'vwnd.daily.2011.2022.csv'
                  
for (l in 1:nrow(all_locations)) {
  # initialize variables
  variable <- data.frame(Date = as.Date(character()), vwind_mPs = numeric())
  location <- all_locations[l,2:3]
  
  # loop through each year of interest **change i count based indices in "filenames"**
  for (i in 63:length(filenames)) {
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
