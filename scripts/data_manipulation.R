# dplyr select verb------------------------------------------------------------
# Load tidyverse suite of packages
library(tidyverse)

# Select unit id, name, state, 2018 Basic Classifications and 2018 UG Profile
ccihe_2018 %>% select(UNITID, NAME, STABBR, BASIC2018, UGPROFILE2018)



# Select UNITID and ACT Category through weighted ACT 25 percentile score
ccihe_2018 %>% select(UNITID, ACTCAT:ACTFINAL)



# Select UNITID and all colummns with SAT or ACT in the name
ccihe_2018 %>% select(UNITID, matches('ACT|SAT')) 



# Select all columns that contains 2018 in the name
ccihe_2018 %>% select(UNITID, contains('2018'))



# Extract all ids and put them in a vector
ccihe_2018 %>% pull(UNITID) -> ids

ids %>% head()



# Rename STABBR to STATE and select UNITID STATE
ccihe_2018 %>% rename(STATE = STABBR) %>% select(UNITID, STATE)



# dplyr filter verb------------------------------------------------------------

# Filter data for University of Denver and University of Colorado-Boulder
ccihe_2018 %>% 
  filter(UNITID %in% c(127060, 126614))



# Find all doctoral granting institutions with a SAT MATH 75th percentile score higher than 600
ccihe_2018 %>%
  filter(BASIC2018 %in% c(15, 16, 17) & SATM25 >= 600) %>%
  select(UNITID, NAME, SATM25)



# dplyr mutate verb-------------------------------------------------------------

# Take known doctoral granting institutions that do not have undergraduate programs
non_ug_doctoral <- 
  c(112251, 448734, 137148, 444130, 450526, 114549, 413413,
    367936, 365426, 436438, 428268, 196468, 190576)


# Create Non-doctoral indicator and change UNITID to have a character data type
ccihe_2018 %>%
  mutate(NON_UG_DOCTORAL = 
           ifelse(BASIC2015 %in% c('15', '16', '17') & 
                    UNITID %in% non_ug_doctoral, 'Y', 'N'),
         UNITID = as.character(UNITID)) %>%
  select(UNITID, NON_UG_DOCTORAL)


# dplyr summarise verb---------------------------------------------------------

# Find mean and standard deviation SAT Math 25th percentile
ccihe_2018 %>% 
  summarise(n(), Mean_SATM25 = mean(SATM25, na.rm = TRUE), 
            `Std.Dev SATM25` = sd(SATM25, na.rm = TRUE))



# Find average SAT Math 25th percentile by carnegie classification
ccihe_2018 %>% 
  group_by(BASIC2018) %>% 
  count(AVG_SATM25 = mean(SATM25, na.rm = TRUE))


# dplyr arrange verb-----------------------------------------------------------

# Arrange institutions by highest SAT Math 25th percentile
ccihe_2018 %>%
  select(UNITID, NAME, SATM25) %>%
  arrange(desc(SATM25))



# dplyr verb extensions--------------------------------------------------------

# Select all numeric columns
ccihe_2018 %>%
  select_if(is.numeric)



# Normalize all columns with Test score 25th percentile columns
ccihe_2018 %>%
  filter_at(vars(matches('25$')), any_vars(. !=0)) %>%
  mutate_at(vars(matches('25$')), 
            list(~(. - mean(., na.rm = TRUE)/sd(., na.rm = TRUE)))) %>%
  select(UNITID, matches('25$'))



# Find institutions whose test score values were higher than their respective means
ccihe_2018 %>% 
  mutate(UNITID = as.character(UNITID)) %>% 
  select(UNITID, matches('SAT|ACT'), -ACTCAT) %>% 
  filter_all(any_vars(. > mean(., na.rm = TRUE))) 

# dplyr combining data---------------------------------------------------------

# Average SAT Math 25th percentile by Carnegie Classification with Overall Average
ccihe_2018 %>%
  filter(SATV25 != 0) %>%
  mutate_at(vars(BASIC2018), funs(as.character(.))) %>%
  group_by(BASIC2018) %>%
  summarise(AVG_SATM25 = mean(SATM25, na.rm = TRUE)) %>%
  ungroup() %>%
  bind_rows(
    ccihe_2018 %>%
      filter(SATV25 != 0) %>%
      mutate_at(vars(BASIC2018), funs(as.character(.))) %>%
    summarise(BASIC2018 = 'All', AVG_SATM25 = mean(SATM25))
) -> avg_sat_math25
    
 

# dplyr joins------------------------------------------------------------------

# Average share of Pell Students by 2015 Carnegie Classification

# Load rscorecard library
library(rscorecard)

sc_key('JGMPtk0k1qLv7x0nLyRdyi83CcCsYpbaJoON0iab')

sc_init() %>%
  sc_year(2015) %>%
  sc_select(unitid, pctpell) %>%
  sc_get() %>%
  rename(UNITID = unitid) -> scorecard_data


ccihe_2018 %>% 
  left_join(scorecard_data) %>%
  select(UNITID, BASIC2015, pctpell) %>%
  group_by(BASIC2015) %>%
  summarise(AVG_PELL_SHARE = mean(pctpell, na.rm = TRUE)) %>%
  arrange(desc(AVG_PELL_SHARE))



# tidyr------------------------------------------------------------------------
# Load ISLR library that contains Higher Ed enrollment funnel data
# Load vctrs package for new pivot_longer functions
library(ISLR)
library(tidyr)
library(vctrs)
# Load new pivot_longer function


# Load Higher Ed applications data
data(College)

# Put the data into one variable called Cycle & Count using gather
College %>%
  rownames_to_column("Institution") %>%
  as_tibble() %>%
  select(Institution, Apps, Accept, Enroll) %>%
  gather(-Institution, key = 'Cycle', value = 'Count')

# Put the data into one variable called Cycle & Count using pivot_longer
College %>%
  rownames_to_column("Institution") %>%
  as_tibble() %>%
  select(Institution, Apps, Accept, Enroll) %>%
  pivot_longer(-Institution, names_to = "Cycle", values_to = "Count")



# Get Average ACT and SAT 25th percentile by 2018 Carnegie Classification
ccihe_2018_sat_by_class <-
  ccihe_2018 %>% 
  filter_at(vars(matches('25$')), any_vars(. !=0)) %>%
  group_by(BASIC2018) %>% 
  summarise(AVG_SATM25 = mean(SATM25, na.rm = TRUE), AVG_SATV25 = mean(SATV25, na.rm = TRUE)) %>%
  gather(-BASIC2018, key = 'Test_Section', value = 'Score')
               
# Using spread
ccihe_2018_sat_by_class %>%
  spread(key = Test_Section, value = Score)

# Using pivot longer
ccihe_2018_sat_by_class %>%
  pivot_wider(names_from =  Test_Section , values_from =  Score)

