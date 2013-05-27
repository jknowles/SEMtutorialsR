SEM Course Notes
========================================================
## Professor Dan Bolt
## Ed Sci 212 1-2:30pm



```r
library(lavaan)
library(devtools)
library(ggplot2)
dev_mode()
library(semPlot)
```


# March 14th, 2013
### Confirmatory Factor Analysis
### sem13.pdf


```r
decmatrix <- matrix(c(1, 0.59, 0.35, 0.34, 0.63, 0.4, 0.28, 0.2, 0.11, -0.07, 
    0.59, 1, 0.42, 0.51, 0.49, 0.52, 0.31, 0.36, 0.21, 0.09, 0.35, 0.42, 1, 
    0.38, 0.19, 0.36, 0.73, 0.24, 0.44, -0.08, 0.34, 0.51, 0.38, 1, 0.29, 0.46, 
    0.27, 0.39, 0.17, 0.18, 0.63, 0.49, 0.19, 0.29, 1, 0.34, 0.17, 0.23, 0.13, 
    0.39, 0.4, 0.52, 0.36, 0.46, 0.34, 1, 0.33, 0.32, 0.18, 0, 0.28, 0.31, 0.73, 
    0.27, 0.17, 0.32, 1, 0.24, 0.34, -0.02, 0.2, 0.36, 0.24, 0.39, 0.23, 0.33, 
    0.24, 1, 0.24, -0.02, 0.11, 0.21, 0.44, 0.17, 0.13, 0.18, 0.34, 0.24, 1, 
    0.17, -0.07, 0.09, -0.08, 0.18, 0.39, 0, -0.02, -0.17, 0, 1), 10, 10, byrow = TRUE)

colnames(decmatrix) <- rownames(decmatrix) <- c("hund", "lj", "sp", "hj", "fourh", 
    "h110", "disc", "pv", "jav", "r1500")

myN <- 230

decmod2 <- " speed =~ hund + lj + fourh + h110 + r1500\nstrength =~ sp + disc + jav\njump =~ lj + hj + h110 +pv\nendur =~ r1500 + fourh\nendur~~ 0*speed\nendur~~ 0*strength\nendur~~ 0*jump\n"
decmodfit <- cfa(decmod2, sample.cov = decmatrix, sample.nobs = myN, mimic = "EQS", 
    sample.cov.rescale = FALSE, std.lv = FALSE)
```

```
## Warning: lavaan WARNING: could not compute standard errors!
```

```r
# summary(decmodfit)
```



How to do control variables in the model?

One way to do this outside of the SEM framework is to transform the data before fitting the SEM model. We use the residual of the regression of the control variable predicting each variable in the dataset, and output the unstandardized residual associated with the analysis. 

Then we calculate the covariance matrix of the residuals and analyze that as the data in the SEM framework. 

We use this framework when we aren't interested in the effect of the control variable and we have a theoretical reason to not be interested in this. 

#### Multigroup Analysis

This is splitting the sample and then fitting multiple models for subsets of the data, but correlations and covariances are allowed across models, and tests can be done if parameters are equal between the models or differ from one another. 

#### Validity and CFA

- Criteria Related Validity
  - Something
- Construct validity
  - Affirm the given measure is a valid measure of a construct


# March 21st, 2013
### Confirmatory Factor Analysis
### sem15.pdf

Some notes on the final project:

Item grouping is an important concern. Model misfit is more likely the more parameters you load onto a factor. 

You can create variable parcels by combining items into a group variable, which will decrease the chance of misfit and simplify issues of model fit. Composites of items make the categorical nature of the data less problematic because they behave more like continuous variables. 

#### Multi-trait Multi-methods and CFA

Unique validity variance $(U_{x_{i}\epsilon{j}})$ 

$$(U_{x_{i}\epsilon{j}}) = R^{2}_{x_{i}} - R^{2}_{x_{i}\epsilon_{j}}$$

To understand method and trait factors, you can use the square of the factor loading of the observed varaible on the method and the trait factors to explore the unique validity variance (defined above) for x.


# April 2nd, 2013
### Multigroup Measurement Models
### No Notes


Consider a regression analysis model: 

$$\x_{i} = \tau_{i} + \lambda_{i}\xi + \delta_{i}$$

With this $\tau$ represents the expected score on $x$ when $\xi = mean(\xi)$. In multigroup models we will add a parameter $\kappa$ that denotes the $mean(\xi)$. Thus we are expanding the LISREL model to include an augmented covariance matrix for the all the variables as well as a vector of the means for the variables. 



# April 4th, 2013
### Multigroup Measurement Models
### No Notes

$$r_{jk} = \frac{p_{jk} - p_{j}p_{k}}{\sqrt{p_j}(1-p_{j})p_{k}(1-p_{k})}$$

This is with a binary categorical variable how we can calculate the correlation of them. 


# April 16th, 2013
### Full LISREL Model Combining Measruement and Structural Parts
###

$$x=\lambda_{x}\xi + \delta$$
$$y=\lambda_{y}\eta + \epsilon$$

And a structural part:

$$\eta = \beta\eta + \gamma\xi + \Delta$$

We have two identification rules for this hybrid model:

1. *the t-rule*

If the number of model parameters is **greater** than the number of unique elements of the covariance matrix, the model is not identified. This is a necessary but not sufficient condition for identification. 

2. *Two-step rule* 

- Step 1. Reformulate the model as strictly a measurement model. Verify that the 
new measurement model is identified. 

- Step 2. Regard the structural part of the model as if it were an observed 
variable path analysis. Show that this model is identified. 

If both of these are true, then the hybrid model is statistically identified. 

# April 23rd, 2013
### Latent Growth Curves
### Notes

Useful for modeling linear / quadratic processes: 


```r
ages <- c(11, 12, 13, 14, 15)
lgcdat <- data.frame(age = sample(ages, 100, replace = TRUE))
lgcdat$tol <- 2.3 * lgcdat$age + rnorm(1, 25, 20)

qplot(age, tol, data = lgcdat) + geom_jitter() + geom_smooth()
```

```
## geom_smooth: method="auto" and size of largest group is <1000, so using
## loess. Use 'method = x' to change the smoothing method.
```

![plot of chunk growthcurves](figure/growthcurves.png) 



When we fit an LGC, we can interpret the correlations among the slope and 
intercept factors. A high correlation means starting high leads to a lower than 
expected or negative growth over time. 


```r
myN <- 168

lgmat <- matrix(c(3.17, 1.33, 1.75, 3.13, 2.30, 1.33, 3.95, 2.56, 2.36, 2.33, 1.75, 2.56, 7.24, 5.31, 4.79, 2.13, 2.36, 5.31, 8.57, 6.63, 2.3, 2.33, 4.79, 6.63, 8.73), 5,5, byrow=TRUE) 

colnames(lgmat) <- rownames(lgmat) <-c("age11", "age12", "age13", "age14", "age15")

lgmeans <- c(2.02, 2.26, 3.26, 4.17, 4.46)

mymod <- "

intercept =~ 1*age11 + 1*age12 + 1*age13 + 1*age14 + 1*age15

slope =~ 0*age11 + 1*age12 + 2*age13 + 3*age14 + 4*age15

slope ~~ 0*slope
intercept ~~ intercept
intercept ~~ 0*slope
"

lgmod <- growth(mymod, sample.cov=lgmat, sample.mean=lgmeans, sample.nobs=myN, 
                mimic="EQS")
```


We can see this model:


```r
semPaths(lgmod, what = "est", style = "lisrel", rotation = 4)
```

```
## Warning: longer object length is not a multiple of shorter object length
```

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-2.png) 


We can then fit random slope, random intercept and random slope and random intercept models to this data by manipulating the constraints on the factors. 

We also can look at our modification indices to see if the residuals correlate and consider freeing up these parameters to recognize this. 

In the model we can interpret the residuals of the observed variables as a measure of the reliability of the growth parameters at each point. If these drift then the linearity of the model can be called into question. 

We can extend the model further by fitting a quadratic term to the model. This is the same basic principle as above. We create a new latent variable where time is squared, that is, the loadings are squared. 


```r

mymod2 <- "

intercept =~ 1*age11 + 1*age12 + 1*age13 + 1*age14 + 1*age15

slope =~ 0*age11 + 1*age12 + 2*age13 + 3*age14 + 4*age15
q =~ 0*age11 + 1*age12 + 4*age13 + 9*age14 + 16*age15

slope ~~ 0*slope
intercept ~~ intercept
intercept ~~ 0*slope
q ~~ q
q ~~ 0*intercept + 0*slope
"

lgmodq <- growth(mymod2, sample.cov=lgmat, sample.mean=lgmeans, sample.nobs=myN, 
                mimic="EQS")
```

```
## Warning: lavaan WARNING: some estimated variances are negative
```

```r

```


Below is a quadratic model:


```r
semPaths(lgmodq, whatLabels = "est", style = "lisrel", rotation = 4)
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3.png) 



