---
layout: coursepage
title: Lab 6
courseurl: /teaching/stats306f17/
coursename: Statistics 306, Fall 2017
parentname: Lab 6
parenturl: /teaching/stats306f17/lab6
---

# Lab 6, October 24, Solutions

-   [Reading a csv file](#reading-a-csv-file)
-   [Exploratory analysis](#exploratory-analysis)


### Reading a csv file

Let's try read this file without specifying data types.

``` r
ab <- read_csv('listings.csv')
```

What data type was given to the `price` variable?  
The price variable was imported as a character vector, but it should represent a numeric value.

#### Column specification

I've created a column specification for you to try. First we will need the levels (unique values) for a few categorical variables.

``` r
(rmlvl <- unique(ab$room_type))
```

    ## [1] "Private room"    "Entire home/apt" "Shared room"

Using the above code as a model, create two other vectors named `proplvl` and `bedlvl` that contain the unique values of the variables `property_type` and `bed_type`, respectively.  
    
```r
proplvl <- unique(ab$property_type)
bedlvl <- unique(ab$bed_type)
```

Now copy and paste the following code to import the data with our own column specification. The `cols_only` function will only import the listed columns.

    # code omitted

What happened? 
    Using `col_double()` for price failed because the dollar signs cause parsing errors. 

Fix the column specification so that `price` and `cleaning_fee` are properly formatted. 

`col_number()` will remove the dollar signs for us:

``` r
colspec$cols[['cleaning_fee']] <- col_number()
colspec$cols[['price']] <- col_number()

ab <- read_csv('listings.csv',
               col_types = colspec)
```

### Exploratory analysis

1.  Is `ab` a tibble or a regular `data.frame`? How do you know?  
    `print(ab)` shows that `ab` is a tibble.

2.  Use pipes, the `$` operator, and the `table` function to list the number of properties in each `city`. List the number of properties in each neighborhood using the `neighbourhood_cleansed` variable.
    
    ``` r
    ab %>% .$city %>% table
    ab %>% .$neighbourhood_cleansed %>% table
    ```

3.  Suppose I store a variable name as a string:

    ``` r
    vn <- 'price'
    ```  
    
    Use pipes and `[[` to select the variable stored in `vn` from `ab`. Pipe the result to the `summary` function.  
    
    ``` r
    ab %>% .[[vn]] %>% summary
    ```

        ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
        ##     0.0    80.0   140.0   172.8   200.0  4000.0

4.  Plot a histogram of the prices (rental cost for a single night). Are there any unusual (high or low) values?  
    There are some prices as high as 3000 or 4000.

    <img src="../pricehist-1.png" align="center">

5.  Remove properites with absurd (high or low) prices.  
    
    ``` r
    ab <- filter(ab, price <=2500, price > 0)
    ```

6.  Create a vector called `nbh50` with the names of neighborhoods with at least 50 listings, sorted by median price. I suggest using `group_by`, `summarise` and `filter`. What neighborhoods have the highest and lowest median price?
    
    ``` r
    nbh50 <- ab %>% 
      group_by(neighbourhood_cleansed)%>%
      summarise(np=n(),
                medprice = median(price)) %>% 
      filter(np>50) %>% arrange(medprice) %>% .[[1]]
    ```

    Then enter this command to create a new factor variable with levels corresponding to the sorted neighborhoods:

    ``` r
    ab <- 
      mutate(ab, nbh_sorted = factor(neighbourhood_cleansed,
                                     levels=nbh50))
    ```

2.  Compute the quintiles of the price distribution across all properties. Store the result in a vector called `pquint`. There should be six values in this vector, including the minimum and maximum prices.  
    
    ``` r
    (pquint <- ab %>% .[[vn]] %>% quantile(probs=seq(0,1,0.2)))
    ```
    
        ##   0%  20%  40%  60%  80% 100% 
        ##   17   75  119  169  235 2000


1.  Enter this command, which makes a factor variable containing the price quintile for each property:

    ``` r
    ab <- mutate(ab, price_q = cut(price, breaks = pquint))
    ```

1.  Finally, create one or two informative graphs that display the distribution of prices within each of the `nbh50` neighborhoods. Filter `ab` to only contain properties in those neighborhoods, and map the `price_q` categorical variable to either `color` or `fill`.  

    ``` r
    ggplot(filter(ab, neighbourhood_cleansed %in% nbh50,
                  !is.na(price_q))) +
      geom_point(aes(x=nbh_sorted,y=price,color=price_q),
                 position=position_jitter(w=0.2,h=0)) +
      scale_color_brewer(palette='YlOrRd')+
      theme(axis.text.x=element_text(hjust=1,angle=45))+
      xlab("")+ylab("Price")
    ```
    
<img src="../eda-plot-1.png" align="center">

