library(lubridate)

# date stamping example
str_c('file', today(), '.txt')



# Earth day 2019
ymd('2019-04-22')



ymd('20190422')



ymd('2019/04/22')



ymd("2019 April 22")


dmy(22042019)


dmy('22/04/2019')


earth_day_in_denver <- ymd_hms('2019-04-22 12:35:14', tz = "America/Denver")



class(earth_day_in_denver)


# Extract year
year(earth_day_in_denver)



# Extract weekday
wday(earth_day_in_denver, label = TRUE, abbr = FALSE)




# Duration examples
my_age <- today() - ymd(19841011)

print(my_age)



# How many seconds in minute
dminutes(1)




# What day a year from now?
today() + dyears(1)



# Periods example
new_years_2016 <- ymd_hms("2016-01-01 12:00:00")


# Using durations, objective measurement
new_years_2016 + dyears(1)


# Using a period
new_years_2016 + years(1)


# Interval example
next_year <- today() + years(1)

class((today() %--% next_year))

(today() %--% next_year)/ ddays(1)

