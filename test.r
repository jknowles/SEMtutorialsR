# Examples starting on p. 63
# Using proficiencyraw-female data

# Load library
library(lavaan)

# read in data
dat<-read.csv("proficiencyraw-female.csv")
# check data
head(dat)

# Write out model 1 in Lavaan syntax and store it
mymod1<-'GOALS2 ~ READSC1 + MATHSC1'
# estimate model by combining model and data
model1<-sem(mymod1, data=dat)

# Get some output
summary(model1)
parameterEstimates(model1)
summary(model1,standardized=TRUE,rsq=TRUE)
fitMeasures(model1)

# Model indices
modindices(model1)
resid(model1,type="standardized")

############################################
# Example 2
############################################

##################
# Specify model
# Syntax:
# ~ regress
# ~~ correlation
# =~ define latent variable
#
# from: http://www.structuralequations.com/resources/Lavaan_Syntax_Grace-BasicOnly.pdf

mymod2<-'GOALS2 ~ READSC1 + MATHSC1
        SATMATH ~ GOALS2 + MATHSC1 + READSC1
        READSC1 ~~ MATHSC1'

model2<-sem(mymod2, data=dat,fixed.x=FALSE)
summary(model2)
parameterEstimates(model2)

########################
# Example 3
########################

mymod3<-'MATHSC1 ~ READSC1
        SATMATH ~ MATHSC1 '

model3<-sem(mymod3, data=dat)
summary(model3,rsq=TRUE)
parameterEstimates(model3)
fitMeasures(model3)


#################
# Hands on Exercise

health<-read.csv("ENGLISHdata.csv")