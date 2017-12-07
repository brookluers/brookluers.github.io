---
layout: coursepage
title: Lab 12
courseurl: /teaching/stats306f17/
coursename: Statistics 306, Fall 2017
parentname: Lab 12
parenturl: /teaching/stats306f17/lab12
---

# Lab 12, December 5, Solutions

### Exercise Part 1

This exercise demonstrates how to import many data files into a single data frame and reviews many of the concepts we have covered this semetser.

Start by downloading `acs-income.zip` from our [Canvas site](https://umich.instructure.com/courses/181629/files){:target="_blank"}. Uncompress this file in your working directory.
The data, from the American Communtiy Survey, describe the household income distribution of each county in the six New England states. There are five pairs of files, one for each of the years 2011, 2012, 2013, 2014, and 2015. The `_metadata.csv` files contain column names and descriptions for each column in the corresponding data files.

1.  Start by creating a character vector containing the names of each metadata file. Complete this command by specifying a regular expression to match the files ending with `_metadata.csv`. If your uncompressed files are located in a folder called `acs-income`, your command will look like this:

    ``` r
    fnames <- dir(path="acs-income/",
                  pattern="_metadata")
    ```

    If the 10 `csv` files are in your working directory, then you can omit the `path=` argument.

    ``` r
    fnames
    ```

        ## [1] "ACS_11_5YR_S1901_metadata.csv" "ACS_12_5YR_S1901_metadata.csv"
        ## [3] "ACS_13_5YR_S1901_metadata.csv" "ACS_14_5YR_S1901_metadata.csv"
        ## [5] "ACS_15_5YR_S1901_metadata.csv"

2.  Extract the two-digit year from each file name in `fnames`, then convert the two-digit years to four-digit years. Complete the following commands.

    First extract the two-digit year:

    ``` r
    fyears <- str_extract(fnames, "\\d\\d")
    ```

    ``` r
    fyears
    ```

        ## [1] "11" "12" "13" "14" "15"

    Then prepend `20` to convert the two-digit years to four-digit years.

    ``` r
    fyears <- str_c("20", fyears)
    ```

    ``` r
    fyears
    ```

        ## [1] "2011" "2012" "2013" "2014" "2015"

3.  Run these commands to create a placeholder list where we will store the metadata for each year:

    ``` r
    metadata <- vector("list", length(fyears))
    names(metadata) <- fyears
    metadata
    ```

        ## $`2011`
        ## NULL
        ## 
        ## $`2012`
        ## NULL
        ## 
        ## $`2013`
        ## NULL
        ## 
        ## $`2014`
        ## NULL
        ## 
        ## $`2015`
        ## NULL

4.  Write the command to display the second element of the vector `fnames`.  
    Reference: list subsetting, [section 20.5.2](http://r4ds.had.co.nz/vectors.html#subsetting-1)

    ``` r
    fnames[[2]]
    ```

        ## [1] "ACS_12_5YR_S1901_metadata.csv"


5.  Complete the body of the following for loop.
    Each iteration of the loop imports the metadata file corresponding to the `i`th element of `fnames` and stores the result as the `i`th element of `metadata`.
    In each iteration, provide an argument to `read_csv` so the columns of the imported data frame are named `varname` and `vardesc`.  
    If the csv files are in your working directory (not a subdirectory called `acs-income`), the first argument of `read_csv` will just be `fnames[i]`.  

    ``` r
    for (i in seq_along(fnames)) {
      metadata[[i]] <- read_csv(str_c("acs-income/", fnames[i]), 
                                col_names = c('varname','vardesc'))
    }
    ```

    To check your answer, print the element of the list `metadata` named `"2014"`:  
    
    ``` r
    metadata[['2014']]
    ```

        ## # A tibble: 131 x 2
        ##              varname                                         vardesc
        ##                <chr>                                           <chr>
        ##  1            GEO.id                                              Id
        ##  2           GEO.id2                                             Id2
        ##  3 GEO.display-label                                       Geography
        ##  4     HC01_EST_VC01                     Households; Estimate; Total
        ##  5     HC01_MOE_VC01              Households; Margin of Error; Total
        ##  6     HC02_EST_VC01                       Families; Estimate; Total
        ##  7     HC02_MOE_VC01                Families; Margin of Error; Total
        ##  8     HC03_EST_VC01        Married-couple families; Estimate; Total
        ##  9     HC03_MOE_VC01 Married-couple families; Margin of Error; Total
        ## 10     HC04_EST_VC01           Nonfamily households; Estimate; Total
        ## # ... with 121 more rows


7.  Now we can combine this list of data frames into a single data frame with `bind_rows`. This function takes a list of data frames and "stacks" them vertically. The `.id` argument will create a column called `year` to identify the source data frame for each row.

    ``` r
    metadata <- bind_rows(metadata, .id='year')
    head(metadata)
    ```

        ## # A tibble: 6 x 3
        ##    year           varname                            vardesc
        ##   <chr>             <chr>                              <chr>
        ## 1  2011            GEO.id                                 Id
        ## 2  2011           GEO.id2                                Id2
        ## 3  2011 GEO.display-label                          Geography
        ## 4  2011     HC01_EST_VC01        Households; Estimate; Total
        ## 5  2011     HC01_MOE_VC01 Households; Margin of Error; Total
        ## 6  2011     HC02_EST_VC01          Families; Estimate; Total

8.  Import the five data files into a data frame called `incomedata`, using the previous few steps as a guide. Start by creating another vector of file names, `fnames2`. Use the `dir` function and a regular expression to match the data file names, which all end with `S1901.csv`.  
    
    ```r 
    fnames2 <- dir("acs-income",
		    pattern="_S1901.csv")
    fnames2 # the data file names
    ```

        ## [1] "ACS_11_5YR_S1901.csv" "ACS_12_5YR_S1901.csv" "ACS_13_5YR_S1901.csv"
        ## [4] "ACS_14_5YR_S1901.csv" "ACS_15_5YR_S1901.csv"

    Now write a for loop to import the five data files. Do not specify column names when importing these files; we will use the variable descriptions in `metadata` to understand what each column represents.  
    
     ``` r
    incomedata <- vector("list", length(fnames2))
    names(incomedata) <- str_c("20", str_extract(fnames2, "\\d\\d"))
    for (i in seq_along(fnames2)) {
      incomedata[[i]] <- read_csv(str_c("acs-income/", fnames2[i]))
    }
    incomedata <- bind_rows(incomedata, .id='year')
    dim(incomedata)
    ```

        ## [1] 335 132

    ``` r
    count(incomedata, year)
    ```

        ## # A tibble: 5 x 2
        ##    year     n
        ##   <chr> <int>
        ## 1  2011    67
        ## 2  2012    67
        ## 3  2013    67
        ## 4  2014    67
        ## 5  2015    67

9.  Print the unique values of `metadata$vardesc` containing the string `Households; Estimate;`. You should see 16 variable descriptions, most of which correspond to income categories (e.g. households earning between 10,000 and 14,999 dollars per year).
    We will focus on just two of these variables: the proportion of households earning more than $200,000 per year and the median household income.  

     ``` r
    filter(metadata, str_detect(vardesc, "Households; Estimate;")) %>% 
    	.$vardesc %>% unique
    ```

        ##  [1] "Households; Estimate; Total"                                                   
        ##  [2] "Households; Estimate; Less than $10,000"                                       
        ##  [3] "Households; Estimate; $10,000 to $14,999"                                      
        ##  [4] "Households; Estimate; $15,000 to $24,999"                                      
        ##  [5] "Households; Estimate; $25,000 to $34,999"                                      
        ##  [6] "Households; Estimate; $35,000 to $49,999"                                      
        ##  [7] "Households; Estimate; $50,000 to $74,999"                                      
        ##  [8] "Households; Estimate; $75,000 to $99,999"                                      
        ##  [9] "Households; Estimate; $100,000 to $149,999"                                    
        ## [10] "Households; Estimate; $150,000 to $199,999"                                    
        ## [11] "Households; Estimate; $200,000 or more"                                        
        ## [12] "Households; Estimate; Median income (dollars)"                                 
        ## [13] "Households; Estimate; Mean income (dollars)"                                   
        ## [14] "Households; Estimate; PERCENT IMPUTED - Household income in the past 12 months"
        ## [15] "Households; Estimate; PERCENT IMPUTED - Family income in the past 12 months"   
        ## [16] "Households; Estimate; PERCENT IMPUTED - Nonfamily income in the past 12 months"


10. Complete this command to produce the output that follows.

    ``` r
    # completed command:
    filter(metadata, str_detect(vardesc, "Households; Estimate; \\$200")) 
    ```

        ## # A tibble: 5 x 3
        ##    year       varname                                vardesc
        ##   <chr>         <chr>                                  <chr>
        ## 1  2011 HC01_EST_VC11 Households; Estimate; $200,000 or more
        ## 2  2012 HC01_EST_VC11 Households; Estimate; $200,000 or more
        ## 3  2013 HC01_EST_VC11 Households; Estimate; $200,000 or more
        ## 4  2014 HC01_EST_VC11 Households; Estimate; $200,000 or more
        ## 5  2015 HC01_EST_VC11 Households; Estimate; $200,000 or more

    We see that every year has the same variable name for the proportion of households earning more than $200,000 (this might not always be the case with Census data).
    Store the variable name (`HC01...`) in an object called `var_maxinc`.  

    ``` r
    var_maxinc <-
      filter(metadata, str_detect(vardesc, "Households; Estimate; \\$200")) %>%
      .$varname %>% unique
    ```

11. Complete the following command to check the variable name for median household income.

    ``` r
    filter(metadata, str_detect(vardesc, "Households; Estimate; Median"))
    ```

        ## # A tibble: 5 x 3
        ##    year       varname                                       vardesc
        ##   <chr>         <chr>                                         <chr>
        ## 1  2011 HC01_EST_VC13 Households; Estimate; Median income (dollars)
        ## 2  2012 HC01_EST_VC13 Households; Estimate; Median income (dollars)
        ## 3  2013 HC01_EST_VC13 Households; Estimate; Median income (dollars)
        ## 4  2014 HC01_EST_VC13 Households; Estimate; Median income (dollars)
        ## 5  2015 HC01_EST_VC13 Households; Estimate; Median income (dollars)

    Again, all five years use the same variable name for median household income. Store this variable name in an object called `var_median`.  
    ``` r
    var_median <- 
      filter(metadata, str_detect(vardesc, "Households; Estimate; Median")) %>%
      .$varname %>% unique
    ```

12. From `incomedata`, select the columns `year`, `Geo.display-label`, and the two columns representing the median household income and the proportion of households making more than $200,000. Rename the columns as indicated below.
    Make sure your `year` variable is either an `integer` or `double`. Store this data frame in an object called `incomedata_small`.  


    ``` r
    (incomedata_small <- select(incomedata, "year", 'county'="GEO.display-label", 
           'median'=var_median, 'gt200k' = var_maxinc) %>%
      mutate(year=as.integer(year)) ) 
    ```

        ## # A tibble: 335 x 4
        ##     year                         county median gt200k
        ##    <int>                          <chr>  <int>  <dbl>
        ##  1  2011  Fairfield County, Connecticut  82558   16.7
        ##  2  2011   Hartford County, Connecticut  64007    6.5
        ##  3  2011 Litchfield County, Connecticut  71497    6.6
        ##  4  2011  Middlesex County, Connecticut  77095    7.8
        ##  5  2011  New Haven County, Connecticut  62497    5.9
        ##  6  2011 New London County, Connecticut  67010    5.2
        ##  7  2011    Tolland County, Connecticut  80333    5.6
        ##  8  2011    Windham County, Connecticut  60063    2.6
        ##  9  2011     Androscoggin County, Maine  45699    1.4
        ## 10  2011        Aroostook County, Maine  37138    1.1
        ## # ... with 325 more rows


13. Use `separate` to add a `state` column to `incomedata_small`:

    ``` r
    (incomedata_small <-
      separate(incomedata_small, county,
                      c('county', 'state'),
                      sep="County, "))
    ```

        ## # A tibble: 335 x 5
        ##     year        county       state median gt200k
        ##  * <int>         <chr>       <chr>  <int>  <dbl>
        ##  1  2011    Fairfield  Connecticut  82558   16.7
        ##  2  2011     Hartford  Connecticut  64007    6.5
        ##  3  2011   Litchfield  Connecticut  71497    6.6
        ##  4  2011    Middlesex  Connecticut  77095    7.8
        ##  5  2011    New Haven  Connecticut  62497    5.9
        ##  6  2011   New London  Connecticut  67010    5.2
        ##  7  2011      Tolland  Connecticut  80333    5.6
        ##  8  2011      Windham  Connecticut  60063    2.6
        ##  9  2011 Androscoggin        Maine  45699    1.4
        ## 10  2011    Aroostook        Maine  37138    1.1
        ## # ... with 325 more rows

14. Write a command to check if there are any county names that are duplicated across states. Start by filtering `incomedata_small` to a single year. Then use one or more `dplyr` functions to find county names that are repeated across multiple states.  

    ``` r
    incomedata_small %>% filter(year==2011) %>% count(county) %>%
      filter(n>1)
    ```

            ## # A tibble: 6 x 2
            ##        county     n
            ##         <chr> <int>
            ## 1    Bristol      2
            ## 2      Essex      2
            ## 3   Franklin      3
            ## 4  Middlesex      2
            ## 5 Washington      3
            ## 6    Windham      2


15. Create a data frame called `top2counties` that contains, for each state, the two counties with the highest proportion of households earning more than $200,000 in 2015:  

    ``` r
    top2counties <- 
      incomedata_small %>%filter(year==2015)%>% group_by(state)%>% top_n(2, gt200k)
    top2counties
    ```

        ## # A tibble: 12 x 5
        ## # Groups:   state [6]
        ##     year        county         state median gt200k
        ##    <int>         <chr>         <chr>  <int>  <dbl>
        ##  1  2015    Fairfield    Connecticut  84233   18.1
        ##  2  2015    Middlesex    Connecticut  79893    9.6
        ##  3  2015   Cumberland          Maine  60051    5.7
        ##  4  2015         York          Maine  57919    3.9
        ##  5  2015    Middlesex  Massachusetts  85118   13.4
        ##  6  2015      Norfolk  Massachusetts  88262   14.4
        ##  7  2015 Hillsborough  New Hampshire  71244    7.0
        ##  8  2015   Rockingham  New Hampshire  81198    8.8
        ##  9  2015      Bristol   Rhode Island  72458    9.6
        ## 10  2015      Newport   Rhode Island  69526    7.8
        ## 11  2015   Chittenden        Vermont  65350    5.7
        ## 12  2015   Grand Isle        Vermont  62608    5.6

16. Complete the following command to produce the plot below.  

    ``` r
    incomedata_small %>% 
    ggplot(aes(x=year, y=gt200k))+
    geom_line(aes(group=interaction(county,state)))+
    geom_text(aes(label=county),size=2,
              hjust=1,vjust=0,
              data=top2counties)+ 
    facet_wrap(~state)+ 
    xlab('year') +
    ylab("Proportion") + 
    ggtitle("New England counties:\nproportion of households earning more than $200k per year")
    ```

    <img src="../p_inc200k.png" align="center" style="max-width: 66%">
    
17. Produce a similar plot using the median household income in each county. First create a data frame `top2counties_med` with the two counties in each state with the highest median income in 2015:   

    ``` r
    top2counties_med <- 
      incomedata_small %>%filter(year==2015)%>% group_by(state)%>% top_n(2, median)
    top2counties_med
    ```

        ## # A tibble: 12 x 5
        ## # Groups:   state [6]
        ##     year        county         state median gt200k
        ##    <int>         <chr>         <chr>  <int>  <dbl>
        ##  1  2015    Fairfield    Connecticut  84233   18.1
        ##  2  2015    Middlesex    Connecticut  79893    9.6
        ##  3  2015   Cumberland          Maine  60051    5.7
        ##  4  2015         York          Maine  57919    3.9
        ##  5  2015    Middlesex  Massachusetts  85118   13.4
        ##  6  2015      Norfolk  Massachusetts  88262   14.4
        ##  7  2015 Hillsborough  New Hampshire  71244    7.0
        ##  8  2015   Rockingham  New Hampshire  81198    8.8
        ##  9  2015      Bristol   Rhode Island  72458    9.6
        ## 10  2015   Washington   Rhode Island  72807    7.5
        ## 11  2015   Chittenden        Vermont  65350    5.7
        ## 12  2015   Grand Isle        Vermont  62608    5.6

    Then reproduce the following plot:
    ``` r
    incomedata_small %>% 
    ggplot(aes(x=year, y=median))+
    geom_line(aes(group=county))+
    geom_text(aes(label=county),size=2,
              hjust=1,vjust=0,
              data=top2counties_med)+ 
    facet_wrap(~state)+ 
    xlab('year') +
    ylab("Household income (dollars)") + 
    ggtitle("New England counties:\nmedian household income")
     ```

    <img src="../p_med.png" align="center" style="max-width: 66%">

### Exercise part 2 (extra review)

Here are some more exercises using the same data from above. You need to complete steps 1 through 8 from part 1 before attempting part 2.

1.  Reproduce the following sequence using `str_pad`:  

    ``` r
    str_pad(2:11, 2, "left", pad='0')
    ```

        ##  [1] "02" "03" "04" "05" "06" "07" "08" "09" "10" "11"

    Combine your previous command with `str_c` to produce the vector `incvars_dist`:  

     ``` r
    incvars_dist <- str_c("HC01_EST_VC", str_pad(2:11, 2, "left", pad="0"))
    incvars_dist
    ```

        ##  [1] "HC01_EST_VC02" "HC01_EST_VC03" "HC01_EST_VC04" "HC01_EST_VC05"
        ##  [5] "HC01_EST_VC06" "HC01_EST_VC07" "HC01_EST_VC08" "HC01_EST_VC09"
        ##  [9] "HC01_EST_VC10" "HC01_EST_VC11"

2.  Apply your `separate` command from an earlier question (see above) to the original `incomedata` data frame, so we have separate `state` and `county` columns.  
    Then use `filter` and `select` to create a data frame `incomedata_nh` that only contains rows for counties in New Hampshire and has columns for `year`, `county`, and the 10 variables named in the vector `incvars_dist`:  

    ``` r
    incomedata <- 
        incomedata %>% 
        rename(county='GEO.display-label') %>%
        separate(county, c('county','state'),
               sep="County, ")

    incomedata_nh <- 
        incomedata %>% 
        filter(state=="New Hampshire") %>% 
        select(c('year','county',incvars_dist))

    incomedata_nh
    ```

        ## # A tibble: 50 x 12
        ##     year        county HC01_EST_VC02 HC01_EST_VC03 HC01_EST_VC04
        ##    <chr>         <chr>         <dbl>         <dbl>         <dbl>
        ##  1  2011      Belknap            4.8           4.8           8.9
        ##  2  2011      Carroll            5.5           5.3           8.8
        ##  3  2011     Cheshire            4.8           4.7          10.3
        ##  4  2011         Coos            7.5           7.5          14.3
        ##  5  2011      Grafton            5.6           4.5           9.9
        ##  6  2011 Hillsborough            4.1           3.5           7.9
        ##  7  2011    Merrimack            4.2           3.9           8.3
        ##  8  2011   Rockingham            3.1           3.0           6.6
        ##  9  2011    Strafford            5.9           4.6           8.6
        ## 10  2011     Sullivan            5.8           6.1           9.0
        ## # ... with 40 more rows, and 7 more variables: HC01_EST_VC05 <dbl>,
        ## #   HC01_EST_VC06 <dbl>, HC01_EST_VC07 <dbl>, HC01_EST_VC08 <dbl>,
        ## #   HC01_EST_VC09 <dbl>, HC01_EST_VC10 <dbl>, HC01_EST_VC11 <dbl>

3.  Convert `incomedata_nh` to "long" format using `gather`. One of the arguments to `gather` should be your vector `incvars_dist`.  

    ``` r
    incomedata_nh <- 
      incomedata_nh %>%
      gather(incvars_dist, key='varname', value='proportion')
    incomedata_nh
    ```

        ## # A tibble: 500 x 4
        ##     year        county       varname proportion
        ##    <chr>         <chr>         <chr>      <dbl>
        ##  1  2011      Belknap  HC01_EST_VC02        4.8
        ##  2  2011      Carroll  HC01_EST_VC02        5.5
        ##  3  2011     Cheshire  HC01_EST_VC02        4.8
        ##  4  2011         Coos  HC01_EST_VC02        7.5
        ##  5  2011      Grafton  HC01_EST_VC02        5.6
        ##  6  2011 Hillsborough  HC01_EST_VC02        4.1
        ##  7  2011    Merrimack  HC01_EST_VC02        4.2
        ##  8  2011   Rockingham  HC01_EST_VC02        3.1
        ##  9  2011    Strafford  HC01_EST_VC02        5.9
        ## 10  2011     Sullivan  HC01_EST_VC02        5.8
        ## # ... with 490 more rows

4.  We are now going to replace these coded variable names with the descriptions in `metadata`. First run this command:

    ``` r
    filter(metadata, year==2011, varname %in% incvars_dist)
    ```

        ## # A tibble: 10 x 3
        ##     year       varname                                    vardesc
        ##    <chr>         <chr>                                      <chr>
        ##  1  2011 HC01_EST_VC02    Households; Estimate; Less than $10,000
        ##  2  2011 HC01_EST_VC03   Households; Estimate; $10,000 to $14,999
        ##  3  2011 HC01_EST_VC04   Households; Estimate; $15,000 to $24,999
        ##  4  2011 HC01_EST_VC05   Households; Estimate; $25,000 to $34,999
        ##  5  2011 HC01_EST_VC06   Households; Estimate; $35,000 to $49,999
        ##  6  2011 HC01_EST_VC07   Households; Estimate; $50,000 to $74,999
        ##  7  2011 HC01_EST_VC08   Households; Estimate; $75,000 to $99,999
        ##  8  2011 HC01_EST_VC09 Households; Estimate; $100,000 to $149,999
        ##  9  2011 HC01_EST_VC10 Households; Estimate; $150,000 to $199,999
        ## 10  2011 HC01_EST_VC11     Households; Estimate; $200,000 or more

    Pipe the results of the previous command to extract the `vardesc` column and store it as a vector `income_descriptions`.  

    ``` r
    filter(metadata, year==2011, varname %in% incvars_dist) %>% 
      .$vardesc -> income_descriptions
    income_descriptions
    ```

        ##  [1] "Households; Estimate; Less than $10,000"   
        ##  [2] "Households; Estimate; $10,000 to $14,999"  
        ##  [3] "Households; Estimate; $15,000 to $24,999"  
        ##  [4] "Households; Estimate; $25,000 to $34,999"  
        ##  [5] "Households; Estimate; $35,000 to $49,999"  
        ##  [6] "Households; Estimate; $50,000 to $74,999"  
        ##  [7] "Households; Estimate; $75,000 to $99,999"  
        ##  [8] "Households; Estimate; $100,000 to $149,999"
        ##  [9] "Households; Estimate; $150,000 to $199,999"
        ## [10] "Households; Estimate; $200,000 or more"

5.  Remove the string `Households; Estimate;` from each element of `income_descriptions`, so this vector looks like this:

    ``` r
    income_descriptions <- str_replace(income_descriptions, "Households; Estimate; ", "")
    income_descriptions
    ```

        ##  [1] "Less than $10,000"    "$10,000 to $14,999"   "$15,000 to $24,999"  
        ##  [4] "$25,000 to $34,999"   "$35,000 to $49,999"   "$50,000 to $74,999"  
        ##  [7] "$75,000 to $99,999"   "$100,000 to $149,999" "$150,000 to $199,999"
        ## [10] "$200,000 or more"

6.  Run the following command so that the vector `income_descriptions` is [named](http://r4ds.had.co.nz/vectors.html#naming-vectors){:target="_blank"}.

    ``` r
    names(income_descriptions) <- incvars_dist
    ```

    This allows us to select the description using the variable name:

    ``` r
    income_descriptions['HC01_EST_VC02']
    ```

        ##       HC01_EST_VC02 
        ## "Less than $10,000"

    Now run this command to add these variable descriptions to our New Hampshire income data:

    ``` r
    incomedata_nh <- 
      incomedata_nh %>% mutate(vardesc = income_descriptions[varname],
                               vardesc = factor(vardesc, levels=income_descriptions))

    # check the results:
    sample_n(incomedata_nh, 5) %>% select(varname, vardesc)
    ```

        ## # A tibble: 5 x 2
        ##         varname              vardesc
        ##           <chr>               <fctr>
        ## 1 HC01_EST_VC10 $150,000 to $199,999
        ## 2 HC01_EST_VC09 $100,000 to $149,999
        ## 3 HC01_EST_VC07   $50,000 to $74,999
        ## 4 HC01_EST_VC11     $200,000 or more
        ## 5 HC01_EST_VC06   $35,000 to $49,999

    (We are storing `vardesc` as a `factor` so that the ordering of the categories is preserved when we use them to make graphics.)

7.  Sort the New Hampshire county names in descending order according to the proportion of households making more than $200,000 in 2015. Complete this command:

    ``` r
    counties_ordered <- 
      incomedata_nh %>% 
      filter(year==2015, vardesc=="$200,000 or more") %>% 
      arrange(desc(proportion)) %>% .$county
    ``` 

    Now change the `county` variable to a `factor` using this command:

    ``` r
    incomedata_nh <-
      incomedata_nh %>% mutate(county = factor(county, levels = counties_ordered))
    ```

8.  Finally, complete this `ggplot` command to visualize the income distribution in New Hampshire counties in 2015.

    ``` r
    filter(incomedata_nh, year==2015) %>%
      ggplot() + 
      geom_tile(aes(x=vardesc,y=county,fill=proportion)) + 
      theme(axis.text.x=element_text(angle=45,hjust=1)) +
      scale_fill_gradient2(low='white',high='darkgreen',
                           name="",
                           breaks=c(5,10,15,20),
                           labels=c("5","10","15","20 percent")) +
      xlab("") + ylab("") + ggtitle("NH Counties\nHousehold income, 2015")
    ```

    <img src="../heatmap.png" align="center" style="max-width: 66%">
