library(tidyverse)
library(survival)
library(survminer)
#library(gtsummary)
#library(scales)
library(coin)
library(ggfortify)
library(ggplot2)
library(xtable)
rm(list=ls())
print("Modelo de sobrevivência - paramétrico")
print("Separado por entrada")
#Load dataset e ajustes dos dados
#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
discentes <-read.table("discentes.csv", header = T, quote = '"', 
                       row.names = NULL, 
                       stringsAsFactors = FALSE, sep=",")
discentes$matricula <- as.character(discentes$matricula)

sapply(discentes, class)

#Considerar o ingressantes entre 2014, inclusive, até 2021
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
#discentes <- discentes %>% dplyr::filter(periodoLetivoAtual > 0)
#discentes <- discentes %>% dplyr::filter(formaIngresso  != "REINGRESSO DE GRADUADO")
#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

#Modelo não paramétrico Kapler-Meier
#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
km_fit_ppc <- survival::survfit(survival::Surv(periodoLetivoAtual, sta) ~ ppc, data = discentes)

#KM <- survfit(Surv(tempo,status) ~ 1)
#print(broom::tidy(km_fit_ppc))

write.csv(broom::tidy(km_fit_ppc), "tabelas-por-ppc.csv")
#print(summary(km_fit_ppc))

discentes$ppc <- as.factor(discentes$ppc)
log_test <- coin::logrank_test(survival::Surv(periodoLetivoAtual, sta) ~ ppc, data = discentes, type="logrank")
geh_test <- coin::logrank_test(survival::Surv(periodoLetivoAtual, sta) ~ ppc, data = discentes, type="Gehan-Breslow")
tar_test <- coin::logrank_test(survival::Surv(periodoLetivoAtual, sta) ~ ppc, data = discentes, type="Tarone-Ware")
pep_test <- coin::logrank_test(survival::Surv(periodoLetivoAtual, sta) ~ ppc, data = discentes, type="Peto-Peto")
print("Comparação das funções:")
print(log_test)
print(geh_test)
print(tar_test)
print(pep_test)



sobrevivencia <- km_fit_ppc %>%
    ggsurvplot(
    fun = "pct", #"pct", #event  #"cumhaz"
    font.legend =c(26, "bold", "black"),
    font.x = c(18, "bold", "black"),
    font.y = c(18, "bold", "black"),
    font.tickslab = c(18, "plain", "black"),
    pval = TRUE,
    pval.size = 7,
    conf.int = TRUE,
    fontsize = 3, # used in risk table
    surv.median.line = "hv", # median horizontal and vertical ref lines
    censor.shape = 3,
    xlab = "Períodos",
    xlim = c(0,19),
    ylab = "Sobrevivência (%)",
    break.time.by = 1,
    legend.title = "",
    legend.labs = c("M_2014", "M_2020"),
    palette = "Set1")

print("Salvando arquivo da sobrevivência")
ggsave(filename = "sobrevivencia-matriz.pdf", width = 11.69, height = 8.27)
# # # #
risco <- km_fit_ppc %>%
    ggsurvplot(
    fun = "event", #"pct", #event  #"cumhaz"
    fontsize = 3, # used in risk table
    surv.median.line = "hv", # median horizontal and vertical ref lines
    xlab = "Períodos",
    xlim = c(0,19),
    ylab = "Risco de evasão",
    ylim = c(0,1),
    break.x.by = 1,
    legend.title = "",
    legend.labs = c("M_2014", "M_2020"),
    palette = "Set1",
    font.legend =c(26, "bold", "black"),
    font.x = c(18, "bold", "black"),
    font.y = c(18, "bold", "black"),
    font.tickslab = c(18, "plain", "black"))
print("Salvando arquivo de risco")
ggsave(filename = "risco-evasao-matriz.pdf", width = 11.69, height = 8.27)