################3
 # Two step example
##############3
library(psych)
library(lavaan)

# Read in data
wheaton.cov <- matrix(c(
  11.834, 0, 0, 0, 0, 0,
  6.947, 9.364, 0, 0, 0, 0,
  6.819, 5.091, 12.532, 0, 0, 0,
  4.783, 5.028, 7.495, 9.986, 0, 0,
  -3.839, -3.889, -3.841, -3.625, 9.610, 0,
  -21.899, -18.831, -21.748, -18.775, 35.522, 450.288),
                      6, 6, byrow=TRUE)
colnames(wheaton.cov) <- rownames(wheaton.cov) <-
  c("anomia67", "powerless67", "anomia71",
    "powerless71", "education", "sei")

# model 1
basiccfa <- '
# measurement model
ses =~ education + sei
alien67 =~ anomia67 + equal(alien71 =~ powerless71)*powerless67
alien71 =~ anomia71 + powerless71
# equations
alien71 ~~ alien67 
alien67 ~~ ses
alien71 ~~ ses
'

fitm <- sem(basiccfa, sample.cov=wheaton.cov, sample.nobs=932)
summary(fitm, standardized=TRUE)
parameterEstimates(fitm,standardized=TRUE)
fitMeasures(fitm)

lavaan.diagram(fitm,simple=FALSE)

# model 1
improvedcfa <- '
# measurement model
ses =~ education + sei
alien67 =~ anomia67 + powerless67
alien71 =~ anomia71 + powerless71

# correlated residuals
anomia67 ~~ anomia71
powerless67 ~~ powerless71

# equations

alien71 ~ alien67 + ses
alien67 ~ ses'


fitm2 <- sem(improvedcfa, sample.cov=wheaton.cov, sample.nobs=932)
summary(fitm2, standardized=TRUE)
parameterEstimates(fitm2,standardized=TRUE)
fitMeasures(fitm2)

lavaan.diagram(fitm2,simple=FALSE)


