# string concatenation 
schools <- c("University of Denver", "Colorado School of Mines", "University of Colorado - Denver")

str_c(schools, collapse = ", ")



# string length
computer_sci_majors <- 
  factor(c("BA - Applied Computing", "BS - Computer Engineering"), 
         levels = c("BA - Applied Computing", "BS - Computer Engineering", "BA - Game Development", "BS - Game Development", "BS - Computer Science"))

str_length(computer_sci_majors)



# Extracting substrings
applied_computing <- "BA - Applied Computing"

str_sub(applied_computing, 1, 2)




# String trimmming
question <- "Did you learn a great deal in the course?         "

str_trim(question)



# String sorting
questions <- c("2c", "1c", "2b", "1b", "2a", "1a")

str_sort(questions, numeric = TRUE)




# Case conversions
str_to_upper('id')




str_to_lower(c('lower', 'UPPPER'))




str_to_sentence('overall, this was an excellent course.')



str_to_title('my title')



# String splitting



# Regular expressions----------------------------------------------------------

# Demonstrate string view

majors <- 
  c("Applied Computing", "Computer Science", "Computer Engineering", 
    "Human-Computer Interaction", "Electrical Engineering")

str_view(majors, "E.")



str_view_all(majors, "Co")


# String splitting 
fsem_1111 <- 'FSEM 1111-1001 - Freshman Seminar'

split_course_data <- str_split_fixed('FSEM 1111-1001 - Freshman Seminar', '-', n = 3)




tibble(COURSE = split_course_data[,1],
       CRN = str_trim(split_course_data[,2]), 
       COURSE_TITLE = str_trim(split_course_data[,3]))



# Extract Computer Science
str_extract(majors, "c.e")



str_subset(majors, "c.e")




# Use beginning of string operator ^
str_subset(majors, "^Comp")



# Use end of string operator $
str_subset(majors, "ing$")



# Use both operators
str_subset(majors, "^Comp|ing$")



# Demonstrate quantifiers
example <- c("a", "b", "c", "ab", "abc","abbc", "abbbc", "abbbbc", "abbbbbc")


str_subset(example, "ab+c")



str_subset(example, "ab?c")



str_subset(example, "ab{2}c")




str_subset(example, "ab{2,}c")



str_subset(example, "ab{2,3}c")


# Demonstrate boundaries
cat_example <- c("cat", "concatanate", "locate", "cat in the hat", "cat!")



str_subset(cat_example, "\\bcat\\b")



str_subset(cat_example, "\\Bcat\\B")



# Character classes
enrollment <- "Biology: 235"


str_extract(enrollment, "[0-9]")



str_extract(enrollment, "[0-9]+")



str_extract(enrollment, "[:digit:]+")



str_extract(enrollment, "[:alpha:]+")
