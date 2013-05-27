# Multigroup Analyses

grl<-read.csv("proficiencyraw-female.csv")
boy<-read.csv("proficiencyraw-male.csv")

mod<-'GOALS2 ~ READSC1 + HISTSC1 + MATHSC1 + SCISC1
     SATMATH ~ GOALS2 + SCISC1 + MATHSC1 + READSC1
    READSC1 ~~ MATHSC1
    READSC1 ~~ READSC1
    READSC1 ~~ HISTSC1
    READSC1 ~~ SCISC1
    MATHSC1 ~~ SCISC1'

fmod<-sem(mod,data=grl,fixed.x=FALSE)
summary(fmod, standardized=TRUE)
parameterEstimates(fmod)

mmod<-sem(mod,data=boy,fixed.x=FALSE)
parameterEstimates(mmod)

boy$GENDER<-"M"
grl$GENDER<-"F"

all<-rbind(boy,grl)
all$GENDER<-factor(all$GENDER)
bigmod<-sem(mod,data=all,fixed.x=FALSE,group="GENDER")
summary(bigmod)
parameterEstimates(bigmod)
fitMeasures(bigmod)

# Can use group.equal to set different parameters equal in the grouping

bigmod<-sem(mod,data=all,fixed.x=FALSE,group="GENDER",
            group.equal=c("loadings","regressions","means"))
parameterEstimates(bigmod)
fitMeasures(bigmod)
modindices(bigmod,standardized=TRUE)
# Can use the group.partial to release a specific parameter

freemod1<-sem(mod,data=all,fixed.x=FALSE,group="GENDER",
            group.equal=c("loadings","regressions","means"),
            group.partial=c("SATMATH ~ MATHSC1"))

summary(freemod1)
fitMeasures(freemod1)

##########################################
# Latent Variable Multigroup PA
##########################################

cfamodel<-'RSC =~ READSC1 + READSC2 + READSC3 + READSC4 + READSC5
           MSC =~ MATHSC1 + MATHSC2 + MATHSC3 + MATHSC4 + MATHSC5
           HSC =~ HISTSC1 + HISTSC2 + HISTSC3 + HISTSC4 + HISTSC5
           SSC =~ SCISC1 + SCISC2 + SCISC3 + SCISC4 + SCISC5
           MSC ~~ HSC
           HSC ~~ SSC
           RSC ~~ MSC
           SSC ~~ MSC
           RSC ~~ HSC
           RSC ~~ SSC
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

cfaf<-lavaan(cfamodel,data=grl,std.lv=FALSE,
             auto.var=TRUE,auto.cov.lv.x=FALSE,auto.cov.y=FALSE,
             auto.fix.first=TRUE,int.ov.free=FALSE,int.lv.free=TRUE)
fitMeasures(cfaf)

cfam<-lavaan(cfamodel,data=boy,std.lv=FALSE,
             auto.var=TRUE,auto.cov.lv.x=FALSE,auto.cov.y=FALSE,
             auto.fix.first=TRUE,int.ov.free=FALSE,int.lv.free=TRUE)

fitMeasures(cfam)


cfaUC<-lavaan(cfamodel,data=all, group="GENDER",std.lv=FALSE,std.ov=FALSE,
             auto.var=TRUE,auto.cov.lv.x=FALSE,auto.cov.y=FALSE,orthogonal=FALSE,
              meanstructure=FALSE,
             auto.fix.first=TRUE,int.ov.free=TRUE,int.lv.free=FALSE,mimic="EQS")
parTable(cfaUC)
fitMeasures(cfaUC)

cfaC<-lavaan(cfamodel,data=all, group="GENDER",std.lv=FALSE,std.ov=FALSE,
             auto.var=TRUE,auto.cov.lv.x=FALSE,auto.cov.y=FALSE,orthogonal=FALSE,
             meanstructure=FALSE,
             auto.fix.first=TRUE,int.ov.free=TRUE,int.lv.free=FALSE,
              group.equal=c("regressions","loadings"))
parTable(cfaC)
fitMeasures(cfaC)
modindices(cfaC,alpha=0.01)

# Update using modindices and release SSC =~ SCISC3

cfaC2<-lavaan(cfamodel,data=all, group="GENDER",std.lv=FALSE,std.ov=FALSE,
             auto.var=TRUE,auto.cov.lv.x=FALSE,auto.cov.y=FALSE,orthogonal=FALSE,
              meanstructure=FALSE,
             auto.fix.first=TRUE,int.ov.free=TRUE,int.lv.free=FALSE,
             group.equal=c("regressions","loadings"),
             group.partial=c("SSC =~  SCISC3"))
fitMeasures(cfaC2)

anova(cfaC,cfaUC)
# Models are not distinguishable at .05


anova(cfaC,cfaC2)
# But, if we free one parameter, we get a better data-model fit (SSC =~ SCISC3)

#######################3
# Hands on
#######################

names<-c("hand","number","word","gestalt","triangles","matrix","spatial","photo")

cor.matW<-matrix(c(1,0,0,0,0,0,0,0,
                  0.35,1,0,0,0,0,0,0,
                  0.36,0.59,1,0,0,0,0,0,
                  0.00,-.08,-.06,1,0,0,0,0,
                  0.31,0.25,0.31,0.07,1,0,0,0,
                  0.39,0.21,0.25,0.17,0.44,1,0,0,
                  0.3,0.09,0.25,0.17,0.39,0.29,1,0,
                  0.33,-.02,0.1,0.32,0.31,0.14,0.29,1),8,8,byrow=TRUE)


cor.matB<-matrix(c(1,0,0,0,0,0,0,0,
                   0.19,1,0,0,0,0,0,0,
                   0.26,0.4,1,0,0,0,0,0,
                   0.13,.06,.08,1,0,0,0,0,
                   0.19,0.22,0.1,0.50,1,0,0,0,
                   0.26,0.24,0.32,0.34,0.41,1,0,0,
                   0.22,0.18,0.30,0.27,0.48,0.41,1,0,
                   0.28,.09,0.11,0.21,0.28,0.35,0.38,1),8,8,byrow=TRUE)

colnames(cor.matW) <- rownames(cor.matW) <-names
colnames(cor.matB) <- rownames(cor.matB) <-names

model<-'simultaneous =~ triangles + matrix + spatial + photo + gestalt
        sequential =~ hand + number + word
        sequential ~~ simultaneous'

dat<-list("white"=cor.matW,"black"=cor.matB)

mod1<-lavaan(model,sample.cov=dat,sample.nobs=c(86,86),meanstructure=FALSE,
          auto.cov.lv.x=FALSE,auto.cov.y=FALSE,orthogonal=FALSE,auto.var=TRUE,
          auto.fix.first=TRUE,int.ov.free=FALSE,int.lv.free=FALSE,
          group.equal=c("loadings","regressions"))
summary(mod1)
fitMeasures(mod1)

mod1C<-lavaan(model,sample.cov=dat,sample.nobs=c(86,86),meanstructure=FALSE,
              auto.cov.lv.x=FALSE,auto.cov.y=FALSE,orthogonal=FALSE,auto.var=TRUE,
              auto.fix.first=TRUE,int.ov.free=FALSE,int.lv.free=FALSE,
              group.equal=c("loadings","intercepts","regressions","lv.covariances"),
              group.partial=c('simultaneous =~ spatial','gestalt~~triangle'))
fitMeasures(mod1C)