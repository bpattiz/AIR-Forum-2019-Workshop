# Load libraries---------------------------------------------------------------
library(tidyverse)
library(rscorecard)
library(betareg)
library(broom)

# rscorecard key
sc_key('SExIdTmiI9BdEgFu006AH21dTrk7fXDYFzZqXYYB')

# Bachalorate granting institutions
cc <- str_c(seq(15, 22, 1))


get_IPEDS_institutional_data <- function(year){
  
  sc_init() %>%
    sc_filter(ccbasic %in% cc) %>%
    sc_select(unitid, instnm, city, stabbr, zip, ccbasic) %>%
    sc_year(year) %>%
    sc_get() %>%
    mutate(unitid = as.character(unitid))
}


get_IPEDS_vars_for_analysis <- function(year){
  
  sc_init() %>%
    sc_filter(ccbasic %in% cc) %>%
    sc_select(unitid, sat_avg, satvr25, satvr75, satmt25, satmt75, satmtmid, 
              satwrmid, actcm25, actcm75, actcmmid, ret_ft4, pctpell, adm_rate) %>%
    sc_year(year) %>%
    sc_get() %>%
    mutate(unitid = as.character(unitid))
  
}

ipeds_data <- 
  2010:2016 %>%
  map_df(get_IPEDS_institutional_data) %>%
  left_join(
    
    2010:2016 %>%
      map_df(get_IPEDS_vars_for_analysis)
  )




ipeds_df <-
  ipeds_data %>%
  mutate(ret_ft4 = ifelse(ret_ft4 %in% c(0, 1), NA, ret_ft4)) %>%
  filter(!is.na(sat_avg) & !is.na(ret_ft4)) 




institution_level <-
  ipeds_df %>%
  group_by(ccbasic) %>%
  nest()



institutional_model <- function(df){
  
  betareg(ret_ft4 ~ sat_avg  + year,  data = df)
  
}




data_with_models <-
  institution_level %>%
  mutate(model = data %>% map(institutional_model)) 




data_with_models <-
  data_with_models %>%
  mutate(tidy = map(model, tidy),
         glance = map(model, glance),
         augment = map(model, augment),
         pseudo_r2 = glance %>% map_dbl('pseudo.r.squared'))


 