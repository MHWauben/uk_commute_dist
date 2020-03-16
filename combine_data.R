### LINK TRANSPORT AND GEOMETRY

source('load_modes.R')
source('load_shapes.R')

mode_geom <- dplyr::left_join(data_full, msoa, by = c('home' = 'name'))
mode_geom <- dplyr::left_join(mode_geom, msoa, by = c('work' = 'name'))
colnames(mode_geom) <- c(colnames(data_full), 
                         'geom_home', 'geom_work')
mode_geom$line <- sf::st_nearest_points(mode_geom$geom_home, mode_geom$geom_work)
