Getting Started with Structural Equation Modeling
========================================================

## Jared E. Knowles
## jknowles@gmail.com


# Setting up your enviRonment

Getting started using structural equation modeling (SEM) in R can be daunting. There are 
lots of different packages for implementing SEM in R and there are different features 
of SEM that a user might be interested in implementing. A few packages you might come 
across can be found on the [CRAN Psychometrics Task View](http://cran.r-project.org/web/views/Psychometrics.html). 

For those who want to just dive in the `lavaan` package seems to offer the most 
comprehensive feature set for most SEM users and has a well thought out and easy 
to learn syntax for describing SEM models. 





```r
library(lavaan)
mat1 <- matrix(c(1, 0, 0, 0.6, 1, 0, 0.33, 0.63, 1), 3, 3, byrow = TRUE)

colnames(mat1) <- rownames(mat1) <- c("ILL", "IMM", "DEP")

myN <- 500
print(mat1)
```

```
##      ILL  IMM DEP
## ILL 1.00 0.00   0
## IMM 0.60 1.00   0
## DEP 0.33 0.63   1
```


We could fit two models to this data:

1. DEP influences IMM influences ILL
2. IMM influences ILL influences DEP



```r

mod1 <- "ILL ~ IMM\n        IMM ~ DEP"

mod1fit <- sem(mod1, sample.cov = mat1, sample.nobs = 500)

mod2 <- "DEP ~ ILL\n             ILL ~ IMM"

mod2fit <- sem(mod2, sample.cov = mat1, sample.nobs = 500)

summary(mod1fit)
```

```
## lavaan (0.5-13) converged normally after  12 iterations
## 
##   Number of observations                           500
## 
##   Estimator                                         ML
##   Minimum Function Test Statistic                2.994
##   Degrees of freedom                                 1
##   P-value (Chi-square)                           0.084
## 
## Parameter estimates:
## 
##   Information                                 Expected
##   Standard Errors                             Standard
## 
##                    Estimate  Std.err  Z-value  P(>|z|)
## Regressions:
##   ILL ~
##     IMM               0.600    0.036   16.771    0.000
##   IMM ~
##     DEP               0.630    0.035   18.140    0.000
## 
## Variances:
##     ILL               0.639    0.040
##     IMM               0.602    0.038
```

```r
summary(mod2fit)
```

```
## lavaan (0.5-13) converged normally after  11 iterations
## 
##   Number of observations                           500
## 
##   Estimator                                         ML
##   Minimum Function Test Statistic              198.180
##   Degrees of freedom                                 1
##   P-value (Chi-square)                           0.000
## 
## Parameter estimates:
## 
##   Information                                 Expected
##   Standard Errors                             Standard
## 
##                    Estimate  Std.err  Z-value  P(>|z|)
## Regressions:
##   DEP ~
##     ILL               0.330    0.042    7.817    0.000
##   ILL ~
##     IMM               0.600    0.036   16.771    0.000
## 
## Variances:
##     DEP               0.889    0.056
##     ILL               0.639    0.040
```



One of the best ways to understand an SEM model is to inspect the model visually 
using a path diagram. Luckily, this is easy to do in R:


```r
library(semPlot)
semPaths(mod1fit, what = "est", layout = "tree", title = TRUE, style = "LISREL")
```

![plot of chunk modelvis](figure/modelvis1.svg) 

```r
semPaths(mod2fit, what = "est", layout = "tree", title = TRUE, style = "LISREL")
```

![plot of chunk modelvis](figure/modelvis2.svg) 


These two simple path models look great. 


#cite(package="lavaan"")

