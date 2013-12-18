Tutorial: Doing Path Analysis in R
========================================================

# Introduction

In our previous tutorial we covered how to set up your R environment in order to 
fit structural equation models. Go ahead and [review that now](http://jaredknowles.com/journal/2013/9/1/latent-variable-analysis-with-r-getting-setup-with-lavaan)! For this section 
we will be using the `lavaan` package to fit models and the `semPlot` package to 
diagram them. [1]

In this example we are going to demonstrate how to do a path analysis using 
structural equation modeling fit through R. Path analysis is a crucial component to
learning [structural equation modeling](http://en.wikipedia.org/wiki/Structural_equation_modeling). 
Path analysis is a **special case** of SEM in which there are no latent variables 
constructed. 




# An Example Problem

Let's say we are at a bar discussing what data we need to collect to best 
understand the speed of a car. You have a friend who suggests that all we need 
to know is horsepower and we can figure out the quarter mile time for the vehicle. 
Another friend suggests that we need to know the fuel efficiency, weight, and 
then the horsepower. Another friend suggests the most parsimonious model is to 
know horsepower and weight, the rest is irrelevant. 

To settle this bet we collect the following data on the cars:


```r
data(mtcars)
head(mtcars)
```

```
##                    mpg cyl disp  hp drat    wt  qsec vs am gear carb
## Mazda RX4         21.0   6  160 110 3.90 2.620 16.46  0  1    4    4
## Mazda RX4 Wag     21.0   6  160 110 3.90 2.875 17.02  0  1    4    4
## Datsun 710        22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
## Hornet 4 Drive    21.4   6  258 110 3.08 3.215 19.44  1  0    3    1
## Hornet Sportabout 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2
## Valiant           18.1   6  225 105 2.76 3.460 20.22  1  0    3    1
```


# What is path analysis?

How can path analysis help us with this problem? Path analysis provides a way of 
specifying multiple regression models on observed data and evaluating the paths 
between the variables. For those who understand path analysis -- skip ahead -- 
for those who are not familiar, let's look at the diagram below.






```r
library(semPlot)
semPaths(mod1fit, "std", curvePivot = TRUE, exoVar = FALSE, exoCov = FALSE, 
    layout = "tree2", rotation = 2)
```

![plot of chunk modelvis](figure/modelvis.svg) 


Here we can see that weight and cylinder counts are positively related to 
displacement. Displacement and horsepower are both negatively related to 
miles per gallon. 

# How do we specify it?


```r

mod2 <- "disp ~ cyl + wt \n        mpg ~ disp + hp\n        qsec ~ wt + hp + mpg\n"
# Give lavaan the command to fit the model
mod2fit <- sem(mod2, data = mtcars)
```

```
## Warning: lavaan WARNING: some observed variances are (at least) a factor
## 1000 times larger than others; use varTable(fit) to investigate
```

```r

```




# Compare path analysis to other analyses


[1]: http://lavaan.ugent.be/ "The lavaan homepage"
