
library(survival)
library(survminer)
library(gtsummary)
library(scales)
library(coin)
library(xtable)
rm(list=ls())
print("Modelo de sobrevivência - paramétrico - apenas modelo lognormal")
print("Separado por entrada")
print("Script usando para entender como a curva dos modelos")
#Load dataset e ajustes dos dados
#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
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
discentes$formaINum <- 0
for (i in 1:length(discentes$IRA)){
  ira <- discentes$IRA[i]
  if (ira < 2.5) discentes$IRAfaixa[i] <- 0
  else if ((ira >= 2.5) && (ira < 5.0)) discentes$IRAfaixa[i] <- 1
  else if ((ira >= 5.0) && (ira < 7.5)) discentes$IRAfaixa[i] <- 2
  else discentes$IRAfaixa[i] <- 3
  
  if (discentes$formaIngresso[i] == "CONVENIO PEC-G") discentes$formaINum[i] <- 3
  else if (discentes$formaIngresso[i] == "MUDANÇA DE CURSO") discentes$formaINum[i] <- 2
  else if (discentes$formaIngresso[i] == "SISU") discentes$formaINum[i] <- 0
  else discentes$formaINum[i] <- 1
}

#discentes = discentes %>%
#  mutate(IRAfaixa = ifelse(IRA < 5, 1, 2))
l_modelo <- survival::survreg(survival::Surv(periodoLetivoAtual, sta)~ppc+IRAfaixa+suspensoes+prorrogacoes+idade+formaINum, discentes, dist = "lognormal")

# print("Weibull------------------------------------------------------------------")
# print(AIC(w_modelo))
# #print(summary(w_modelo))
# print("Exponencial--------------------------------------------------------------")
# print(AIC(e_modelo))
#print(summary(e_modelo))
print("AIC(l_modelo))------------------------------------------------------------------")
print(AIC(l_modelo))
print("#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::")
print("summary(l_modelo)---------------------------------------------------------------")
print(summary(l_modelo))
      
      
      
#print("#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::")
#print("l_modelo------------------------------------------------------------------------")
#print(l_modelo)
#print("#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::")
t <- seq(from=0, to=20, by=1)
km_fit_ppc <- survival::survfit(survival::Surv(periodoLetivoAtual, sta) ~ 1, data = discentes)
beta0 <- l_modelo$coefficients[1]   #intercept
beta1 <- l_modelo$coefficients[2]   #PPC
beta2 <- l_modelo$coefficients[3]   #IRAfaixa
beta3 <- l_modelo$coefficients[4]   #suspensoes
beta4 <- l_modelo$coefficients[5]   #prorrogacoes
beta5 <- l_modelo$coefficients[6]   #idade
beta6 <- l_modelo$coefficients[7]   #formaINum


ppc          <-  0 # 0 - antigo / 1 - novo
iraFaixa     <-  1 # 0,1,2,3
suspensoes   <-  0 # máximo: 4 / mediana 0 / média 0.8189
prorrogacoes <-  0 # máximo: 6 / mediana 0 / média 0.05967
idade        <- 25 # máximo: 54 / mediana 19 / média 25.77
ingresso     <-  1 # ENEM = 3 / SISU = 2 / Mudanç = 1 / convênio = 0

mu <- exp( beta0 + (beta1*ppc) + (beta2*iraFaixa) + (beta3*suspensoes)  + (beta4*prorrogacoes) + (beta5*idade) + (beta6*ingresso) )

sigma <- l_modelo$scale 
plot(km_fit_ppc)
lines(pnorm(t, mean = mu, sd = sigma, lower.tail = FALSE))

#lower.tail = P(T>t)
#plot(pnorm(t, mean = mu, sd = sigma, lower.tail = FALSE))
