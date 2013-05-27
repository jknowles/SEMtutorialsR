# R Workspace

library(lavaan)
library("Rgraphviz")

# Day 1, draw simple model

rEG <- new("graphNEL", nodes=c("ILL","IMM","DEP"), edgemode="directed")
rEG <- addEdge("ILL", "IMM", rEG, 1)
rEG <- addEdge("IMM", "DEP", rEG, 1)

nAttrs<-list()

nAttrs<-makeNodeAttrs(rEG,label=nodes(rEG),
                      shape=c("ellipse","ellipse","rectangle"))


eAttrs<-list()
eAttrs$label <- c("ILL~IMM"=".66", "IMM~DEP"=".35")


plot(rEG,edgeAttrs=eAttrs,nodeAttrs=nAttrs)

sg1 <- subGraph(c("A","B","C"), rEG)
plot(sg1)
