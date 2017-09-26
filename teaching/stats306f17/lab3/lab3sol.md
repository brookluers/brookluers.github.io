---
layout: coursepage
title: Lab 3
courseurl: /teaching/stats306f17/
coursename: Statistics 306, Fall 2017
parentname: Lab 3
parenturl: /teaching/stats306f17/lab3
---

# Lab 3 Solutions
-   [Assignment Part 1](#assignment-part-1)
-   [Assignment Part 2](#assignment-part-2)

## Assignment Part 1

``` r
ggplot(umenr) + 
  geom_bar(aes(x=year, y=count, fill=reth),
           stat='identity',
            position='stack') +
  scale_fill_brewer(palette='Set2',name='') +
  xlab("Year")+ylab("Num. freshmen") +
  scale_x_continuous(breaks=c(1995,2005,2015)) +
  ggtitle("University of Michigan\n(a)")

ggplot(umenr) + 
  geom_bar(aes(x=year, y=count, fill=reth), stat='identity',
           position='fill') +
  scale_fill_brewer(palette='Set2', name='') +
  xlab("Year") + ylab("Proportion of freshmen") +
  scale_x_continuous(breaks=c(1995, 2005, 2015)) +
  ggtitle("\n(b)")

ggplot(umenr) +
  geom_line(aes(x=year, y=pct, color=reth)) +
  scale_color_brewer(palette='Set2', name='')+
  xlab("Year")+ylab("Proportion of freshmen")+
  scale_x_continuous(breaks=c(1995, 2005, 2015))+
  ggtitle("\n(c)")

```

<img src="../lab3barplots.png" align="center">

## Assignment Part 2 

Here is the simplest solution with minimal changes to the appearance. (To make things easier to read I will only display a few schools.)

``` r
enr_sol <- 
  filter(enr, School %in% c('University of Florida',
                            'University of Michigan-Ann Arbor',
                            'University of California-Berkeley',
                            'University of Iowa'))

ggplot(filter(enr_sol, reth!="Other/unknown")) +
  geom_line(aes(x=year,y=pct, color=reth)) + 
  facet_wrap(~School) + 
  scale_x_continuous(breaks=c(1995,2005,2015))+
  scale_color_brewer(palette='Set1',name='')
```

<img src="../plot4simple-1.png" align="center">

It is only necessary for you to understand the above solution. Everything that follows is extra information on how to control the visual appearance of the graph.

First I created a new version of the `School` variable so that long school names would have a line break in the facet title.

``` r
# the dollar sign accesses a variable in a data frame
# this variable doesn't exist until I create it
enr_sol$school_facet 
```

    ## NULL

``` r
# creating a new variable school_facet
# the gsub function finds and replaces strings
enr_sol$school_facet <-
  gsub("University of ", "University of\n", # \n is the newline character
       paste(enr_sol$School),
       fixed=TRUE)

tail(select(enr_sol, School, school_facet))
```

    ##                                School                       school_facet
    ## 435                University of Iowa                University of\nIowa
    ## 436  University of Michigan-Ann Arbor  University of\nMichigan-Ann Arbor
    ## 437 University of California-Berkeley University of\nCalifornia-Berkeley
    ## 438             University of Florida             University of\nFlorida
    ## 439                University of Iowa                University of\nIowa
    ## 440  University of Michigan-Ann Arbor  University of\nMichigan-Ann Arbor

Next I created a new data frame object to contain the text labels for 2015.

``` r
adat <- 
  filter(enr_sol, year==2015, reth!="Other/unknown") %>%
  select(school_facet, pct, reth, year) %>% 
  group_by(school_facet) %>%              # for each school
  mutate(prank = min_rank(desc(pct))) %>% # rank the percent enrollment in each category
  filter(prank <= 2) %>%                  # only keep the top 2 categories
  mutate(lb = paste(100 * round(pct, 2), '% ', reth, sep='')) # create a text label

head(select(adat, school_facet, year, pct, lb))
```

    ## # A tibble: 6 x 4
    ## # Groups:   school_facet [4]
    ##                           school_facet  year        pct           lb
    ##                                  <chr> <int>      <dbl>        <chr>
    ## 1 "University of\nCalifornia-Berkeley"  2015 0.38856624    39% Asian
    ## 2  "University of\nMichigan-Ann Arbor"  2015 0.13504132    14% Asian
    ## 3             "University of\nFlorida"  2015 0.20604556 21% Hispanic
    ## 4                "University of\nIowa"  2015 0.09636814 10% Hispanic
    ## 5 "University of\nCalifornia-Berkeley"  2015 0.25063521    25% White
    ## 6             "University of\nFlorida"  2015 0.56074766    56% White  

Here's an example of the `paste` function, which concatenates character vectors (after converting numeric values to characters):

``` r
paste(c("a","b","c"), c(1, 2, 3), sep=' ')
```

    ## [1] "a 1" "b 2" "c 3"

Finally, we use the same aesthetic mappings as the first solution but we add `geom_text` using the `adat` data frame:

``` r
ggplot(filter(enr_sol, reth!="Other/unknown")) +
  geom_line(aes(x=year, y=pct, color=reth)) + 
  facet_wrap(~school_facet, ncol=4, scales='free_x') + 
  # text is added like any other geometric object
  # but you must specify the 'label' aesthetic
  geom_text(aes(x=year + 0.5, y=pct, color=reth, label=lb),
            hjust=0, size=2.5, # size and horizontal justification
            show.legend=FALSE, 
            data=adat) + # use the special adat data frame created above
  scale_x_continuous(breaks=c(1995, 2005, 2015),
                     limits=c(1994, 2030))+ # extend the x-axis limits to contain the text labels
  scale_y_continuous(breaks=c(0.1, 0.4, 0.7),
                     labels=c("10%", "40%", "70%")) +
  theme(strip.background = element_rect(fill='white', color='white'), # background of facet labels
        strip.text=element_text(size=11),
        panel.grid.major.x=element_blank(), # remove the vertical gridlines
        panel.grid.minor.x=element_blank(), # remove the vertical gridlines
        panel.grid.major.y=element_line(linetype='dotted', color='lightgrey'), #horizontal gridlines
        panel.background = element_rect(fill='white',color='white'), # white plot background
        axis.line = element_line(color='lightgrey'), # color of axis lines
        legend.position=c(0.8, 0),
        legend.justification = c(1, 0),
        legend.direction='vertical',
        panel.spacing=unit(6,'pt')) + # space between facets 
  xlab("") + ylab("") +
  scale_color_brewer(palette='Set1',name='')
```

<img src="../enrplot_small-1.png" align="center">
