#library(tidyverse)
library(survival)
library(survminer)
library(gtsummary)
library(scales)
library(coin)

rm(list=ls())
print("Modelo de sobrevivência - paramétrico")
print("Separado por entrada")
discentes <-read.table("discentes.csv", header = T, quote = '"', 
                       row.names = NULL, 
                       stringsAsFactors = FALSE, sep=",")
discentes$matricula <- as.character(discentes$matricula)
sapply(discentes, class)
discentes <- discentes[discentes$anoEntrada >= 2014, ]
discentes <- discentes[discentes$anoEntrada < 2022, ]

discentes$sta <- 0
discentes$sta[discentes$situacao == "EVADIDO"] <- 1
discentes$ppc[discentes$anoEntrada <= 2019] <- 0
discentes$ppc[discentes$anoEntrada > 2019] <- 1
discentes$periodoLetivoAtual <- as.numeric(discentes$periodoLetivoAtual)
discentes$anoEntrada <- as.factor(discentes$anoEntrada)
discentes$sta <- as.numeric(discentes$sta)
discentes$periodoLetivoAtual[discentes$periodoLetivoAtual == 0] <- 1



#Justando a faixa do IRA. Abaixo de 5 é repreovado
#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
discentes$IRAfaixa <- 0
#discentes = discentes %>%
#  mutate(IRAfaixa = ifelse(IRA < 5, 1, 2))
discentes$IRAfaixa <- 0
discentes$formaINum <- 0
for (i in 1:length(discentes$IRA)){
  ira <- discentes$IRA[i]
  if (ira < 2.5) discentes$IRAfaixa[i] <- 0
  else if ((ira >= 2.5) && (ira < 5.0)) discentes$IRAfaixa[i] <- 1
  else if ((ira >= 5.0) && (ira < 7.5)) discentes$IRAfaixa[i] <- 2
  else discentes$IRAfaixa[i] <- 3
  
  if (discentes$formaIngresso[i] == "CONVENIO PEC-G") discentes$formaINum[i] <- 3
  else if (discentes$formaIngresso[i] == "MUDANÇA DE CURSO") discentes$formaINum[i] <- 2
  #else if (discentes$formaIngresso[i] == "SISU") discentes$formaINum[i] <- 0
  else discentes$formaINum[i] <- 1
}

w_modelo <- survival::survreg(survival::Surv(periodoLetivoAtual, sta)~ppc+IRAfaixa+suspensoes+prorrogacoes+idade, discentes, dist = "weibull")
e_modelo <- survival::survreg(survival::Surv(periodoLetivoAtual, sta)~ppc+IRAfaixa+suspensoes+prorrogacoes+idade, discentes, dist = "exponential")
l_modelo <- survival::survreg(survival::Surv(periodoLetivoAtual, sta)~ppc+IRAfaixa+suspensoes+prorrogacoes+idade, discentes, dist = "lognormal")
print("Escolha do melhor modelo. Escolher o que apresenta o menor valor para AIC:")
print("Weibull------------------------------------------------------------------")
print(AIC(w_modelo))
#print(summary(w_modelo))
print("Exponencial--------------------------------------------------------------")
print(AIC(e_modelo))
#print(summary(e_modelo))
print("Lognormal----------------------------------------------------------------")
print(AIC(l_modelo))
print("O modelo que tem o menor valor é o lognormal - atenção para executar novamente com outras variáveis")
