# Purpose: Figures for Energy-Climate Data Paper
# Author: Renee Obringer
# Run On: 25 September 2024

rm(list=ls())
options(scipen = 999)

# libraries
library(readxl)
library(purrr)
library(dplyr)
library(lubridate)
library(rnaturalearth)     
library(ggplot2)      
library(sf)  
library(cowplot)

# directories
maindir <- '    '
# NOTE: set `maindir` path to the folder on your personal machine which contains the downloaded data and code

datadir1 <- paste(maindir, '/data/NARRdata', sep = '')
datadir2 <- paste(maindir, '/data/EIAdata', sep = '')

########## LOAD DATA #################

# NARR data
convectprecipdata <- read_excel(paste(datadir1, '/acpcp.agg.2011.2022.xlsx', sep = ''))  # convective precipitation accumulation (kg/m^2)
temppdata <- read_excel(paste(datadir1, '/air.agg.2011.2022.xlsx', sep = ''))            # air temperature (K)
albedodata <- read_excel(paste(datadir1, '/albedo.agg.2011.2022.xlsx', sep = ''))        # albedo (%)
precipdata <- read_excel(paste(datadir1, '/apcp.agg.2011.2022.xlsx', sep = ''))          # precipitation amount (kg/m^2)
dewpointdata <- read_excel(paste(datadir1, '/dpt.agg.2011.2022.xlsx', sep = ''))         # dew point temperature (K)
pottempdata <- read_excel(paste(datadir1, '/pottmp.agg.2011.2022.xlsx', sep = ''))       # potential temperature (K)
rhdata <- read_excel(paste(datadir1, '/rhum.agg.2011.2022.xlsx', sep = ''))              # relative humidity (%)
cloudcoverdata <- read_excel(paste(datadir1, '/tcdc.agg.2011.2022.xlsx', sep = ''))      # total cloud cover (%)
uwinddata <- read_excel(paste(datadir1, '/uwnd.agg.2011.2022.xlsx', sep = ''))           # u-component of wind (m/s)
vwinddata <- read_excel(paste(datadir1, '/vwnd.agg.2011.2022.xlsx', sep = ''))           # v-component of wind (m/s)

# EIA data
plantdata <- read_excel(paste(datadir2, '/eia_master_df.xlsx', sep = ''))
latlondata <- read_excel(paste(maindir, '/miscellaneousfiles/REF_LAT_LON.xlsx', sep = ''))
statedata <- read_excel(paste(maindir, '/miscellaneousfiles/state_plantIDs.xlsx', sep = ''))

########## ORGANIZE DATA ############

# merge all NARR dataframes
datasets <- list(convectprecipdata, temppdata, albedodata, precipdata, dewpointdata, pottempdata, rhdata, cloudcoverdata, uwinddata, vwinddata)
narrdata <- purrr::reduce(.x = datasets, merge, by = c('plant_code', 'year', 'month'), all = T)

# write to csv
setwd(paste(maindir, '/data', sep = ''))
write.csv(narrdata, 'allnarrdata.csv')

# merge plant dataframes
plantinfo <- merge(latlondata, statedata, by = 'plant_code')
plantdata2 <- merge(plantdata, plantinfo, by = 'plant_code')

# remove & rename certain variables
plantdata2 <- plantdata2[,-2]
names(plantdata2)[5] <- 'source'

# write to csv
setwd(paste(maindir, '/data', sep = ''))
write.csv(plantdata2, 'allplantdata.csv')

setwd(paste(maindir, '/miscellaneousfiles', sep = ''))
write.csv(plantinfo, 'plantinformation.csv')

########## FIGURES ##################

setwd(paste(maindir, '/data', sep = ''))
narrdata <- read.csv('allnarrdata.csv')
eiadata <- read.csv('allplantdata.csv')

setwd(maindir)

# FIGURE 1: Power plant location and type

states <- ne_states(country = 'united states of america', returnclass = "sf")
states_crop <- st_crop(states, xmin = -130, xmax = -60, ymin = 20, ymax = 50)

plotdata <- eiadata %>% distinct(lat,lon, .keep_all = T)

pdf('allpowerplantsmap.pdf', width = 10.5, height = 6)
ggplot(plotdata) + theme_light() + geom_sf(data = states_crop, color = "#8a8a8a", fill = "#f8f8f8") +
  coord_sf(xlim = c(-130, -60), ylim = c(24, 50), expand = FALSE) +
  geom_point(aes(x = lon, y = lat, size = nameplate_capacity_mw, color = source)) +
  scale_color_manual(values = c('#fb9a99', '#fdbf6f', '#a6cee3', '#b2df8a'), name = 'Plant Type', labels = c('Geothermal', 'Solar', 'Hydro', 'Wind')) +
  scale_size_continuous(guide = 'none') + xlab('') + ylab('') + 
  theme(legend.position= 'bottom', text = element_text(size = 20)) +
  guides(color = guide_legend(override.aes = list(size = 5))) 
dev.off()

# FIGURE 2a: Changing total generation through time by power plant type 

plotdata <- aggregate(net_gen ~ month + year + source, data = eiadata, FUN = 'sum')
plotdata <- plotdata %>% mutate(date = make_date(year, month))

pdf('totalgeneration_allsources.pdf', width = 9, height = 5)
ggplot(plotdata) + geom_line(aes(x = date, y = net_gen/1000000, color = source)) +
  theme_light() + xlab('') + ylab('Generation (million MWh)') +
  scale_color_manual(values = c('#fb9a99', '#fdbf6f', '#a6cee3', '#b2df8a'), name = 'Plant Type', labels = c('Geothermal', 'Solar', 'Hydro', 'Wind')) +
  theme(legend.position= 'bottom', text = element_text(size = 20))
dev.off()

# FIGURE 2b: Changing average generation through time by power plant type

plotdata <- aggregate(net_gen ~ month + year + source, data = eiadata, FUN = 'mean')
plotdata <- plotdata %>% mutate(date = make_date(year, month))

pdf('avggeneration_allsources.pdf', width = 9, height = 5)
ggplot(plotdata) + geom_line(aes(x = date, y = net_gen/1000, color = source)) +
  theme_light() + xlab('') + ylab('Generation (thousand MWh)') +
  scale_color_manual(values = c('#fb9a99', '#fdbf6f', '#a6cee3', '#b2df8a'), name = 'Plant Type', labels = c('Geothermal', 'Solar', 'Hydro', 'Wind')) +
  theme(legend.position= 'bottom', text = element_text(size = 20))
dev.off()

# FIGURE 2c: Changing total capacity through time by power plant type 

plotdata <- aggregate(nameplate_capacity_mw ~ month + year + source, data = eiadata, FUN = 'sum')
plotdata <- plotdata %>% mutate(date = make_date(year, month))

pdf('totalcapacity_allsources.pdf', width = 9, height = 5)
ggplot(plotdata) + geom_line(aes(x = date, y = nameplate_capacity_mw/1000, color = source)) +
  theme_light() + xlab('') + ylab('Capacity (thousand MW)') +
  scale_color_manual(values = c('#fb9a99', '#fdbf6f', '#a6cee3', '#b2df8a'), name = 'Plant Type', labels = c('Geothermal', 'Solar', 'Hydro', 'Wind')) +
  theme(legend.position= 'bottom', text = element_text(size = 20))
dev.off()

# FIGURE 3a: Total generation in 2022 by state

states <- ne_states(country = 'united states of america', returnclass = "sf")
states_crop <- st_crop(states, xmin = -130, xmax = -60, ymin = 20, ymax = 50)

plotdata <- eiadata[which(eiadata$year == 2022),]
plotdata <- aggregate(net_gen ~ source + State, data = plotdata, FUN = 'sum')
names(plotdata)[2] <- 'postal'

hydrodata <- merge(states_crop, plotdata[which(plotdata$source == 'WAT'),], by = 'postal', all = TRUE)
solardata <- merge(states_crop, plotdata[which(plotdata$source == 'SUN'),], by = 'postal', all = TRUE)
winddata <- merge(states_crop, plotdata[which(plotdata$source == 'WND'),], by = 'postal', all = TRUE)
geodata <- merge(states_crop, plotdata[which(plotdata$source == 'GEO'),], by = 'postal', all = TRUE)

p1 <- ggplot() + theme_light() + geom_sf(data = hydrodata, aes(fill = net_gen/1000000), color = "#8a8a8a") +
  coord_sf(xlim = c(-130, -60), ylim = c(24, 50), expand = FALSE) + ggtitle('Hydroelectric') +
  scale_fill_gradient(low = '#c6dbef', high = '#084594', name = '') +
  theme(legend.position= 'bottom', text = element_text(size = 20), legend.key.width= unit(2, 'cm'), 
        axis.text = element_blank(), panel.grid = element_blank(), panel.border = element_blank(), axis.ticks = element_blank()) 

p2 <- ggplot() + theme_light() + geom_sf(data = solardata, aes(fill = net_gen/1000000), color = "#8a8a8a") +
  coord_sf(xlim = c(-130, -60), ylim = c(24, 50), expand = FALSE) + ggtitle('Solar') +
  scale_fill_gradient(low = '#fdd0a2', high = '#8c2d04', name = '') +
  theme(legend.position= 'bottom', text = element_text(size = 20), legend.key.width= unit(2, 'cm'), 
        axis.text = element_blank(), panel.grid = element_blank(), panel.border = element_blank(), axis.ticks = element_blank()) 

p3 <- ggplot() + theme_light() + geom_sf(data = geodata, aes(fill = net_gen/1000000), color = "#8a8a8a") +
  coord_sf(xlim = c(-130, -60), ylim = c(24, 50), expand = FALSE) + ggtitle('Geothermal') +
  scale_fill_gradient(low = '#fc9272', high = '#99000d', name = '') +
  theme(legend.position= 'bottom', text = element_text(size = 20), legend.key.width= unit(2, 'cm'), 
        axis.text = element_blank(), panel.grid = element_blank(), panel.border = element_blank(), axis.ticks = element_blank()) 

p4 <- ggplot() + theme_light() + geom_sf(data = winddata, aes(fill = net_gen/1000000), color = "#8a8a8a") +
  coord_sf(xlim = c(-130, -60), ylim = c(24, 50), expand = FALSE) + ggtitle('Wind') +
  scale_fill_gradient(low = '#a1d99b', high = '#005a32', name = '') +
  theme(legend.position= 'bottom', text = element_text(size = 20), legend.key.width= unit(2, 'cm'), 
        axis.text = element_blank(), panel.grid = element_blank(), panel.border = element_blank(), axis.ticks = element_blank()) 

pdf('2022stategenerationmap.pdf', width = 10, height = 7)
plot_grid(p1, p2, p3, p4, nrow = 2)
dev.off()

# FIGURE 3b: Total capacity in 2022 by state

states <- ne_states(country = 'united states of america', returnclass = "sf")
states_crop <- st_crop(states, xmin = -130, xmax = -60, ymin = 20, ymax = 50)

plotdata <- eiadata[which(eiadata$year == 2022),]
plotdata <- aggregate(nameplate_capacity_mw ~ source + State, data = plotdata, FUN = 'sum')
names(plotdata)[2] <- 'postal'

hydrodata <- merge(states_crop, plotdata[which(plotdata$source == 'WAT'),], by = 'postal', all = TRUE)
solardata <- merge(states_crop, plotdata[which(plotdata$source == 'SUN'),], by = 'postal', all = TRUE)
winddata <- merge(states_crop, plotdata[which(plotdata$source == 'WND'),], by = 'postal', all = TRUE)
geodata <- merge(states_crop, plotdata[which(plotdata$source == 'GEO'),], by = 'postal', all = TRUE)

p1 <- ggplot() + theme_light() + geom_sf(data = hydrodata, aes(fill = nameplate_capacity_mw/1000), color = "#8a8a8a") +
  coord_sf(xlim = c(-130, -60), ylim = c(24, 50), expand = FALSE) + ggtitle('Hydroelectric') +
  scale_fill_gradient(low = '#c6dbef', high = '#084594', name = '') +
  theme(legend.position= 'bottom', text = element_text(size = 20), legend.key.width= unit(2, 'cm'), 
        axis.text = element_blank(), panel.grid = element_blank(), panel.border = element_blank(), axis.ticks = element_blank()) 

p2 <- ggplot() + theme_light() + geom_sf(data = solardata, aes(fill = nameplate_capacity_mw/1000), color = "#8a8a8a") +
  coord_sf(xlim = c(-130, -60), ylim = c(24, 50), expand = FALSE) + ggtitle('Solar') +
  scale_fill_gradient(low = '#fdd0a2', high = '#8c2d04', name = '') +
  theme(legend.position= 'bottom', text = element_text(size = 20), legend.key.width= unit(2, 'cm'), 
        axis.text = element_blank(), panel.grid = element_blank(), panel.border = element_blank(), axis.ticks = element_blank()) 

p3 <- ggplot() + theme_light() + geom_sf(data = geodata, aes(fill = nameplate_capacity_mw/1000), color = "#8a8a8a") +
  coord_sf(xlim = c(-130, -60), ylim = c(24, 50), expand = FALSE) + ggtitle('Geothermal') +
  scale_fill_gradient(low = '#fc9272', high = '#99000d', name = '') +
  theme(legend.position= 'bottom', text = element_text(size = 20), legend.key.width= unit(2, 'cm'), 
        axis.text = element_blank(), panel.grid = element_blank(), panel.border = element_blank(), axis.ticks = element_blank()) 

p4 <- ggplot() + theme_light() + geom_sf(data = winddata, aes(fill = nameplate_capacity_mw/1000), color = "#8a8a8a") +
  coord_sf(xlim = c(-130, -60), ylim = c(24, 50), expand = FALSE) + ggtitle('Wind') +
  scale_fill_gradient(low = '#a1d99b', high = '#005a32', name = '') +
  theme(legend.position= 'bottom', text = element_text(size = 20), legend.key.width= unit(2, 'cm'), 
        axis.text = element_blank(), panel.grid = element_blank(), panel.border = element_blank(), axis.ticks = element_blank()) 

pdf('2022statecapacitymap.pdf', width = 10, height = 7)
plot_grid(p1, p2, p3, p4, nrow = 2)
dev.off()

# FIGURE 4a: changing generation over specific states

plotdata <- aggregate(net_gen ~ month + year + source + State, data = eiadata, FUN = 'sum')
plotdata <- plotdata %>% mutate(date = make_date(year, month))

statedata <- plotdata[which(plotdata$State == 'CA' | plotdata$State == 'TX' | plotdata$State == 'WA' | plotdata$State == 'AZ'),]

pdf('specificstatesgen_allsources.pdf', width =11, height = 7)
ggplot(statedata) + geom_area(aes(x = date, y = net_gen/1000000, fill = source), color = '#8a8a8a', linewidth = 0.1) +
  theme_light() + xlab('') + ylab('Generation (million MWh)') +
  scale_fill_manual(values = c('#fb9a99', '#fdbf6f', '#a6cee3', '#b2df8a'), name = 'Plant Type', labels = c('Geothermal', 'Solar', 'Hydro', 'Wind')) +
  theme(legend.position= 'bottom', text = element_text(size = 20)) +
  facet_wrap(~State, scales = 'free', nrow = 2)
dev.off()

# FIGURE 4b: changing capacity over specific states

plotdata <- aggregate(nameplate_capacity_mw ~ month + year + source + State, data = eiadata, FUN = 'sum')
plotdata <- plotdata %>% mutate(date = make_date(year, month))

statedata <- plotdata[which(plotdata$State == 'CA' | plotdata$State == 'TX' | plotdata$State == 'WA' | plotdata$State == 'AZ'),]

pdf('specificstatescap_allsources.pdf', width =11, height = 7)
ggplot(statedata) + geom_area(aes(x = date, y = nameplate_capacity_mw/1000, fill = source), color = '#8a8a8a', linewidth = 0.1) +
  theme_light() + xlab('') + ylab('Capacity (thousand MW)') +
  scale_fill_manual(values = c('#fb9a99', '#fdbf6f', '#a6cee3', '#b2df8a'), name = 'Plant Type', labels = c('Geothermal', 'Solar', 'Hydro', 'Wind')) +
  theme(legend.position= 'bottom', text = element_text(size = 20)) +
  facet_wrap(~State, scales = 'free', nrow = 2)
dev.off()



