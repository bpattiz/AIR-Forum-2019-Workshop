# tibble data frames-----------------------------------------------------------

# Load tidvyerse package suite
library(tidyverse)

# Create a tibble
tibble(x = 1:3, y = 15:17, z = x*y, 
       listcol = list(1:5, seq(5, 10, 1), rep(1, 3)))


# Create a tibble with vector recycling
tibble(x = 1:3, y = 15:17, z = x*y,
       listcol = list(1:5, seq(5, 10, 1), rep(1, 3)),
       one_col = 1)

# Show off tibble's printing of a large dataframe
df <- tibble(x = 1:1000, y = 2, z = x*y)
print(df)

# Class of the tibble
class(df)

# Subsetting tibbles
df[1:3,]; class(df[1:3,])

# tibble's column naming conventions 
tibble(`0 1 Normal distribution` = rnorm(5), 
       `:)` = rep('Smile',5))

# readr------------------------------------------------------------------------

# Load Delta Cost Project
delta_cost_project_00_15 <- 
  read_tsv("data/delta_public_release_00_15.csv")

# Specify column types
delta_cost_project_00_15 <- 
  read_tsv("data/delta_public_release_00_15.csv",
           col_types = cols(carnegie_sector_2010 = col_character()))

# readxl-----------------------------------------------------------------------

# Load readxl library
library(readxl)

# Load CCIHE Public Data 2015
ccihe_2018 <- read_excel("data/CCIHE2018-PublicData.xlsx", sheet = 'Data')


## httr------------------------------------------------------------------------

# Load httr library
library(httr)

# URL string to access data from API
url_str <-  paste0("https://ed-data-portal.urban.org/api/v1/college-university/",
         "ipeds/admissions-enrollment/2016/?year=2016&unitid=127060")

# Get response from API
resp <- GET(url_str)

# Print response
print(resp)

# Get headers
headers(resp)

# Get the results from the response
content(resp)$results

# Use httr to download and load a file

# URL for BLS Educational attainment for workers 25 years and older by detailed occupation
bls_data_str <- "https://www.bls.gov/emp/ind-occ-matrix/education.xlsx"

# Get the file, create a temporary file using tempfile 
GET(bls_data_str, write_disk(tf <- tempfile(fileext = ".xlsx")))

# Read the data
bls_occupation_by_education <- read_excel(tf, sheet = 'Attainment', skip = 1)


# Parsing json with jsonlite---------------------------------------------------

# Load jsonlite to parse JSON
library(jsonlite)

# Create tibble from parsed JSON 
du_admissions <- as_tibble(fromJSON(content(resp, "text"))$results)


# Parsing xml with xml2--------------------------------------------------------

# Load xml2 library
library(xml2)

# Parse National Endowment for the Humanities Grants data
neh_grants <- read_xml("data/NEH_Grants2010s.xml") 

# Extract unique institutions awarded a grant
institutions <- 
  unique(xml_text(xml_find_all(neh_grants, "//Institution")))


# Scraping data with rvest-----------------------------------------------------

# Load rvest 
library(rvest)

# URL to Wikpedia page
url_str <- 
  "https://en.wikipedia.org/wiki/List_of_university_and_college_name_changes_in_the_United_States"

# Read html from URL 
webpage <- read_html(url_str)

# Extract table nodes
table_node <- 
  html_node(webpage, 
            'body #content #bodyContent #mw-content-text .mw-parser-output table')

# Create dataframe for table
tibble(html_table(table_node, fill = TRUE))


