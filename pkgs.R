library(lavaan)
library(ggplot2)
library(xtable)
library(eeptools)
library(scales)
library(devtools)
library(apsrtable)
options('xtable.caption.placement'="top")
options('xtable.table.placement' = "h!")
bentlertest <- function(x, d=3){
  dig <- ifelse(!is.na(d), d, 3)
  a <- fitMeasures(x)
  s <- round(a["srmr"], digits=dig)
  c <- round(a["cfi"], digits=dig)
  r <- round(a["rmsea"], digits=dig)
  n <- round(a["nnfi"], digits=dig)
  output <- list(SRMR = ifelse(s <= .08, "Pass", "Fail"),
                 CFI  = ifelse(c >= .90, "Pass", "Fail"), 
                 TLI  = ifelse(n >= .95, "Pass", "Fail"),
                 RMSEA = ifelse(r <= .06, "Pass", "Fail"),
                 OVERALL = 0)
  output$OVERALL <- ifelse(output$SRMR[[1]] == "Pass" & 
                             (output$CFI[[1]] == "Pass" | 
                                output$TLI[[1]] == "Pass" |
                                output$RMSEA[[1]] == "Pass"), "meets",
                           "fails to meet")
  strout <- paste0("The model ", output$OVERALL, " the Hu-Bentler criteria. \n")
  strout2 <- paste0("The SRMR is ", s, " and the CFI is ", c, "\n")
  strout3 <- paste0("The TLI is ", n, " and the RMSEA is ", r, "\n")
  cat(strout)
  cat(strout2)
  cat(strout3)
}


dfreedom.lavaan <- function(x){
  msize <- dim(fitted(x)$cov)[1] * dim(fitted(x)$cov)[2]
  vars <- msize - sqrt(msize) * 2
  vars - parcount.lavaan(x)
  
}

parcount.lavaan <- function(x){
  m <- inspect(x, what="free")
  max(max(m$lambda), max(m$theta), max(m$psi), max(m$beta))
}



pathCoefPlot.lavaan <- function(x){
  plotdf <- parameterEstimates(x, standardized=TRUE)
  plotdf <- plotdf[plotdf$op != "~1", ] # exclude variances
  plot <- ggplot(plotdf, aes(x=paste(lhs, op, rhs), y=est, 
                             ymin = est - 2*se,
                        ymax = est + 2*se)) + geom_errorbar(width = 0.3) + 
    geom_point() +  coord_flip()
  plot <- plot + geom_hline(yintercept=0, color=I("red")) + 
    labs(x="Paths", y="Estimate", title = "Coefficient CI for Model")
  plot + theme_bw()
}



residPlot.lavaan <- function(x, scale){
  resid_mat <- resid(x, type=scale)$cov
  library(reshape)
  plotdf <- melt(resid_mat)
  plotdf$X1 <- factor(plotdf$X1,  levels=unique(as.character(plotdf$X1)))
  plotdf$X2 <- factor(plotdf$X2,  levels=unique(as.character(plotdf$X2)))
  
  ggplot(plotdf, aes(x=X1, y=X2, fill=value)) + geom_tile() + 
    scale_fill_gradient2(low="blue", high="orange") + coord_cartesian() + 
    theme_bw() + labs(x="Item", y="Item", fill="Resid. Var.")
}

  
stat_sum_df <- function(fun, geom="crossbar", ...) {
  stat_summary(fun.data=fun, colour="red", geom=geom, width=0.2, ...)
}

