---
layout: coursepage
title: Lab 3
courseurl: /teaching/stats306f17/
coursename: Statistics 306, Fall 2017
---

# Lab 3, September 26

-   [Exercise 1](#exercise-1)
    -   [Assignment Part 1](#assignment-part-1)
    -   [Assignment Part 2](#assignment-part-2)
-   [Solutions](#solutions)


## Exercise 1

### Background

This exercise is inspired by a recent New York Times [visualization](https://www.nytimes.com/interactive/2017/08/24/us/affirmative-action.html?mcubz=1){:target="_blank"} of college enrollment rates by race/ethnicity. We will focus on public flagship universities.

Download `enrollment.txt` from our <a href="https://umich.instructure.com/courses/181629/files" target="_blank">Canvas site</a> and import the data set into an R data frame named `enr`.

(These data are from <a href="https://nces.ed.gov/ipeds/Home/UseTheData" target="_blank">IPEDS</a>, a survey conducted by the National Center for Education Statistics.)

Print the first few rows of `enr` in your R console. For each of the 50 public flagship universities, this data set contains the number (`count`) of new freshmen in each of five race/ethnicity categories (`reth`) for the years 1994--2015.

### Assignment Part 1

Reference material: <a href="http://r4ds.had.co.nz/data-visualisation.html#statistical-transformations" target="_blank">statistical transformations</a>

First we will focus on the University of Michigan. Filter `enr` so it only contains data for Michigan:

``` r
umenr <- filter(enr, School=="University of Michigan-Ann Arbor")
```
Now recreate the following three plots. In parts (a) and (b), map the `count` variable to the `y` aesthetic and specify the appropriate `position` and `stat` arguments to `geom_bar`. In part (c), map the `pct` variable to the `y` aesthetic.

<img src="lab3barplots.png" align="center">

These graphs use a color palette developed by [Color Brewer](http://colorbrewer2.org/){:target="_blank"}:
```r 
 +  scale_fill_brewer(palette='Set2',name='')
```

Which plot you think is more informative?

### Assignment Part 2

Now recreate, as closely as possible, the NYT plot of all 50 public flagship universities, displaying the proportion of freshmen in each race/ethnicity category over time. 

![](nyt_snippet.png)

Use the `pct` variable in the `enr` data frame. You can remove the "other" category for simplicity.

Here is a code snippet to get you started. Fill in the `...` with your own code.

``` r
ggplot(filter(enr, reth!="Other/unknown")) +
  ... # add the appropriate geom
  facet_wrap(...) + 
  scale_x_continuous(breaks=...,
                     labels=...) + 
  ... + # change the axis labels 
  scale_color_brewer(palette='Set1',name='')
```

My attempt is below. There are clearly some problems with the way I am calculating these percentages (e.g. University of Maine). Perhaps a future lab exercise will consist of properly downloading and computing these enrollment percentages.

<a href="enrplot_all-1.png" target="_blank">
<img src="enrplot_all-1.png" align="center">
</a>

## Solutions
[Solutions to exercise 1](lab3sol)

