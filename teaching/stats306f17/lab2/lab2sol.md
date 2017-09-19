---
layout: coursepage
title: Lab 2
courseurl: /teaching/stats306f17/
coursename: Statistics 306, Fall 2017
parentname: Lab 2
parenturl: /teaching/stats306f17/lab2
---

# Lab 2 Solutions

## Exercise 1

All six of these plots map the same variables to the `x` and `y` aesthetics. 
```r
p <- ggplot(mpg, aes(x=displ, y=hwy))
```

We can now add to the object `p` the appropriate geoms to create the six plots.

```r 
p + geom_point() + geom_smooth(method='loess', se=F) # the x and y aesthetics are already mapped
p + geom_point() + geom_smooth(aes(group=drv), se=F)
p + geom_point(aes(color=drv)) + geom_smooth(aes(color=drv),se=F)
p + geom_point(aes(color=drv)) + geom_smooth(se=F)
p + geom_point(aes(color=drv)) + geom_smooth(aes(linetype=drv), se=F)
# the white points appear "under" the multicolor points 
# the order of geoms you add in your code is reflected in your plot
p + geom_point(color='white', size=4) + geom_point(aes(color=drv), size=1.5)
```
<img src = "../warmup-1.png">

## Exercise 2

You can use either `geom_point` or `geom_jitter` to plot the points.

```r 
ggplot(ChickWeight) +
  geom_point(aes(x=Time, y=weight, color=Diet), shape=1,
             position=position_jitter(width=0.25, height=0))+
  stat_summary(aes(x=Time,y=weight,color=Diet), 
  		geom='line',fun.y=mean) + 
  scale_color_hue(name='Mean weight',
                     breaks=1:4,
		     labels=c("Diet 1","Diet 2","Diet 3","Diet 4"))
```


```r
ggplot(ChickWeight) +
  geom_jitter(aes(x=Time, y=weight, color=Diet), 
  		width=0.25, height=0, shape=1) + 
  stat_summary(aes(x=Time, y=weight, color=Diet), geom='line', fun.y=mean) +
  scale_color_hue(name='Mean weight',
                     breaks=1:4, labels=c("Diet 1","Diet 2","Diet 3","Diet 4"))
```

<img src="../chick2-1.png" align="center">

