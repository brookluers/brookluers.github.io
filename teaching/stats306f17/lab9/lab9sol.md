---
layout: coursepage
title: Lab 9
courseurl: /teaching/stats306f17/
coursename: Statistics 306, Fall 2017
parentname: Lab 9
parenturl: /teaching/stats306f17/lab9
---

# Lab 9, November 14, Solutions

``` r
sk <- read_lines('shakespeare_sonnets.txt')
head(sk)
```

    ## [1] "  I"                                          
    ## [2] ""                                             
    ## [3] "  From fairest creatures we desire increase," 
    ## [4] "  That thereby beauty's rose might never die,"
    ## [5] "  But as the riper should by time decease,"   
    ## [6] "  His tender heir might bear his memory:"

1.  Remove the empty lines (strings of length zero) from `sk` using [`str_length`](http://r4ds.had.co.nz/strings.html#string-length){:target="_blank"}.  

    ```r 
    sk <- sk[str_length(sk)>0]
    ```

2.  Remove the leading whitespace in each line using [`str_trim`](http://stringr.tidyverse.org/reference/str_trim.html){:target="_blank"}.  

    ```r
    sk <- str_trim(sk, side='left')
    ```

3.  This text file contains lines with each sonnet number as a roman numeral. Use a regular expression to remove the elements of `sk` containing the sonnet number. Remember that `$` matches the end of a string and `^` matches the beginning of the string. We have removed the leading whitespace from each line, so you need to match strings that consist entirely of roman numeral characters (capital letters IVXLCDM).  
    
    ```r
    sk <- sk[!str_detect(sk, "^[ICDMLVX]+$")]
    ```

4.  How many sonnet lines (elements of `sk`) contain the word `fairest`?  
    
    ```r
    sum(str_detect(sk, 'fairest'))
    ```
    
4.  Find four-letter words that begin and end with the letter `e`. You can restrict your search to words occurring in the middle of a line (words surrounded by spaces).  

    ```r
    str_subset(sk, " e..e ")
    ```

5.  Extract all the words that end with `'st`, like "deserv'st". Start by finding occurrences of `'st`, then add to your regular expression to match the entire word ending with `'st`.  
    
    ```r
    regex_st <- "[a-zA-Z]+'st"
    str_extract_all(str_subset(sk, regex_st), regex_st, simplify=TRUE)
    ```

5.  Print the sonnet lines in which a question mark or period occurs in the middle of the line.  
    
    ```r
    str_subset(sk, "[\\?\\.] ")
    ```

6.  Print the lines that contain at least one of each vowel appearing in alphabetical order.  
    *As many of you pointed out, this is an ambiguous exercise. The search pattern below allows the in-order vowels to be separated by other vowels.*  

    ```r
    str_subset(sk, "[aA]+.*[eE]+.*[iI]+.*[oO]+.*[uU]+.*$")
    ```

7.  Use `str_view_all` to highlight every word beginning with the letter `s` (lowercase or uppercase). To get started, run this command:

    ``` r
    str_view_all(sk, "\\b[sS]")
    ```

    Note that an apostrophe is considered a word boundary (matched by `\b`). Instead of using `\b` to define the beginning of a word, use a character class containing the uppercase and lowercase letters and the apostrophe character; any character *except* these characters will define the beginning of a word.  
    
    ```r
    str_view_all(sk, "[^a-zA-Z'][sS][a-zA-Z]+")
    ```

8.  Now use your expression from the previous exercise to highlight all words that begin with `s` or `S` and contain at least three letters.  
    
    ```r
    str_view_all(sk, "[^a-zA-Z'][sS][a-zA-Z]{3,}")
    ```

9.  Using [`str_count`](http://stringr.tidyverse.org/reference/str_count.html#examples){:target="_blank"}, print the lines of `sk` containing at least two words that begin with `s` or `S` and contain at least three letters.  
    
    ```r
    sk[str_count(sk, "[^a-zA-Z'][sS][a-zA-Z]{3,}") > 1]
    ```

