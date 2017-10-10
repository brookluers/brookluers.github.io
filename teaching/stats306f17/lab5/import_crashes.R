cr <- read.csv('cyclist_crashes.txt', header=T)
timelevels <- c("2:00 PM - 3:00 PM" = 14, 
                "      2:00 PM - 3:00 PM" = 14,
                "12:00 midnight - 1:00 AM" = 00,
                "1:00 AM - 2:00 AM" = 01,
                "2:00 AM - 3:00 AM" = 02,
                "3:00 AM - 4:00 AM" = 03,
                "4:00 AM - 5:00 AM" = 04,
                "5:00 AM - 6:00 AM" = 05,
                "6:00 AM - 7:00 AM" = 06,
                "7:00 AM - 8:00 AM" = 07,
                "8:00 AM - 9:00 AM" = 08,
                "9:00 AM - 10:00 AM" = 09,
                "12:00 noon - 1:00 PM" = 12,
                "1:00 PM - 2:00 PM" = 13,
                "10:00 AM - 11:00 AM" =10,
                "10:00 PM - 11:00 PM"    = 22 ,
                "11:00 AM - 12:00 noon" = 11,
                "3:00 PM - 4:00 PM" = 15,
                "4:00 PM - 5:00 PM" = 16,
                "5:00 PM - 6:00 PM" = 17,
                "6:00 PM - 7:00 PM" = 18,
                "7:00 PM - 8:00 PM" = 19,
                "8:00 PM - 9:00 PM" = 20,
                "9:00 PM - 10:00 PM" = 21,
                "11:00 PM - 12:00 midnight" = 23,
                "Unknown" = NA
)
cr <- mutate(cr, 
             hour_num = timelevels[paste(Time.of.Day)]) %>%
  select(id = Crash.Instance,
         date, year, month, hour_num, day=Day.of.Week, tod = Time.of.Day,
         County, city=City.or.Township, worst.injury)
# Create a variable for the month number
cr <- mutate(cr, month_num = as.numeric(strftime(date, "%m")))
cr$month <- factor(cr$month_num,
                   levels=1:12,
                   labels=month.name)

cr_year <- 
  cr %>% group_by(County, year) %>% 
  summarize(ncrash = n()) %>% 
  arrange(year, County)

daysofweek <- c('Saturday','Sunday','Monday','Tuesday','Wednesday','Thursday','Friday')

# reorder the levels of cr$day
cr$day <-
  factor(cr$day, levels=daysofweek) 
cr$daynum <- as.numeric(strftime(cr$date, "%u"))