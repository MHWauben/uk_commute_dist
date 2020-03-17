### COMMUTES WITHIN-MSOA

source('load_modes.R')
source('load_shapes.R')

data_local <- data_full %>%
  dplyr::filter(home == work)

local_geom <- dplyr::left_join(data_local, msoa, by = c('home' = 'name'))
local_geom$mid <- sf::st_centroid(local_geom$geometry, of_largest_polygon = T)
local_coords <- sf::st_coordinates(local_geom$mid)
colnames(local_coords) <- c('local_lon', 'local_lat')
local_geom <- cbind(local_geom, local_coords)


local_clean <- local_geom[!is.na(sf::st_dimension(sf::st_as_sf(local_geom))),] %>%
  dplyr::mutate(log_prop = log(public_prop + 0.0000000000001),
                log_public = log(public + 1)) %>%
  dplyr::mutate(scale_log_prop = scale(log_prop),
                scale_log_pub = scale(log_public),
                scale_prop = scale(public_prop),
                scale_pub = scale(public)) %>%
  sf::st_as_sf(.)

# Check distribution of values ~normal after transformation?
hist(local_clean$public_prop)
hist(local_clean$scale_log_prop)

# Proportion of trips used public transport
plot(local_clean['public_prop'])
# Absolute number of people using public transport
plot(local_clean['public'])
# Scaled log of both
plot(local_clean[c('log_prop', 'log_public')])
plot(local_clean[c('scale_log_prop', 'scale_log_pub')])
plot(local_clean[c('scale_prop', 'scale_pub')])


                 