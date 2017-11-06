---
layout: coursepage
title: Lab 4
courseurl: /teaching/stats306f17/
coursename: Statistics 306, Fall 2017
parentname: Lab 4
parenturl: /teaching/stats306f17/lab4
---

# Lab 4, October 3, Solutions


-   [Exercise 1](#exercise-1)
-   [Exercise 2](#exercise-2)


## Data transformation with `dplyr`

Reference material: [Chapter 5](http://r4ds.had.co.nz/transform.html){:target="\_blank"}

## Exercise 1

Data: [`presidents.txt`](/data/presidents.txt){:target="\_blank"}.

First run the following code to create two `Date` columns for the inauguration date and last day in office.

``` r
p <-
  p %>% mutate(left_date = 
               as.Date(paste(left_year, sprintf("%02d", left_month), 
                             sprintf("%02d", left_day), sep='-'),
                       format='%Y-%m-%d'),
             inaug_date = 
               as.Date(paste(inaug_year, sprintf("%02d", inaug_month), 
                             sprintf("%02d", inaug_day), sep='-'),
                       format='%Y-%m-%d'))
```

Answer the following questions using the five `dplyr` functions discussed above.

1.  Which president had the shortest term in office? Create a new variable, `days_in_office` which contains the number of days each president was in office. Note that you can subtract `Date` objects to compute the length of time between two dates. Then use `arrange` to find the president with the shortest term.  
    
    ``` r
    p %>% mutate(days_in_office = left_date - inaug_date) %>% 
      arrange(days_in_office) %>% 
      select(lastname, firstname, days_in_office, assassinated) %>% head
    ```

        ##   lastname firstname days_in_office assassinated
        ## 1 Harrison   William        31 days        FALSE
        ## 2 Garfield     James       199 days         TRUE
        ## 3   Taylor   Zachary       492 days        FALSE
        ## 4  Harding    Warren       881 days        FALSE
        ## 5     Ford    Gerald       895 days        FALSE
        ## 6 Fillmore   Millard       969 days        FALSE


2.  Display a list of presidents who were born or died on July 4 (in any year). Only display their full names, birth dates and dates of death.  
    ``` r
    filter(p, (birth_day==4 & birth_month==7) | (death_day==4 & death_month==7)) %>%
      select(lastname, firstname, birth_month, birth_day, 
             birth_year, death_month, death_day, death_year)
    ```  
    
        ##    lastname firstname birth_month birth_day birth_year death_month death_day death_year
        ## 1     Adams      John          10        30       1735           7         4       1826
        ## 2 Jefferson    Thomas           4        13       1743           7         4       1826
        ## 3    Monroe     James           4        28       1758           7         4       1831
        ## 4  Coolidge    Calvin           7         4       1872           1         5       1933

3.  List the number of presidents in each political party, only counting presidents inaugurated after the end of the Civil War (May 9, 1865). Use `filter`, `group_by`, and `summarize`.  
    ``` r
    p %>% filter(inaug_date >= "1865-05-09") %>% 
      group_by(party) %>% 
      summarize(npres = n())
    ```
    
        ## # A tibble: 2 x 2
        ##        party npres
        ##       <fctr> <int>
        ## 1 Democratic    10
        ## 2 Republican    18


## Exercise 2

For this exercise we will use data on cyclist-involved crashes in Michigan (from [MTCF](https://www.michigantrafficcrashfacts.org/){:target="\_blank"}). Download `cyclist_crashes.txt` from our Canvas site. Load the data into a data frame called `cr`. Each row in this data frame represents a single car-cyclist crash in Michigan.

Run the following code to import the data and create a variable corresponding to the hour when each crash occurred.

``` r
# omitted, see lab exercise
```

1.  Use `select` to make `cr` contain the following variables with the following names...  
    ``` r
    cr <- select( cr, id = Crash.Instance,
             date, year, month, hour_num, day=Day.of.Week, tod = Time.of.Day,
             County, city=City.or.Township, worst.injury)
    ```

2.  How many cyclist-involved crashes were there in Washtenaw County in 2004? How many were there in Washtenaw County in August of 2015?  

    ``` r
    nrow(filter(cr, County=='Washtenaw', year==2004))
    ```
    
        ## [1] 76
    
    ``` r
    nrow(filter(cr, County=='Washtenaw', year==2015, month=='August'))
    ```
    
        ## [1] 12

3.  Use `group_by` and `summarize` to compute the number of cyclist-involved crashes in each county in each year. Store the results in a new data frame called `cr_year`, and sort this data frame by year and then by county name.  

    ``` r
    (cr_year <- 
      cr %>% group_by(County, year) %>% summarize(ncrash = n()) %>% 
      arrange(year, County))
    ```
    
        ## # A tibble: 857 x 3
        ## # Groups:   County [83]
        ##     County  year ncrash
        ##     <fctr> <int>  <int>
        ##  1 Allegan  2004     18
        ##  2  Alpena  2004     12
        ##  3  Antrim  2004      2
        ##  4  Baraga  2004      1
        ##  5   Barry  2004      9
        ##  6     Bay  2004     31
        ##  7  Benzie  2004      2
        ##  8 Berrien  2004     41
        ##  9  Branch  2004      9
        ## 10 Calhoun  2004     43
        ## # ... with 847 more rows

4.  For each year, display the three counties with the highest number of crashes.  
    What were the three counties with the highest number of cyclist-involved crashes in 2015? Are you surprised?  

    ``` r
    cr_year %>% group_by(year) %>% 
      mutate(mrank = min_rank(desc(ncrash))) %>% 
      filter(mrank<4, year==2015)
    ```  
    
        ## # A tibble: 3 x 4
        ## # Groups:   year [1]
        ##    County  year ncrash mrank
        ##    <fctr> <int>  <int> <int>
        ## 1    Kent  2015    178     3
        ## 2 Oakland  2015    180     2
        ## 3   Wayne  2015    449     1
    

5. Use `mutate` to add a column called `month_num` to `cr` that contains the numeric month. Apply the function `strftime` to the `date` variable. You will need to convert the results of `strftime` to a number using `as.numeric`.  

    ``` r
    cr <- mutate(cr, month_num = as.numeric(strftime(date, "%m")))
    ```

6. Filter `cr` to only contain crashes in Washtenaw and Wayne counties. Then compute the number of crashes in each of those two counties for each month-year combination. Plot the results as follows:

    ``` r
    cr %>% filter(County %in% c('Washtenaw','Wayne')) %>%
      group_by(County,month_num, year) %>%
      summarize(ncr = n()) %>%
      ggplot(aes(x=month_num,y=ncr,color=County))+geom_line(aes(group=interaction(year,County))) +
      scale_x_continuous(breaks=1:12, labels=month.name) +
      scale_color_brewer(palette='Set1')+
      theme(axis.text.x=element_text(hjust=1,angle=45),
            panel.background = element_rect(fill=NA,color='lightgrey')) + xlab("") + ylab("Num. Crashes")
    ```
    
    <img src="../wash-wayne-1.png" align="center">

7. For each month, what proportion of crashes occurred during each hour of the day? Use `group_by`, `mutate` and `summarize` (possibly more than once) applied to the `month_num` and `hour_num` columns. Plot the proportion of crashes versus the hour of the day with a line for each month.

    ``` r
    cr %>% 
      filter(!is.na(hour_num)) %>%
      group_by(day, hour_num) %>%
      summarise(ncr_hour = n()) %>%
      group_by(day) %>%
      mutate(cr_prop_hour = ncr_hour / sum(ncr_hour)) %>%
      ggplot(aes(x=hour_num,y=cr_prop_hour)) + 
      geom_line(aes(group=day)) + 
      facet_wrap(~day)
    ```

<img src="../unnamed-chunk-22-1.png" align="center">