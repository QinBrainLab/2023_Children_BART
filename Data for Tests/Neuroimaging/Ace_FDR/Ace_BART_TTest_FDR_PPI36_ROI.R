#Designed by Shamrockheart
#Ver_2020.02.20

rm(list = ls())
library(car); library(carData); library(fdrtool)

name.condition<-c('pump','cashout','explode')
name.colname<-c('dACC_DLPFC',	'dACC_VMPFC',	'dACC_NAc',	'dACC_Caudate',	'dACC_Putamen',	'dACC_Amygdala',	'dACC_Insula',	'dACC_Hippocampus',	'DLPFC_VMPFC',	'DLPFC_NAc',	'DLPFC_Caudate',	'DLPFC_Putamen',	'DLPFC_Amygdala',	'DLPFC_Insula',	'DLPFC_Hippocampus',	'VMPFC_NAc',	'VMPFC_Caudate',	'VMPFC_Putamen',	'VMPFC_Amygdala',	'VMPFC_Insula',	'VMPFC_Hippocampus',	'NAc_Caudate',	'NAc_Putamen',	'NAc_Amygdala',	'NAc_Insula',	'NAc_Hippocampus',	'Caudate_Putamen',	'Caudate_Amygdala',	'Caudate_Insula',	'Caudate_Hippocampus',	'Putamen_Amygdala',	'Putamen_Insula',	'Putamen_Hippocampus',	'Amygdala_Insula',	'Amygdala_Hippocampus',	'Insula_Hippocampus')

ltp<-c(rep(0,9)); t1p<-c(rep(0,9)); t2p<-c(rep(0,9))
for (i in 1:length(name.condition)) {
  setwd("D:\\JM_Neo_BART\\TST_Ace_Analyses\\Ace_FDR\\Input\\PPI36_ROI")
  mydata<-read.csv(paste(name.condition[i],"_Ace_PPI_value_int.csv", sep="") ,header=TRUE)
  # setwd("D:\\JM_Neo_BART\\JM_Neo_Results\\FDR_Correction_2019\\Input\\PPI_ROI")
  # mydata<-read.csv(paste("ave_",name.condition[i],"_NAc_gPPI.csv", sep="") ,header=TRUE)
  
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
  setwd("D:\\JM_Neo_BART\\TST_Ace_Analyses\\Ace_FDR\\Output\\PPI36_ROI")
  write.csv(res,file=paste(name.condition[i],"_Ace_PPI_ROI_TTest_FDR.csv", sep = ""))
}