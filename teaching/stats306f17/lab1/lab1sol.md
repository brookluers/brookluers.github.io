---
layout: coursepage
title: Lab 1
courseurl: /teaching/stats306f17/
coursename: Statistics 306, Fall 2017
parentname: Lab 1
parenturl: /teaching/stats306f17/lab1
---

# Solution to Lab 1 Exercise

``` r
ggplot(grad)+
  geom_line(aes(x=year,y=GradRate, group=SCL_NAME,
                color=SCL_NAME=="University of Michigan-Ann Arbor")) + 
  facet_grid(Gender~Population)+
  scale_color_hue(name="",
                       breaks=c("FALSE","TRUE"),
                       labels=c("Other Big 10 schools","Michigan"))
```

![](../lab1exercise-1.png){: .center-image }

Here's a modification to help understand the `breaks` and `labels` arguments to `scale_color_hue`.

``` r
ggplot(grad)+
  geom_line(aes(x=year,y=GradRate, group=SCL_NAME,
                color=SCL_NAME=="University of Michigan-Ann Arbor")) + 
  facet_grid(Gender~Population)+
  scale_color_hue(name="",
                       breaks=c(TRUE),
                       labels=c("Michigan"))
```

![](../lab1exercisev2-1.png){: .center-image }