---
layout: coursepage
title: Lab 11
courseurl: /teaching/stats306f17/
coursename: Statistics 306, Fall 2017
parentname: Lab 11
parenturl: /teaching/stats306f17/lab11
---

# Lab 11, November 28, Solutions

The car-cyclist crash data set contains the approximate time when each crash occurred. 
``` r
cr <- read_csv('cyclist_crashes.txt')
head(cr$Time.of.Day)
```

    ## [1] "7:00 PM - 8:00 PM"   "10:00 AM - 11:00 AM" "3:00 PM - 4:00 PM"  
    ## [4] "8:00 PM - 9:00 PM"   "4:00 PM - 5:00 PM"   "4:00 AM - 5:00 AM"

In [Lab 4](http://www.brookluers.com/teaching/stats306f17/lab4/#exercise-2){:target="_blank"} we wrote a lengthy command to convert the variable `Time.of.Day` to a numeric hour in 24-hour format.

In this exercise we will use regular expressions to extract the numeric hour from `Time.of.Day` and convert it to 24-hour time.

1.  Write a function called `time24` that takes two arguments: `h12`, a vector of integers, and `pm` a logical vector. The function should convert the integers in `h12` from 12-hour time to 24-hour time. The vector `pm` indicates whether the corresponding element of `h12` is an hour that occurrs after 12 noon.  

    Before defining a function, enter these commands into the R console:  
    ``` r
    1:12 %% 12
    ```
    
        ##  [1]  1  2  3  4  5  6  7  8  9 10 11  0
    
    ``` r
    1:12 %% 12 + 12
    ```
    
        ##  [1] 13 14 15 16 17 18 19 20 21 22 23 12

    This shows that `h12 %% 12` is the desired result for all AM elements of `h12` and `h12 %% 12 + 12` is the desired result for the PM elements of `h12`.  
    This logic can be implemented using `ifelse`:  

    ``` r
    times <- c(1:12, 1:12)
    pm <- c(rep(FALSE,12), rep(TRUE,12))
    times %% 12 + ifelse(pm, 12, 0)
    ```
    
        ##  [1]  1  2  3  4  5  6  7  8  9 10 11  0 13 14 15 16 17 18 19 20 21 22 23
        ## [24] 12

    Now define a function:  

    ``` r
    time24 <- function(h12, pm){
      return(h12 %% 12 + ifelse(pm, 12, 0))
    }    
    ```

1.  What are the unique values of `cr$Time.of.Day`? Replace ocurrences of `midnight` with `AM` and replace `noon` with `PM`.  
    
    
    ``` r
    unique(cr$Time.of.Day)
    ```
    
        ##  [1] "7:00 PM - 8:00 PM"         "10:00 AM - 11:00 AM"      
        ##  [3] "3:00 PM - 4:00 PM"         "8:00 PM - 9:00 PM"        
        ##  [5] "4:00 PM - 5:00 PM"         "4:00 AM - 5:00 AM"        
        ##  [7] "11:00 AM - 12:00 noon"     "6:00 PM - 7:00 PM"        
        ##  [9] "9:00 PM - 10:00 PM"        "2:00 PM - 3:00 PM"        
        ## [11] "12:00 noon - 1:00 PM"      "5:00 PM - 6:00 PM"        
        ## [13] "Unknown"                   "1:00 PM - 2:00 PM"        
        ## [15] "3:00 AM - 4:00 AM"         "9:00 AM - 10:00 AM"       
        ## [17] "10:00 PM - 11:00 PM"       "8:00 AM - 9:00 AM"        
        ## [19] "6:00 AM - 7:00 AM"         "7:00 AM - 8:00 AM"        
        ## [21] "11:00 PM - 12:00 midnight" "12:00 midnight - 1:00 AM" 
        ## [23] "5:00 AM - 6:00 AM"         "2:00 AM - 3:00 AM"        
        ## [25] "1:00 AM - 2:00 AM"
    
    ``` r
    cr <- cr %>% 
      mutate(Time.of.Day = str_replace_all(Time.of.Day, "midnight" ,"AM"),
             Time.of.Day = str_replace_all(Time.of.Day, "noon", "PM"))
    # Check the results:
    unique(cr$Time.of.Day) 
    ```

        ##  [1] "7:00 PM - 8:00 PM"   "10:00 AM - 11:00 AM" "3:00 PM - 4:00 PM"  
        ##  [4] "8:00 PM - 9:00 PM"   "4:00 PM - 5:00 PM"   "4:00 AM - 5:00 AM"  
        ##  [7] "11:00 AM - 12:00 PM" "6:00 PM - 7:00 PM"   "9:00 PM - 10:00 PM" 
        ## [10] "2:00 PM - 3:00 PM"   "12:00 PM - 1:00 PM"  "5:00 PM - 6:00 PM"  
        ## [13] "Unknown"             "1:00 PM - 2:00 PM"   "3:00 AM - 4:00 AM"  
        ## [16] "9:00 AM - 10:00 AM"  "10:00 PM - 11:00 PM" "8:00 AM - 9:00 AM"  
        ## [19] "6:00 AM - 7:00 AM"   "7:00 AM - 8:00 AM"   "11:00 PM - 12:00 AM"
        ## [22] "12:00 AM - 1:00 AM"  "5:00 AM - 6:00 AM"   "2:00 AM - 3:00 AM"  
        ## [25] "1:00 AM - 2:00 AM"

2.  Use `tidyr::extract` to create two new columns: `tstart` and `tend`, containing the beginning and ending hour for the one-hour time window represented by `Time.of.Day`. Your regular expression should match the hour and the PM/AM indicator (e.g. `8:00 AM`). Include the argument `remove=FALSE`.  
    
    Note: if you receive an error like this:  
         "Data source must be a dictionary"  
    your data frame has two columns with the same name. You may have repeatedly applied `extract` and created duplicate columns.  
    
    
    Here is an answer:  

    ``` r
    tmatch <- "^(\\d{1,2}:00 [A-Za-z]+) - (\\d{1,2}:00 [A-Za-z]+)$"
    cr <- 
      cr %>%
      tidyr::extract(Time.of.Day,
                     c('tstart','tend'), 
                     tmatch, remove=FALSE) 
    ```
    
    The first group of the regular expression matches everything before the space-hyphen-space separating the starting and ending times.  

    Check the results:  

    ``` r
    cr %>% select(Time.of.Day, tstart, tend) %>%
      count(tstart, tend)
    ```

        ## # A tibble: 25 x 3
        ##      tstart     tend     n
        ##       <chr>    <chr> <int>
        ##  1  1:00 AM  2:00 AM   106
        ##  2  1:00 PM  2:00 PM  1473
        ##  3 10:00 AM 11:00 AM   821
        ##  4 10:00 PM 11:00 PM   600
        ##  5 11:00 AM 12:00 PM  1140
        ##  6 11:00 PM 12:00 AM   323
        ##  7 12:00 AM  1:00 AM   203
        ##  8 12:00 PM  1:00 PM  1451
        ##  9  2:00 AM  3:00 AM    91
        ## 10  2:00 PM  3:00 PM  1784
        ## # ... with 15 more rows

1.  Create another two columns, `hnum` and `ampm`, containing, respectively, the numeric hour corresponding to `tstart` and the string `AM` or `PM` as appropriate. Provide the arguments `remove=FALSE` and `convert=TRUE`.  
    ``` r
    cr <- 
      cr %>% 
      tidyr::extract(tstart, c("hnum","ampm"),
                     "(\\d{1,2}).{4}([AP]M)",
                     remove=FALSE,
                     convert=TRUE) 

    cr %>% select(tstart, tend, hnum, ampm)
    ```

        ## # A tibble: 23,809 x 4
        ##      tstart     tend  hnum  ampm
        ##  *    <chr>    <chr> <int> <chr>
        ##  1  7:00 PM  8:00 PM     7    PM
        ##  2 10:00 AM 11:00 AM    10    AM
        ##  3  3:00 PM  4:00 PM     3    PM
        ##  4  8:00 PM  9:00 PM     8    PM
        ##  5  4:00 PM  5:00 PM     4    PM
        ##  6  4:00 AM  5:00 AM     4    AM
        ##  7 11:00 AM 12:00 PM    11    AM
        ##  8 10:00 AM 11:00 AM    10    AM
        ##  9  8:00 PM  9:00 PM     8    PM
        ## 10  3:00 PM  4:00 PM     3    PM
        ## # ... with 23,799 more rows

1.  Use `mutate` to add a column called `hnum24` which contains the 24-hour time corresponding to `tstart`. (Apply your function `time24`.)  


    ``` r
    cr <- cr %>%
      mutate(hnum24 = time24(hnum, ampm=="PM"))
    cr %>% select(tstart, hnum, ampm, hnum24)
    ```

        ## # A tibble: 23,809 x 4
        ##      tstart  hnum  ampm hnum24
        ##       <chr> <int> <chr>  <dbl>
        ##  1  7:00 PM     7    PM     19
        ##  2 10:00 AM    10    AM     10
        ##  3  3:00 PM     3    PM     15
        ##  4  8:00 PM     8    PM     20
        ##  5  4:00 PM     4    PM     16
        ##  6  4:00 AM     4    AM      4
        ##  7 11:00 AM    11    AM     11
        ##  8 10:00 AM    10    AM     10
        ##  9  8:00 PM     8    PM     20
        ## 10  3:00 PM     3    PM     15
        ## # ... with 23,799 more rows
