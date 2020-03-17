# England commutes by public transport
How far and where do people travel for work using public transport in England?

## Primary script to run: map_data.R
This script will load load_modes.R (which has travel by mode of transport) and load_shapes.R (which has polygons for MSOAs). **Note**: uncomment the download and unzip lines the first time you run load_shapes.R. 

map_data.R will then generate igraph, ggraph, and ggplot visualisations of density of public transport commutes by MSOA-link.

## Local commutes: local_commutes.R
Explores which MSOAs rely on public transport to travel within the same MSOA. 

## Data sources
* 2011 Census table WU03EW: Location of usual residence and place of work by method of travel to work (MSOA level). Queried all modes of transport at MSOA-level for MSOAs in England only. Query output saved as CSV in this repository.
* Open Geography Portal: Middle Layer Super Output Areas (December 2011) Boundaries EW BSC. Shapefile downloaded and unzipped programmatically. 

