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

    Parsed with column specification:
    cols(
      MAJOR_DESC = col_character(),
      CODE = col_character(),
      DEGREE = col_character(),
      COLL_CODE = col_character(),
      COLLEGE = col_character(),
      DEPT_CODE = col_character(),
      DEPARTMENT = col_character()
    )

2. Go to the Carnegie Classification's website <http://carnegieclassifications.iu.edu/downloads.php> and download the 2018 Update public file with `GET` from from the *httr* package. Use the function `write_disk()` and save it as a temporary file using the function`tempfile()`. Then read it using `read_excel()` from *readxl* package. Use the argument `sheet = 'Data'`.

``` r
# URL for file
url <- 'http://carnegieclassifications.iu.edu/downloads/CCIHE2018-PublicData.xlsx'

# Get the file, create a temporary file using tempfile 
GET(url, write_disk(tf <- tempfile(fileext = ".xlsx")))
```

    Response [http://carnegieclassifications.iu.edu/downloads/CCIHE2018-PublicData.xlsx]
      Date: 2019-05-28 17:04
      Status: 200
      Content-Type: application/vnd.openxmlformats
      Size: 1.89 MB
    <ON DISK>  C:\Users\BRIAN~1.PAT\AppData\Local\Temp\RtmpGsDpc3\file1c387fc14ec9.xlsx

``` r
# Read the data
ccihe_2018 <- read_excel(tf, sheet = 'Data')
```

 
3. Write a data pipeline to select the variables *ID*, *AGE*, *RACE/ETHNICITY*,*LEVEL*and *DEGREE\_SEEKING*.

``` r
fall_2017_census %>%
  select(ID:GENDER, LEVEL:DEGREE_SEEKING)
```

    # A tibble: 11,037 x 6
       ID          AGE RACE_ETHNICITY     GENDER LEVEL DEGREE_SEEKING
       <chr>     <dbl> <chr>              <chr>  <chr> <chr>         
     1 f9691a5ce    20 White              Female UG    Y             
     2 1ad1b2e26    22 White              Female UG    Y             
     3 6beace93a    21 Hispanic/Latino    Female UG    Y             
     4 35a7aa089    22 Hispanic/Latino    Male   UG    Y             
     5 95b30c72f    19 Two or more races  Male   UG    Y             
     6 c9ae01646    20 Asian              Female UG    Y             
     7 c301d9b82    21 White              Male   UG    Y             
     8 f9893dec8    22 Non-Resident Alien Female UG    Y             
     9 f9c312637    19 Asian              Female UG    Y             
    10 e02e516a1    21 Asian              Male   UG    Y             
    # ... with 11,027 more rows

 
4. Use `filter` to extract all students Age 24 or younger.

``` r
fall_2017_census %>%
  filter(AGE <= 24)
```

    # A tibble: 6,063 x 17
       TERM_CODE ID      AGE RACE_ETHNICITY GENDER CITIZENSHIP HOUSING_IND
           <dbl> <chr> <dbl> <chr>          <chr>  <chr>       <chr>      
     1    201770 f969~    20 White          Female Y           N          
     2    201770 1ad1~    22 White          Female Y           Y          
     3    201770 6bea~    21 Hispanic/Lati~ Female Y           Y          
     4    201770 35a7~    22 Hispanic/Lati~ Male   Y           N          
     5    201770 95b3~    19 Two or more r~ Male   Y           Y          
     6    201770 c9ae~    20 Asian          Female Y           Y          
     7    201770 c301~    21 White          Male   Y           N          
     8    201770 f989~    22 Non-Resident ~ Female N           N          
     9    201770 f9c3~    19 Asian          Female Y           Y          
    10    201770 e02e~    21 Asian          Male   Y           Y          
    # ... with 6,053 more rows, and 10 more variables: GREEK_IND <chr>,
    #   LEVEL <chr>, DEGREE_SEEKING <chr>, COLL_CODE <chr>, DEPT_CODE <chr>,
    #   MAJOR <chr>, DEGREE <chr>, STUDENT_TYPE <chr>, CLASS_CODE <chr>,
    #   REGISTERED_HRS <dbl>

5. Using the verb `mutate`, change the variable *RACE\_ETHNICITY* to a factor variable. Add levels "Native Hawaiian or Pacific Islander" and "American Indian or Alaska Native". Save it as an object with a helpfull name or use the `%<>%` operator from the *magrittr* package.

``` r
fall_2017_census %<>% 
  mutate(RACE_ETHNICITY = 
           factor(RACE_ETHNICITY, 
                                 levels = c(unique(fall_2017_census$RACE_ETHNICITY), "Native Hawaiian or Other Pacific Islander", "American Indian or Alaska Native"))) 
```

6. Produce the counts and proportions of enrollment by Race/Ethnicity. When grouping the variable, use the argument `.drop = FALSE` and create the variable, *prop* using`prop = n/sum(n)`.

``` r
fall_2017_census %>%
  count(RACE_ETHNICITY, .drop = FALSE) %>%
  mutate(prop = n/sum(n))
```

    # A tibble: 9 x 3
      RACE_ETHNICITY                                n   prop
      <fct>                                     <int>  <dbl>
    1 White                                      4516 0.409 
    2 Hispanic/Latino                            1105 0.100 
    3 Two or more races                           534 0.0484
    4 Asian                                      1469 0.133 
    5 Non-Resident Alien                         2003 0.181 
    6 Black or African American                   630 0.0571
    7 Race/Ethnicity Unknown                      780 0.0707
    8 Native Hawaiian or Other Pacific Islander     0 0     
    9 American Indian or Alaska Native              0 0     

7. A CDS type question requires to produce counts by Race/Ethnicity of degree-seeking FTFY students and all degree-seeking undergraduates. Use `bind_cols()` to add the column of other degree-seeking undergraduates. Name the columns "Degree-Seeking FTFY" and "All Degree-Seeking UG" . Remember to deselect the *RACE\_ETHNICITY* column so you won't have two of them!

``` r
fall_2017_census %>%
  filter(DEGREE_SEEKING == "Y" & LEVEL == "UG" & CLASS_CODE == "F") %>%
  group_by(RACE_ETHNICITY, .drop = FALSE) %>%
  summarise(`Degree Seeking FTFY` = n()) %>%
  ungroup() %>%
bind_cols(
  fall_2017_census %>%
  filter(DEGREE_SEEKING == "Y" & LEVEL == "UG") %>%
  group_by(RACE_ETHNICITY, .drop = FALSE) %>%
  summarise(`Degree Seeking All UG` = n()) %>%
  ungroup()  %>%
  select(-RACE_ETHNICITY)
)
```

    # A tibble: 9 x 3
      RACE_ETHNICITY                   `Degree Seeking FT~ `Degree Seeking All~
      <fct>                                          <int>                <int>
    1 White                                            496                 1884
    2 Hispanic/Latino                                  119                  471
    3 Two or more races                                 57                  219
    4 Asian                                            163                  589
    5 Non-Resident Alien                               238                  852
    6 Black or African American                         67                  229
    7 Race/Ethnicity Unknown                            74                  290
    8 Native Hawaiian or Other Pacifi~                   0                    0
    9 American Indian or Alaska Native                   0                    0

8. Join together the **admissions\_table** dataset to *fall\_2017\_dataframe* disregarding the *hs\_percentile* rank variable. Keep all the data from the fall 2017 census. Create a new object or use `%<>%`.

``` r
fall_2017_census %<>%  
  left_join(
    admissions_table %>%
      select(-HS_PERCENTILE_RANK)
  )
```

    Joining, by = "ID"

``` r
fall_2017_census
```

    # A tibble: 11,037 x 24
       TERM_CODE ID      AGE RACE_ETHNICITY GENDER CITIZENSHIP HOUSING_IND
           <dbl> <chr> <dbl> <fct>          <chr>  <chr>       <chr>      
     1    201770 f969~    20 White          Female Y           N          
     2    201770 1ad1~    22 White          Female Y           Y          
     3    201770 6bea~    21 Hispanic/Lati~ Female Y           Y          
     4    201770 35a7~    22 Hispanic/Lati~ Male   Y           N          
     5    201770 95b3~    19 Two or more r~ Male   Y           Y          
     6    201770 c9ae~    20 Asian          Female Y           Y          
     7    201770 c301~    21 White          Male   Y           N          
     8    201770 f989~    22 Non-Resident ~ Female N           N          
     9    201770 f9c3~    19 Asian          Female Y           Y          
    10    201770 e02e~    21 Asian          Male   Y           Y          
    # ... with 11,027 more rows, and 17 more variables: GREEK_IND <chr>,
    #   LEVEL <chr>, DEGREE_SEEKING <chr>, COLL_CODE <chr>, DEPT_CODE <chr>,
    #   MAJOR <chr>, DEGREE <chr>, STUDENT_TYPE <chr>, CLASS_CODE <chr>,
    #   REGISTERED_HRS <dbl>, SAT_MATH <dbl>, SAT_VERBAL <dbl>,
    #   SAT_EQIV_MATH <dbl>, SAT_EQUV_VERBAL <dbl>, ACT_MATH <dbl>,
    #   ACT_ENGLISH <dbl>, ACT_COMP <dbl>

9. Take the CCIHE 2018 set and select the 2005, 2010 and 2018 Basic classifications. Select the *UNITID*, *NAME* and the *BASIC* columns. Rename the BASIC Columns to be their corresponding years. Use `gather()` to create variables *YEAR* and *CC*. Remember to the disregard *UNITID* and *NAME* in the gather function.

``` r
ccihe_2018 %>%
  select(UNITID, NAME, contains('BASIC')) %>%
  gather(key = YEAR, value = CC, -UNITID, -NAME)
```

    # A tibble: 17,296 x 4
       UNITID NAME                                       YEAR         CC
        <dbl> <chr>                                      <chr>     <dbl>
     1 177834 A T Still University of Health Sciences    BASIC2005    25
     2 180203 Aaniiih Nakoda College                     BASIC2005    33
     3 222178 Abilene Christian University               BASIC2005    19
     4 138558 Abraham Baldwin Agricultural College       BASIC2005     2
     5 488031 Abraham Lincoln University                 BASIC2005    -3
     6 172866 Academy College                            BASIC2005    14
     7 451079 Academy for Five Element Acupuncture       BASIC2005    -3
     8 457271 Academy for Jewish Religion-California     BASIC2005    -3
     9 412173 Academy for Nursing and Health Occupations BASIC2005    -3
    10 108232 Academy of Art University                  BASIC2005    30
    # ... with 17,286 more rows

10. Find the Average SAT and ACT scores for Fall 2017 First-time First Year students using `map_dbl()`. Rather than trying to type out every field in select, try the `matches()` helper function.

``` r
fall_2017_census %>%
  filter(CLASS_CODE == 'F') %>% 
  select(matches('SAT|ACT')) %>%
  map_dbl(mean, na.rm  = TRUE)
```

           SAT_MATH      SAT_VERBAL   SAT_EQIV_MATH SAT_EQUV_VERBAL 
          710.18598       684.37768       710.22186       683.77979 
           ACT_MATH     ACT_ENGLISH        ACT_COMP 
           31.01546        29.44674        30.65979 

11. Create a regular expression to find all words that start with a vowel. Test it with the character vector **words** that's included in the *stringr* package.

``` r
str_subset(words, "^[aeiou]")
```

      [1] "a"           "able"        "about"       "absolute"    "accept"     
      [6] "account"     "achieve"     "across"      "act"         "active"     
     [11] "actual"      "add"         "address"     "admit"       "advertise"  
     [16] "affect"      "afford"      "after"       "afternoon"   "again"      
     [21] "against"     "age"         "agent"       "ago"         "agree"      
     [26] "air"         "all"         "allow"       "almost"      "along"      
     [31] "already"     "alright"     "also"        "although"    "always"     
     [36] "america"     "amount"      "and"         "another"     "answer"     
     [41] "any"         "apart"       "apparent"    "appear"      "apply"      
     [46] "appoint"     "approach"    "appropriate" "area"        "argue"      
     [51] "arm"         "around"      "arrange"     "art"         "as"         
     [56] "ask"         "associate"   "assume"      "at"          "attend"     
     [61] "authority"   "available"   "aware"       "away"        "awful"      
     [66] "each"        "early"       "east"        "easy"        "eat"        
     [71] "economy"     "educate"     "effect"      "egg"         "eight"      
     [76] "either"      "elect"       "electric"    "eleven"      "else"       
     [81] "employ"      "encourage"   "end"         "engine"      "english"    
     [86] "enjoy"       "enough"      "enter"       "environment" "equal"      
     [91] "especial"    "europe"      "even"        "evening"     "ever"       
     [96] "every"       "evidence"    "exact"       "example"     "except"     
    [101] "excuse"      "exercise"    "exist"       "expect"      "expense"    
    [106] "experience"  "explain"     "express"     "extra"       "eye"        
    [111] "idea"        "identify"    "if"          "imagine"     "important"  
    [116] "improve"     "in"          "include"     "income"      "increase"   
    [121] "indeed"      "individual"  "industry"    "inform"      "inside"     
    [126] "instead"     "insure"      "interest"    "into"        "introduce"  
    [131] "invest"      "involve"     "issue"       "it"          "item"       
    [136] "obvious"     "occasion"    "odd"         "of"          "off"        
    [141] "offer"       "office"      "often"       "okay"        "old"        
    [146] "on"          "once"        "one"         "only"        "open"       
    [151] "operate"     "opportunity" "oppose"      "or"          "order"      
    [156] "organize"    "original"    "other"       "otherwise"   "ought"      
    [161] "out"         "over"        "own"         "under"       "understand" 
    [166] "union"       "unit"        "unite"       "university"  "unless"     
    [171] "until"       "up"          "upon"        "use"         "usual"      

12. Create a stacked bar plot of degree-seeking undergraduate and graduate enrollment by College. Filter out undecided majors (UNDE). Label the plot using the full college name, either by joining together the majors dataframe or using `case_when()`. Name the y-label "Students". Use the `stat = 'identity'` argument in `geom_bar()`. Add the argument `geom_text(aes(label =  Students), size = 3, hjust = 0.5, vjust = 1.5, position = "stack")` and give it a title and add the argument `theme(plot.title = element_text(hjust = 0.5))`.

``` r
fall_2017_census %>%
  filter(COLL_CODE != 'UN' & DEGREE_SEEKING == 'Y') %>%
  left_join(majors %>% 
              rename(MAJOR = CODE) %>%
               select(MAJOR, COLLEGE)) %>%
  group_by(LEVEL, COLLEGE) %>% 
  summarise(Students = n()) %>%
  ggplot(. , aes(COLLEGE, Students, fill = LEVEL)) + geom_bar(stat = "identity") + geom_text(aes(label = Students), size = 3, hjust = 0.5, vjust = 1.5, position = "stack") + ggtitle('Degree-Seeking Enrollment by College') +  theme(plot.title = element_text(hjust = 0.5))
```

    Joining, by = "MAJOR"

![](AIR_Forum_Workshop_Exercises_with_Solutions_files/figure-markdown_github/unnamed-chunk-12-1.png)
13. Take the fall 2017 census data with SAT scores. Create a varable *SAT\_TOTAL*, which is the sum of the two SAT equivalent Math and Verbal scores. Filter out the first-time first year students and create a retention indicator variable called RETAINED if the students are in the fall 2018 census file. Disregard all variables except the *ID*, *SAT\_TOTAL* and *RETAINED* variables. Fit a logistic regression model using the `glm(RETAINED ~ SAT_TOTAL, data = your_data_frame, family = 'bionomial')`. Save it to an object. Using the *broom* package and the `augment(your_fitted_glm, type.predict = 'response')`. Save it as an object and make plot of *SAT\_TOTAL* vs the fitted probabilites.

``` r
library(broom)
```

    Warning: package 'broom' was built under R version 3.5.3

``` r
fall_2017_ftfy <-
  fall_2017_census %>%
   filter(CLASS_CODE == 'F') %>%
   mutate(RETAINED = ifelse(ID %in% fall_2018_census$ID, 1, 0),
         SAT_TOTAL = SAT_EQIV_MATH + SAT_EQUV_VERBAL) %>%
  select(ID, SAT_TOTAL, RETAINED)

logit_model <- glm(RETAINED ~ SAT_TOTAL, data = fall_2017_ftfy, family = 'binomial')

augmented_frame <- augment(logit_model, type.predict = 'response')

ggplot(augmented_frame,aes(SAT_TOTAL,.fitted)) + geom_point() + ylab('Probability of Retaining')
```

![](AIR_Forum_Workshop_Exercises_with_Solutions_files/figure-markdown_github/unnamed-chunk-13-1.png)
