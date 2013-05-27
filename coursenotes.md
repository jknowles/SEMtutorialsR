SEM Course Notes
========================================================
## Professor Dan Bolt
## Ed Sci 212 1-2:30pm


# January 22nd, 2012
### Introduction to Structural Equation Modeling
### sem1.pdf

Course notes are available in the notes folder. 

* Class will use the LISREL model for describing SEM
* Will explore both observed variable path analysis and latent variable/mixed variable analysis
* SEM at its heart is about relationships -- matrices of variances and covariances, so matrix algebra is important
* Kline text is the main text for the course

** Homework is a two week due date from date it is given **

** Final project is one month before finals part 1 is due; part 2 due during finals week**

[Longitudinal analysis in lavaan](http://r.789695.n4.nabble.com/Structural-equation-modeling-in-R-lavaan-sem-td3409642.html)

#### Introduction to SEM

In SEM we think of correlations and covariances among variables are the units we are interested in analyzing, not individual observations and cases.

In terms of model fit, we are always interested in how well the model recovers the covariance matrix. 

In OLS we estimate an intercept, a slope, and a variance to minimize the sum of squares.

SEM does something similar, but instead we estimate three parameters (a coefficient for how *x* predicts *y*, a variance for *x*, and a variance for error *$\zeta$*)

This is important because SEM models usually comprise a network of regression equations. The goal is to estimate parameters in a whole system of equations that accounts for the covariances between the observed variables.


```r
library(lavaan)
```

```
## Loading required package: MASS
```

```
## Loading required package: boot
```

```
## Loading required package: mnormt
```

```
## Loading required package: pbivnorm
```

```
## Loading required package: quadprog
```

```
## This is lavaan 0.5-11
```

```
## lavaan is BETA software! Please report any bugs.
```

```r

day1matrix <- matrix(c(1, 0, 0, 0.6, 1, 0, 0.33, 0.63, 1), 3, 3, byrow = TRUE)

colnames(day1matrix) <- rownames(day1matrix) <- c("ILL", "IMM", "DEP")

myN <- 500
print(day1matrix)
```

```
##      ILL  IMM DEP
## ILL 1.00 0.00   0
## IMM 0.60 1.00   0
## DEP 0.33 0.63   1
```

```r
# ILL = illness IMM= immune system DEP= depression
```


We could fit two models to this data:

1. DEP influences IMM influences ILL
2. IMM influences ILL influences DEP


```r

day1mod1 <- "ILL ~ IMM\nIMM ~ DEP"

day1mod1fit <- sem(day1mod1, sample.cov = day1matrix, sample.nobs = 500)

day1mod2 <- "DEP ~ ILL\nILL ~ IMM"

day1mod2fit <- sem(day1mod2, sample.cov = day1matrix, sample.nobs = 500)

summary(day1mod1fit)
```

```
## lavaan (0.5-11) converged normally after  12 iterations
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
print(day1mod1fit)
```

```
## lavaan (0.5-11) converged normally after  12 iterations
## 
##   Number of observations                           500
## 
##   Estimator                                         ML
##   Minimum Function Test Statistic                2.994
##   Degrees of freedom                                 1
##   P-value (Chi-square)                           0.084
```

```r
summary(day1mod2fit)
```

```
## lavaan (0.5-11) converged normally after   9 iterations
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

```r
print(day1mod2fit)
```

```
## lavaan (0.5-11) converged normally after   9 iterations
## 
##   Number of observations                           500
## 
##   Estimator                                         ML
##   Minimum Function Test Statistic              198.180
##   Degrees of freedom                                 1
##   P-value (Chi-square)                           0.000
```


We have failed to show that the model does not fit, that is, there is no evidence from the data to indicate model I is inappropriate. With model II, we do reject the null hypothesis, which is that model II fits the data. 

Suppose model III comes along:


```r
# library(psych)
day1mod3 <- "DEP ~ IMM\nIMM ~ ILL"

day1mod3fit <- sem(day1mod3, sample.cov = day1matrix, sample.nobs = 500)
print(day1mod3fit)
```

```
## lavaan (0.5-11) converged normally after  12 iterations
## 
##   Number of observations                           500
## 
##   Estimator                                         ML
##   Minimum Function Test Statistic                2.994
##   Degrees of freedom                                 1
##   P-value (Chi-square)                           0.084
```

```r
summary(day1mod3fit)
```

```
## lavaan (0.5-11) converged normally after  12 iterations
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
##   DEP ~
##     IMM               0.630    0.035   18.140    0.000
##   IMM ~
##     ILL               0.600    0.036   16.771    0.000
## 
## Variances:
##     DEP               0.602    0.038
##     IMM               0.639    0.040
```

```r
# lavaan.diagram(day1mod1fit,simple=FALSE)
```


This shows that model I is not the only model that fits the data. Model III fits the data as well. So in this case we cannot use the data to distinguish between these models, but we can use theory.

In this example it only makes sense that the IMMUNE system should be influencing ILLNESS, and that the relationship should not run in the other direction.

SEM can account for measurement error by having multiple measures to allow the construction of a latent variable to examine the relationship of our constructs, and not their measurements alone. 




# January 27th, 2012
### Matrix Algebra Review
### sem2.pdf

Matrix algebra is a cornerstone of the LISREL model. 

Square matrices are easy.


```r
mat1 <- matrix(c(1, 0, 0, 0.6, 1, 0, 0.33, 0.63, 1), 3, 3, byrow = TRUE)

mat2 <- matrix(c(7, 0, 0, 0.4, 2.8, 0, 0.3, 0.9, 1.3), 3, 3, byrow = TRUE)

# Multiply
mat1 %*% mat2
```

```
##       [,1]  [,2] [,3]
## [1,] 7.000 0.000  0.0
## [2,] 4.600 2.800  0.0
## [3,] 2.862 2.664  1.3
```

```r

# Transpose
t(mat1)
```

```
##      [,1] [,2] [,3]
## [1,]    1  0.6 0.33
## [2,]    0  1.0 0.63
## [3,]    0  0.0 1.00
```

```r

# Transpose and multiply

t(mat1) %*% mat2
```

```
##       [,1]  [,2]  [,3]
## [1,] 7.339 1.977 0.429
## [2,] 0.589 3.367 0.819
## [3,] 0.300 0.900 1.300
```



Non-square matrices


```r
mat3 <- matrix(c(1, 0, 0, 0.6, 1, 0, 0.33, 0.63, 1), 3, 3, byrow = TRUE)

mat4 <- matrix(c(7, 0, 0.4, 2.8, 0.3, 0.9), 3, 2, byrow = TRUE)

mat3 %*% mat4
```

```
##       [,1]  [,2]
## [1,] 7.000 0.000
## [2,] 4.600 2.800
## [3,] 2.862 2.664
```

```r
# works
mat4 %*% mat3
```

```
## Error: non-conformable arguments
```

```r
# does not

mat4 %*% t(mat3)
```

```
## Error: non-conformable arguments
```

```r
# does not

t(mat4) %*% mat3
```

```
##       [,1]  [,2] [,3]
## [1,] 7.339 0.589  0.3
## [2,] 1.977 3.367  0.9
```


In R we can also take covariances. 


```r
vec1 <- c(1, 4, 5, -2)  # mu = 2
vec2 <- c(8, 14, 10, 4)  # mu = 9
mu1 <- mean(vec1)
mu2 <- mean(vec2)
n <- length(vec1)

mycov <- n^-1 * sum((vec1 - mu1) * (vec2 - mu2))
mycov
```

```
## [1] 8.5
```

```r

# In R this is different since n-1 is used
cov(vec1, vec2, method = "pearson")
```

```
## [1] 11.33
```


Be careful in R, we need a different formula to do this:


```r
cov_adj <- function(x, y, ...) {
    mu1 <- mean(x)
    mu2 <- mean(y)
    n <- length(x)
    mycov <- n^-1 * sum((x - mu1) * (y - mu2))
    print(mycov)
}

cov_adj(vec1, vec2)
```

```
## [1] 8.5
```


The variance of a variable is the covariance of that variable with itself. This is represented on the diagonal of the variance-covariance matrix. Variances always have to be positive. A variance of 0 means the variable is a constant.

A correlation simply divides the covariances by the square root of the variance for each variable.


```r
sig1 <- sd(vec1)
sig2 <- sd(vec2)
mycor <- n^-1 * sum(((vec1 - mu1)/sig1) * (vec2 - mu2)/sig2)
mycor
```

```
## [1] 0.6456
```

```r

cor(vec1, vec2)
```

```
## [1] 0.8608
```


We see again that in R the correlation is using a funky denominator (which only matters in small group sizes).


```r
# THIS IS WRONG!
cor_adj <- function(x, y, ...) {
    mu1 <- mean(x)
    mu2 <- mean(y)
    n <- length(x)
    sig1 <- sqrt(sum(x^2 - mu1))
    sig2 <- sqrt(sum(y^2 - mu2))
    mycor <- n^-1 * sum(((x - mu1)/sig1) * ((y - mu2)/sig2))
    print(mycor)
}

cor_adj(vec1, vec2)

```


#### Consider Regression

$$y = \alpha + \gamma x + \zeta$$

We want to look at what the $cov(x,y)$ is that can estimate the parameters of this regression. How can we reparameterize it? We have two variables $x$ and $y$ and we also have a variance of $\zeta$ known as $\psi$. The variance of $x$ is represented as $\phi$.

Now we can rewrite the first equation above as:

$$cov(x,y) = cov(x, \alpha + \gamma x + \zeta)$$

We can apply covariance rules to rewrite this as:

$$cov(x,y) = cov(x,\alpha) + cov(x, \gamma x) + cov(x,\zeta)$$

Since $\alpha$ is a parameter, and a constant, this reduces to 0, because of the first rule of covariances (any variable's covariance with a constant is 0). The second covariance reduces to $\gamma * \phi$. In regression we assume the final $cov(x,\zeta)$$ is 0 - by assumption. 

In the end if this model is true, then the $cov(x,y) = \gamma * \phi$, or $\gamma$ multiplied by the variance of $var(x)$.


```r
# create an identity matrix
diag(5)
```

```
##      [,1] [,2] [,3] [,4] [,5]
## [1,]    1    0    0    0    0
## [2,]    0    1    0    0    0
## [3,]    0    0    1    0    0
## [4,]    0    0    0    1    0
## [5,]    0    0    0    0    1
```

```r

# Transpose
mat1
```

```
##      [,1] [,2] [,3]
## [1,] 1.00 0.00    0
## [2,] 0.60 1.00    0
## [3,] 0.33 0.63    1
```

```r
t(mat1)
```

```
##      [,1] [,2] [,3]
## [1,]    1  0.6 0.33
## [2,]    0  1.0 0.63
## [3,]    0  0.0 1.00
```

```r

# Inverse
solve(mat1)
```

```
##        [,1]  [,2] [,3]
## [1,]  1.000  0.00    0
## [2,] -0.600  1.00    0
## [3,]  0.048 -0.63    1
```




# January 29th, 2012
### The LISREL Model
### sem3.pdf

Two model types in LISREL: a **structural** model (sometimes called latent variable model) and a **measurement** model.

The structural part describes the relationships between the latent variable, while the measurement part describes how latent variables are related to observed variables. 

The model is concerned with the causal associations among the latent variables. 

Placeholder for real LISREL model image below:


```
## Dev mode: ON
```

```
## Loading required package: qgraph
```

```
## Loading Tcl/Tk interface ...
```

```
## done
```

```
## This is semPlot 0.3.1
```

```
## semPlot is BETA software! Please report any bugs.
```

![plot of chunk LISRELplot](figure/LISRELplot.png) 

```
## Dev mode: OFF
```


Key components are circles for latent variables, squares/rectangles for observed variables, path arrows for connections between them, and coefficients between them.

In LISREL we make a distinction between **endogenous** and **exogenous** variables. Variables which are **endogenous** are predicted by another variable in the model, **exogenous** variables are not predicted by another variable. 

#### Four Coefficient Matrices

$$\eta=\beta_{\eta}+\Gamma \xi + \zeta$$
$$x=\delta_{x} \psi + \delta$$
$$y=\delta_{y} \eta + \epsilon$$


In this model we have four coefficient matrices and we can specify them using equations above. We have other matrices as well that we can use to understand the model

#### Covariance Matrices

Four square symmetric matrices that are part of the models, for $\xi$, $\zeta$, for $\delta$ and $\epsilon$ terms. 

The matrix of $\zeta$ s is defined by the number of $\zeta$ s and is known as the $\Psi$ matrix. 

The matrix of $\xi$ s is known as the, defined by the number of $\xi$ s we have. This is known as the $\Phi$ matrix. 

The matrix of $\delta$ is known as $\theta_{\delta}$. This is defined by the number of $\delta$ terms in the model. 

The matrix for the $\epsilon$ s is known as the $\theta_{\epsilon}$ matrix. This is defined by the number of $\epsilon$ terms. The diagonal has all the variances, the off diagonal includes any relationships between the $\epsilon$ terms that are "unanalyzed associations".

$$p = number of ys$$
$$q = number of xs$$
$$m = number of \eta 's$$
$$n = number of \xi 's$$


# February 5th, 2013
### LISREL Notation
### sem5.pdf

In a measurement model, every latent variable is an exogenous latent variable. 


```r

model2 <- "\ninvisible(\".BeGiN_TiDy_IdEnTiFiEr_HaHaHa# latent variable definitions.HaHaHa_EnD_TiDy_IdEnTiFiEr\")\nind60 =~ x1 + x2 + x3\ndem60 =~ y1 + a*y2 + b*y3 + c*y4\ndem65 =~ y5 + a*y6 + b*y7 + c*y8\ninvisible(\".BeGiN_TiDy_IdEnTiFiEr_HaHaHa.HaHaHa_EnD_TiDy_IdEnTiFiEr\")\ninvisible(\".BeGiN_TiDy_IdEnTiFiEr_HaHaHa# residual correlations.HaHaHa_EnD_TiDy_IdEnTiFiEr\")\ny1 ~~ y5\ny2 ~~ y4 + y6\ny3 ~~ y7\ny4 ~~ y8\ny6 ~~ y8\n"

fit2 <- sem(model2, data = PoliticalDemocracy)
```

```
## Error: 1:89: unexpected symbol 1: ~
## y5+a*y6+b*y7+c*y8invisible(".BeGiN_TiDy_IdEnTiFiEr_HaHaHa.HaHaHa_EnD_TiDy_IdEnTiFiEr")invisible
## ^
```

```r
semPaths(fit2, whatLabels = "est", style = "lisrel", residuals = TRUE)
```

```
## Error: object 'fit2' not found
```



No longer need a $\Beta$ matrix, no $\Psi$ matrix, and no $\Gamma$ matrix. Also the $\lambda_{y}$ matrix is no longer necessary because there are no endogenous latent variables in the model, and we are not making any predictions. 

Three remaining matrices that we need are the $\theta^{\delta}$, the $\Phi$, and the $\lambda_{x}$ matrices. 


### Observed Variable Path Analysis

In this analysis we assume the variables are measured without error. 



```r
model3 <- "\ninvisible(\".BeGiN_TiDy_IdEnTiFiEr_HaHaHa# latent variable definitions.HaHaHa_EnD_TiDy_IdEnTiFiEr\")\ny1 ~  x1 + x2 + x3\ny2 ~ y1 + y2 + y3\ninvisible(\".BeGiN_TiDy_IdEnTiFiEr_HaHaHa.HaHaHa_EnD_TiDy_IdEnTiFiEr\")\ninvisible(\".BeGiN_TiDy_IdEnTiFiEr_HaHaHa# residual correlations y1 ~~ y5 y2 ~~ y4 + y6 y3 ~~ y7 y4 ~~ y8 y6 ~~ y8.HaHaHa_EnD_TiDy_IdEnTiFiEr\")\n"

fit3 <- sem(model3, data = PoliticalDemocracy)
```

```
## Error: 1:80: unexpected symbol 1: ~
## y1+y2+y3invisible(".BeGiN_TiDy_IdEnTiFiEr_HaHaHa.HaHaHa_EnD_TiDy_IdEnTiFiEr")invisible
## ^
```

```r
semPaths(fit3, whatLabels = "est", style = "lisrel", residuals = TRUE)
```

```
## Error: object 'fit3' not found
```


For path analysis we only need our $\Beta$, $\Gamma$, $\phi$ and $\Psi$ matrices. 

X or exogenous variables are variables with arrows exiting them, endogenous or y variables are variables with arrows entering them.

N * (N+1) / 2 gives you the size of the variance, covariance matrix. 

E.g.  4 variables = (4*5/20) = 10 


# February 7th, 2013
### A LISREL Model
### sem6.pdf

This class we will look at a LISREL model of political democracy


```r
data(PoliticalDemocracy)
names(PoliticalDemocracy)
```

```
##  [1] "y1" "y2" "y3" "y4" "y5" "y6" "y7" "y8" "x1" "x2" "x3"
```


Below, this should be the model spelled out for `lavaan`:


```r
model <- ' 
  # latent variable definitions
     ind60 =~ x1 + x2 + x3
     dem60 =~ y1 + y2 + y3 + y4
     dem65 =~ y5 + y6 + y7 + y8

  # regressions
    dem60 ~ ind60
    dem65 ~ ind60 + dem60

  # residual correlations
    y1 ~~ y5
    y2 ~~ y4 + y6
    y3 ~~ y7
    y4 ~~ y8
    y6 ~~ y8
'
```


And here is the call to fit the model:


```r
fit1 <- sem(model, data = PoliticalDemocracy, representation = "LISREL", mimic = "EQS")
# LISREL gives us compatible output
myplot <- semPaths(fit1, whatLabels = "est", style = "lisrel", residuals = TRUE)
```

![plot of chunk polidemmodelfit](figure/polidemmodelfit1.png) 

```r

myplot$labels[grepl("d65", myplot$labels)] <- paste0("*x", 1)
myplot$labels[!grepl("x|y|z", myplot$labels)] <- paste0("*h", 1:2)
# myplot$labels[grepl('x',myplot$labels)] <- paste0('*n',1:3)
qgraph(myplot)
```

![plot of chunk polidemmodelfit](figure/polidemmodelfit2.png) 


Let's inspect the output. For S4 objects we need to see what we get


```r
slotNames(fit1)
```

```
## [1] "call"        "timing"      "Options"     "ParTable"    "Data"       
## [6] "SampleStats" "Model"       "Cache"       "Fit"
```

```r
slotNames(fit1@Model)
```

```
##  [1] "GLIST"            "dimNames"         "isSymmetric"     
##  [4] "mmSize"           "representation"   "meanstructure"   
##  [7] "categorical"      "ngroups"          "nmat"            
## [10] "nvar"             "num.idx"          "th.idx"          
## [13] "nx.free"          "nx.unco"          "nx.user"         
## [16] "m.free.idx"       "x.free.idx"       "m.unco.idx"      
## [19] "x.unco.idx"       "m.user.idx"       "x.user.idx"      
## [22] "x.def.idx"        "x.ceq.idx"        "x.cin.idx"       
## [25] "eq.constraints"   "eq.constraints.K" "def.function"    
## [28] "ceq.function"     "ceq.jacobian"     "cin.function"    
## [31] "cin.jacobian"     "con.jac"          "con.lambda"      
## [34] "nexo"             "fixed.x"
```

```r
names(fit1@Model@GLIST)
```

```
## [1] "lambda" "theta"  "psi"    "beta"
```

```r
fit1@Model@GLIST$beta
```

```
##        [,1]   [,2] [,3]
## [1,] 0.0000 0.0000    0
## [2,] 1.4830 0.0000    0
## [3,] 0.5723 0.8373    0
```

```r
slotNames(fit1@SampleStats)
```

```
##  [1] "CAT"          "var"          "cov"          "mean"        
##  [5] "th"           "th.nox"       "th.idx"       "th.names"    
##  [9] "slopes"       "cov.x"        "bifreq"       "nobs"        
## [13] "ntotal"       "ngroups"      "icov"         "cov.log.det" 
## [17] "WLS.obs"      "WLS.V"        "NACOV"        "missing.flag"
## [21] "missing"      "missing.h1"
```

```r
fit1@SampleStats@cov
```

```
## [[1]]
##         [,1]   [,2]   [,3]   [,4]    [,5]    [,6]   [,7]  [,8]    [,9]
##  [1,] 0.5371 0.9904 0.8234 0.7344  0.6195  0.7869  1.150 1.082  0.8528
##  [2,] 0.9904 2.2821 1.8061 1.2734  1.4913  1.5519  2.241 2.064  1.8055
##  [3,] 0.8234 1.8061 1.9760 0.9115  1.1698  1.0391  1.838 1.583  1.5721
##  [4,] 0.7344 1.2734 0.9115 6.8786  6.2514  5.8388  6.089 5.064  5.7458
##  [5,] 0.6195 1.4913 1.1698 6.2514 15.5798  5.8386  9.509 5.603  9.3863
##  [6,] 0.7869 1.5519 1.0391 5.8388  5.8386 10.7642  6.688 4.939  4.7274
##  [7,] 1.1505 2.2410 1.8380 6.0886  9.5086  6.6879 11.219 5.702  7.4422
##  [8,] 1.0816 2.0637 1.5835 5.0638  5.6031  4.9390  5.702 6.826  4.9768
##  [9,] 0.8528 1.8055 1.5721 5.7458  9.3863  4.7274  7.442 4.977 11.3753
## [10,] 0.9368 1.9956 1.6260 5.8119  7.5355  7.0064  7.488 5.821  6.7481
## [11,] 1.1029 2.2342 1.6922 5.6711  7.7582  5.6391  8.013 5.339  8.2468
##         [,10]  [,11]
##  [1,]  0.9368  1.103
##  [2,]  1.9956  2.234
##  [3,]  1.6260  1.692
##  [4,]  5.8119  5.671
##  [5,]  7.5355  7.758
##  [6,]  7.0064  5.639
##  [7,]  7.4880  8.013
##  [8,]  5.8214  5.339
##  [9,]  6.7481  8.247
## [10,] 10.7994  7.592
## [11,]  7.5924 10.534
```

```r
parameterEstimates(fit1, standardized = TRUE)
```

```
##      lhs op   rhs   est    se      z pvalue ci.lower ci.upper std.lv
## 1  ind60 =~    x1 1.000 0.000     NA     NA    1.000    1.000  0.674
## 2  ind60 =~    x2 2.180 0.139 15.636  0.000    1.907    2.454  1.470
## 3  ind60 =~    x3 1.819 0.153 11.887  0.000    1.519    2.118  1.226
## 4  dem60 =~    y1 1.000 0.000     NA     NA    1.000    1.000  2.238
## 5  dem60 =~    y2 1.257 0.184  6.842  0.000    0.897    1.617  2.813
## 6  dem60 =~    y3 1.058 0.152  6.940  0.000    0.759    1.356  2.367
## 7  dem60 =~    y4 1.265 0.146  8.664  0.000    0.979    1.551  2.831
## 8  dem65 =~    y5 1.000 0.000     NA     NA    1.000    1.000  2.117
## 9  dem65 =~    y6 1.186 0.170  6.977  0.000    0.853    1.519  2.510
## 10 dem65 =~    y7 1.280 0.161  7.948  0.000    0.964    1.595  2.709
## 11 dem65 =~    y8 1.266 0.159  7.953  0.000    0.954    1.578  2.680
## 12 dem60  ~ ind60 1.483 0.402  3.691  0.000    0.695    2.271  0.447
## 13 dem65  ~ ind60 0.572 0.223  2.569  0.010    0.136    1.009  0.182
## 14 dem65  ~ dem60 0.837 0.099  8.457  0.000    0.643    1.031  0.885
## 15    y1 ~~    y5 0.632 0.366  1.729  0.084   -0.084    1.349  0.632
## 16    y2 ~~    y4 1.331 0.716  1.858  0.063   -0.073    2.735  1.331
## 17    y2 ~~    y6 2.182 0.749  2.914  0.004    0.715    3.649  2.182
## 18    y3 ~~    y7 0.806 0.620  1.299  0.194   -0.410    2.021  0.806
## 19    y4 ~~    y8 0.353 0.451  0.782  0.434   -0.531    1.237  0.353
## 20    y6 ~~    y8 1.374 0.580  2.370  0.018    0.238    2.511  1.374
## 21    x1 ~~    x1 0.083 0.020  4.156  0.000    0.044    0.122  0.083
## 22    x2 ~~    x2 0.121 0.071  1.707  0.088   -0.018    0.261  0.121
## 23    x3 ~~    x3 0.473 0.092  5.142  0.000    0.293    0.653  0.473
## 24    y1 ~~    y1 1.917 0.453  4.227  0.000    1.028    2.806  1.917
## 25    y2 ~~    y2 7.473 1.402  5.331  0.000    4.725   10.220  7.473
## 26    y3 ~~    y3 5.136 0.971  5.289  0.000    3.233    7.039  5.136
## 27    y4 ~~    y4 3.190 0.754  4.232  0.000    1.713    4.668  3.190
## 28    y5 ~~    y5 2.383 0.490  4.863  0.000    1.422    3.343  2.383
## 29    y6 ~~    y6 5.021 0.933  5.382  0.000    3.193    6.849  5.021
## 30    y7 ~~    y7 3.478 0.727  4.781  0.000    2.052    4.903  3.478
## 31    y8 ~~    y8 3.298 0.709  4.653  0.000    1.909    4.687  3.298
## 32 ind60 ~~ ind60 0.454 0.088  5.138  0.000    0.281    0.628  1.000
## 33 dem60 ~~ dem60 4.009 0.940  4.266  0.000    2.167    5.852  0.800
## 34 dem65 ~~ dem65 0.175 0.219  0.798  0.425   -0.255    0.604  0.039
##    std.all std.nox
## 1    0.920   0.920
## 2    0.973   0.973
## 3    0.872   0.872
## 4    0.850   0.850
## 5    0.717   0.717
## 6    0.722   0.722
## 7    0.846   0.846
## 8    0.808   0.808
## 9    0.746   0.746
## 10   0.824   0.824
## 11   0.828   0.828
## 12   0.447   0.447
## 13   0.182   0.182
## 14   0.885   0.885
## 15   0.296   0.296
## 16   0.273   0.273
## 17   0.356   0.356
## 18   0.191   0.191
## 19   0.109   0.109
## 20   0.338   0.338
## 21   0.154   0.154
## 22   0.053   0.053
## 23   0.239   0.239
## 24   0.277   0.277
## 25   0.486   0.486
## 26   0.478   0.478
## 27   0.285   0.285
## 28   0.347   0.347
## 29   0.443   0.443
## 30   0.322   0.322
## 31   0.315   0.315
## 32   1.000   1.000
## 33   0.800   0.800
## 34   0.039   0.039
```

```r
fitMeasures(fit1)
```

```
##              fmin             chisq                df            pvalue 
##             0.254            37.617            35.000             0.350 
##    baseline.chisq       baseline.df   baseline.pvalue               cfi 
##           720.912            55.000             0.000             0.996 
##               tli              nnfi               rfi               nfi 
##             0.994             0.994             0.918             0.948 
##              pnfi               ifi               rni              logl 
##             0.603             0.996             0.996         -1553.328 
## unrestricted.logl              npar               aic               bic 
##         -1534.265            31.000          3168.656          3240.498 
##            ntotal              bic2             rmsea    rmsea.ci.lower 
##            75.000          3142.794             0.032             0.000 
##    rmsea.ci.upper      rmsea.pvalue               rmr        rmr_nomean 
##             0.091             0.632             0.280             0.280 
##              srmr       srmr_nomean             cn_05             cn_01 
##             0.044             0.044           100.294           115.328 
##               gfi              agfi              pgfi               mfi 
##             0.923             0.854             0.489             0.983 
##              ecvi 
##             1.328
```

```r
resid(fit1, type = "normalized")
```

```
## $cov
##    x1     x2     x3     y1     y2     y3     y4     y5     y6     y7    
## x1  0.000                                                               
## x2 -0.003  0.000                                                        
## x3 -0.020  0.012  0.000                                                 
## y1  0.254 -0.408 -0.717 -0.042                                          
## y2 -0.666 -0.501 -0.566 -0.031  0.077                                   
## y3  0.253 -0.004 -0.471  0.450 -0.500  0.014                            
## y4  0.952  0.598  0.493 -0.200  0.115 -0.009  0.008                     
## y5  1.013  0.517  0.182 -0.151 -0.113  0.083 -0.075 -0.035              
## y6 -0.413 -0.522 -0.357  0.259  0.202 -0.732  0.367 -0.289  0.029       
## y7 -0.396 -0.493 -0.517 -0.040  0.098  0.001  0.049  0.073 -0.034 -0.009
## y8  0.195 -0.067 -0.367 -0.108  0.273 -0.355  0.209 -0.289  0.092  0.220
##    y8    
## x1       
## x2       
## x3       
## y1       
## y2       
## y3       
## y4       
## y5       
## y6       
## y7       
## y8  0.031
## 
## $mean
## x1 x2 x3 y1 y2 y3 y4 y5 y6 y7 y8 
##  0  0  0  0  0  0  0  0  0  0  0
```

```r
inspect(fit1, "rsquare")
```

```
##     x1     x2     x3     y1     y2     y3     y4     y5     y6     y7 
## 0.8461 0.9468 0.7606 0.7232 0.5143 0.5218 0.7152 0.6529 0.5565 0.6784 
##     y8  dem60  dem65 
## 0.6853 0.1996 0.9610
```



# February 19th, 2013
### Identification Conditions for Path Models
### sem8.pdf

We can divide rules about identification conditions into necessary conditions, and sufficient conditions:

1. **Recursive rule** - when we have errors that are uncorrelated with each other, and no feedback loops / reciprocal paths; models that are recursive are *statistically identified*
2. **The algebraic method** - specify the model and look at the relationship between parameters and covariance elements and make sure that for each parameter it is defined only by elements within the covariance matrix. 

For a three variable mediation model [x1 -> y1 -> y2] :

$$\phi_{11} = \sigma_{11}$$
$$\gamma_{11} = \frac{\sigma_{21}}{\sigma_{21}}$$
$$\psi_{11} = \sigma_{22} - \frac{\sigma_{21}}{\sigma_{21}} - \sigma_{11}$$
$$\beta_{21} = ??$$
$$\psi_{22} = ??$$

3. **The t-rule** - if you have more parameters than you have elements in your variance-covariance matrix, then the model is not identified. Cannot be used of evidence that a model is identified, only that it is not identified.
4. **The null $\beta$ rule** -  if the $\beta$ matrix contains all 0s, then the model is is identified. This is a sufficient condition, but not a necessary one. As long as I don't have ys predicting other ys, then the model is statistically identified. 

#### The next two rules only apply when all elements of the $\psi$ matrix are unrestricted

5. **The order rule** - (necessary, but not sufficient for identification) construct a matrix with as many rows as y variables, and then include the identity matrix minus $\beta$ and the negation of the $\Gamma$ matrix. Columns will correspond to the four variables. 

$$ \begin{matrix} var & y1 & y2 & x1 & x2 \\ y1 & I - \beta & & - & \Gamma \\
   y2 &  &  & & & \end{matrix}$$
   
Which in practice looks like: 

$$\begin{matrix} var & y1 & y2 & x1 & x2 \\ y1 & 1 & 0 & -\gamma_{11} & -\gamma_{12} \\ y2 & -\beta_{21}  & 1  & -\gamma_{21} & -\gamma_{22} \end{matrix}$$

The number of 0s in each row must be greater than *p-1*. Constraining paths will allow the above model to be identified potentially. Changing $\beta{_21}$ to 0 would do this. 
6. **The rank rule** - Delete all columns in the above matrix where there is a 0. If the rank of the resulting matrix is equal to *p-1* then the equation is identified, and if all equations are identified, then the model is identified. 

For all of these, empiricial underidentification can occur if the data turns out to violate some of the assumptions that the identification rules may assume. 

#### Practically speaking, we can use methods in statistical software to help us with this. 

- Software model checks
- Rerun the analysis using different starting values and test for changes in parameter estimates, if parameter estimates change, then there is a problem likely
- Fit the model to the observed covariance matrix, then fit another model using the fitted covariance matrix from that model, and fit the same model again, parameter estimates should remain constant


```r
fit1 <- sem(model, data = PoliticalDemocracy, representation = "LISREL", mimic = "EQS")
newdata <- fitted.values(fit1)$cov

fit2 <- sem(model, sample.cov = newdata, sample.nobs = nrow(PoliticalDemocracy), 
    representation = "LISREL", mimic = "EQS")

coef(fit1) - coef(fit2)
```

```
##    ind60=~x2    ind60=~x3    dem60=~y2    dem60=~y3    dem60=~y4 
##            0            0            0            0            0 
##    dem65=~y6    dem65=~y7    dem65=~y8  dem60~ind60  dem65~ind60 
##            0            0            0            0            0 
##  dem65~dem60       y1~~y5       y2~~y4       y2~~y6       y3~~y7 
##            0            0            0            0            0 
##       y4~~y8       y6~~y8       x1~~x1       x2~~x2       x3~~x3 
##            0            0            0            0            0 
##       y1~~y1       y2~~y2       y3~~y3       y4~~y4       y5~~y5 
##            0            0            0            0            0 
##       y6~~y6       y7~~y7       y8~~y8 ind60~~ind60 dem60~~dem60 
##            0            0            0            0            0 
## dem65~~dem65 
##            0
```

 
In this example, because the difference between the coefficients is 0 across the board, this indicates the model did converge well. 

- Another option is to look at standard errors in the solution. Extremely large standard errors are  a problem. 


```r
inspect(fit1, "se")
```

```
## $lambda
##    ind60 dem60 dem65
## x1 0.000 0.000 0.000
## x2 0.139 0.000 0.000
## x3 0.153 0.000 0.000
## y1 0.000 0.000 0.000
## y2 0.000 0.184 0.000
## y3 0.000 0.152 0.000
## y4 0.000 0.146 0.000
## y5 0.000 0.000 0.000
## y6 0.000 0.000 0.170
## y7 0.000 0.000 0.161
## y8 0.000 0.000 0.159
## 
## $theta
##    x1    x2    x3    y1    y2    y3    y4    y5    y6    y7    y8   
## x1 0.020                                                            
## x2 0.000 0.071                                                      
## x3 0.000 0.000 0.092                                                
## y1 0.000 0.000 0.000 0.453                                          
## y2 0.000 0.000 0.000 0.000 1.402                                    
## y3 0.000 0.000 0.000 0.000 0.000 0.971                              
## y4 0.000 0.000 0.000 0.000 0.716 0.000 0.754                        
## y5 0.000 0.000 0.000 0.366 0.000 0.000 0.000 0.490                  
## y6 0.000 0.000 0.000 0.000 0.749 0.000 0.000 0.000 0.933            
## y7 0.000 0.000 0.000 0.000 0.000 0.620 0.000 0.000 0.000 0.727      
## y8 0.000 0.000 0.000 0.000 0.000 0.000 0.451 0.000 0.580 0.000 0.709
## 
## $psi
##       ind60 dem60 dem65
## ind60 0.088            
## dem60 0.000 0.940      
## dem65 0.000 0.000 0.219
## 
## $beta
##       ind60 dem60 dem65
## ind60 0.000 0.000     0
## dem60 0.402 0.000     0
## dem65 0.223 0.099     0
```



- Improper solutions, where variances are negative, which is not possible.

#### Block Recursive Models

A special class of models that rules have special identification rules applied to them. Block recursive models are:
- Models where y variables can be grouped into blocks where the $\zeta$ have errors correlated, and 
- unidirectional effects between the blocks

#### How to handle identification problems
- Add x variables
- Constrain correlations between $\psi$ s that are involved in feedback loops to 0
- Constrain parameters as being equal, being 0, or proportional
- Delete paths from the model

# February 21rd, 2013
### Estimation Methods
#### sem9.pdf

The whole purpose in estimating a model is to find values of parameters that leads to a fitted covariance matrix that is as close as possible to the data (covariance matrix) 

The sampel covariance matrix is referred to as $S$ and the fitted covariance matrix is $\hat\Sigma$. Our goal is to minimize the distance between $S$ and $\hat\Sigma$. 

In `lavaan` we have a number of arguments we can pass to the `estimator` option in the fitting function for these: "ML", "GLS", "WLS", "ULS", and "DWLS" are the main. 

#### Maximum Likelihood

Often the preferred estimator. Robust to non-normality in terms of estimates, but not statistical tests (need robustness for this). 

Parameter estimates have some nice properties: 
- consistent
- asymptotically unbiased
- efficient
- normally distributed
- scale free
- scale invariant
- a $\Chi^{2}$ test is possible to evaluate model fit

ML output is more susceptible to improper solutions than other methods.

#### Unweighted Least Squares (ULS or LS)

Minimize the sum of squares in the residual matrix. Viewed as less attractive sometimes. 

Advantages:
- statistically consistent parameter estimates
- no distributional assumptions of variables
- simplicity
- can compute tests for statistical significance of model parameters

Disadvantages:
- parameter estimates and fit index are scale dependent
- parameter estimates are not asymptoticaly efficient
- no overall test of fit

#### Generalized Least Squares (GLS)

A weight matrix $W$ is used to modify the LS estimator to control for unequal variances or nonzero correlations among equation errors

Very similar to maximum likelihood.

Advantages:
- Parameter estimates are consistent, efficient, and unbiased
- asymptotically normally distributed
- Scale invariant and scale free (weight matrix compensates for weights to variables)
- $\chi^{2}$ test is available for model fit

Disadvantages:
- Not that different from ML

# February 25th, 2013
### Model Fit Statistics
#### sem10.pdf


#### $\chi^{2}$ Test 

Essentially a yes or no test of whether the model fits or not. Which can be a very conservative way to evaluate model fit. The smaller the number, the better the model fit.

- $\chi^{2}$ test has no upper bound
- $\chi^{2}$ is very influenced by sample size, as the sample gets larger, the same amount of model fit implies a larger amount of misfit; large samples with small differences can claim misfit
- Heavily influenced by the number of parameters in the model, as the number of parameters increases, the $\chi^{2}$ value decreases. This will make us tend always toward a more complex model. 

#### Other of goodness of fit indices

- Are often normalized
- Often include penalties for model complexity to capture the belief we prefer simpler models over more complex models

These indices can be classified and grouped:

*Incremental Fit Indices*
- Make comparisons to null model, which in this case is defined as the model where the correlations between all the variables in the model is 0
- Now we compare how much the proposed model improves the fit on the model with no paths at all
- Thus we get a $\chi^{2}_{M}$ for the model we propose and a $\chi^{2}_{N}$ for the null model; and we also have a $df_{M}$ and $df_{N}$
- The null model will always be simpler and have fewer degrees of freedom
- Examples: NFI (Bentler-Bonnett Normed Fit Index) scaling the reduction in model $\chi^{2}$ compared to the null model $\frac{\chi^{2}_{N} - \chi^{2}_{M}}{\chi^{2}_{N}}$
- 0 is a poor fit, 1 is a good fit 0.95 is ideal
- NNFI (Tucker-Lewis Index TLI)  $\frac{\frac{\chi^{2}_{N}}{df_{N}} - \frac{\chi^{2}_{M}}{df_{M}}}{\frac{\chi^{2}_{N}}{df_{N}}-1}$
- This index can climb above 1
- Parsimony normed fit index (PNFI) $\frac{df_{M}}{df_{N}}NFI$
- CFI (Comparative Fit Index) $$1-\frac{Max(\chi^{2}_{M}-df_{M}, 0)}{Max(\chi^{2}_{M}-df_{M},\chi^{2}_{N}-df_{N}, 0)}$$
- Incremental Fit Index
- Relative Fit Index
- CFI and NNFI are most popular to report

*Indices based on population error of approximation*

Based on a recognition that we do not have a population. Adjust the minimum fit function to account for the errors in the approximation of the population. 

- PDF
- RMSEA 

$$\sqrt{\frac{\frac{\chi^{2}_{M}}{n}}{df_{M}}-\frac{1}{n}}$$
- Low values imply a well fitting model 

*Indices based on model parsimony*

Used to compare models of different model fits.

- Akaike Information Criterion (AIC) $\chi^{2}_{M} - 2df_{M}$
- Consistent AIC (CAIC) $\chi^{2}_{M} - log_{c}(n+1)df_{M}$
- When reported it shows the AIC of the independence and the saturated model to show the bounds around the AIC for the current model
- The smaller the value the better here, and the more simple models have a better chance due to the penalty for having additional model parameters
- BIC and others fall within this category

*Residual-based Indices*
- Root mean square residual (RMR): average size of the residual on the estimated covariance matrix (scale dependent, smaller is better)
- Standardized RMR (SRMR) is the average size of the residual on the estimated correlation matrix (between 0 and 1); ideally .05 or lower
- Goodness of Fit Index (GFI) proportion of variability in the covariance elements explained by the model fitted covariance $S$ basedo on the data and the $\hat\Sigma$ matrix estimated by the model
- GFI takes comparison between $S$ and $\hat\Sigma$ elements, looking at their correlation, square it, and get the GFI: regressing the $S$ values onto the $\hat\Sigma$ values (0.95 or higher are good values)
- Adjusted GFI (AGFI) corrected for shrinkage

#### Remember

- Model fit indices refer to the fit of the whole model. Pieces of the model may fit quite well. A single path that does not fit well can dramatically reduce model fit indices. 
- Fit indices may be good, but parameter estimates may be inconsistent with theoretical expectations. Always need to inspect path estimates.
- Indices can indicate good fit, but predictive power can be low still. This occurs especially when you have a large sample, but the relationships among your variables is not that large. This improves over the independence model, but does not explain much real variation in your outcome.

#### Model Fit Recommendation

Hu and Bentler (1999)

- Two index approach 
- SRMR of .08 or lower indicates fit
- Report another index (one of TLI, CFI, RMSEA)
- Suggested cutoffs TLI(NNI) .95 / CFI .9 / RMSEA .06

#### Hierarchical Relations Among models

Two models are considered hierarchically related if you can go from one to the other only by adding or only by deleting paths (you can't add *and* remove paths)

One model can be viewed as a special case of another model where one or more paths are fixed to 0 

From initial model, define one that is a special case of the initial model and one that is a non-hierarchically related model (remove and add a path to initial model).


# February 28th, 2013
### Model Fit Statistics
#### sem10.pdf

We often want to inspect the residuals to see which paths are causing problems in model fit. Large positive residuals indicate the path is underestimating the relationship between two variables. Restricting paths could be good to fix this. Large negative residuals indicate the path is overestimating the relationship between two variables, and adding a path between these variables may help. 

To compare two models we can do a statistical test with hierarchically related models. A $\chi^{2}$ fit test says that we are evaluating a null hypothesis where there is no difference in the fit between the two models. The difference between the two $\chi^{2}$ is distributed $\chi^{2}$, we can conduct a test of significance using this difference, and the difference in the degrees of freedom in the two models as the $df$ for the $\chi^{2}$ test. 

#### Modification Fit Indices

Based on looking at how model fit will change in response to constraining paths. This is estimated using a LaGrange Multiplier. For a modification index about **3.84** would suggest that if that path is added, the $\chi^{2}$ should drop enough to make a statistically significant difference. 

#### Equivalent Models

However, a better way to do this is to use modification indices. 

# March 7th, 2013
### Measurement Models
### sem12.pdf

Why should we be concerned about measurement error?

The relationship between $\gamma_{1}^{*}$ and $\gamma_{1}$ is affected by other factors, and not just the reliability or measurement error of $x_{1}$ and $y$. 



```r
measmatrix <- matrix(c(1, 0.6, 0.33, 0.4, 0.6, 1, 0.63, 0.21, 0.33, 0.63, 1, 
    0.11, 0.4, 0.21, 0.11, 1), 4, 4, byrow = TRUE)

colnames(measmatrix) <- rownames(measmatrix) <- c("x1", "x2", "x3", "y1")

myN <- 500


measmod <- "y1 ~ factor\neta =~ x1 + x2 + x3"

measmodfit <- sem(measmod, sample.cov = measmatrix, sample.nobs = myN)
```

```
## found:  x1 x2 x3 y1 
## expected:  x1 x2 x3 y1 factor
```

```
## Error: lavaan ERROR: rownames of covariance matrix do not match the model!
## found: x1 x2 x3 y1 expected: x1 x2 x3 y1 factor
```

```r

summary(measmodfit)
```

```
## Error: error in evaluating the argument 'object' in selecting a method for
## function 'summary': Error: object 'measmodfit' not found
```


Let's look at the plot of this:


```r
dev_mode()
```

```
## Dev mode: ON
```

```r
library(semPlot)
semPaths(measmodfit, whatLabels = "est", style = "lisrel")
```

```
## Error: object 'measmodfit' not found
```

```r
dev_mode()
```

```
## Dev mode: OFF
```


Now consider the example in the notes:


```r
jobsatis <- matrix(c(1, 0.2, 0.2, 1), 2, 2, byrow = TRUE)

colnames(jobsatis) <- rownames(jobsatis) <- c("JSO", "ACHO")

myN <- 200

jobmod <- " JSL ~ ACHL\nJSL =~ JSO\nACHL =~ ACHO"

jobmodfit <- cfa(jobmod, sample.cov = jobsatis, sample.nobs = myN)

summary(jobmodfit)
```

```
## lavaan (0.5-11) converged normally after  34 iterations
## 
##   Number of observations                           200
## 
##   Estimator                                         ML
##   Minimum Function Test Statistic                0.000
##   Degrees of freedom                                 0
##   P-value (Chi-square)                           0.000
## 
## Parameter estimates:
## 
##   Information                                 Expected
##   Standard Errors                             Standard
## 
##                    Estimate  Std.err  Z-value  P(>|z|)
## Latent variables:
##   JSL =~
##     JSO               1.000
##   ACHL =~
##     ACHO              1.000
## 
## Regressions:
##   JSL ~
##     ACHL              0.200    0.069    2.887    0.004
## 
## Variances:
##     JSO               0.000
##     ACHO              0.000
##     JSL               0.955    0.096
##     ACHL              0.995    0.099
```


And another model with mediation:



```r
mediationmod <- matrix(c(1, 0.07, 0.07, 0.07, 1, 0.2, 0.07, 0.2, 1), 3, 3, byrow = TRUE)

colnames(mediationmod) <- rownames(mediationmod) <- c("EXPO", "JSO", "ACHO")

myN <- 200

medmod <- " JSL ~ EXPL\nEXPL ~ ACHL\nEXPL =~ EXPO\nJSL =~ JSO\nACHL =~ ACHO"

medmodfit <- cfa(medmod, sample.cov = mediationmod, sample.nobs = myN)

summary(medmodfit)
```

```
## lavaan (0.5-11) converged normally after  31 iterations
## 
##   Number of observations                           200
## 
##   Estimator                                         ML
##   Minimum Function Test Statistic                7.840
##   Degrees of freedom                                 1
##   P-value (Chi-square)                           0.005
## 
## Parameter estimates:
## 
##   Information                                 Expected
##   Standard Errors                             Standard
## 
##                    Estimate  Std.err  Z-value  P(>|z|)
## Latent variables:
##   EXPL =~
##     EXPO              1.000
##   JSL =~
##     JSO               1.000
##   ACHL =~
##     ACHO              1.000
## 
## Regressions:
##   JSL ~
##     EXPL              0.070    0.071    0.992    0.321
##   EXPL ~
##     ACHL              0.070    0.071    0.992    0.321
## 
## Variances:
##     EXPO              0.000
##     JSO               0.000
##     ACHO              0.000
##     EXPL              0.990    0.099
##     JSL               0.990    0.099
##     ACHL              0.995    0.099
```


Remember that LISREL will set the error variances of the latent variables to being free. 

#### Pure Measurement Models

Everything to estimate a pure measurment model can be estimated with three matrices: $\lambda_{x}$, $\phi$ and the $\theta_{\delta}$. 

In a measurement model there is a distinction between reflective indicators of latent variables and formative indicators of latent variables. The paths go from the latent variable out to the measures of the effect, because the latent variable is leading to the higher observed values of the measures. The latent variable is fixed and observed variables are **reflections** of it. 

$\xi$ is a reflection of the $x$'s. 

There are lots of settings where a group of variables are considered as part of a collection, and people want to think about them giving a latent variable a definition, and these are known as **formative** indicators of the latent variable. 

In the **formative** setting there is no expectation about the correlation structure among the $x$'s. In a **reflective** setting, $\xi$ is defined by the correlation among the $x$'s and will wind up having no variance itself if the $x$'s do not have much correlation. 

To check for this: 
1. Check the fit of the measurement model. 
2. There will be large heterogeneity among the loadings and won't line up with descriptive statistics. 
3. There will be a very low variance for the $\xi$. 
4. You can't figure out how to interpret what the variable means. 

If you have a **formative** setting, then you can create a composite of these variables and use that composite as an observed variable in your model as an observed and not a latent variable. 

$$x_{1} = \lambda_{11}\xi_{1} + \delta_{1}$$
$$x_{2} = \lambda_{21}\xi_{1} + \delta_{2}$$

Now we need to understand that we can reduce down the covariance among the $x$'s using the variables we already have:

$$Cov(x_{1}, x_{2}) = Cov(\lambda_{11}\xi_{1} + \delta_{1}, \lambda_{21}\xi_{1} + \delta_{2})$$

Which reduced to: 

$$\lambda{11}\lambda{21}\phi_{11}$$

This is the product of the two factor loadings of the $x$'s on the $\xi$ and the $Var(\xi)$. In some cases, we set $Var(\xi) = 1$ in which case this covariance is actually equal entirely to $\lambda_{11}\lambda_{21}$. 


# March 12th, 2013
### Confirmatory Factor Analysis
### sem13.pdf


```r
cfamatrix1 <- matrix(c(1, 0.39, 0.35, 0.21, 0.32, 0.4, 0.39, 0.39, 0.39, 1, 
    0.67, 0.11, 0.27, 0.29, 0.32, 0.29, 0.35, 0.67, 1, 0.16, 0.29, 0.28, 0.3, 
    0.37, 0.21, 0.11, 0.16, 1, 0.38, 0.3, 0.31, 0.42, 0.32, 0.27, 0.29, 0.38, 
    1, 0.47, 0.42, 0.48, 0.4, 0.29, 0.28, 0.3, 0.47, 1, 0.41, 0.51, 0.39, 0.32, 
    0.3, 0.31, 0.42, 0.41, 1, 0.42, 0.39, 0.29, 0.37, 0.42, 0.48, 0.51, 0.42, 
    1), 8, 8, byrow = TRUE)

colnames(cfamatrix1) <- rownames(cfamatrix1) <- c("handmov", "numbrec", "wordord", 
    "gesclos", "triangle", "spatmem", "matanalg", "photser")

myN <- 200

cfamod1 <- " Sequent =~ handmov + numbrec + wordord\nSimult =~ gesclos + triangle+ spatmem + matanalg+ photser\n"
cfamodfit <- cfa(cfamod1, sample.cov = cfamatrix1, sample.nobs = myN, mimic = "EQS", 
    sample.cov.rescale = FALSE)

summary(cfamodfit, standardized = TRUE)
```

```
## lavaan (0.5-11) converged normally after  31 iterations
## 
##   Number of observations                           200
## 
##   Estimator                                         ML
##   Minimum Function Test Statistic               38.644
##   Degrees of freedom                                19
##   P-value (Chi-square)                           0.005
## 
## Parameter estimates:
## 
##   Information                                 Expected
##   Standard Errors                             Standard
## 
##                    Estimate  Std.err  Z-value  P(>|z|)   Std.lv  Std.all
## Latent variables:
##   Sequent =~
##     handmov           1.000                               0.500    0.500
##     numbrec           1.615    0.254    6.369    0.000    0.807    0.807
##     wordord           1.612    0.253    6.370    0.000    0.806    0.806
##   Simult =~
##     gesclos           1.000                               0.508    0.508
##     triangle          1.336    0.219    6.102    0.000    0.678    0.678
##     spatmem           1.333    0.219    6.095    0.000    0.677    0.677
##     matanalg          1.200    0.208    5.778    0.000    0.609    0.609
##     photser           1.453    0.230    6.321    0.000    0.738    0.738
## 
## Covariances:
##   Sequent ~~
##     Simult            0.146    0.037    3.950    0.000    0.574    0.574
## 
## Variances:
##     handmov           0.750    0.082    9.200    0.000    0.750    0.750
##     numbrec           0.348    0.072    4.847    0.000    0.348    0.348
##     wordord           0.350    0.072    4.886    0.000    0.350    0.350
##     gesclos           0.742    0.081    9.138    0.000    0.742    0.742
##     triangle          0.540    0.068    7.885    0.000    0.540    0.540
##     spatmem           0.542    0.069    7.903    0.000    0.542    0.542
##     matanalg          0.629    0.074    8.539    0.000    0.629    0.629
##     photser           0.456    0.065    7.041    0.000    0.456    0.456
##     Sequent           0.250    0.073    3.405    0.001    1.000    1.000
##     Simult            0.258    0.075    3.452    0.001    1.000    1.000
```




To extract the squared multiple correlations:


```r
library(psych)
```

```
## Warning: package 'psych' was built under R version 2.15.3
```

```
## Attaching package: 'psych'
```

```
## The following object(s) are masked from 'package:boot':
## 
## logit
```

```r
smc(cfamatrix1, covar = TRUE)
```

```
##  handmov  numbrec  wordord  gesclos triangle  spatmem matanalg  photser 
##   0.2960   0.4874   0.4856   0.2319   0.3591   0.3734   0.3152   0.4315
```


To look for misfit, let's examine the residuals:


```r
resid(cfamodfit, type = "normalized")  # type can be switched between
```

```
## $cov
##          handmv numbrc wordrd gescls tringl spatmm matnlg photsr
## handmov   0.000                                                 
## numbrec  -0.181  0.000                                          
## wordord  -0.707  0.225  0.000                                   
## gesclos   0.891 -1.759 -1.043  0.000                            
## triangle  1.690 -0.604 -0.321  0.471  0.000                     
## spatmem   2.704 -0.319 -0.448 -0.590  0.140  0.000              
## matanalg  2.836  0.508  0.247  0.009  0.087 -0.031  0.000       
## photser   2.350 -0.703  0.383  0.592 -0.261  0.134 -0.386  0.000
## 
## $mean
##  handmov  numbrec  wordord  gesclos triangle  spatmem matanalg  photser 
##        0        0        0        0        0        0        0        0
```

```r
# normalized, standardized, and raw

mi <- modindices(cfamodfit)
# Phi
mi[mi$op == "=~" & mi$mi > 0, ]
```

```
##        lhs   op      rhs     mi    epc sepc.lv sepc.all sepc.nox
## 1     <NA> <NA>     <NA>     NA     NA      NA       NA       NA
## 2  Sequent   =~  gesclos  3.857 -0.379  -0.190   -0.190   -0.190
## 3  Sequent   =~ triangle  0.199 -0.081  -0.041   -0.041   -0.041
## 4  Sequent   =~  spatmem  0.002  0.008   0.004    0.004    0.004
## 5  Sequent   =~ matanalg  2.119  0.271   0.135    0.135    0.135
## 6  Sequent   =~  photser  0.217  0.084   0.042    0.042    0.042
## 7   Simult   =~  handmov 21.722  0.893   0.453    0.453    0.453
## 8   Simult   =~  numbrec  7.172 -0.601  -0.305   -0.305   -0.305
## 9   Simult   =~  wordord  0.490 -0.157  -0.080   -0.080   -0.080
## 10    <NA> <NA>     <NA>     NA     NA      NA       NA       NA
```

```r
# Theta-Delta
mi[mi$op == "~~" & mi$mi > 0, ]
```

```
##         lhs op      rhs     mi    epc sepc.lv sepc.all sepc.nox
## 1   handmov ~~  numbrec  0.490 -0.047  -0.047   -0.047   -0.047
## 2   handmov ~~  wordord  7.172 -0.178  -0.178   -0.178   -0.178
## 3   handmov ~~  gesclos  0.049  0.013   0.013    0.013    0.013
## 4   handmov ~~ triangle  0.065  0.013   0.013    0.013    0.013
## 5   handmov ~~  spatmem  4.407  0.107   0.107    0.107    0.107
## 6   handmov ~~ matanalg  3.370  0.098   0.098    0.098    0.098
## 7   handmov ~~  photser  1.302  0.056   0.056    0.056    0.056
## 8   numbrec ~~  wordord 21.722  0.690   0.690    0.690    0.690
## 9   numbrec ~~  gesclos  2.439 -0.073  -0.073   -0.073   -0.073
## 10  numbrec ~~ triangle  0.069 -0.011  -0.011   -0.011   -0.011
## 11  numbrec ~~  spatmem  0.021  0.006   0.006    0.006    0.006
## 12  numbrec ~~ matanalg  0.862  0.041   0.041    0.041    0.041
## 13  numbrec ~~  photser  2.615 -0.067  -0.067   -0.067   -0.067
## 14  wordord ~~  gesclos  0.089 -0.014  -0.014   -0.014   -0.014
## 15  wordord ~~ triangle  0.065 -0.011  -0.011   -0.011   -0.011
## 16  wordord ~~  spatmem  1.429 -0.051  -0.051   -0.051   -0.051
## 17  wordord ~~ matanalg  0.353 -0.026  -0.026   -0.026   -0.026
## 18  wordord ~~  photser  2.005  0.058   0.058    0.058    0.058
## 19  gesclos ~~ triangle  0.950  0.053   0.053    0.053    0.053
## 20  gesclos ~~  spatmem  1.409 -0.065  -0.065   -0.065   -0.065
## 21  gesclos ~~ matanalg  0.000  0.001   0.001    0.001    0.001
## 22  gesclos ~~  photser  2.133  0.079   0.079    0.079    0.079
## 23 triangle ~~  spatmem  0.167  0.022   0.022    0.022    0.022
## 24 triangle ~~ matanalg  0.045  0.012   0.012    0.012    0.012
## 25 triangle ~~  photser  0.884 -0.053  -0.053   -0.053   -0.053
## 26  spatmem ~~ matanalg  0.006 -0.004  -0.004   -0.004   -0.004
## 27  spatmem ~~  photser  0.237  0.027   0.027    0.027    0.027
## 28 matanalg ~~  photser  1.281 -0.062  -0.062   -0.062   -0.062
```


Factor loading decisions can be somewhat arbitrary, but should be driven by theory. It becomes more complicated to interpret the factors the more associations you free up among them and the variables loading onto them, so being careful and thinking about interpretation is an important element to consider. The best fitting measurement model may not be the most useful for interpretation. 

#### Misspecification Example of CFA



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

decmod1 <- " speed =~ hund + lj + fourh + h110 + r1500\nstrength =~ sp + disc + jav\njump =~ lj + hj + h110 +pv\n"
decmodfit <- cfa(decmod1, sample.cov = decmatrix, sample.nobs = myN, mimic = "EQS", 
    sample.cov.rescale = FALSE, std.lv = FALSE)
summary(decmodfit)
```

```
## lavaan (0.5-11) converged normally after  46 iterations
## 
##   Number of observations                           230
## 
##   Estimator                                         ML
##   Minimum Function Test Statistic              159.845
##   Degrees of freedom                                30
##   P-value (Chi-square)                           0.000
## 
## Parameter estimates:
## 
##   Information                                 Expected
##   Standard Errors                             Standard
## 
##                    Estimate  Std.err  Z-value  P(>|z|)
## Latent variables:
##   speed =~
##     hund              1.000
##     lj                0.500    0.100    5.013    0.000
##     fourh             0.877    0.090    9.715    0.000
##     h110              0.196    0.110    1.774    0.076
##     r1500             0.131    0.086    1.532    0.126
##   strength =~
##     sp                1.000
##     disc              0.789    0.075   10.458    0.000
##     jav               0.476    0.071    6.657    0.000
##   jump =~
##     lj                1.000
##     hj                1.476    0.278    5.316    0.000
##     h110              1.152    0.232    4.954    0.000
##     pv                1.059    0.218    4.863    0.000
## 
## Covariances:
##   speed ~~
##     strength          0.307    0.066    4.612    0.000
##     jump              0.222    0.058    3.809    0.000
##   strength ~~
##     jump              0.257    0.057    4.476    0.000
## 
## Variances:
##     hund              0.282    0.064    4.380    0.000
##     lj                0.362    0.048    7.603    0.000
##     fourh             0.448    0.062    7.257    0.000
##     h110              0.558    0.065    8.570    0.000
##     r1500             0.988    0.093   10.672    0.000
##     sp                0.076    0.071    1.070    0.285
##     disc              0.424    0.059    7.146    0.000
##     jav               0.791    0.076   10.365    0.000
##     hj                0.484    0.071    6.780    0.000
##     pv                0.734    0.077    9.502    0.000
##     speed             0.718    0.107    6.697    0.000
##     strength          0.924    0.117    7.918    0.000
##     jump              0.237    0.076    3.125    0.002
```


Let's inspect the residuals:


```r
resid(decmodfit, type = "normalized")
```

```
## $cov
##       hund   lj     fourh  h110   r1500  sp     disc   jav    hj    
## hund   0.000                                                        
## lj     0.120  0.000                                                 
## fourh  0.005 -0.264  0.000                                          
## h110   0.050  0.076 -0.111  0.000                                   
## r1500 -2.486  0.207  4.342 -0.790  0.000                            
## sp     0.622  0.140 -1.175  0.059 -1.818  0.000                     
## disc   0.555 -0.197 -0.631  0.565 -0.785  0.004  0.000              
## jav   -0.541  0.221  0.031  0.159 -0.291  0.001 -0.105  0.000       
## hj     0.174 -0.045  0.035 -0.093  2.044  0.013 -0.428 -0.156  0.000
## pv    -0.526 -0.120  0.349 -0.072 -3.004 -0.473  0.372  1.630  0.279
##       pv    
## hund        
## lj          
## fourh       
## h110        
## r1500       
## sp          
## disc        
## jav         
## hj          
## pv     0.000
## 
## $mean
##  hund    lj fourh  h110 r1500    sp  disc   jav    hj    pv 
##     0     0     0     0     0     0     0     0     0     0
```


Mimic the LISREL output:


```r
inspect(decmodfit, "parameters")
```

```
## $lambda
##       speed strngt  jump
## hund  1.000  0.000 0.000
## lj    0.500  0.000 1.000
## fourh 0.877  0.000 0.000
## h110  0.196  0.000 1.152
## r1500 0.131  0.000 0.000
## sp    0.000  1.000 0.000
## disc  0.000  0.789 0.000
## jav   0.000  0.476 0.000
## hj    0.000  0.000 1.476
## pv    0.000  0.000 1.059
## 
## $theta
##       hund  lj    fourh h110  r1500 sp    disc  jav   hj    pv   
## hund  0.282                                                      
## lj    0.000 0.362                                                
## fourh 0.000 0.000 0.448                                          
## h110  0.000 0.000 0.000 0.558                                    
## r1500 0.000 0.000 0.000 0.000 0.988                              
## sp    0.000 0.000 0.000 0.000 0.000 0.076                        
## disc  0.000 0.000 0.000 0.000 0.000 0.000 0.424                  
## jav   0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.791            
## hj    0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.484      
## pv    0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.734
## 
## $psi
##          speed strngt jump 
## speed    0.718             
## strength 0.307 0.924       
## jump     0.222 0.257  0.237
```


