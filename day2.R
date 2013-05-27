###############################
# Day 2 of Workshop
###############################

library(lavaan)

dat<-read.csv("proficiencyraw-female.csv")

names(dat)

cfamod1<-'READSC1 =~ reading
         READSC2 =~ reading
         READSC3 =~ reading
         READSC4 =~ reading
         READSC5 =~ reading'

cfamod1<-'reading =~ READSC1
         reading =~ READSC2
         reading =~ READSC3
         reading =~ READSC4
         reading =~ READSC5'

# estimate model by combining model and data
model1<-cfa(cfamod1, data=dat)
summary(model1)
parTable(model1)

# Example 2

cfamod2<-'# Factors
  reading =~ READSC1 + READSC2 + READSC3 + READSC4 + READSC5
  math =~ MATHSC1 + MATHSC2 + MATHSC3 + MATHSC4 + MATHSC5
  hist =~ HISTSC1 + HISTSC2 + HISTSC3 + HISTSC4 + HISTSC5
  sci =~ SCISC1 + SCISC2 + SCISC3 + SCISC4 + SCISC5'

model2<-cfa(cfamod2,data=dat)

summary(model2)
fitMeasures(model2)
parameterEstimates(model2,standardized=TRUE)


cfamod3<-'# Factors
  reading =~ READSC1 + READSC2 + READSC3 
  math =~ MATHSC1 + MATHSC2 + MATHSC3 
  hist =~ HISTSC1 + HISTSC2 + HISTSC3 
  sci =~ SCISC1 + SCISC2 + SCISC3 
   # Second order
  selfcon =~ reading+math+hist+sci'

model3<-cfa(cfamod3,data=dat,mimic="EQS",control=list(iterations=10000))

model3<-lavaan(cfamod3,data=dat,auto.var=TRUE,auto.cov.y=TRUE)

model3<-lavaan(cfamod3,data=dat,auto.cov.lv.x=FALSE,auto.var=TRUE,
               auto.cov.y=TRUE)

############################
# Residualized Factor Model
############################

cfamod4<-'# Factors
  reading =~ READSC1 + READSC2 + READSC3 + READSC4 +READSC5
  math =~ MATHSC1 + MATHSC2 + MATHSC3 + MATHSC4 + MATHSC5
  hist =~ HISTSC1 + HISTSC2 + HISTSC3 + HISTSC4 + HISTSC5
  sci =~ SCISC1 + SCISC2 + SCISC3 + SCISC4 + SCISC5
  goals =~ GOALS1 + GOALS2 + GOALS3 + GOALS4 + GOALS5
  mathprof =~ SATMATH + SATPROB + SATPROC
   # structural model
  goals ~ reading + math + hist + sci
  mathprof ~ reading + math + sci + goals
  # Variance constraints
  hist ~~ 0*math
  hist ~~ 0*sci
  # covariances
  READSC1 ~~ MATHSC1
  READSC1 ~~ SCISC1
  READSC1 ~~ HISTSC1
  HISTSC1 ~~ MATHSC1
  HISTSC1 ~~ SCISC1
  MATHSC1 ~~ SCISC1
  READSC2 ~~ MATHSC2
  READSC2 ~~ SCISC2
  READSC2 ~~ HISTSC2
  HISTSC2 ~~ MATHSC2
  HISTSC2 ~~ SCISC2
  MATHSC2 ~~ SCISC2
  READSC3 ~~ MATHSC3
  READSC3 ~~ SCISC3
  READSC3 ~~ HISTSC3
  HISTSC3 ~~ MATHSC3
  HISTSC3 ~~ SCISC3
  MATHSC3 ~~ SCISC3
  READSC4 ~~ MATHSC4
  READSC4 ~~ SCISC4
  READSC4 ~~ HISTSC4
  HISTSC4 ~~ MATHSC4
  HISTSC4 ~~ SCISC4
  MATHSC4 ~~ SCISC4
  READSC5 ~~ MATHSC5
  READSC5 ~~ SCISC5
  READSC5 ~~ HISTSC5
  HISTSC5 ~~ MATHSC5
  HISTSC5 ~~ SCISC5
  MATHSC5 ~~ SCISC5
  '

model4<-lavaan(cfamod4,data=dat,mimic="EQS",auto.var=FALSE,
               auto.cov.y=TRUE,auto.cov.lv.x=FALSE)

fitMeasures(model4)
parameterEstimates(model4)



library(MASS)
?mvrnorm
