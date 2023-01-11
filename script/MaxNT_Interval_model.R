rm(list=ls())

library(dplyr)
library(openxlsx)
library(rstan)

setwd("/Users/sho/Documents/R/20220323 seroepi/20230110 github")

d <- read.xlsx("input/Table S3.xlsx", startRow = 2) %>% 
  mutate(GID=case_when(
    Group_ID=="Pre-Omicron"~1,
    Group_ID=="Omicron"~2,
    Group_ID=="Boosted"~3,
    TRUE ~ 0
  ))
ls(d)

##model
N <- nrow(d)
K <- 3 #number of groups
days<-d$Dose2_to_Last_exposure

#model Ancestral_NT
NT<-d$Ancestral_NT
data <- list(N=N, X=days, Y=NT,GID=d$GID, K=K)
fitAnc <- stan(file='script/interval_model.stan', data=data, iter = 10000,thin=5, seed=1236)
save.image('output/result-model-Anc.RData')
#model BA.1_NT
NT<-d$BA.1_NT
data <- list(N=N, X=days, Y=NT,GID=d$GID, K=K)
fitBA1 <- stan(file='script/interval_model.stan', data=data, iter = 10000,thin=5, seed=1236)
save.image('output/result-model-BA1.RData')
#model BA.2_NT
NT<-d$BA.2_NT
data <- list(N=N, X=days, Y=NT,GID=d$GID, K=K)
fitBA2 <- stan(file='script/interval_model.stan', data=data, iter = 10000,thin=5, seed=1236)
save.image('output/result-model-BA2.RData')
#model BA.5_NT
NT<-d$BA.5_NT
data <- list(N=N, X=days, Y=NT,GID=d$GID, K=K)
fitBA5 <- stan(file='script/interval_model.stan', data=data, iter = 10000,thin=5, seed=1236)
save.image('output/result-model-BA5.RData')
#model BA.2.75_NT
NT<-d$BA.2.75_NT
data <- list(N=N, X=days, Y=NT,GID=d$GID, K=K)
fitBA275 <- stan(file='script/interval_model.stan', data=data, iter = 10000,thin=5, seed=1236)
save.image('output/result-model-BA275.RData')
#model BQ.1.1_NT
d2 <- d %>% subset(!(is.na(BQ.1.1_NT)))
N <- nrow(d2)
days<-d2$Dose2_to_Last_exposure
NT<-d2$BQ.1.1_NT
data <- list(N=N, X=days, Y=NT,GID=d2$GID, K=K)
fitBQ11 <- stan(file='script/interval_model.stan', data=data, iter = 10000,thin=5, seed=1236)
save.image('output/result-model-BQ11.RData')

##tMNT90
ms <- rstan::extract(fitAnc)
X_new <- 0:350
N_X <- length(X_new)
N_mcmc <- length(ms$lp__)

tMNT90 <- as.data.frame(matrix(nrow=N_mcmc, ncol=6))
colnames(tMNT90) <- c("X_Ancst","X_BA1","X_BA2","X_BA5","X_BA275","X_BQ11")
#Ancst
ms <- rstan::extract(fitAnc)
tMNT90$X_Ancst <- (1/ms$b)*log(9*ms$a)
#BA1
ms <- rstan::extract(fitBA1)
tMNT90$X_BA1 <- (1/ms$b)*log(9*ms$a)
#BA2
ms <- rstan::extract(fitBA2)
tMNT90$X_BA2 <- (1/ms$b)*log(9*ms$a)
#BA5
ms <- rstan::extract(fitBA5)
tMNT90$X_BA5 <- (1/ms$b)*log(9*ms$a)
#BA275
ms <- rstan::extract(fitBA275)
tMNT90$X_BA275 <- (1/ms$b)*log(9*ms$a)
#BQ11
ms <- rstan::extract(fitBQ11)
tMNT90$X_BQ11 <- (1/ms$b)*log(9*ms$a)

summary_tMNT90 <- apply(tMNT90, 2, quantile, probs=c(0.025, 0.25, 0.50, 0.75, 0.975))
summary_tMNT90