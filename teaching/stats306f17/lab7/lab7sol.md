---
layout: coursepage
title: Lab 7
courseurl: /teaching/stats306f17/
coursename: Statistics 306, Fall 2017
parentname: Lab 7
parenturl: /teaching/stats306f17/lab7
---

# Lab 7, October 31, Solutions

## Exercise: University of Michigan Enrollment

Using data from the [Registrar](http://ro.umich.edu/enrollment/ethnicity.php){:target="_blank"}, I created two files containing University of Michigan enrollment counts by race/ethnicity and sex. Download these files from our [Canvas page](https://umich.instructure.com/courses/181629/files){:target="_blank"}.

The first file has enrollment counts for the years 2006--2015 and the second has the counts for 1995--2005. First import the files:

``` r
d15 <- read_csv('umich_enrollment15.csv')
d05 <- read_csv('umich_enrollment05.csv')
```

### Part 1

1.  Familiarize yourself with how these data are formatted. Are the datasets "tidy"?  
    *No, these data are not tidy. The column names represent race/ethnicity categories.*

2.  The older data (`d05`) has fewer race/ethnicity categories. Use `mutate` to redefine the `Unknown` column in `d15` so that it combines the "Two or More", "Hawaiian" and "Unknown" categories. Remove the columns for "Two or More" and "Hawaiian".  
    ```r
    d15 <-
      mutate(d15, Unknown = Hawaiian + `Two or More` + Unknown) %>%
      select(-`Two or More`, -Hawaiian)
    ```

3.  The two data frames `d05` and `d15` should now have the same variables (columns). Run this command to "stack" the two datasets on top of each other:

    ``` r
    d <- bind_rows(d15, d05)
    ```

1.  Create a data frame called `d_ut` with the undergraduate enrollment counts for men and women combined (filter the `Level` and `Sex` columns).  
    
    ```r
    d_ut <- filter(d, Level=="Undergraduate", Sex=='Total') 
    ```

2.  Compute the proportion of undergraduates in each race/ethnicity category. We can do this using `mutate_at`, which applies the same transformation to multiple columns. Run this command to complete this step:

    ``` r
    d_ut <-
      mutate_at(d_ut, vars(-Level, -Sex, -Year, -All), funs(. / All))
    ```

    This command selects all columns except `Level`, `Sex`, `Year` and `All`, and then divides each column by the value in `All`.
    You should now have a dataset like this:

    ``` r
    head(d_ut)
    ```

        ## # A tibble: 6 x 10
        ##           Level   Sex  Year   All     Asian      Black   Hispanic
        ##           <chr> <chr> <int> <int>     <dbl>      <dbl>      <dbl>
        ## 1 Undergraduate Total  2015 26353 0.1364171 0.04614275 0.04933025
        ## 2 Undergraduate Total  2014 26442 0.1350125 0.04409651 0.04572271
        ## 3 Undergraduate Total  2013 26329 0.1311482 0.04656462 0.04420981
        ## 4 Undergraduate Total  2012 26175 0.1290926 0.04691500 0.04305635
        ## 5 Undergraduate Total  2011 25752 0.1257766 0.04706431 0.04360826
        ## 6 Undergraduate Total  2010 25383 0.1231139 0.04782729 0.04597565
        ## # ... with 3 more variables: `Native American` <dbl>, White <dbl>,
        ## #   Unknown <dbl>


3.  Use `gather` so that `d_ut` has a column called `reth`, containing the race/ethnicity category, and a column called `pct`, containing the percent enrollment in that category. Then create the following plot.  
    
    ```r
    d_ut <-
      gather(d_ut, Asian, Black,Hispanic,`Native American`, White, Unknown,
           key=reth, value=pct)

    ggplot(d_ut, aes(x=Year,y=pct,color=reth))+geom_line() + ggtitle("Undergraduate enrollment")
    ```

    <img src="../unnamed-chunk-14-1.png" align="center">

### Part 2

1.  Now let's focus on total enrollment by gender. Filter the `Level` variable to create a data frame called `d_t` containing just the total counts (remove the rows with undergraduate enrollment counts). Use `select` so that `d_t` only has three columns: `Sex`, `Year`, and `All` (the enrollment count across all race/ethnicity categories).  
    
    ```r
    d_t <- filter(d, Level=='Total') %>% select(Sex, Year, All, -Level)
    ```

2.  Compute the percent enrollment for each gender in each year. First use `spread` so we have separate columns for the male and female enrollment counts:  

    ```r
    d_t %>% spread(key=Sex, value=All)
    ```

        ## # A tibble: 21 x 4
        ##     Year Females Males Total
        ##  * <int>   <int> <int> <int>
        ##  1  1995   15854 16836 32690
        ##  2  1996   15824 16537 32361
        ##  3  1997   16065 16689 32754
        ##  4  1998   16093 16549 32642
        ##  5  1999   16286 16654 32940
        ##  6  2000   16334 16504 32838
        ##  7  2001   16627 16578 33205
        ##  8  2002   16849 16591 33440
        ##  9  2003   16995 16521 33516
        ## 10  2004   17126 16809 33935
        ## # ... with 11 more rows

    Then `mutate` the `Females` and `Males` columns so they contain proportions instead of counts.
        *see below*

3.  Now `gather` the result so there is a `Sex` column and a `pct` column.
    
    ```r
    d_t %>% 
      spread(key=Sex,value=All) %>%
      mutate_at(vars(-Year,-Total), funs(. / Total)) %>%
      gather(Females, Males, key=Sex, value=pct) 
    ```

        ## # A tibble: 42 x 4
        ##     Year Total     Sex       pct
        ##    <int> <int>   <chr>     <dbl>
        ##  1  1995 32690 Females 0.4849801
        ##  2  1996 32361 Females 0.4889837
        ##  3  1997 32754 Females 0.4904744
        ##  4  1998 32642 Females 0.4930151
        ##  5  1999 32940 Females 0.4944141
        ##  6  2000 32838 Females 0.4974115
        ##  7  2001 33205 Females 0.5007378
        ##  8  2002 33440 Females 0.5038577
        ##  9  2003 33516 Females 0.5070712
        ## 10  2004 33935 Females 0.5046707
        ## # ... with 32 more rows

4.  Finally, create this plot of the proportion of men and women at Michigan over time:  
    
     ```r
    d_t %>% 
          spread(key=Sex,value=All) %>%
          mutate_at(vars(-Year,-Total), funs(. / Total)) %>%
          gather(Females, Males, key=Sex, value=pct)  %>% 
          ggplot(aes(x=Year,y=pct,color=Sex)) + geom_line() + ggtitle("Total enrollment")
    ```
    
    <img src="../unnamed-chunk-18-1.png" align="center">