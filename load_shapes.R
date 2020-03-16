### MSOA BOUNDARIES
# To calculate distances and plot
library(downloader)
library(sf)
library(lwgeom)
library(magrittr)
library(dplyr)

# downloader::download('https://opendata.arcgis.com/datasets/c661a8377e2647b0bae68c4911df868b_3.zip?outSR=%7B%22latestWkid%22%3A27700%2C%22wkid%22%3A27700%7D',
#                      destfile = 'msoa.zip', mode = 'wb')
# unzip('msoa.zip')

msoa <- sf::read_sf('Middle_Layer_Super_Output_Areas_December_2011_Boundaries_EW_BSC.shp')
msoa$name <- gsub(' [0-9]*$', '', msoa$msoa11nm)
msoa$namew <- gsub(' [0-9]*$', '', msoa$msoa11nmw)

msoa <- msoa %>%
  dplyr::select(name, geometry) %>%
  dplyr::group_by(name) %>%
  dplyr::mutate(geometry = sf::st_union(geometry)) %>%
  unique(.)
