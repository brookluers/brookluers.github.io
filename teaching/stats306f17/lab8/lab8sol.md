---
layout: coursepage
title: Lab 8
courseurl: /teaching/stats306f17/
coursename: Statistics 306, Fall 2017
parentname: Lab 8
parenturl: /teaching/stats306f17/lab8
---

# Lab 8, November 7, Solutions

## Exercise: Cyclist crashes in MI (again)

``` r
cr <- read_csv("cyclist_crashes.txt") %>% 
  rename(city = City.or.Township) # for convenience
```

Recall that this dataset contains one row for each bicycle-involved crash in Michigan between 2004 and 2015.

1.  Compute the number of crashes in each `County`-`year` combination. Store the result in a data frame called `cr_year`.  

    ``` r
    cr_year <-
      cr %>%
      group_by(County, year) %>%
      summarise(ncr = n())

    print(cr_year)
    ```

        ## # A tibble: 857 x 3
        ## # Groups:   County [?]
        ##     County  year   ncr
        ##      <chr> <int> <int>
        ##  1  Alcona  2006     1
        ##  2  Alcona  2009     1
        ##  3   Alger  2008     2
        ##  4   Alger  2009     1
        ##  5   Alger  2012     1
        ##  6 Allegan  2004    18
        ##  7 Allegan  2005     9
        ##  8 Allegan  2006    14
        ##  9 Allegan  2007    10
        ## 10 Allegan  2008    11
        ## # ... with 847 more rows

1.  The dataset `cr_year` illustrates "implicit" missing values. For example:

    ``` r
    filter(cr_year, County=="Alcona")
    ```

        ## # A tibble: 2 x 3
        ## # Groups:   County [1]
        ##   County  year   ncr
        ##    <chr> <int> <int>
        ## 1 Alcona  2006     1
        ## 2 Alcona  2009     1

    This means that between 2004 and 2015 only two crashes were recorded in Alcona county, and they occurred during 2006 and 2009.
    To fill in the missing values, use the `complete` function. First read the documentation for `complete` [here](http://tidyr.tidyverse.org/reference/complete.html){:target="_blank"}. Then use `complete` so that `cr_year` has a row for every year-county combination and `ncr` is zero when there were no crashes in the corresponding county-year period. 

    ``` r
    cr_year <-
      cr_year %>% 
      ungroup %>% 
      complete(County, year, fill=list(ncr = 0 ))

    print(cr_year)	  
    ```
    
        ## # A tibble: 996 x 3
        ##    County  year   ncr
        ##     <chr> <int> <dbl>
        ##  1 Alcona  2004     0
        ##  2 Alcona  2005     0
        ##  3 Alcona  2006     1
        ##  4 Alcona  2007     0
        ##  5 Alcona  2008     0
        ##  6 Alcona  2009     1
        ##  7 Alcona  2010     0
        ##  8 Alcona  2011     0
        ##  9 Alcona  2012     0
        ## 10 Alcona  2013     0
        ## # ... with 986 more rows

2.  As a review, use `spread` to produce the following table:  
    
    ```r 
    spread(cr_year, key=County,value=ncr)
    ```

        ## # A tibble: 12 x 84
        ##     year Alcona Alger Allegan Alpena Antrim Arenac Baraga Barry   Bay
        ##  * <int>  <dbl> <dbl>   <dbl>  <dbl>  <dbl>  <dbl>  <dbl> <dbl> <dbl>
        ##  1  2004      0     0      18     12      2      0      1     9    31
        ##  2  2005      0     0       9     12      0      1      0     5    28
        ##  3  2006      1     0      14      8      2      1      0     4    37
        ##  4  2007      0     0      10     10      4      2      1     3    28
        ##  5  2008      0     2      11      8      1      1      0     4    31
        ##  6  2009      1     1       8      3      2      0      1     5    31
        ##  7  2010      0     0      19      7      1      2      0     7    24
        ##  8  2011      0     0      16      8      1      0      1     5    28
        ##  9  2012      0     1      15      7      3      1      0     6    26
        ## 10  2013      0     0      10     10      1      2      0     4    18
        ## 11  2014      0     0      11      8      2      1      0     1    37
        ## 12  2015      0     0      12      7      2      0      0     5    21
        ## # ... with 74 more variables: Benzie <dbl>, Berrien <dbl>, Branch <dbl>,
        ##     --- additional output omitted ---


3.  How is the `city` variable formatted? Run this command:

    ``` r
    cr %>%
      select(year, Crash.Instance, city)
    ```

    Now use `separate` so that the `city` variable no longer contains the county name.

    ``` r
    cr  <-
      cr %>% separate(city, c('county2','city'), sep=': ')
    ```

    To check your answer:

    ``` r
    cr %>% select(Crash.Instance, city, County, county2)
    ```

        ## # A tibble: 23,809 x 4
        ##    Crash.Instance           city    County          county2
        ##  *          <int>          <chr>     <chr>            <chr>
        ##  1     2004374322      Roseville    Macomb    Macomb County
        ##  2     2004374216   Lasalle Twp.    Monroe    Monroe County
        ##  3     2004373946   Lincoln Twp.   Berrien   Berrien County
        ##  4     2004373597     Hazel Park   Oakland   Oakland County
        ##  5     2004371832 Hillsdale Twp. Hillsdale Hillsdale County
        ##    --- additional output omitted ---

4.  Create a data frame called `cr_year_wash` which contains the number of crashes in each city in Washtenaw county for the years 2004--2015.

    ``` r
    cr_year_wash <-
      filter(cr, County=='Washtenaw') %>% 
      group_by(city, year) %>% 
      summarise(ncr=n())

    cr_year_wash
    ```

        ## # A tibble: 153 x 3
        ## # Groups:   city [?]
        ##         city  year   ncr
        ##        <chr> <int> <int>
        ##  1 Ann Arbor  2004    45
        ##  2 Ann Arbor  2005    28
        ##  3 Ann Arbor  2006    50
        ##  4 Ann Arbor  2007    34
        ##  5 Ann Arbor  2008    58
        ##  6 Ann Arbor  2009    61
        ##  7 Ann Arbor  2010    59
        ##  8 Ann Arbor  2011    59
        ##  9 Ann Arbor  2012    64
        ## 10 Ann Arbor  2013    63
        ## # ... with 143 more rows

5.  Are there any missing values in `cr_year_wash`? Ensure that there are no explicit or implicit missing values. If there were no crashes in a given year for any of the cities in Washtenaw county, make sure that `ncr` is zero for that year. If you call `complete` you should first call `ungroup` so there is no grouping variable in `cr_year_wash`.  
    *see below*

6.  Create a plot of the number of crashes over time for the cities in Washtenaw county. Your plot should look something like this:  

    ```r
    cr_year_wash %>% ungroup %>%
      complete(city, year, fill = list(ncr = 0)) %>%
      ggplot(aes(x=year, y=ncr)) + geom_line(aes(color=city=='Ann Arbor', group=city)) +
      scale_color_discrete(breaks=c("FALSE", "TRUE"), labels=c("Other", "Ann Arbor"), name='')
    ```

    <img src="../cr-wash-cities.png" align="center">

