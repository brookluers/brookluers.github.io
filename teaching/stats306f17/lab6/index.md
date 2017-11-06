---
layout: coursepage
title: Lab 6
courseurl: /teaching/stats306f17/
coursename: Statistics 306, Fall 2017
---

# Lab 6, October 24

[Solutions](lab6sol)

-   [Data Import](#data-import)
-   [Exercise: Airbnb](#exercise-airbnb)
    -   [Reading a csv file](#reading-a-csv-file)
    -   [Exploratory analysis](#exploratory-analysis)


## Data Import

Reference: [R4DS Chapter 11](http://r4ds.had.co.nz/data-import.html){:target="_blank"}

Here is a review of `read_csv` and the `parse_` functions that convert raw text data to R vectors. Let's create some example data:

``` r
ssc <- 
"***Sesame Street Characters***
id,name,v2,v3
1,Oscar,$30.0,2017-10-01
1,Oscar,$27.0,2017-09-09
2,Big Bird,$18.3,2017-08-31
2,Big Bird,$17.5,na
4,Grover,$16.0,2017-10-03
"
id <- c(1,1,2,2,4)
nm <- c('Oscar','Oscar','Big Bird','Big Bird','Grover')
v2 <- c('$30.0','$27.0','$18.3','$17.5','$16.0')
v3 <- c('2017-10-01','2017-09-09','2017-08-31','na','2017-10-03')
```

For numeric data: `parse_double` and `parse_number`

``` r
parse_double(v2)
```

    ## Warning: 5 parsing failures.
    ## row # A tibble: 5 x 4 col     row   col expected actual expected   <int> <int>    <chr>  <chr> actual 1     1    NA a double  $30.0 row 2     2    NA a double  $27.0 col 3     3    NA a double  $18.3 expected 4     4    NA a double  $17.5 actual 5     5    NA a double  $16.0

    ## [1] NA NA NA NA NA
    ## attr(,"problems")
    ## # A tibble: 5 x 4
    ##     row   col expected actual
    ##   <int> <int>    <chr>  <chr>
    ## 1     1    NA a double  $30.0
    ## 2     2    NA a double  $27.0
    ## 3     3    NA a double  $18.3
    ## 4     4    NA a double  $17.5
    ## 5     5    NA a double  $16.0

`parse_double` is strict about number formatting. For the dollar amounts in `v2` we can use `parse_number`:

``` r
parse_number(v2) # removes the dollar signs
```

    ## [1] 30.0 27.0 18.3 17.5 16.0

For categorical variables we can use `parse_factor`:

``` r
clevels <- c('Big Bird','Grover','Bert','Ernie','Oscar')
parse_factor(nm, levels=clevels)
```

    ## [1] Oscar    Oscar    Big Bird Big Bird Grover  
    ## Levels: Big Bird Grover Bert Ernie Oscar

Dates are formatted with `parse_date`:

``` r
parse_date(v3)
```

    ## Warning: 1 parsing failure.
    ## row # A tibble: 1 x 4 col     row   col   expected actual expected   <int> <int>      <chr>  <chr> actual 1     4    NA date like      na

    ## [1] "2017-10-01" "2017-09-09" "2017-08-31" NA           "2017-10-03"

Specify the values that should be treated as `NA`:

``` r
parse_date(v3, na='na')
```

    ## [1] "2017-10-01" "2017-09-09" "2017-08-31" NA           "2017-10-03"

Putting it all together, we can import this data set with `read_csv`, specifying the variable types with `col_types`:

``` r
read_csv(ssc,
         skip = 1, # skip the first line of the file
         col_types = cols(
          id = col_integer(), 
          name = col_factor(levels=clevels),
          v2 = col_number(), # removes the dollar signs
          v3 = col_date()
         ),
         na=c('','na')
)
```

    ## # A tibble: 5 x 4
    ##      id     name    v2         v3
    ##   <int>   <fctr> <dbl>     <date>
    ## 1     1    Oscar  30.0 2017-10-01
    ## 2     1    Oscar  27.0 2017-09-09
    ## 3     2 Big Bird  18.3 2017-08-31
    ## 4     2 Big Bird  17.5         NA
    ## 5     4   Grover  16.0 2017-10-03


## Exercise: Airbnb

We will use data on Airbnb listings in Boston compiled by [Inside Airbnb](http://insideairbnb.com/get-the-data.html){:target="_blank"}. Download the first file for Boston, described as "Detailed listings data for Boston". Decompress the `.gz` file and save the resulting `.csv` file in your working directory.

### Reading a csv file

Let's try read this file without specifying data types.

``` r
ab <- read_csv('listings.csv')
```

Examine the column types that were chosen by default:
``` r
spec(ab)
```

What data type was given to the `price` variable? Print a few `price` values to understand what is stored in this variable.

#### Column specification

I've created a column specification for you to try. First we will need the levels (unique values) for a few categorical variables.

``` r
(rmlvl <- unique(ab$room_type))
```

    ## [1] "Private room"    "Entire home/apt" "Shared room"

Using the above code as a model, create two other vectors named `proplvl` and `bedlvl` that contain the unique values of the variables `property_type` and `bed_type`, respectively.

Now copy and paste the following code to import the data with our own column specification. The `cols_only` function will only import the listed columns.

``` r
colspec <- cols_only(
                 price = col_double(),
                 zipcode = col_character(),
                 city = col_character(),
                 description = col_character(),
                 name = col_character(),
                 state = col_character(),
                 is_location_exact = col_character(),
                 latitude = col_double(),
                 longitude = col_double(),
                 neighbourhood_cleansed = col_character(),
                 calculated_host_listings_count = col_integer(),
                 availability_365 = col_integer(),
                 host_is_superhost = col_character(),
                 host_since = col_date(),
                 review_scores_rating = col_integer(),
                 property_type = col_factor(levels = proplvl),
                 room_type = col_factor(levels = rmlvl),
                 bathrooms = col_double(),
                 bedrooms = col_integer(),
                 beds = col_integer(),
                 accommodates = col_integer(),
                 bed_type = col_factor(levels = bedlvl),
                 guests_included = col_integer(),
                 cleaning_fee = col_double(),
                 minimum_nights = col_integer(),
                 number_of_reviews = col_integer(),
                 review_scores_rating = col_double(),
                 instant_bookable = col_character(),
                 last_review = col_date(),
                 first_review = col_date(),
                 market = col_character()
               )
ab <- read_csv('listings.csv',
               col_types = colspec)
```

What happened? Enter the command `problems(ab)`.  
Fix the column specification so that `price` and `cleaning_fee` are properly formatted. You can do this by completing the following commands:

``` r
colspec$cols[['cleaning_fee']] <-     # complete this command
colspec$cols[['price']] <-            # complete this command

ab <- read_csv('listings.csv',
                col_types = colspec)  
```

### Exploratory analysis

1.  Is `ab` a tibble or a regular `data.frame`? How do you know?
2.  Use pipes, the `$` operator, and the `table` function to list the number of properties in each `city`. List the number of properties in each neighborhood using the `neighbourhood_cleansed` variable.

3.  Suppose I store a variable name as a string:

    ``` r
    vn <- 'price'
    ```  
    
    Use pipes and `[[` to select the variable stored in `vn` from `ab`. Pipe the result to the `summary` function. You should see output like this:

        ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
        ##     0.0    80.0   140.0   172.8   200.0  4000.0

4.  Plot a histogram of the prices (rental cost for a single night). Are there any unusual (high or low) values? Try a few different `binwidth` values.

5.  Remove properites with absurd (high or low) prices. What cutoff values did you choose and why?

6.  Create a vector called `nbh50` with the names of neighborhoods with at least 50 listings, sorted by median price. I suggest using `group_by`, `summarise` and `filter`. What neighborhoods have the highest and lowest median price?

    Then enter this command to create a new factor variable with levels corresponding to the sorted neighborhoods:

    ``` r
    ab <- 
      mutate(ab, nbh_sorted = factor(neighbourhood_cleansed,
                                     levels=nbh50))
    ```

2.  Compute the quintiles of the price distribution across all properties. Store the result in a vector called `pquint`. There should be six values in this vector, including the minimum and maximum prices. Here is an example of the `quantile` function:

    ``` r
    quantile(c(100,50,73,1,2), probs=c(0, 0.1,0.5,0.9,1))
    ```
    
        ##    0%   10%   50%   90%  100% 
        ##   1.0   1.4  50.0  89.2 100.0

1.  Enter this command, which makes a factor variable containing the price quintile for each property:

    ``` r
    ab <- mutate(ab, price_q = cut(price, breaks = pquint))
    ```

1.  Finally, create one or two informative graphs that display the distribution of prices within each of the `nbh50` neighborhoods. Filter `ab` to only contain properties in those neighborhoods, and map the `price_q` categorical variable to either `color` or `fill`. Some possibilities include boxplots, histograms, density plots, and (jittered) points. Use `nbh_sorted` as your neighborhood variable.
