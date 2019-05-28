# Load libraries
library(ISLR) 
library(tidyverse)
library(magrittr)


# Load wage data
data(Wage)


# Convert Wage to a tibble
Wage %<>%  as_tibble(Wage) 



# Create boxplot of the relationship between education and wages
ggplot(Wage, aes(education, wage)) + geom_boxplot()




# Another way to look at the distribution of wages by education group
ggplot(Wage, aes(wage, fill = education, color = education)) + geom_density(alpha = 0.1)




# Look at the relatioship of age and wages by education group
ggplot(Wage, aes(wage, age, fill = education, color = education)) + geom_point() 



# Faceting example using a grid
ggplot(Wage, aes(wage, age)) + geom_point() + facet_grid(~education)




# Overlay a statistical model to denote a trend
ggplot(Wage, aes(age, wage)) + geom_point() + geom_smooth(method ="lm", formula = y ~ x)




# Publication style plot 
Wage %>% 
  ggplot(., aes(wage)) + facet_wrap(~education) + geom_histogram() + 
  ggtitle("Histograms of Wages by Education") + 
  theme(plot.title =  element_text(hjust = 0.5)) + labs(caption = "data from package ISLR")

