### LINK TRANSPORT AND GEOMETRY

source('load_modes.R')
source('load_shapes.R')

mode_geom <- dplyr::left_join(data_full, msoa, by = c('home' = 'name'))
mode_geom <- dplyr::left_join(mode_geom, msoa, by = c('work' = 'name'))
colnames(mode_geom) <- c(colnames(data_full), 
                         'geom_home', 'geom_work')
mode_geom$home_mid <- sf::st_centroid(mode_geom$geom_home, of_largest_polygon = T)
home_coords <- sf::st_coordinates(mode_geom$home_mid)
colnames(home_coords) <- c('home_lon', 'home_lat')
mode_geom$work_mid <- sf::st_centroid(mode_geom$geom_work, of_largest_polygon = T)
work_coords <- sf::st_coordinates(mode_geom$work_mid)
colnames(work_coords) <- c('work_lon', 'work_lat')
mode_geom <- cbind(mode_geom, home_coords, work_coords)
geom_clean <- mode_geom[!is.na(sf::st_dimension(sf::st_as_sf(mode_geom))),]

### PLOT PROPORTION OF PUBLIC TRANSPORT USED
library(igraph)
library(ggraph)
geom_public <- geom_clean[!is.na(geom_clean$public_prop) & geom_clean$public_prop > 0,]
edges <- unique(geom_public[, c('home', 'work', 'public', 'public_prop', 'home_mid', 'work_mid')])
nodes <- data.frame(loc = unique(c(geom_public$home, geom_public$work)),
                    location = unique(c(geom_public$home, geom_public$work)))

# Define network graph
net <- igraph::graph_from_data_frame(d=edges, vertices=nodes, directed=T) 
net <- simplify(net, remove.multiple = F, remove.loops = T)

# Only show nodes with at least twice the mean proportion of public transport use
cut.off <- mean(edges$public_prop)*2 
net.sp <- delete_edges(net, E(net)[public_prop<cut.off])
plot(net.sp, edge.arrow.size=.4,
     vertex.label=V(net)$names, 
     edge.width = E(net)$public_prop,
     layout = layout_with_drl(net.sp))

ggraph(net.sp,  layout = 'drl') +
        geom_edge_arc(aes(edge_width = (public_prop / 10), edge_colour = public_prop), 
                      strength=0.3) +
        geom_node_text(aes(label = location), size=3, color="gray50", repel=T) +
        scale_edge_width(range = c(0.01, 0.1))+
        theme_void()

### PLOT GGMAP
library(ggplot2)

geom_test <- geom_clean %>%
        dplyr::filter(home != work) %>% # Only keep connections to other MSOAs
        dplyr::filter(public_prop > 0.25) %>% # 
        dplyr::mutate(prop_bin = cut(public_prop, 
                                     breaks = seq(0.2, 1, by = 0.1), 
                                     labels = 1:8)) # Create categorical variable
ggplot(geom_test, aes(x = home_lon, y = home_lat))+
        geom_curve(aes(x = home_lon, y = home_lat, 
                       xend = work_lon, yend = work_lat,
                       size = public_prop,
                       colour = prop_bin), 
                   alpha = 0.2,
                   curvature = 0.1)+
        scale_size(range = c(0.01, 0.1))+
        geom_point(color = 'aquamarine')




