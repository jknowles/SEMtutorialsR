######################################
# Two Step Example
######################################


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

wheaton.model <- "
 # measurement model
 ses =~ education + sei
 alien67 =~ anomia67 + powerless67
 'delta*alien71' =~ anomia71 + powerless71

 # equations
 'delta*alien71' ~ alien67 + ses
 alien67 ~ ses

 # correlated residuals
 anomia67 ~~ anomia71
 powerless67 ~~ powerless71
 "
fit <- sem(wheaton.model, sample.cov=wheaton.cov, sample.nobs=932)
#summary(fit, standardized=TRUE)
