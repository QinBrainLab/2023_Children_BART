#Designed by Min
#Ver_2020.02.19

rm(list = ls())
library(fdrtool)
name.condition<-c("pump","cashout","explode")
name.colname<-c("Within_Control","Within_Approach","Within_Avoidance","Control_Approach","Control_Avoidance","Approach_Avoidance")
# name.grpname<-c("Adults","Children")
ltp=t1p=t2p<-c(rep(0,length(name.colname)))
for (i in 1:length(name.condition)) {
  setwd("D:\\JM_Neo_BART\\TST_Ace_Analyses\\Ace_FDR\\Input\\Net")
  mydata<-read.csv(paste(name.condition[i],"_Ace_com.csv", sep="") ,header=TRUE)
  
  for (j in 1:length(name.colname)) {
    x<-mydata[,j+1]; a<-mydata[,1]
    library(car); library(carData); lt=leveneTest(x~a); ltp[j]<-lt[1,3]
    
    Adults<-mydata[1:80,j+1]; Children<-mydata[81:298,j+1]
    tt1=t.test(Adults, Children, paired=FALSE, var.equal=TRUE, conf.level=0.95); t1p[j]<-tt1$p.value
    tt2=t.test(Adults,Children,paired=FALSE,var.equal=FALSE,conf.level=0.95); t2p[j]<-tt2$p.value
    
  }
  p1=sort(t1p); fdrp1=p.adjust(p1, method="fdr", length(p1)); f1=fdrtool(p1, statistic="pvalue", plot=FALSE)$qval
  p2=sort(t2p); fdrp2=p.adjust(p2, method="fdr", length(p2)); f2=fdrtool(p2, statistic="pvalue", plot=FALSE)$qval
  res<-cbind(ltp, t1p, t2p, p1, fdrp1, f1, p2, fdrp2, f2)
  setwd("D:\\JM_Neo_BART\\TST_Ace_Analyses\\Ace_FDR\\Output\\Net")
  write.csv(res,file=paste(name.condition[i],"_Ace_Network_TTest_FDR.csv", sep = ""))
}