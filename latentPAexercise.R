# Motivation example 

names<-c('Per1','JS1','JS2','Mot1','Mot2','SE1','SE2','VI1')

covmat<-matrix(c(
1.000, 0, 0, 0 , 0, 0, 0, 0,      
0.418, 1.000, 0, 0, 0, 0, 0, 0,
0.394, 0.627, 1.000, 0 ,0 ,0 ,0 ,0,      
0.129, 0.202, 0.266, 1.000 , 0 ,0 ,0 ,0 ,
0.189, 0.284, 0.208, 0.365, 1.000 , 0 ,0 ,0,    
0.544, 0.281, 0.324, 0.201, 0.161, 1.000 , 0 ,0, 
0.507, 0.225, 0.314, 0.172, 0.174, 0.546, 1.000 ,0,
-0.357, -0.156, -0.038, -0.199, -0.277, -0.294, -0.174, 1.000),8, 8, byrow=TRUE)

colnames(covmat) <- rownames(covmat) <-names

mymod<-'Achieve =~ Mot1 + Mot2
        Esteem =~ SE1 + SE2
        Verbal =~ VI1
        Perform =~ Per1
        Satis =~ JS1 + JS2
        Perform =~ Esteem
        Satis =~ Verbal + Achieve + Perform
        #Per1 ~~ 1*Perform
        #VI1 ~~ 1*Perform
        Per1 ~~ 0*Per1
        VI1 ~~ 0*VI1
        Perform  ~~ 0*Esteem
        JS1 ~~ 1*Satis
        SE1 ~~ 1*Esteem
        Mot1~~ 1*Achieve
        Mot2~~ Achieve
        SE2 ~~ Esteem
        JS2 ~~ Satis
        Achieve ~~ Esteem
        Achieve ~~ Verbal
        Verbal ~~ Esteem
        Satis ~~ Satis'

fit<-lavaan(mymod, sample.cov=covmat,sample.nobs=122,mimic="EQS")
fitMeasures(fit)
parTable(fit)

require(psych)
lavaan.diagram(fit)

fit2<-lavaan(mymod,sample.cov=covmat,sample.nobs=122,
             auto.fix.first=TRUE,auto.fix.single=TRUE,
             int.ov.free=FALSE,mimic="EQS")


parTable(fit)

fit <- lavaan(mymod, sample.cov=covmat, sample.nobs=122,
              std.lv=FALSE,auto.fix.first=TRUE,
              auto.fix.single=TRUE,auto.var=FALSE,
              auto.cov.lv.x=FALSE, auto.cov.y=FALSE,int.ov.free=FALSE,
              mimic="EQS")

fit<-lavaan(mymod,sample.cov=covmat,sample.nobs=122,auto.var=FALSE,
            auto.cov.y=FALSE,auto.cov.lv.x=FALSE)

summary(fit, standardized=TRUE)
 