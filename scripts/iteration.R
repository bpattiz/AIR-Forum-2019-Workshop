
# Get averages of ACT and SAT variables and map it to dataframe
ccihe_2018 %>%
  select(matches('ACT|SAT'), -ACTCAT) %>% 
  map_df(mean, na.rm = TRUE)

# Use the annoymous function .x to add one to a sequence
x_seq <- seq(1, 10, 1)

x_seq %>%
  map_dbl(~ .x + 1)



# Get IDs of univiersites using only names, put it to a dataframe

# Universities to look up
universities <- c('University of Denver', 'University of Colorado Boulder')

# Create function to apply to data
get_unitid <- function(university){
  
  ccihe_2018 %>% 
    filter(NAME %in% university) %>%
    select(UNITID, NAME)
  
  
}

universities %>%
  map_df(get_unitid) 

# Grouped mapping using do, will be replaced by grouped_map
# Get the first five institutions of each group
ccihe_2018 %>% 
  group_by(BASIC2018) %>%
  do(slice(., 1:5)) %>%
  select(UNITID, NAME, BASIC2018)




