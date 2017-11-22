---
layout: coursepage
title: Lab 10
courseurl: /teaching/stats306f17/
coursename: Statistics 306, Fall 2017
parentname: Lab 10
parenturl: /teaching/stats306f17/lab10
---

# Lab 10, November 21, Solutions

``` r
# Required setup from Lab 9
sk <- read_lines('shakespeare_sonnets.txt')
sk <- sk[str_length(sk)>0]      # Remove zero-length lines
sk <- str_trim(sk, side='left') # Remove leading whitespace
sk <-                           # Remove lines containing only a roman numeral
  sk[!str_detect(sk, "^[ICDMLVX]+$")]
```

1.  Find lines containing three-letter strings that are repeated. For example, "contented" repeats the three-letter string `nte` twice in a row.  
    
    ```r
    str_subset(sk, "([a-z]{3})\\1")
    ```

2.  Using [`str_replace_all`](http://stringr.tidyverse.org/reference/str_replace.html){:target="_blank"}, remove all `!`, `,`, `'`, `;`, `:`, `?` and `.` characters from `sk`. Store the result in an object called `sk2`.  
    
    ```r
    sk2 <- str_replace_all(sk, "[!,';:\\?\\.]", "")
    ```

3.  Replace all `--` (two hyphens) in `sk2` with a single space.  
    
    ```r
    sk2 <- str_replace_all(sk2, "--", " ")
    ```

4.  Now combine the elements of `sk2` into a single string, called `sk2_combined`, using [`str_c`](http://stringr.tidyverse.org/reference/str_c.html){:target="_blank"}. Include the argument `collapse=" "` so that the result is a single string containing all of the words in Shakespeare's sonnets, separated by spaces.  

    ``` r
    sk2_combined <- str_c(sk2, collapse=" ")
    str_sub(sk2_combined, 1, 300)
    ```

        ## [1] "From fairest creatures we desire increase That thereby beautys rose might never die But as the riper should by time decease His tender heir might bear his memory But thou contracted to thine own bright eyes Feedst thy lights flame with self-substantial fuel Making a famine where abundance lies Thy s"

1.  Use [`str_split`](http://stringr.tidyverse.org/reference/str_split.html){:target="_blank"} to split `sk2_combined` into individual words. The splitting pattern should match one or more whitespace characters (`\s`). Include the argument `simplify=TRUE`.  
    
    ``` r
    sk2_split <- str_split(sk2_combined, "\\s+", simplify=TRUE)
    dim(sk2_split) # a matrix with one row
    ```

        ## [1]     1 17536
    
    ``` r
    sk2_split[1, 1:15]
    ```

        ##  [1] "From"      "fairest"   "creatures" "we"        "desire"   
        ##  [6] "increase"  "That"      "thereby"   "beautys"   "rose"     
        ## [11] "might"     "never"     "die"       "But"       "as"


1.  Count the number of letters in each word using [`str_length`](http://stringr.tidyverse.org/reference/str_length.html){:target="_blank"}. Create the following chart, which displays the frequency of word lengths in Shakespeare's sonnets.  

    ```r
    sklen <- str_length(sk2_split)
    (sklen_df <- tibble(sklen))
    ```

        ## # A tibble: 17,536 x 1
        ##    sklen
        ##    <int>
        ##  1     4
        ##  2     7
        ##  3     9
        ##  4     2
        ##  5     6
        ##  6     8
        ##  7     4
        ##  8     7
        ##  9     7
        ## 10     4
        ## # ... with 17,526 more rows
    
    ```r
    ggplot(sklen-df) + 
        geom_bar(aes(x=sklen)) + 
        xlab("Word length") + ylab("Number of words")
    ```

    <img src="../wfreq-1.png" align="center" style="max-width:75%;">
