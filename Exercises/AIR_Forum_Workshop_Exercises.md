Tidy up Your Data with R Workshop Exercises
================
Brian Pattiz
2019-05-28

1.  Load the Fall 2017 census and Fall 2018 census files from Github and specify that the field *CLASS\_CODE* is a character vector. Load the admissions table and specify *ACT\_MATH*, *ACT\_ENGLISH* and *ACT\_COMP* as a double. Load the majors crosswalk.

``` r
# Load Census data
fall_2017_census <- 
  read_csv('https://raw.githubusercontent.com/bpattiz/AIR-Forum-2019-Workshop/master/data/fall_2017_census.csv', col_types = cols(CLASS_CODE = col_character()))

fall_2018_census <- 
  read_csv('https://raw.githubusercontent.com/bpattiz/AIR-Forum-2019-Workshop/master/data/fall_2018_census.csv', col_types = cols(CLASS_CODE = col_character()))

admissions_table <-
  read_csv('https://raw.githubusercontent.com/bpattiz/AIR-Forum-2019-Workshop/master/data/admissions_table.csv',  col_types = cols(ACT_MATH = col_double(), ACT_ENGLISH = col_double(), ACT_COMP = col_double()))

majors <- read_csv('https://raw.githubusercontent.com/bpattiz/AIR-Forum-2019-Workshop/master/data/majors.csv')
```

2. Go to the Carnegie Classification's website <http://carnegieclassifications.iu.edu/downloads.php> and download the 2018 Update public file with `GET` from from the *httr* package. Use the function `write_disk()` and save it as a temporary file using the function`tempfile()`. Then read it using `read_excel()` from *readxl* package. Use the argument `sheet = 'Data'`.
 
3. Write a data pipeline to select the variables *ID*, *AGE*, *RACE/ETHNICITY*,*LEVEL*and *DEGREE\_SEEKING*.
 
4. Use `filter` to extract all students Age 24 or younger.
5. Using the verb `mutate`, change the variable *RACE\_ETHNICITY* to a factor variable. Add levels "Native Hawaiian or Pacific Islander" and "American Indian or Alaska Native". Save it as an object with a helpfull name or use the `%<>%` operator from the *magrittr* package.
6. Produce the counts and proportions of enrollment by Race/Ethnicity. When grouping the variable, use the argument `.drop = FALSE` and create the variable, *prop* using`prop = n/sum(n)`.
7. A CDS type question requires to produce counts by Race/Ethnicity of degree-seeking FTFY students and all degree-seeking undergraduates. Use `bind_cols()` to add the column of other degree-seeking undergraduates. Name the columns "Degree-Seeking FTFY" and "All Degree-Seeking UG" . Remember to deselect the *RACE\_ETHNICITY* column so you won't have two of them!
8. Join together the **admissions\_table** dataset to *fall\_2017\_dataframe* disregarding the *hs\_percentile* rank variable. Keep all the data from the fall 2017 census. Create a new object or use `%<>%`.
9. Take the CCIHE 2018 set and select the 2005, 2010 and 2018 Basic classifications. Select the *UNITID*, *NAME* and the *BASIC* columns. Rename the BASIC Columns to be their corresponding years. Use `gather()` to create variables *YEAR* and *CC*. Remember to the disregard *UNITID* and *NAME* in the gather function.
10. Find the Average SAT and ACT scores for Fall 2017 First-time First Year students using `map_dbl()`. Rather than trying to type out every field in select, try the `matches()` helper function.
11. Create a regular expression to find all words that start with a vowel. Test it with the character vector **words** that's included in the *stringr* package.
12. Create a stacked bar plot of degree-seeking undergraduate and graduate enrollment by College. Filter out undecided majors (UNDE). Label the plot using the full college name, either by joining together the majors dataframe or using `case_when()`. Name the y-label "Students". Use the `stat = 'identity'` argument in `geom_bar()`. Add the argument `geom_text(aes(label =  Students), size = 3, hjust = 0.5, vjust = 1.5, position = "stack")` and give it a title and add the argument `theme(plot.title = element_text(hjust = 0.5))`.
13. Take the fall 2017 census data with SAT scores. Create a varable *SAT\_TOTAL*, which is the sum of the two SAT equivalent Math and Verbal scores. Filter out the first-time first year students and create a retention indicator variable called RETAINED if the students are in the fall 2018 census file. Disregard all variables except the *ID*, *SAT\_TOTAL* and *RETAINED* variables. Fit a logistic regression model using the `glm(RETAINED ~ SAT_TOTAL, data = your_data_frame, family = 'bionomial')`. Save it to an object. Using the *broom* package and the `augment(your_fitted_glm, type.predict = 'response')`. Save it as an object and make plot of *SAT\_TOTAL* vs the fitted probabilites.
