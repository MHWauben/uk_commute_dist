### Load NOMIS data from single csv ###
library(readr)
library(purrr)
library(dplyr)
library(tidyr)
library(magrittr)

file_p <- 'home_travel_nomis.csv'

modes <- c('wfh', 'metro_tram', 'train', 'bus', 'taxi', 'drive_car', 'pass_car', 'foot')
skips <- seq(from = 9, by = 348, length.out = length(modes))

data_out <- function(skip, mode){
  data <- readr::read_csv(file_p,
                          skip = skip,
                          n_max = 324) %>%
    tidyr::pivot_longer(2:ncol(.), 
                        names_to = 'work',
                        values_to = mode)
  colnames(data) <- c('home', 'work', mode)
  return(data)
}

data_list <- purrr::map2(skips, modes, data_out) %>%
  purrr::reduce(left_join, by = c('home', 'work'))

# Calculate total trips and total trips using public transport
data_list$total <- rowSums(data_list[, 3:ncol(data_list)], na.rm = TRUE)
data_list$public <- data_list$metro_tram + data_list$train + data_list$bus

# Calculate proportion of total travel by mode
data_prop <- data_list %>%
  dplyr::mutate_if(is.numeric, funs(. / data_list$total)) %>%
  dplyr::select(-total)
colnames(data_prop) <- c('home', 'work', paste0(colnames(data_prop)[3:ncol(data_prop)], '_prop'))

# Combine all data
data_full <- dplyr::left_join(data_list, data_prop, by = c('home', 'work'))
