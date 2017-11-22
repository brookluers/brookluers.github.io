---
layout: coursepage
title: Lab 9
courseurl: /teaching/stats306f17/
coursename: Statistics 306, Fall 2017
---

# Lab 9, November 14

[Solutions](lab9sol)

-  [Regular expressions review](#regular-expressions-review)
    -   [Literal strings](#literal-strings)
    -   [Anchors](#anchors)
    -   [The dot](#the-dot)
    -   [Character classes and repetition](#character-classes-and-repetition)
-  [Exercises](#exercises)

## Regular expressions review

Let's review regular expressions using Shakespeare's sonnets. Download the file `shakespeare_sonnets.txt` [here](../../../data/shakespeare_sonnets.txt){:target="_blank"}, which contains the text of all 154 of Shakespeare's sonnets.

We can import the sonnets into R using `read_lines`, which reads a text file line-by-line into an R character vector.

``` r
library(stringr)
library(tidyverse)

sk <- read_lines('shakespeare_sonnets.txt')
length(sk)
```

    ## [1] 2618

``` r
# Display the first 20 lines
writeLines(head(sk, 20))
```

    ##   I
    ## 
    ##   From fairest creatures we desire increase,
    ##   That thereby beauty's rose might never die,
    ##   But as the riper should by time decease,
    ##   His tender heir might bear his memory:
    ##   But thou, contracted to thine own bright eyes,
    ##   Feed'st thy light's flame with self-substantial fuel,
    ##   Making a famine where abundance lies,
    ##   Thy self thy foe, to thy sweet self too cruel:
    ##   Thou that art now the world's fresh ornament,
    ##   And only herald to the gaudy spring,
    ##   Within thine own bud buriest thy content,
    ##   And tender churl mak'st waste in niggarding:
    ##     Pity the world, or else this glutton be,
    ##     To eat the world's due, by the grave and thee.
    ## 
    ##   II
    ## 
    ##   When forty winters shall besiege thy brow,

Recall that [`writeLines`](https://www.rdocumentation.org/packages/base/versions/3.4.1/topics/writeLines){:target="_blank"} prints text to the console, removing escape characters to show you the raw contents of a string.

Throughout this lab page we will use many of the [pattern matching](http://stringr.tidyverse.org/reference/index.html#section-pattern-matching){:target="_blank"} `str_` functions from the `stringr` package. These functions accept a character vector and a regular expression as arguments.

Regular expressions are sequences of characters that specify a search pattern. Here is a handy regular expressions tutorial with interactive exercises: [https://regexone.com/](https://regexone.com/){:target="_blank"}.

### Literal strings

The simplest search pattern is a literal sequence of characters. Let's find the line in Shakespeare's sonnets that begins with "Shall I compare thee".

This code will return elements of `sk` that contain the exact sequence of characters `Shall I compare thee`.

``` r
# str_subset returns strings that match the specified pattern
str_subset(sk, "Shall I compare thee")
```

    ## [1] "  Shall I compare thee to a summer's day?"

``` r
# equivalent version using str_detect
sk[str_detect(sk, "Shall I compare thee")]
```

    ## [1] "  Shall I compare thee to a summer's day?"

More advanced search patterns will involve [special characters](https://www.regular-expressions.info/characters.html){:target="_blank"} such as `.` or brackets `[]`.

To find these special characters inside a string, they need to be "escaped" with a backslash.

``` r
str_subset(sk, "day?") %>% tail
```

    ## [1] "  That they elsewhere might dart their injuries:"   
    ## [2] "  My tongue-tied patience with too much disdain;"   
    ## [3] "  That followed it as gentle day,"                  
    ## [4] "    Who art as black as hell, as dark as night."    
    ## [5] "  And swear that brightness doth not grace the day?"
    ## [6] "  A dateless lively heat, still to endure,"

The question mark is a special character indicating that the preceding character must be matched zero or one time. That is why the above code returns a line containing `dart`: the characters `da` match our search pattern, with the `y` occurring zero times.

``` r
str_subset(sk, "day\\?")
```

    ## [1] "  Shall I compare thee to a summer's day?"          
    ## [2] "  And swear that brightness doth not grace the day?"

To match a literal question mark, we use the escape character `\`, which itself needs to be escaped in R. Hence `day\\?` is the regular expression string that matches the string `day?`.

### Anchors

Anchors match locations within a string rather than characters. The `^` character matches the start of a string, while the `$` character matches the end of a string.

``` r
# number of lines ending with a question mark
sum( str_detect(sk, "\\?$") )
```

    ## [1] 93

The expression above matches question marks (`\\?`) that are followed immediately by the end of the string (`$`). Recall that [`str_detect`](http://stringr.tidyverse.org/reference/str_detect.html){:target="_blank"} returns a logical vector, so calling `sum` on the results of `str_detect` counts the number of elements that matched the search pattern.

Another anchor, `\b` matches [boundaries](https://www.regular-expressions.info/wordboundaries.html){:target="_blank"} between words (see an example below).

### The dot

The dot `.` matches any character except a newline character.

This code will find four-letter words like "deep" or "keep" that contain two sandwiched e's. The spaces in this regular expression mean that we are only matching these words in the middle of a line.

``` r
head(str_subset(sk, " .ee. "))
```

    ## [1] "  And dig deep trenches in thy beauty's field,"      
    ## [2] "  Will be a tatter'd weed of small worth held:"      
    ## [3] "  To say, within thine own deep sunken eyes,"        
    ## [4] "  Pluck the keen teeth from the fierce tiger's jaws,"
    ## [5] "  Bearing thy heart, which I will keep so chary"     
    ## [6] "  And in mine own love's strength seem to decay,"

### Character classes and repetition

We can match any character in a set of characters by enclosing them in square brackets `[]`. So to match either `a`, `b`, or `c` the regular expression is `[abc]`.

There are also [shorthands](https://www.regular-expressions.info/shorthand.html){:target="_blank"} for common sets of characters, like whitespace (`\s`) and digits (`\d`).

We can specify the number of times a character is matched using repetition: `?` for zero or one occurrence, `*` for zero or more, `+` for one or more, and `{m, n}` to match between `m` and `n` occurrences.

Here's an example which extracts sonnet lines containing a word with four or more consecutive vowels:

``` r
str_subset(sk, "[aeiouAEIOU]{4,}")
```

    ## [1] "  How many a holy and obsequious tear"   
    ## [2] "  No; let me be obsequious in thy heart,"

The character class contains all of the uppercase and lowercase vowels, and the notation `{4,}` matches four or more of those vowels (consecutively).

Here's another example, which extracts the first word of each line:

``` r
first_word_line <- "^\\s*[a-zA-Z]+\\b"
head( str_extract(sk, first_word_line) )
```

    ## [1] "  I"    NA       "  From" "  That" "  But"  "  His"

Each string in `sk` is a single line from one of the sonnets, or possibly the sonnet number. The sonnet lines start with whitespace:

``` r
sk[1:3]
```

    ## [1] "  I"                                         
    ## [2] ""                                            
    ## [3] "  From fairest creatures we desire increase,"

So here's how the above regular expression is working:

-   Match the beginning of the string (`^`),
-   After the beginning of the string, match zero or more whitespace characters: `\\s*`.
-   Then match one or more letters (a word): `[a-zA-Z]+`. Note the use of `a-z` to represent the entire lowercase alphabet.
-   Then match a word boundary: `\b` (note that the slash is escaped with a double slash)
-   The function [`str_extract`](http://stringr.tidyverse.org/reference/str_extract.html){:target="_blank"} extracts the substring that matches your search pattern.

What if we want to match lines that begin with long words?

``` r
# match lines where the first word is at least 10 letters long
str_subset(sk, "^\\s*[a-zA-Z]{10,}")
```

    ## [1] "  Profitless usurer, why dost thou use"            
    ## [2] "  Resembling strong youth in his middle age,"      
    ## [3] "  Resembling sire and child and happy mother,"     
    ## [4] "  Authorizing thy trespass with compare,"          
    ## [5] "    Lascivious grace, in whom all ill well shows," 
    ## [6] "  Increasing store with loss, and loss with store;"
    ## [7] "  Possessing or pursuing no delight,"              
    ## [8] "  Incertainties now crown themselves assur'd,"

Finally, one more example: this expression finds lines where the first six letters of the alphabet occur in order, but may be separated by any number of characters.

``` r
first_six <- "a.*b.*c.*d.*e.*f"
str_extract(str_subset(sk, first_six), first_six)
```

    ## [1] "akes black night beauteous, and her old f"
    ## [2] "absence seem'd my flame to qualif"

The expression `.*` matches any character (`.`) zero or more times (`*`), so `a.*b` finds an `a`, followed by zero or more characters, followed by a `b`.

## Exercises

Use Shakespeare's sonnets to complete these exercises. Remember that each element of the vector `sk` is a single line from the file `shakespeare_sonnets.txt`.

``` r
sk <- read_lines('shakespeare_sonnets.txt')
length(sk)
```

    ## [1] 2618

``` r
head(sk)
```

    ## [1] "  I"                                          
    ## [2] ""                                             
    ## [3] "  From fairest creatures we desire increase," 
    ## [4] "  That thereby beauty's rose might never die,"
    ## [5] "  But as the riper should by time decease,"   
    ## [6] "  His tender heir might bear his memory:"

1.  Remove the empty lines (strings of length zero) from `sk` using [`str_length`](http://r4ds.had.co.nz/strings.html#string-length){:target="_blank"}. Here is an example that may help:

    ``` r
    x <- c(0, 1, 2, 3)
    x > 0 
    ```

        ## [1] FALSE  TRUE  TRUE  TRUE

    ``` r
    x <- x[x > 0]
    x
    ```

        ## [1] 1 2 3

2.  Remove the leading whitespace in each line using [`str_trim`](http://stringr.tidyverse.org/reference/str_trim.html){:target="_blank"}.

3.  This text file contains lines with each sonnet number as a roman numeral. Use a regular expression to remove the elements of `sk` containing the sonnet number. Remember that `$` matches the end of a string and `^` matches the beginning of the string. We have removed the leading whitespace from each line, so you need to match strings that consist entirely of roman numeral characters (capital letters IVXLCDM).

4.  How many sonnet lines (elements of `sk`) contain the word `fairest`? See [this example](http://r4ds.had.co.nz/strings.html#detect-matches){:target="_blank"}.

4.  Find four-letter words that begin and end with the letter `e`. You can restrict your search to words occurring in the middle of a line (words surrounded by spaces).

5.  Extract all the words that end with `'st`, like "deserv'st". Start by finding occurrences of `'st`, then add to your regular expression to match the entire word ending with `'st`.

5.  Print the sonnet lines in which a question mark or period occurs in the middle of the line. [This section](http://r4ds.had.co.nz/strings.html#basic-matches){:target="_blank"} of the textbook contains an example of how to match the period character.

6.  Print the lines that contain at least one of each vowel appearing in alphabetical order. Hints: `[aA]+` matches at least one `a` or `A`, and `.*` matches zero or more of any character except the newline character.
    Here is one of the lines that should be included in your result:

        ## [1] "Nature's bequest gives nothing, but doth lend,"

7.  Use `str_view_all` to highlight every word beginning with the letter `s` (lowercase or uppercase). To get started, run this command:

    ``` r
    str_view_all(sk, "\\b[sS]")
    ```

    Note that an apostrophe is considered a word boundary (matched by `\b`). Instead of using `\b` to define the beginning of a word, use a character class containing the uppercase and lowercase letters and the apostrophe character; any character *except* these characters will define the beginning of a word. Remember that `^` negates a character class: `[^abc]` matches any character *except* `a`, `b`, or `c`.

8.  Now use your expression from the previous exercise to highlight all words that begin with `s` or `S` and contain at least three letters.

9.  Using [`str_count`](http://stringr.tidyverse.org/reference/str_count.html#examples){:target="_blank"}, print the lines of `sk` containing at least two words that begin with `s` or `S` and contain at least three letters.