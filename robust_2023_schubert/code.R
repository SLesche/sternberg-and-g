##################################################################
## This R script accompanies the paper "How Robust is the       ## 
## Relationship between Neural Processing Speed and Abilities?" ## 
## by Schubert et al. (2022)                                    ## 
##################################################################

# set working directory
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# load package
library(lavaan)

# load data

data <- read.csv("data.csv", sep = ";")

# main SEM analyses ----

## SEM: Average reference, 8 Hz low-pass filter, peak latency ----

model_avg_8Hz_PL <- c(# hierarchical model
  "P2 =~ 1*zPosner_P2_PL_8Hz_avg + 1*zCRT_P2_PL_8Hz_avg + 1*zSternberg_P2_PL_8Hz_avg",
  "N2 =~ 1*zPosner_N2_PL_8Hz_avg + 1*zCRT_N2_PL_8Hz_avg + 1*zSternberg_N2_PL_8Hz_avg",
  "P3 =~ 1*zPosner_P3_PL_8Hz_avg + 1*zCRT_P3_PL_8Hz_avg + 1*zSternberg_P3_PL_8Hz_avg",
  "ERP =~ 1*P2 + b_n2*N2 + b_p3*P3",
  
  # task-specific factors
  "Posner =~ 1*zPosner_P2_PL_8Hz_avg + 1*zPosner_N2_PL_8Hz_avg + 1*zPosner_P3_PL_8Hz_avg",
  "CRT =~ 1*zCRT_P2_PL_8Hz_avg + 1*zCRT_N2_PL_8Hz_avg + 1*zCRT_P3_PL_8Hz_avg",
  "Sternberg =~ 1*zSternberg_P2_PL_8Hz_avg + 1*zSternberg_N2_PL_8Hz_avg + 1*zSternberg_P3_PL_8Hz_avg",
  "Posner ~~ 0*CRT + 0*Sternberg",
  "CRT ~~ 0*Sternberg",
  
  # cognitive abilities
  "gf =~ zPC + zPS + zM + zC",
  
  # structural model
  "ERP ~~ gf",
  "gf ~~ 0*P2 + 0*N2 + 0*P3",
  "gf ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "P2 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "N2 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "P3 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "ERP ~~ 0*Posner + 0*CRT + 0*Sternberg",
  
  # fix intercepts to zero
  "zPosner_P2_PL_8Hz_avg ~ 0",
  "zPosner_N2_PL_8Hz_avg ~ 0",
  "zPosner_P3_PL_8Hz_avg ~ 0",
  "zCRT_P2_PL_8Hz_avg ~ 0",
  "zCRT_N2_PL_8Hz_avg ~ 0",
  "zCRT_P3_PL_8Hz_avg ~ 0",
  "zSternberg_P2_PL_8Hz_avg ~ 0",
  "zSternberg_N2_PL_8Hz_avg ~ 0",
  "zSternberg_P3_PL_8Hz_avg ~ 0",
  "zPC ~ 0",
  "zPS ~ 0",
  "zM ~ 0",
  "zC ~ 0",
  
  # variances
  "ERP ~~ v_erp*ERP",
  "CRT ~~ v_crt*CRT",
  "Sternberg ~~ v_sternberg*Sternberg",
  "Posner ~~ v_posner*Posner",
  "P2 ~~ v_p2*P2",
  "N2 ~~ 0*N2",
  "P3 ~~ v_p3*P3",
  "zPosner_P2_PL_8Hz_avg ~~ v_P_P2*zPosner_P2_PL_8Hz_avg",
  "zPosner_N2_PL_8Hz_avg ~~ v_P_N2*zPosner_N2_PL_8Hz_avg",
  "zPosner_P3_PL_8Hz_avg~~ v_P_P3*zPosner_P3_PL_8Hz_avg",
  "zCRT_P2_PL_8Hz_avg ~~ v_C_P2*zCRT_P2_PL_8Hz_avg",
  "zCRT_N2_PL_8Hz_avg ~~ v_C_N2*zCRT_N2_PL_8Hz_avg",
  "zCRT_P3_PL_8Hz_avg ~~ v_C_P3*zCRT_P3_PL_8Hz_avg",
  "zSternberg_P2_PL_8Hz_avg ~~ v_S_P2*zSternberg_P2_PL_8Hz_avg",
  "zSternberg_N2_PL_8Hz_avg ~~ v_S_N2*zSternberg_N2_PL_8Hz_avg",
  "zSternberg_P3_PL_8Hz_avg ~~ v_S_P3*zSternberg_P3_PL_8Hz_avg",
  
  # consistencies
  "consistency_Posner_P2 := (v_erp)/(v_erp + v_p2 + v_posner + v_P_P2)",
  "consistency_N2 := (b_n2^2*v_erp)/(b_n2^2*v_erp + 0 + v_posner + v_P_N2)",
  "consistency_Posner_P3 := (b_p3^2*v_erp)/(b_p3^2*v_erp + v_p3 + v_posner + v_P_P3)",
  "consistency_CRT_P2 := (v_erp)/(v_erp + v_p2 + v_crt + v_C_P2)",
  "consistency_CRT_N2 := (b_n2^2*v_erp)/(b_n2^2*v_erp + 0 + v_crt + v_C_N2)",
  "consistency_CRT_P3 := (b_p3^2*v_erp)/(b_p3^2*v_erp + v_p3 + v_crt + v_C_P3)",
  "consistency_Sternberg_P2 := (v_erp)/(v_erp + v_p2 + v_sternberg + v_S_P2)",
  "consistency_Sternberg_N2 := (b_n2^2*v_erp)/(b_n2^2*v_erp +0 + v_sternberg + v_S_N2)",
  "consistency_Sternberg_P3 := (b_p3^2*v_erp)/(b_p3^2*v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # component specifities
  "comp_Posner_P2 := (v_p2)/(v_erp + v_p2 + v_posner + v_P_P2)",
  "comp_Posner_N2 := (0)/(b_n2^2*v_erp + 0 + v_posner + v_P_N2)",
  "comp_Posner_P3 := (v_p3)/(b_p3^2*v_erp + v_p3 + v_posner + v_P_P3)",
  "comp_CRT_P2 := (v_p2)/(v_erp + v_p2 + v_crt + v_C_P2)",
  "comp_CRT_N2 := (0)/(b_n2^2*v_erp + 0 + v_crt + v_C_N2)",
  "comp_CRT_P3 := (v_p3)/(b_p3^2*v_erp + v_p3 + v_crt + v_C_P3)",
  "comp_Sternberg_P2 := (v_p2)/(v_erp + v_p2 + v_sternberg + v_S_P2)",
  "comp_Sternberg_N2 := (0)/(b_n2^2*v_erp +0 + v_sternberg + v_S_N2)",
  "comp_Sternberg_P3 := (v_p3)/(b_p3^2*v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # task specifities
  "task_Posner_P2 := (v_posner)/(v_erp + v_p2 + v_posner + v_P_P2)",
  "task_Posner_N2 := (v_posner)/(b_n2^2*v_erp + 0 + v_posner + v_P_N2)",
  "task_Posner_P3 := (v_posner)/(b_p3^2*v_erp + v_p3 + v_posner + v_P_P3)",
  "task_CRT_P2 := (v_crt)/(v_erp + v_p2 + v_crt + v_C_P2)",
  "task_CRT_N2 := (v_crt)/(b_n2^2*v_erp + 0 + v_crt + v_C_N2)",
  "task_CRT_P3 := (v_crt)/(b_p3^2*v_erp + v_p3 + v_crt + v_C_P3)",
  "task_Sternberg_P2 := (v_sternberg)/(v_erp + v_p2 + v_sternberg + v_S_P2)",
  "task_Sternberg_N2 := (v_sternberg)/(b_n2^2*v_erp +0 + v_sternberg + v_S_N2)",
  "task_Sternberg_P3 := (v_sternberg)/(b_p3^2*v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # reliabilities
  "rel_Posner_P2 := (v_erp + v_p2 + v_posner)/(v_erp + v_p2 + v_posner + v_P_P2)",
  "rel_Posner_N2 := (b_n2^2*v_erp + 0 + v_posner)/(b_n2^2*v_erp + 0 + v_posner + v_P_N2)",
  "rel_Posner_P3 := (b_p3^2*v_erp + v_p3 + v_posner)/(b_p3^2*v_erp + v_p3 + v_posner + v_P_P3)",
  "rel_CRT_P2 := (v_erp + v_p2 + v_crt)/(v_erp + v_p2 + v_crt + v_C_P2)",
  "rel_CRT_N2 := (b_n2^2*v_erp + 0 + v_crt)/(b_n2^2*v_erp + 0 + v_crt + v_C_N2)",
  "rel_CRT_P3 := (b_p3^2*v_erp + v_p3 + v_crt)/(b_p3^2*v_erp + v_p3 + v_crt + v_C_P3)",
  "rel_Sternberg_P2 := (v_erp + v_p2 + v_sternberg)/(v_erp + v_p2 + v_sternberg + v_S_P2)",
  "rel_Sternberg_N2 := (b_n2^2*v_erp +0 + v_sternberg)/(b_n2^2*v_erp +0 + v_sternberg + v_S_N2)",
  "rel_Sternberg_P3 := (b_p3^2*v_erp + v_p3 + v_sternberg)/(b_p3^2*v_erp + v_p3 + v_sternberg + v_S_P3)")

fit_avg_8Hz_PL <- sem(model_avg_8Hz_PL, data = data, estimator = "MLR" , missing="fiml", std.lv = FALSE)
summary(fit_avg_8Hz_PL, fit.measures=TRUE,standardized = TRUE,rsquare=T, ci = TRUE)

## SEM: Average reference, 8 Hz low-pass filter, 50 % FA latency ----

model_avg_8Hz_FA <- c(# hierarchical model
  "P2 =~ 1*zPosner_P2_FA_8Hz_avg + 1*zCRT_P2_FA_8Hz_avg + 1*zSternberg_P2_FA_8Hz_avg",
  "N2 =~ 1*zPosner_N2_FA_8Hz_avg + 1*zCRT_N2_FA_8Hz_avg + 1*zSternberg_N2_FA_8Hz_avg",
  "P3 =~ 1*zPosner_P3_FA_8Hz_avg + 1*zCRT_P3_FA_8Hz_avg + 1*zSternberg_P3_FA_8Hz_avg",
  "ERP =~ 1*P2 + b_n2*N2 + b_p3*P3",
  
  # task-specific factors
  "Posner =~ 1*zPosner_P2_FA_8Hz_avg + 1*zPosner_N2_FA_8Hz_avg + 1*zPosner_P3_FA_8Hz_avg",
  "CRT =~ 1*zCRT_P2_FA_8Hz_avg + 1*zCRT_N2_FA_8Hz_avg + 1*zCRT_P3_FA_8Hz_avg",
  "Sternberg =~ 1*zSternberg_P2_FA_8Hz_avg + 1*zSternberg_N2_FA_8Hz_avg + 1*zSternberg_P3_FA_8Hz_avg",
  "Posner ~~ 0*CRT + 0*Sternberg",
  "CRT ~~ 0*Sternberg",
  
  # cognitive abilities
  "gf =~ zPC + zPS + zM + zC",
  
  # structural model
  "ERP ~~ gf",
  "gf ~~ 0*P2 + 0*N2 + 0*P3",
  "gf ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "P2 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "N2 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "P3 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "ERP ~~ 0*Posner + 0*CRT + 0*Sternberg",
  
  # fix intercepts to zero
  "zPosner_P2_FA_8Hz_avg ~ 0",
  "zPosner_N2_FA_8Hz_avg ~ 0",
  "zPosner_P3_FA_8Hz_avg ~ 0",
  "zCRT_P2_FA_8Hz_avg ~ 0",
  "zCRT_N2_FA_8Hz_avg ~ 0",
  "zCRT_P3_FA_8Hz_avg ~ 0",
  "zSternberg_P2_FA_8Hz_avg ~ 0",
  "zSternberg_N2_FA_8Hz_avg ~ 0",
  "zSternberg_P3_FA_8Hz_avg ~ 0",
  "zPC ~ 0",
  "zPS ~ 0",
  "zM ~ 0",
  "zC ~ 0",
  
  # variances
  "ERP ~~ v_erp*ERP",
  "CRT ~~ v_crt*CRT",
  "Sternberg ~~ v_sternberg*Sternberg",
  "Posner ~~ v_posner*Posner",
  "P2 ~~ v_p2*P2",
  "N2 ~~ 0*N2",
  "P3 ~~ v_p3*P3",
  "zPosner_P2_FA_8Hz_avg ~~ v_P_P2*zPosner_P2_FA_8Hz_avg",
  "zPosner_N2_FA_8Hz_avg ~~ v_P_N2*zPosner_N2_FA_8Hz_avg",
  "zPosner_P3_FA_8Hz_avg~~ v_P_P3*zPosner_P3_FA_8Hz_avg",
  "zCRT_P2_FA_8Hz_avg ~~ v_C_P2*zCRT_P2_FA_8Hz_avg",
  "zCRT_N2_FA_8Hz_avg ~~ v_C_N2*zCRT_N2_FA_8Hz_avg",
  "zCRT_P3_FA_8Hz_avg ~~ v_C_P3*zCRT_P3_FA_8Hz_avg",
  "zSternberg_P2_FA_8Hz_avg ~~ v_S_P2*zSternberg_P2_FA_8Hz_avg",
  "zSternberg_N2_FA_8Hz_avg ~~ v_S_N2*zSternberg_N2_FA_8Hz_avg",
  "zSternberg_P3_FA_8Hz_avg ~~ v_S_P3*zSternberg_P3_FA_8Hz_avg",
  
  # consistencies
  "consistency_Posner_P2 := (v_erp)/(v_erp + v_p2 + v_posner + v_P_P2)",
  "consistency_N2 := (b_n2^2*v_erp)/(b_n2^2*v_erp + 0 + v_posner + v_P_N2)",
  "consistency_Posner_P3 := (b_p3^2*v_erp)/(b_p3^2*v_erp + v_p3 + v_posner + v_P_P3)",
  "consistency_CRT_P2 := (v_erp)/(v_erp + v_p2 + v_crt + v_C_P2)",
  "consistency_CRT_N2 := (b_n2^2*v_erp)/(b_n2^2*v_erp + 0 + v_crt + v_C_N2)",
  "consistency_CRT_P3 := (b_p3^2*v_erp)/(b_p3^2*v_erp + v_p3 + v_crt + v_C_P3)",
  "consistency_Sternberg_P2 := (v_erp)/(v_erp + v_p2 + v_sternberg + v_S_P2)",
  "consistency_Sternberg_N2 := (b_n2^2*v_erp)/(b_n2^2*v_erp +0 + v_sternberg + v_S_N2)",
  "consistency_Sternberg_P3 := (b_p3^2*v_erp)/(b_p3^2*v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # component specifities
  "comp_Posner_P2 := (v_p2)/(v_erp + v_p2 + v_posner + v_P_P2)",
  "comp_Posner_N2 := (0)/(b_n2^2*v_erp + 0 + v_posner + v_P_N2)",
  "comp_Posner_P3 := (v_p3)/(b_p3^2*v_erp + v_p3 + v_posner + v_P_P3)",
  "comp_CRT_P2 := (v_p2)/(v_erp + v_p2 + v_crt + v_C_P2)",
  "comp_CRT_N2 := (0)/(b_n2^2*v_erp + 0 + v_crt + v_C_N2)",
  "comp_CRT_P3 := (v_p3)/(b_p3^2*v_erp + v_p3 + v_crt + v_C_P3)",
  "comp_Sternberg_P2 := (v_p2)/(v_erp + v_p2 + v_sternberg + v_S_P2)",
  "comp_Sternberg_N2 := (0)/(b_n2^2*v_erp +0 + v_sternberg + v_S_N2)",
  "comp_Sternberg_P3 := (v_p3)/(b_p3^2*v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # task specifities
  "task_Posner_P2 := (v_posner)/(v_erp + v_p2 + v_posner + v_P_P2)",
  "task_Posner_N2 := (v_posner)/(b_n2^2*v_erp + 0 + v_posner + v_P_N2)",
  "task_Posner_P3 := (v_posner)/(b_p3^2*v_erp + v_p3 + v_posner + v_P_P3)",
  "task_CRT_P2 := (v_crt)/(v_erp + v_p2 + v_crt + v_C_P2)",
  "task_CRT_N2 := (v_crt)/(b_n2^2*v_erp + 0 + v_crt + v_C_N2)",
  "task_CRT_P3 := (v_crt)/(b_p3^2*v_erp + v_p3 + v_crt + v_C_P3)",
  "task_Sternberg_P2 := (v_sternberg)/(v_erp + v_p2 + v_sternberg + v_S_P2)",
  "task_Sternberg_N2 := (v_sternberg)/(b_n2^2*v_erp +0 + v_sternberg + v_S_N2)",
  "task_Sternberg_P3 := (v_sternberg)/(b_p3^2*v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # reliabilities
  "rel_Posner_P2 := (v_erp + v_p2 + v_posner)/(v_erp + v_p2 + v_posner + v_P_P2)",
  "rel_Posner_N2 := (b_n2^2*v_erp + 0 + v_posner)/(b_n2^2*v_erp + 0 + v_posner + v_P_N2)",
  "rel_Posner_P3 := (b_p3^2*v_erp + v_p3 + v_posner)/(b_p3^2*v_erp + v_p3 + v_posner + v_P_P3)",
  "rel_CRT_P2 := (v_erp + v_p2 + v_crt)/(v_erp + v_p2 + v_crt + v_C_P2)",
  "rel_CRT_N2 := (b_n2^2*v_erp + 0 + v_crt)/(b_n2^2*v_erp + 0 + v_crt + v_C_N2)",
  "rel_CRT_P3 := (b_p3^2*v_erp + v_p3 + v_crt)/(b_p3^2*v_erp + v_p3 + v_crt + v_C_P3)",
  "rel_Sternberg_P2 := (v_erp + v_p2 + v_sternberg)/(v_erp + v_p2 + v_sternberg + v_S_P2)",
  "rel_Sternberg_N2 := (b_n2^2*v_erp +0 + v_sternberg)/(b_n2^2*v_erp +0 + v_sternberg + v_S_N2)",
  "rel_Sternberg_P3 := (b_p3^2*v_erp + v_p3 + v_sternberg)/(b_p3^2*v_erp + v_p3 + v_sternberg + v_S_P3)")

fit_avg_8Hz_FA <- sem(model_avg_8Hz_FA, data = data, estimator = "MLR" , missing="fiml", std.lv = FALSE)
summary(fit_avg_8Hz_FA, fit.measures=TRUE,standardized = TRUE,rsquare=T, ci = TRUE)

## SEM: Average reference, 16 Hz low-pass filter, peak latency ----

model_avg_16Hz_PL <- c(# hierarchical model
  "P2 =~ 1*zPosner_P2_PL_16Hz_avg + 1*zCRT_P2_PL_16Hz_avg + 1*zSternberg_P2_PL_16Hz_avg",
  "N2 =~ 1*zPosner_N2_PL_16Hz_avg + 1*zCRT_N2_PL_16Hz_avg + 1*zSternberg_N2_PL_16Hz_avg",
  "P3 =~ 1*zPosner_P3_PL_16Hz_avg + 1*zCRT_P3_PL_16Hz_avg + 1*zSternberg_P3_PL_16Hz_avg",
  "ERP =~ 1*P2 + b_n2*N2 + b_p3*P3",
  
  # task-specific factors
  "Posner =~ 1*zPosner_P2_PL_16Hz_avg + 1*zPosner_N2_PL_16Hz_avg + 1*zPosner_P3_PL_16Hz_avg",
  "CRT =~ 1*zCRT_P2_PL_16Hz_avg + 1*zCRT_N2_PL_16Hz_avg + 1*zCRT_P3_PL_16Hz_avg",
  "Sternberg =~ 1*zSternberg_P2_PL_16Hz_avg + 1*zSternberg_N2_PL_16Hz_avg + 1*zSternberg_P3_PL_16Hz_avg",
  "Posner ~~ 0*CRT + 0*Sternberg",
  "CRT ~~ 0*Sternberg",
  
  # cognitive abilities
  "gf =~ zPC + zPS + zM + zC",
  
  # structural model
  "ERP ~~ gf",
  "gf ~~ 0*P2 + 0*N2 + 0*P3",
  "gf ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "P2 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "N2 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "P3 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "ERP ~~ 0*Posner + 0*CRT + 0*Sternberg",
  
  # fix intercepts to zero
  "zPosner_P2_PL_16Hz_avg ~ 0",
  "zPosner_N2_PL_16Hz_avg ~ 0",
  "zPosner_P3_PL_16Hz_avg ~ 0",
  "zCRT_P2_PL_16Hz_avg ~ 0",
  "zCRT_N2_PL_16Hz_avg ~ 0",
  "zCRT_P3_PL_16Hz_avg ~ 0",
  "zSternberg_P2_PL_16Hz_avg ~ 0",
  "zSternberg_N2_PL_16Hz_avg ~ 0",
  "zSternberg_P3_PL_16Hz_avg ~ 0",
  "zPC ~ 0",
  "zPS ~ 0",
  "zM ~ 0",
  "zC ~ 0",
  
  # variances
  "ERP ~~ v_erp*ERP",
  "CRT ~~ v_crt*CRT",
  "Sternberg ~~ v_sternberg*Sternberg",
  "Posner ~~ v_posner*Posner",
  "P2 ~~ v_p2*P2",
  "N2 ~~ 0*N2",
  "P3 ~~ v_p3*P3",
  "zPosner_P2_PL_16Hz_avg ~~ v_P_P2*zPosner_P2_PL_16Hz_avg",
  "zPosner_N2_PL_16Hz_avg ~~ v_P_N2*zPosner_N2_PL_16Hz_avg",
  "zPosner_P3_PL_16Hz_avg~~ v_P_P3*zPosner_P3_PL_16Hz_avg",
  "zCRT_P2_PL_16Hz_avg ~~ v_C_P2*zCRT_P2_PL_16Hz_avg",
  "zCRT_N2_PL_16Hz_avg ~~ v_C_N2*zCRT_N2_PL_16Hz_avg",
  "zCRT_P3_PL_16Hz_avg ~~ v_C_P3*zCRT_P3_PL_16Hz_avg",
  "zSternberg_P2_PL_16Hz_avg ~~ v_S_P2*zSternberg_P2_PL_16Hz_avg",
  "zSternberg_N2_PL_16Hz_avg ~~ v_S_N2*zSternberg_N2_PL_16Hz_avg",
  "zSternberg_P3_PL_16Hz_avg ~~ v_S_P3*zSternberg_P3_PL_16Hz_avg",
  
  # consistencies
  "consistency_Posner_P2 := (v_erp)/(v_erp + v_p2 + v_posner + v_P_P2)",
  "consistency_N2 := (b_n2^2*v_erp)/(b_n2^2*v_erp + 0 + v_posner + v_P_N2)",
  "consistency_Posner_P3 := (b_p3^2*v_erp)/(b_p3^2*v_erp + v_p3 + v_posner + v_P_P3)",
  "consistency_CRT_P2 := (v_erp)/(v_erp + v_p2 + v_crt + v_C_P2)",
  "consistency_CRT_N2 := (b_n2^2*v_erp)/(b_n2^2*v_erp + 0 + v_crt + v_C_N2)",
  "consistency_CRT_P3 := (b_p3^2*v_erp)/(b_p3^2*v_erp + v_p3 + v_crt + v_C_P3)",
  "consistency_Sternberg_P2 := (v_erp)/(v_erp + v_p2 + v_sternberg + v_S_P2)",
  "consistency_Sternberg_N2 := (b_n2^2*v_erp)/(b_n2^2*v_erp +0 + v_sternberg + v_S_N2)",
  "consistency_Sternberg_P3 := (b_p3^2*v_erp)/(b_p3^2*v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # component specifities
  "comp_Posner_P2 := (v_p2)/(v_erp + v_p2 + v_posner + v_P_P2)",
  "comp_Posner_N2 := (0)/(b_n2^2*v_erp + 0 + v_posner + v_P_N2)",
  "comp_Posner_P3 := (v_p3)/(b_p3^2*v_erp + v_p3 + v_posner + v_P_P3)",
  "comp_CRT_P2 := (v_p2)/(v_erp + v_p2 + v_crt + v_C_P2)",
  "comp_CRT_N2 := (0)/(b_n2^2*v_erp + 0 + v_crt + v_C_N2)",
  "comp_CRT_P3 := (v_p3)/(b_p3^2*v_erp + v_p3 + v_crt + v_C_P3)",
  "comp_Sternberg_P2 := (v_p2)/(v_erp + v_p2 + v_sternberg + v_S_P2)",
  "comp_Sternberg_N2 := (0)/(b_n2^2*v_erp +0 + v_sternberg + v_S_N2)",
  "comp_Sternberg_P3 := (v_p3)/(b_p3^2*v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # task specifities
  "task_Posner_P2 := (v_posner)/(v_erp + v_p2 + v_posner + v_P_P2)",
  "task_Posner_N2 := (v_posner)/(b_n2^2*v_erp + 0 + v_posner + v_P_N2)",
  "task_Posner_P3 := (v_posner)/(b_p3^2*v_erp + v_p3 + v_posner + v_P_P3)",
  "task_CRT_P2 := (v_crt)/(v_erp + v_p2 + v_crt + v_C_P2)",
  "task_CRT_N2 := (v_crt)/(b_n2^2*v_erp + 0 + v_crt + v_C_N2)",
  "task_CRT_P3 := (v_crt)/(b_p3^2*v_erp + v_p3 + v_crt + v_C_P3)",
  "task_Sternberg_P2 := (v_sternberg)/(v_erp + v_p2 + v_sternberg + v_S_P2)",
  "task_Sternberg_N2 := (v_sternberg)/(b_n2^2*v_erp +0 + v_sternberg + v_S_N2)",
  "task_Sternberg_P3 := (v_sternberg)/(b_p3^2*v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # reliabilities
  "rel_Posner_P2 := (v_erp + v_p2 + v_posner)/(v_erp + v_p2 + v_posner + v_P_P2)",
  "rel_Posner_N2 := (b_n2^2*v_erp + 0 + v_posner)/(b_n2^2*v_erp + 0 + v_posner + v_P_N2)",
  "rel_Posner_P3 := (b_p3^2*v_erp + v_p3 + v_posner)/(b_p3^2*v_erp + v_p3 + v_posner + v_P_P3)",
  "rel_CRT_P2 := (v_erp + v_p2 + v_crt)/(v_erp + v_p2 + v_crt + v_C_P2)",
  "rel_CRT_N2 := (b_n2^2*v_erp + 0 + v_crt)/(b_n2^2*v_erp + 0 + v_crt + v_C_N2)",
  "rel_CRT_P3 := (b_p3^2*v_erp + v_p3 + v_crt)/(b_p3^2*v_erp + v_p3 + v_crt + v_C_P3)",
  "rel_Sternberg_P2 := (v_erp + v_p2 + v_sternberg)/(v_erp + v_p2 + v_sternberg + v_S_P2)",
  "rel_Sternberg_N2 := (b_n2^2*v_erp +0 + v_sternberg)/(b_n2^2*v_erp +0 + v_sternberg + v_S_N2)",
  "rel_Sternberg_P3 := (b_p3^2*v_erp + v_p3 + v_sternberg)/(b_p3^2*v_erp + v_p3 + v_sternberg + v_S_P3)")

fit_avg_16Hz_PL <- sem(model_avg_16Hz_PL, data = data, estimator = "MLR" , missing="fiml", std.lv = FALSE)
summary(fit_avg_16Hz_PL, fit.measures=TRUE,standardized = TRUE,rsquare=T, ci = TRUE)
standardizedsolution(fit_avg_16Hz_PL)
## SEM: Average reference, 16 Hz low-pass filter, 50 % FA latency ----

model_avg_16Hz_FA <- c(# hierarchical model
  "P2 =~ 1*zPosner_P2_FA_16Hz_avg + 1*zCRT_P2_FA_16Hz_avg + 1*zSternberg_P2_FA_16Hz_avg",
  "N2 =~ 1*zPosner_N2_FA_16Hz_avg + 1*zCRT_N2_FA_16Hz_avg + 1*zSternberg_N2_FA_16Hz_avg",
  "P3 =~ 1*zPosner_P3_FA_16Hz_avg + 1*zCRT_P3_FA_16Hz_avg + 1*zSternberg_P3_FA_16Hz_avg",
  "ERP =~ 1*P2 + b_n2*N2 + b_p3*P3",
  
  # task-specific factors
  "Posner =~ 1*zPosner_P2_FA_16Hz_avg + 1*zPosner_N2_FA_16Hz_avg + 1*zPosner_P3_FA_16Hz_avg",
  "CRT =~ 1*zCRT_P2_FA_16Hz_avg + 1*zCRT_N2_FA_16Hz_avg + 1*zCRT_P3_FA_16Hz_avg",
  "Sternberg =~ 1*zSternberg_P2_FA_16Hz_avg + 1*zSternberg_N2_FA_16Hz_avg + 1*zSternberg_P3_FA_16Hz_avg",
  "Posner ~~ 0*CRT + 0*Sternberg",
  "CRT ~~ 0*Sternberg",
  
  # cognitive abilities
  "gf =~ zPC + zPS + zM + zC",
  
  # structural model
  "ERP ~~ gf",
  "gf ~~ 0*P2 + 0*N2 + 0*P3",
  "gf ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "P2 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "N2 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "P3 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "ERP ~~ 0*Posner + 0*CRT + 0*Sternberg",
  
  # fix intercepts to zero
  "zPosner_P2_FA_16Hz_avg ~ 0",
  "zPosner_N2_FA_16Hz_avg ~ 0",
  "zPosner_P3_FA_16Hz_avg ~ 0",
  "zCRT_P2_FA_16Hz_avg ~ 0",
  "zCRT_N2_FA_16Hz_avg ~ 0",
  "zCRT_P3_FA_16Hz_avg ~ 0",
  "zSternberg_P2_FA_16Hz_avg ~ 0",
  "zSternberg_N2_FA_16Hz_avg ~ 0",
  "zSternberg_P3_FA_16Hz_avg ~ 0",
  "zPC ~ 0",
  "zPS ~ 0",
  "zM ~ 0",
  "zC ~ 0",
  
  # variances
  "ERP ~~ v_erp*ERP",
  "CRT ~~ v_crt*CRT",
  "Sternberg ~~ v_sternberg*Sternberg",
  "Posner ~~ v_posner*Posner",
  "P2 ~~ v_p2*P2",
  "N2 ~~ 0*N2",
  "P3 ~~ v_p3*P3",
  "zPosner_P2_FA_16Hz_avg ~~ v_P_P2*zPosner_P2_FA_16Hz_avg",
  "zPosner_N2_FA_16Hz_avg ~~ v_P_N2*zPosner_N2_FA_16Hz_avg",
  "zPosner_P3_FA_16Hz_avg~~ v_P_P3*zPosner_P3_FA_16Hz_avg",
  "zCRT_P2_FA_16Hz_avg ~~ v_C_P2*zCRT_P2_FA_16Hz_avg",
  "zCRT_N2_FA_16Hz_avg ~~ v_C_N2*zCRT_N2_FA_16Hz_avg",
  "zCRT_P3_FA_16Hz_avg ~~ v_C_P3*zCRT_P3_FA_16Hz_avg",
  "zSternberg_P2_FA_16Hz_avg ~~ v_S_P2*zSternberg_P2_FA_16Hz_avg",
  "zSternberg_N2_FA_16Hz_avg ~~ v_S_N2*zSternberg_N2_FA_16Hz_avg",
  "zSternberg_P3_FA_16Hz_avg ~~ v_S_P3*zSternberg_P3_FA_16Hz_avg",
  
  # consistencies
  "consistency_Posner_P2 := (v_erp)/(v_erp + v_p2 + v_posner + v_P_P2)",
  "consistency_N2 := (b_n2^2*v_erp)/(b_n2^2*v_erp + 0 + v_posner + v_P_N2)",
  "consistency_Posner_P3 := (b_p3^2*v_erp)/(b_p3^2*v_erp + v_p3 + v_posner + v_P_P3)",
  "consistency_CRT_P2 := (v_erp)/(v_erp + v_p2 + v_crt + v_C_P2)",
  "consistency_CRT_N2 := (b_n2^2*v_erp)/(b_n2^2*v_erp + 0 + v_crt + v_C_N2)",
  "consistency_CRT_P3 := (b_p3^2*v_erp)/(b_p3^2*v_erp + v_p3 + v_crt + v_C_P3)",
  "consistency_Sternberg_P2 := (v_erp)/(v_erp + v_p2 + v_sternberg + v_S_P2)",
  "consistency_Sternberg_N2 := (b_n2^2*v_erp)/(b_n2^2*v_erp +0 + v_sternberg + v_S_N2)",
  "consistency_Sternberg_P3 := (b_p3^2*v_erp)/(b_p3^2*v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # component specifities
  "comp_Posner_P2 := (v_p2)/(v_erp + v_p2 + v_posner + v_P_P2)",
  "comp_Posner_N2 := (0)/(b_n2^2*v_erp + 0 + v_posner + v_P_N2)",
  "comp_Posner_P3 := (v_p3)/(b_p3^2*v_erp + v_p3 + v_posner + v_P_P3)",
  "comp_CRT_P2 := (v_p2)/(v_erp + v_p2 + v_crt + v_C_P2)",
  "comp_CRT_N2 := (0)/(b_n2^2*v_erp + 0 + v_crt + v_C_N2)",
  "comp_CRT_P3 := (v_p3)/(b_p3^2*v_erp + v_p3 + v_crt + v_C_P3)",
  "comp_Sternberg_P2 := (v_p2)/(v_erp + v_p2 + v_sternberg + v_S_P2)",
  "comp_Sternberg_N2 := (0)/(b_n2^2*v_erp +0 + v_sternberg + v_S_N2)",
  "comp_Sternberg_P3 := (v_p3)/(b_p3^2*v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # task specifities
  "task_Posner_P2 := (v_posner)/(v_erp + v_p2 + v_posner + v_P_P2)",
  "task_Posner_N2 := (v_posner)/(b_n2^2*v_erp + 0 + v_posner + v_P_N2)",
  "task_Posner_P3 := (v_posner)/(b_p3^2*v_erp + v_p3 + v_posner + v_P_P3)",
  "task_CRT_P2 := (v_crt)/(v_erp + v_p2 + v_crt + v_C_P2)",
  "task_CRT_N2 := (v_crt)/(b_n2^2*v_erp + 0 + v_crt + v_C_N2)",
  "task_CRT_P3 := (v_crt)/(b_p3^2*v_erp + v_p3 + v_crt + v_C_P3)",
  "task_Sternberg_P2 := (v_sternberg)/(v_erp + v_p2 + v_sternberg + v_S_P2)",
  "task_Sternberg_N2 := (v_sternberg)/(b_n2^2*v_erp +0 + v_sternberg + v_S_N2)",
  "task_Sternberg_P3 := (v_sternberg)/(b_p3^2*v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # reliabilities
  "rel_Posner_P2 := (v_erp + v_p2 + v_posner)/(v_erp + v_p2 + v_posner + v_P_P2)",
  "rel_Posner_N2 := (b_n2^2*v_erp + 0 + v_posner)/(b_n2^2*v_erp + 0 + v_posner + v_P_N2)",
  "rel_Posner_P3 := (b_p3^2*v_erp + v_p3 + v_posner)/(b_p3^2*v_erp + v_p3 + v_posner + v_P_P3)",
  "rel_CRT_P2 := (v_erp + v_p2 + v_crt)/(v_erp + v_p2 + v_crt + v_C_P2)",
  "rel_CRT_N2 := (b_n2^2*v_erp + 0 + v_crt)/(b_n2^2*v_erp + 0 + v_crt + v_C_N2)",
  "rel_CRT_P3 := (b_p3^2*v_erp + v_p3 + v_crt)/(b_p3^2*v_erp + v_p3 + v_crt + v_C_P3)",
  "rel_Sternberg_P2 := (v_erp + v_p2 + v_sternberg)/(v_erp + v_p2 + v_sternberg + v_S_P2)",
  "rel_Sternberg_N2 := (b_n2^2*v_erp +0 + v_sternberg)/(b_n2^2*v_erp +0 + v_sternberg + v_S_N2)",
  "rel_Sternberg_P3 := (b_p3^2*v_erp + v_p3 + v_sternberg)/(b_p3^2*v_erp + v_p3 + v_sternberg + v_S_P3)")

fit_avg_16Hz_FA <- sem(model_avg_16Hz_FA, data = data, estimator = "MLR" , missing="fiml", std.lv = FALSE)
summary(fit_avg_16Hz_FA, fit.measures=TRUE,standardized = TRUE,rsquare=T, ci = TRUE)

## SEM: Average reference, 32 Hz low-pass filter, peak latency ----

model_avg_32Hz_PL <- c(# hierarchical model
  "P2 =~ 1*zPosner_P2_PL_32Hz_avg + 1*zCRT_P2_PL_32Hz_avg + 1*zSternberg_P2_PL_32Hz_avg",
  "N2 =~ 1*zPosner_N2_PL_32Hz_avg + 1*zCRT_N2_PL_32Hz_avg + 1*zSternberg_N2_PL_32Hz_avg",
  "P3 =~ 1*zPosner_P3_PL_32Hz_avg + 1*zCRT_P3_PL_32Hz_avg + 1*zSternberg_P3_PL_32Hz_avg",
  "ERP =~ 1*P2 + b_n2*N2 + b_p3*P3",
  
  # task-specific factors
  "Posner =~ 1*zPosner_P2_PL_32Hz_avg + 1*zPosner_N2_PL_32Hz_avg + 1*zPosner_P3_PL_32Hz_avg",
  "CRT =~ 1*zCRT_P2_PL_32Hz_avg + 1*zCRT_N2_PL_32Hz_avg + 1*zCRT_P3_PL_32Hz_avg",
  "Sternberg =~ 1*zSternberg_P2_PL_32Hz_avg + 1*zSternberg_N2_PL_32Hz_avg + 1*zSternberg_P3_PL_32Hz_avg",
  "Posner ~~ 0*CRT + 0*Sternberg",
  "CRT ~~ 0*Sternberg",
  
  # cognitive abilities
  "gf =~ zPC + zPS + zM + zC",
  
  # structural model
  "ERP ~~ gf",
  "gf ~~ 0*P2 + 0*N2 + 0*P3",
  "gf ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "P2 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "N2 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "P3 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "ERP ~~ 0*Posner + 0*CRT + 0*Sternberg",
  
  # fix intercepts to zero
  "zPosner_P2_PL_32Hz_avg ~ 0",
  "zPosner_N2_PL_32Hz_avg ~ 0",
  "zPosner_P3_PL_32Hz_avg ~ 0",
  "zCRT_P2_PL_32Hz_avg ~ 0",
  "zCRT_N2_PL_32Hz_avg ~ 0",
  "zCRT_P3_PL_32Hz_avg ~ 0",
  "zSternberg_P2_PL_32Hz_avg ~ 0",
  "zSternberg_N2_PL_32Hz_avg ~ 0",
  "zSternberg_P3_PL_32Hz_avg ~ 0",
  "zPC ~ 0",
  "zPS ~ 0",
  "zM ~ 0",
  "zC ~ 0",
  
  # variances
  "ERP ~~ v_erp*ERP",
  "CRT ~~ v_crt*CRT",
  "Sternberg ~~ v_sternberg*Sternberg",
  "Posner ~~ v_posner*Posner",
  "P2 ~~ v_p2*P2",
  "N2 ~~ 0*N2",
  "P3 ~~ v_p3*P3",
  "zPosner_P2_PL_32Hz_avg ~~ v_P_P2*zPosner_P2_PL_32Hz_avg",
  "zPosner_N2_PL_32Hz_avg ~~ v_P_N2*zPosner_N2_PL_32Hz_avg",
  "zPosner_P3_PL_32Hz_avg~~ v_P_P3*zPosner_P3_PL_32Hz_avg",
  "zCRT_P2_PL_32Hz_avg ~~ v_C_P2*zCRT_P2_PL_32Hz_avg",
  "zCRT_N2_PL_32Hz_avg ~~ v_C_N2*zCRT_N2_PL_32Hz_avg",
  "zCRT_P3_PL_32Hz_avg ~~ v_C_P3*zCRT_P3_PL_32Hz_avg",
  "zSternberg_P2_PL_32Hz_avg ~~ v_S_P2*zSternberg_P2_PL_32Hz_avg",
  "zSternberg_N2_PL_32Hz_avg ~~ v_S_N2*zSternberg_N2_PL_32Hz_avg",
  "zSternberg_P3_PL_32Hz_avg ~~ v_S_P3*zSternberg_P3_PL_32Hz_avg",
  
  # consistencies
  "consistency_Posner_P2 := (v_erp)/(v_erp + v_p2 + v_posner + v_P_P2)",
  "consistency_N2 := (b_n2^2*v_erp)/(b_n2^2*v_erp + 0 + v_posner + v_P_N2)",
  "consistency_Posner_P3 := (b_p3^2*v_erp)/(b_p3^2*v_erp + v_p3 + v_posner + v_P_P3)",
  "consistency_CRT_P2 := (v_erp)/(v_erp + v_p2 + v_crt + v_C_P2)",
  "consistency_CRT_N2 := (b_n2^2*v_erp)/(b_n2^2*v_erp + 0 + v_crt + v_C_N2)",
  "consistency_CRT_P3 := (b_p3^2*v_erp)/(b_p3^2*v_erp + v_p3 + v_crt + v_C_P3)",
  "consistency_Sternberg_P2 := (v_erp)/(v_erp + v_p2 + v_sternberg + v_S_P2)",
  "consistency_Sternberg_N2 := (b_n2^2*v_erp)/(b_n2^2*v_erp +0 + v_sternberg + v_S_N2)",
  "consistency_Sternberg_P3 := (b_p3^2*v_erp)/(b_p3^2*v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # component specifities
  "comp_Posner_P2 := (v_p2)/(v_erp + v_p2 + v_posner + v_P_P2)",
  "comp_Posner_N2 := (0)/(b_n2^2*v_erp + 0 + v_posner + v_P_N2)",
  "comp_Posner_P3 := (v_p3)/(b_p3^2*v_erp + v_p3 + v_posner + v_P_P3)",
  "comp_CRT_P2 := (v_p2)/(v_erp + v_p2 + v_crt + v_C_P2)",
  "comp_CRT_N2 := (0)/(b_n2^2*v_erp + 0 + v_crt + v_C_N2)",
  "comp_CRT_P3 := (v_p3)/(b_p3^2*v_erp + v_p3 + v_crt + v_C_P3)",
  "comp_Sternberg_P2 := (v_p2)/(v_erp + v_p2 + v_sternberg + v_S_P2)",
  "comp_Sternberg_N2 := (0)/(b_n2^2*v_erp +0 + v_sternberg + v_S_N2)",
  "comp_Sternberg_P3 := (v_p3)/(b_p3^2*v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # task specifities
  "task_Posner_P2 := (v_posner)/(v_erp + v_p2 + v_posner + v_P_P2)",
  "task_Posner_N2 := (v_posner)/(b_n2^2*v_erp + 0 + v_posner + v_P_N2)",
  "task_Posner_P3 := (v_posner)/(b_p3^2*v_erp + v_p3 + v_posner + v_P_P3)",
  "task_CRT_P2 := (v_crt)/(v_erp + v_p2 + v_crt + v_C_P2)",
  "task_CRT_N2 := (v_crt)/(b_n2^2*v_erp + 0 + v_crt + v_C_N2)",
  "task_CRT_P3 := (v_crt)/(b_p3^2*v_erp + v_p3 + v_crt + v_C_P3)",
  "task_Sternberg_P2 := (v_sternberg)/(v_erp + v_p2 + v_sternberg + v_S_P2)",
  "task_Sternberg_N2 := (v_sternberg)/(b_n2^2*v_erp +0 + v_sternberg + v_S_N2)",
  "task_Sternberg_P3 := (v_sternberg)/(b_p3^2*v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # reliabilities
  "rel_Posner_P2 := (v_erp + v_p2 + v_posner)/(v_erp + v_p2 + v_posner + v_P_P2)",
  "rel_Posner_N2 := (b_n2^2*v_erp + 0 + v_posner)/(b_n2^2*v_erp + 0 + v_posner + v_P_N2)",
  "rel_Posner_P3 := (b_p3^2*v_erp + v_p3 + v_posner)/(b_p3^2*v_erp + v_p3 + v_posner + v_P_P3)",
  "rel_CRT_P2 := (v_erp + v_p2 + v_crt)/(v_erp + v_p2 + v_crt + v_C_P2)",
  "rel_CRT_N2 := (b_n2^2*v_erp + 0 + v_crt)/(b_n2^2*v_erp + 0 + v_crt + v_C_N2)",
  "rel_CRT_P3 := (b_p3^2*v_erp + v_p3 + v_crt)/(b_p3^2*v_erp + v_p3 + v_crt + v_C_P3)",
  "rel_Sternberg_P2 := (v_erp + v_p2 + v_sternberg)/(v_erp + v_p2 + v_sternberg + v_S_P2)",
  "rel_Sternberg_N2 := (b_n2^2*v_erp +0 + v_sternberg)/(b_n2^2*v_erp +0 + v_sternberg + v_S_N2)",
  "rel_Sternberg_P3 := (b_p3^2*v_erp + v_p3 + v_sternberg)/(b_p3^2*v_erp + v_p3 + v_sternberg + v_S_P3)")


fit_avg_32Hz_PL <- sem(model_avg_32Hz_PL, data = data, estimator = "MLR" , missing="fiml", std.lv = FALSE)
summary(fit_avg_32Hz_PL, fit.measures=TRUE,standardized = TRUE,rsquare=T, ci = TRUE)

## SEM: Average reference, 32 Hz low-pass filter, 50 % FA latency ----

model_avg_32Hz_FA <- c(# hierarchical model
  "P2 =~ 1*zPosner_P2_FA_32Hz_avg + 1*zCRT_P2_FA_32Hz_avg + 1*zSternberg_P2_FA_32Hz_avg",
  "N2 =~ 1*zPosner_N2_FA_32Hz_avg + 1*zCRT_N2_FA_32Hz_avg + 1*zSternberg_N2_FA_32Hz_avg",
  "P3 =~ 1*zPosner_P3_FA_32Hz_avg + 1*zCRT_P3_FA_32Hz_avg + 1*zSternberg_P3_FA_32Hz_avg",
  "ERP =~ 1*P2 + b_n2*N2 + b_p3*P3",
  
  # task-specific factors
  "Posner =~ 1*zPosner_P2_FA_32Hz_avg + 1*zPosner_N2_FA_32Hz_avg + 1*zPosner_P3_FA_32Hz_avg",
  "CRT =~ 1*zCRT_P2_FA_32Hz_avg + 1*zCRT_N2_FA_32Hz_avg + 1*zCRT_P3_FA_32Hz_avg",
  "Sternberg =~ 1*zSternberg_P2_FA_32Hz_avg + 1*zSternberg_N2_FA_32Hz_avg + 1*zSternberg_P3_FA_32Hz_avg",
  "Posner ~~ 0*CRT + 0*Sternberg",
  "CRT ~~ 0*Sternberg",
  
  # cognitive abilities
  "gf =~ zPC + zPS + zM + zC",
  
  # structural model
  "ERP ~~ gf",
  "gf ~~ 0*P2 + 0*N2 + 0*P3",
  "gf ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "P2 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "N2 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "P3 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "ERP ~~ 0*Posner + 0*CRT + 0*Sternberg",
  
  # fix intercepts to zero
  "zPosner_P2_FA_32Hz_avg ~ 0",
  "zPosner_N2_FA_32Hz_avg ~ 0",
  "zPosner_P3_FA_32Hz_avg ~ 0",
  "zCRT_P2_FA_32Hz_avg ~ 0",
  "zCRT_N2_FA_32Hz_avg ~ 0",
  "zCRT_P3_FA_32Hz_avg ~ 0",
  "zSternberg_P2_FA_32Hz_avg ~ 0",
  "zSternberg_N2_FA_32Hz_avg ~ 0",
  "zSternberg_P3_FA_32Hz_avg ~ 0",
  "zPC ~ 0",
  "zPS ~ 0",
  "zM ~ 0",
  "zC ~ 0",
  
  # variances
  "ERP ~~ v_erp*ERP",
  "CRT ~~ v_crt*CRT",
  "Sternberg ~~ v_sternberg*Sternberg",
  "Posner ~~ v_posner*Posner",
  "P2 ~~ v_p2*P2",
  "N2 ~~ 0*N2",
  "P3 ~~ v_p3*P3",
  "zPosner_P2_FA_32Hz_avg ~~ v_P_P2*zPosner_P2_FA_32Hz_avg",
  "zPosner_N2_FA_32Hz_avg ~~ v_P_N2*zPosner_N2_FA_32Hz_avg",
  "zPosner_P3_FA_32Hz_avg~~ v_P_P3*zPosner_P3_FA_32Hz_avg",
  "zCRT_P2_FA_32Hz_avg ~~ v_C_P2*zCRT_P2_FA_32Hz_avg",
  "zCRT_N2_FA_32Hz_avg ~~ v_C_N2*zCRT_N2_FA_32Hz_avg",
  "zCRT_P3_FA_32Hz_avg ~~ v_C_P3*zCRT_P3_FA_32Hz_avg",
  "zSternberg_P2_FA_32Hz_avg ~~ v_S_P2*zSternberg_P2_FA_32Hz_avg",
  "zSternberg_N2_FA_32Hz_avg ~~ v_S_N2*zSternberg_N2_FA_32Hz_avg",
  "zSternberg_P3_FA_32Hz_avg ~~ v_S_P3*zSternberg_P3_FA_32Hz_avg",
  
  # consistencies
  "consistency_Posner_P2 := (v_erp)/(v_erp + v_p2 + v_posner + v_P_P2)",
  "consistency_N2 := (b_n2^2*v_erp)/(b_n2^2*v_erp + 0 + v_posner + v_P_N2)",
  "consistency_Posner_P3 := (b_p3^2*v_erp)/(b_p3^2*v_erp + v_p3 + v_posner + v_P_P3)",
  "consistency_CRT_P2 := (v_erp)/(v_erp + v_p2 + v_crt + v_C_P2)",
  "consistency_CRT_N2 := (b_n2^2*v_erp)/(b_n2^2*v_erp + 0 + v_crt + v_C_N2)",
  "consistency_CRT_P3 := (b_p3^2*v_erp)/(b_p3^2*v_erp + v_p3 + v_crt + v_C_P3)",
  "consistency_Sternberg_P2 := (v_erp)/(v_erp + v_p2 + v_sternberg + v_S_P2)",
  "consistency_Sternberg_N2 := (b_n2^2*v_erp)/(b_n2^2*v_erp +0 + v_sternberg + v_S_N2)",
  "consistency_Sternberg_P3 := (b_p3^2*v_erp)/(b_p3^2*v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # component specifities
  "comp_Posner_P2 := (v_p2)/(v_erp + v_p2 + v_posner + v_P_P2)",
  "comp_Posner_N2 := (0)/(b_n2^2*v_erp + 0 + v_posner + v_P_N2)",
  "comp_Posner_P3 := (v_p3)/(b_p3^2*v_erp + v_p3 + v_posner + v_P_P3)",
  "comp_CRT_P2 := (v_p2)/(v_erp + v_p2 + v_crt + v_C_P2)",
  "comp_CRT_N2 := (0)/(b_n2^2*v_erp + 0 + v_crt + v_C_N2)",
  "comp_CRT_P3 := (v_p3)/(b_p3^2*v_erp + v_p3 + v_crt + v_C_P3)",
  "comp_Sternberg_P2 := (v_p2)/(v_erp + v_p2 + v_sternberg + v_S_P2)",
  "comp_Sternberg_N2 := (0)/(b_n2^2*v_erp +0 + v_sternberg + v_S_N2)",
  "comp_Sternberg_P3 := (v_p3)/(b_p3^2*v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # task specifities
  "task_Posner_P2 := (v_posner)/(v_erp + v_p2 + v_posner + v_P_P2)",
  "task_Posner_N2 := (v_posner)/(b_n2^2*v_erp + 0 + v_posner + v_P_N2)",
  "task_Posner_P3 := (v_posner)/(b_p3^2*v_erp + v_p3 + v_posner + v_P_P3)",
  "task_CRT_P2 := (v_crt)/(v_erp + v_p2 + v_crt + v_C_P2)",
  "task_CRT_N2 := (v_crt)/(b_n2^2*v_erp + 0 + v_crt + v_C_N2)",
  "task_CRT_P3 := (v_crt)/(b_p3^2*v_erp + v_p3 + v_crt + v_C_P3)",
  "task_Sternberg_P2 := (v_sternberg)/(v_erp + v_p2 + v_sternberg + v_S_P2)",
  "task_Sternberg_N2 := (v_sternberg)/(b_n2^2*v_erp +0 + v_sternberg + v_S_N2)",
  "task_Sternberg_P3 := (v_sternberg)/(b_p3^2*v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # reliabilities
  "rel_Posner_P2 := (v_erp + v_p2 + v_posner)/(v_erp + v_p2 + v_posner + v_P_P2)",
  "rel_Posner_N2 := (b_n2^2*v_erp + 0 + v_posner)/(b_n2^2*v_erp + 0 + v_posner + v_P_N2)",
  "rel_Posner_P3 := (b_p3^2*v_erp + v_p3 + v_posner)/(b_p3^2*v_erp + v_p3 + v_posner + v_P_P3)",
  "rel_CRT_P2 := (v_erp + v_p2 + v_crt)/(v_erp + v_p2 + v_crt + v_C_P2)",
  "rel_CRT_N2 := (b_n2^2*v_erp + 0 + v_crt)/(b_n2^2*v_erp + 0 + v_crt + v_C_N2)",
  "rel_CRT_P3 := (b_p3^2*v_erp + v_p3 + v_crt)/(b_p3^2*v_erp + v_p3 + v_crt + v_C_P3)",
  "rel_Sternberg_P2 := (v_erp + v_p2 + v_sternberg)/(v_erp + v_p2 + v_sternberg + v_S_P2)",
  "rel_Sternberg_N2 := (b_n2^2*v_erp +0 + v_sternberg)/(b_n2^2*v_erp +0 + v_sternberg + v_S_N2)",
  "rel_Sternberg_P3 := (b_p3^2*v_erp + v_p3 + v_sternberg)/(b_p3^2*v_erp + v_p3 + v_sternberg + v_S_P3)")

fit_avg_32Hz_FA <- sem(model_avg_32Hz_FA, data = data, estimator = "MLR" , missing="fiml", std.lv = FALSE)
summary(fit_avg_32Hz_FA, fit.measures=TRUE,standardized = TRUE,rsquare=T, ci = TRUE)

## SEM: Linked mastoids reference, 8 Hz low-pass filter, peak latency ----

model_mas_8Hz_PL <- c(# hierarchical model
  "P2 =~ 1*zPosner_P2_PL_8Hz_mas + 1*zCRT_P2_PL_8Hz_mas + 1*zSternberg_P2_PL_8Hz_mas",
  "N2 =~ 1*zPosner_N2_PL_8Hz_mas + 1*zCRT_N2_PL_8Hz_mas + 1*zSternberg_N2_PL_8Hz_mas",
  "P3 =~ 1*zPosner_P3_PL_8Hz_mas + 1*zCRT_P3_PL_8Hz_mas + 1*zSternberg_P3_PL_8Hz_mas",
  "ERP =~ 1*N2 + 1*P3",
  
  # task-specific factors
  "Posner =~ 1*zPosner_N2_PL_8Hz_mas + 1*zPosner_P3_PL_8Hz_mas",
  "CRT =~ 1*zCRT_N2_PL_8Hz_mas + 1*zCRT_P3_PL_8Hz_mas",
  "Sternberg =~ 1*zSternberg_N2_PL_8Hz_mas + 1*zSternberg_P3_PL_8Hz_mas",
  "Posner ~~ 0*CRT + 0*Sternberg",
  "CRT ~~ 0*Sternberg",
  
  # cognitive abilities
  "gf =~ zPC + zPS + zM + zC",
  
  # structural model
  "ERP ~~ gf",
  "gf ~~ 0*N2 + 0*P3",
  "gf ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "P2 ~~ 0*Posner + 0*CRT + 0*Sternberg + 0*ERP",
  "N2 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "P3 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "ERP ~~ 0*Posner + 0*CRT + 0*Sternberg",
  
  # fix intercepts to zero
  "zPosner_P2_PL_8Hz_mas ~ 0",
  "zPosner_N2_PL_8Hz_mas ~ 0",
  "zPosner_P3_PL_8Hz_mas ~ 0",
  "zCRT_P2_PL_8Hz_mas ~ 0",
  "zCRT_N2_PL_8Hz_mas ~ 0",
  "zCRT_P3_PL_8Hz_mas ~ 0",
  "zSternberg_P2_PL_8Hz_mas ~ 0",
  "zSternberg_N2_PL_8Hz_mas ~ 0",
  "zSternberg_P3_PL_8Hz_mas ~ 0",
  "zPC ~ 0",
  "zPS ~ 0",
  "zM ~ 0",
  "zC ~ 0",
  
  # variances
  "ERP ~~ v_erp*ERP",
  "CRT ~~ v_crt*CRT",
  "Sternberg ~~ v_sternberg*Sternberg",
  "Posner ~~ v_posner*Posner",
  "P2 ~~ v_p2*P2",
  "N2 ~~ v_n2*N2",
  "P3 ~~ v_p3*P3",
  "zPosner_P2_PL_8Hz_mas ~~ v_P_P2*zPosner_P2_PL_8Hz_mas",
  "zPosner_N2_PL_8Hz_mas ~~ v_P_N2*zPosner_N2_PL_8Hz_mas",
  "zPosner_P3_PL_8Hz_mas~~ v_P_P3*zPosner_P3_PL_8Hz_mas",
  "zCRT_P2_PL_8Hz_mas ~~ v_C_P2*zCRT_P2_PL_8Hz_mas",
  "zCRT_N2_PL_8Hz_mas ~~ v_C_N2*zCRT_N2_PL_8Hz_mas",
  "zCRT_P3_PL_8Hz_mas ~~ v_C_P3*zCRT_P3_PL_8Hz_mas",
  "zSternberg_P2_PL_8Hz_mas ~~ v_S_P2*zSternberg_P2_PL_8Hz_mas",
  "zSternberg_N2_PL_8Hz_mas ~~ v_S_N2*zSternberg_N2_PL_8Hz_mas",
  "zSternberg_P3_PL_8Hz_mas ~~ v_S_P3*zSternberg_P3_PL_8Hz_mas",
  
  # trait specifities
  "trait_Posner_P2 := (0*v_erp)/(0*v_erp + v_p2 + 0*v_posner + v_P_P2)",
  "trait_Posner_N2 := (v_erp)/(v_erp + v_n2 + v_posner + v_P_N2)",
  "trait_Posner_P3 := (v_erp)/(v_erp + v_p3 + v_posner + v_P_P3)",
  "trait_CRT_P2 := (0*v_erp)/(0*v_erp + v_p2 + 0*v_crt + v_C_P2)",
  "trait_CRT_N2 := (v_erp)/(v_erp + v_n2 + v_crt + v_C_N2)",
  "trait_CRT_P3 := (v_erp)/(v_erp + v_p3 + v_crt + v_C_P3)",
  "trait_Sternberg_P2 := (0*v_erp)/(0*v_erp + v_p2 + 0*v_sternberg + v_S_P2)",
  "trait_Sternberg_N2 := (v_erp)/(v_erp +v_n2 + v_sternberg + v_S_N2)",
  "trait_Sternberg_P3 := (v_erp)/(v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # component specifities
  "comp_Posner_P2 := (v_p2)/(0*v_erp + v_p2 + 0*v_posner + v_P_P2)",
  "comp_Posner_N2 := (v_n2)/(v_erp + v_n2 + v_posner + v_P_N2)",
  "comp_Posner_P3 := (v_p3)/(v_erp + v_p3 + v_posner + v_P_P3)",
  "comp_CRT_P2 := (v_p2)/(0*v_erp + v_p2 + 0*v_crt + v_C_P2)",
  "comp_CRT_N2 := (v_n2)/(v_erp + v_n2 + v_crt + v_C_N2)",
  "comp_CRT_P3 := (v_p3)/(v_erp + v_p3 + v_crt + v_C_P3)",
  "comp_Sternberg_P2 := (v_p2)/(0*v_erp + v_p2 + 0*v_sternberg + v_S_P2)",
  "comp_Sternberg_N2 := (v_n2)/(v_erp +v_n2 + v_sternberg + v_S_N2)",
  "comp_Sternberg_P3 := (v_p3)/(v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # task specifities
  "task_Posner_P2 := (0*v_posner)/(0*v_erp + v_p2 + 0*v_posner + v_P_P2)",
  "task_Posner_N2 := (v_posner)/(v_erp + v_n2 + v_posner + v_P_N2)",
  "task_Posner_P3 := (v_posner)/(v_erp + v_p3 + v_posner + v_P_P3)",
  "task_CRT_P2 := (0*v_crt)/(0*v_erp + v_p2 + 0*v_crt + v_C_P2)",
  "task_CRT_N2 := (v_crt)/(v_erp + v_n2 + v_crt + v_C_N2)",
  "task_CRT_P3 := (v_crt)/(v_erp + v_p3 + v_crt + v_C_P3)",
  "task_Sternberg_P2 := (0*v_sternberg)/(0*v_erp + v_p2 + 0*v_sternberg + v_S_P2)",
  "task_Sternberg_N2 := (v_sternberg)/(v_erp +v_n2 + v_sternberg + v_S_N2)",
  "task_Sternberg_P3 := (v_sternberg)/(v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # reliabilities
  "rel_Posner_P2 := (0*v_erp + v_p2 + 0*v_posner)/(0*v_erp + v_p2 + 0*v_posner + v_P_P2)",
  "rel_Posner_N2 := (v_erp + v_n2 + v_posner)/(v_erp + v_n2 + v_posner + v_P_N2)",
  "rel_Posner_P3 := (v_erp + v_p3 + v_posner)/(v_erp + v_p3 + v_posner + v_P_P3)",
  "rel_CRT_P2 := (0*v_erp + v_p2 + 0*v_crt)/(0*v_erp + v_p2 + 0*v_crt + v_C_P2)",
  "rel_CRT_N2 := (v_erp + v_n2 + v_crt)/(v_erp + v_n2 + v_crt + v_C_N2)",
  "rel_CRT_P3 := (v_erp + v_p3 + v_crt)/(v_erp + v_p3 + v_crt + v_C_P3)",
  "rel_Sternberg_P2 := (0*v_erp + v_p2 + 0*v_sternberg)/(0*v_erp + v_p2 + 0*v_sternberg + v_S_P2)",
  "rel_Sternberg_N2 := (v_erp +v_n2 + v_sternberg)/(v_erp +v_n2 + v_sternberg + v_S_N2)",
  "rel_Sternberg_P3 := (v_erp + v_p3 + v_sternberg)/(v_erp + v_p3 + v_sternberg + v_S_P3)")

fit_mas_8Hz_PL <- sem(model_mas_8Hz_PL, data = data, estimator = "MLR" , missing="fiml", std.lv = FALSE)
summary(fit_mas_8Hz_PL, fit.measures=TRUE,standardized = TRUE,rsquare=T, ci = TRUE)

## SEM: Linked mastoids reference, 8 Hz low-pass filter, 50 % FA latency ----

model_mas_8Hz_FA <- c(# hierarchical model
  "P2 =~ 1*zPosner_P2_FA_8Hz_mas + 1*zCRT_P2_FA_8Hz_mas + 1*zSternberg_P2_FA_8Hz_mas",
  "N2 =~ 1*zPosner_N2_FA_8Hz_mas + 1*zCRT_N2_FA_8Hz_mas + 1*zSternberg_N2_FA_8Hz_mas",
  "P3 =~ 1*zPosner_P3_FA_8Hz_mas + 1*zCRT_P3_FA_8Hz_mas + 1*zSternberg_P3_FA_8Hz_mas",
  "ERP =~ 1*N2 + 1*P3",
  
  # task-specific factors
  "Posner =~ 1*zPosner_N2_FA_8Hz_mas + 1*zPosner_P3_FA_8Hz_mas",
  "CRT =~ 1*zCRT_N2_FA_8Hz_mas + 1*zCRT_P3_FA_8Hz_mas",
  "Sternberg =~ 1*zSternberg_N2_FA_8Hz_mas + 1*zSternberg_P3_FA_8Hz_mas",
  "Posner ~~ 0*CRT + 0*Sternberg",
  "CRT ~~ 0*Sternberg",
  
  # cognitive abilities
  "gf =~ zPC + zPS + zM + zC",
  
  # structural model
  "ERP ~~ gf",
  "gf ~~ 0*N2 + 0*P3",
  "gf ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "P2 ~~ 0*Posner + 0*CRT + 0*Sternberg + 0*ERP",
  "N2 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "P3 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "ERP ~~ 0*Posner + 0*CRT + 0*Sternberg",
  
  # fix intercepts to zero
  "zPosner_P2_FA_8Hz_mas ~ 0",
  "zPosner_N2_FA_8Hz_mas ~ 0",
  "zPosner_P3_FA_8Hz_mas ~ 0",
  "zCRT_P2_FA_8Hz_mas ~ 0",
  "zCRT_N2_FA_8Hz_mas ~ 0",
  "zCRT_P3_FA_8Hz_mas ~ 0",
  "zSternberg_P2_FA_8Hz_mas ~ 0",
  "zSternberg_N2_FA_8Hz_mas ~ 0",
  "zSternberg_P3_FA_8Hz_mas ~ 0",
  "zPC ~ 0",
  "zPS ~ 0",
  "zM ~ 0",
  "zC ~ 0",
  
  # variances
  "ERP ~~ v_erp*ERP",
  "CRT ~~ v_crt*CRT",
  "Sternberg ~~ v_sternberg*Sternberg",
  "Posner ~~ v_posner*Posner",
  "P2 ~~ v_p2*P2",
  "N2 ~~ v_n2*N2",
  "P3 ~~ v_p3*P3",
  "zPosner_P2_FA_8Hz_mas ~~ v_P_P2*zPosner_P2_FA_8Hz_mas",
  "zPosner_N2_FA_8Hz_mas ~~ v_P_N2*zPosner_N2_FA_8Hz_mas",
  "zPosner_P3_FA_8Hz_mas~~ v_P_P3*zPosner_P3_FA_8Hz_mas",
  "zCRT_P2_FA_8Hz_mas ~~ v_C_P2*zCRT_P2_FA_8Hz_mas",
  "zCRT_N2_FA_8Hz_mas ~~ v_C_N2*zCRT_N2_FA_8Hz_mas",
  "zCRT_P3_FA_8Hz_mas ~~ v_C_P3*zCRT_P3_FA_8Hz_mas",
  "zSternberg_P2_FA_8Hz_mas ~~ v_S_P2*zSternberg_P2_FA_8Hz_mas",
  "zSternberg_N2_FA_8Hz_mas ~~ v_S_N2*zSternberg_N2_FA_8Hz_mas",
  "zSternberg_P3_FA_8Hz_mas ~~ v_S_P3*zSternberg_P3_FA_8Hz_mas",
  
  # trait specifities
  "trait_Posner_P2 := (0*v_erp)/(0*v_erp + v_p2 + 0*v_posner + v_P_P2)",
  "trait_Posner_N2 := (v_erp)/(v_erp + v_n2 + v_posner + v_P_N2)",
  "trait_Posner_P3 := (v_erp)/(v_erp + v_p3 + v_posner + v_P_P3)",
  "trait_CRT_P2 := (0*v_erp)/(0*v_erp + v_p2 + 0*v_crt + v_C_P2)",
  "trait_CRT_N2 := (v_erp)/(v_erp + v_n2 + v_crt + v_C_N2)",
  "trait_CRT_P3 := (v_erp)/(v_erp + v_p3 + v_crt + v_C_P3)",
  "trait_Sternberg_P2 := (0*v_erp)/(0*v_erp + v_p2 + 0*v_sternberg + v_S_P2)",
  "trait_Sternberg_N2 := (v_erp)/(v_erp +v_n2 + v_sternberg + v_S_N2)",
  "trait_Sternberg_P3 := (v_erp)/(v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # component specifities
  "comp_Posner_P2 := (v_p2)/(0*v_erp + v_p2 + 0*v_posner + v_P_P2)",
  "comp_Posner_N2 := (v_n2)/(v_erp + v_n2 + v_posner + v_P_N2)",
  "comp_Posner_P3 := (v_p3)/(v_erp + v_p3 + v_posner + v_P_P3)",
  "comp_CRT_P2 := (v_p2)/(0*v_erp + v_p2 + 0*v_crt + v_C_P2)",
  "comp_CRT_N2 := (v_n2)/(v_erp + v_n2 + v_crt + v_C_N2)",
  "comp_CRT_P3 := (v_p3)/(v_erp + v_p3 + v_crt + v_C_P3)",
  "comp_Sternberg_P2 := (v_p2)/(0*v_erp + v_p2 + 0*v_sternberg + v_S_P2)",
  "comp_Sternberg_N2 := (v_n2)/(v_erp +v_n2 + v_sternberg + v_S_N2)",
  "comp_Sternberg_P3 := (v_p3)/(v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # task specifities
  "task_Posner_P2 := (0*v_posner)/(0*v_erp + v_p2 + 0*v_posner + v_P_P2)",
  "task_Posner_N2 := (v_posner)/(v_erp + v_n2 + v_posner + v_P_N2)",
  "task_Posner_P3 := (v_posner)/(v_erp + v_p3 + v_posner + v_P_P3)",
  "task_CRT_P2 := (0*v_crt)/(0*v_erp + v_p2 + 0*v_crt + v_C_P2)",
  "task_CRT_N2 := (v_crt)/(v_erp + v_n2 + v_crt + v_C_N2)",
  "task_CRT_P3 := (v_crt)/(v_erp + v_p3 + v_crt + v_C_P3)",
  "task_Sternberg_P2 := (0*v_sternberg)/(0*v_erp + v_p2 + 0*v_sternberg + v_S_P2)",
  "task_Sternberg_N2 := (v_sternberg)/(v_erp +v_n2 + v_sternberg + v_S_N2)",
  "task_Sternberg_P3 := (v_sternberg)/(v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # reliabilities
  "rel_Posner_P2 := (0*v_erp + v_p2 + 0*v_posner)/(0*v_erp + v_p2 + 0*v_posner + v_P_P2)",
  "rel_Posner_N2 := (v_erp + v_n2 + v_posner)/(v_erp + v_n2 + v_posner + v_P_N2)",
  "rel_Posner_P3 := (v_erp + v_p3 + v_posner)/(v_erp + v_p3 + v_posner + v_P_P3)",
  "rel_CRT_P2 := (0*v_erp + v_p2 + 0*v_crt)/(0*v_erp + v_p2 + 0*v_crt + v_C_P2)",
  "rel_CRT_N2 := (v_erp + v_n2 + v_crt)/(v_erp + v_n2 + v_crt + v_C_N2)",
  "rel_CRT_P3 := (v_erp + v_p3 + v_crt)/(v_erp + v_p3 + v_crt + v_C_P3)",
  "rel_Sternberg_P2 := (0*v_erp + v_p2 + 0*v_sternberg)/(0*v_erp + v_p2 + 0*v_sternberg + v_S_P2)",
  "rel_Sternberg_N2 := (v_erp +v_n2 + v_sternberg)/(v_erp +v_n2 + v_sternberg + v_S_N2)",
  "rel_Sternberg_P3 := (v_erp + v_p3 + v_sternberg)/(v_erp + v_p3 + v_sternberg + v_S_P3)")

fit_mas_8Hz_FA <- sem(model_mas_8Hz_FA, data = data, estimator = "MLR" , missing="fiml", std.lv = FALSE)
summary(fit_mas_8Hz_FA, fit.measures=TRUE,standardized = TRUE,rsquare=T, ci = TRUE)

## SEM: Linked mastoids reference, 16 Hz low-pass filter, peak latency ----

model_mas_16Hz_PL <- c(# hierarchical model
  "P2 =~ 1*zPosner_P2_PL_16Hz_mas + 1*zCRT_P2_PL_16Hz_mas + 1*zSternberg_P2_PL_16Hz_mas",
  "N2 =~ 1*zPosner_N2_PL_16Hz_mas + 1*zCRT_N2_PL_16Hz_mas + 1*zSternberg_N2_PL_16Hz_mas",
  "P3 =~ 1*zPosner_P3_PL_16Hz_mas + 1*zCRT_P3_PL_16Hz_mas + 1*zSternberg_P3_PL_16Hz_mas",
  "ERP =~ 1*N2 + 1*P3",
  
  # task-specific factors
  "Posner =~ 1*zPosner_N2_PL_16Hz_mas + 1*zPosner_P3_PL_16Hz_mas",
  "CRT =~ 1*zCRT_N2_PL_16Hz_mas + 1*zCRT_P3_PL_16Hz_mas",
  "Sternberg =~ 1*zSternberg_N2_PL_16Hz_mas + 1*zSternberg_P3_PL_16Hz_mas",
  "Posner ~~ 0*CRT + 0*Sternberg",
  "CRT ~~ 0*Sternberg",
  
  # cognitive abilities
  "gf =~ zPC + zPS + zM + zC",
  
  # structural model
  "ERP ~~ gf",
  "gf ~~ 0*N2 + 0*P3",
  "gf ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "P2 ~~ 0*Posner + 0*CRT + 0*Sternberg + 0*ERP",
  "N2 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "P3 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "ERP ~~ 0*Posner + 0*CRT + 0*Sternberg",
  
  # fix intercepts to zero
  "zPosner_P2_PL_16Hz_mas ~ 0",
  "zPosner_N2_PL_16Hz_mas ~ 0",
  "zPosner_P3_PL_16Hz_mas ~ 0",
  "zCRT_P2_PL_16Hz_mas ~ 0",
  "zCRT_N2_PL_16Hz_mas ~ 0",
  "zCRT_P3_PL_16Hz_mas ~ 0",
  "zSternberg_P2_PL_16Hz_mas ~ 0",
  "zSternberg_N2_PL_16Hz_mas ~ 0",
  "zSternberg_P3_PL_16Hz_mas ~ 0",
  "zPC ~ 0",
  "zPS ~ 0",
  "zM ~ 0",
  "zC ~ 0",
  
  # variances
  "ERP ~~ v_erp*ERP",
  "CRT ~~ v_crt*CRT",
  "Sternberg ~~ v_sternberg*Sternberg",
  "Posner ~~ v_posner*Posner",
  "P2 ~~ v_p2*P2",
  "N2 ~~ 0*N2",
  "P3 ~~ v_p3*P3",
  "zPosner_P2_PL_16Hz_mas ~~ v_P_P2*zPosner_P2_PL_16Hz_mas",
  "zPosner_N2_PL_16Hz_mas ~~ v_P_N2*zPosner_N2_PL_16Hz_mas",
  "zPosner_P3_PL_16Hz_mas~~ v_P_P3*zPosner_P3_PL_16Hz_mas",
  "zCRT_P2_PL_16Hz_mas ~~ v_C_P2*zCRT_P2_PL_16Hz_mas",
  "zCRT_N2_PL_16Hz_mas ~~ v_C_N2*zCRT_N2_PL_16Hz_mas",
  "zCRT_P3_PL_16Hz_mas ~~ v_C_P3*zCRT_P3_PL_16Hz_mas",
  "zSternberg_P2_PL_16Hz_mas ~~ v_S_P2*zSternberg_P2_PL_16Hz_mas",
  "zSternberg_N2_PL_16Hz_mas ~~ v_S_N2*zSternberg_N2_PL_16Hz_mas",
  "zSternberg_P3_PL_16Hz_mas ~~ v_S_P3*zSternberg_P3_PL_16Hz_mas",
  
  # trait specifities
  "trait_Posner_P2 := (0*v_erp)/(0*v_erp + v_p2 + 0*v_posner + v_P_P2)",
  "trait_Posner_N2 := (v_erp)/(v_erp + 0 + v_posner + v_P_N2)",
  "trait_Posner_P3 := (v_erp)/(v_erp + v_p3 + v_posner + v_P_P3)",
  "trait_CRT_P2 := (0*v_erp)/(0*v_erp + v_p2 + 0*v_crt + v_C_P2)",
  "trait_CRT_N2 := (v_erp)/(v_erp + 0 + v_crt + v_C_N2)",
  "trait_CRT_P3 := (v_erp)/(v_erp + v_p3 + v_crt + v_C_P3)",
  "trait_Sternberg_P2 := (0*v_erp)/(0*v_erp + v_p2 + 0*v_sternberg + v_S_P2)",
  "trait_Sternberg_N2 := (v_erp)/(v_erp +0 + v_sternberg + v_S_N2)",
  "trait_Sternberg_P3 := (v_erp)/(v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # component specifities
  "comp_Posner_P2 := (v_p2)/(0*v_erp + v_p2 + 0*v_posner + v_P_P2)",
  "comp_Posner_N2 := (0)/(v_erp + 0 + v_posner + v_P_N2)",
  "comp_Posner_P3 := (v_p3)/(v_erp + v_p3 + v_posner + v_P_P3)",
  "comp_CRT_P2 := (v_p2)/(0*v_erp + v_p2 + 0*v_crt + v_C_P2)",
  "comp_CRT_N2 := (0)/(v_erp + 0 + v_crt + v_C_N2)",
  "comp_CRT_P3 := (v_p3)/(v_erp + v_p3 + v_crt + v_C_P3)",
  "comp_Sternberg_P2 := (v_p2)/(0*v_erp + v_p2 + 0*v_sternberg + v_S_P2)",
  "comp_Sternberg_N2 := (0)/(v_erp +0 + v_sternberg + v_S_N2)",
  "comp_Sternberg_P3 := (v_p3)/(v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # task specifities
  "task_Posner_P2 := (0*v_posner)/(0*v_erp + v_p2 + 0*v_posner + v_P_P2)",
  "task_Posner_N2 := (v_posner)/(v_erp + 0 + v_posner + v_P_N2)",
  "task_Posner_P3 := (v_posner)/(v_erp + v_p3 + v_posner + v_P_P3)",
  "task_CRT_P2 := (0*v_crt)/(0*v_erp + v_p2 + 0*v_crt + v_C_P2)",
  "task_CRT_N2 := (v_crt)/(v_erp + 0 + v_crt + v_C_N2)",
  "task_CRT_P3 := (v_crt)/(v_erp + v_p3 + v_crt + v_C_P3)",
  "task_Sternberg_P2 := (0*v_sternberg)/(0*v_erp + v_p2 + 0*v_sternberg + v_S_P2)",
  "task_Sternberg_N2 := (v_sternberg)/(v_erp +0 + v_sternberg + v_S_N2)",
  "task_Sternberg_P3 := (v_sternberg)/(v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # reliabilities
  "rel_Posner_P2 := (0*v_erp + v_p2 + 0*v_posner)/(0*v_erp + v_p2 + 0*v_posner + v_P_P2)",
  "rel_Posner_N2 := (v_erp + 0 + v_posner)/(v_erp + 0 + v_posner + v_P_N2)",
  "rel_Posner_P3 := (v_erp + v_p3 + v_posner)/(v_erp + v_p3 + v_posner + v_P_P3)",
  "rel_CRT_P2 := (0*v_erp + v_p2 + 0*v_crt)/(0*v_erp + v_p2 + 0*v_crt + v_C_P2)",
  "rel_CRT_N2 := (v_erp + 0 + v_crt)/(v_erp + 0 + v_crt + v_C_N2)",
  "rel_CRT_P3 := (v_erp + v_p3 + v_crt)/(v_erp + v_p3 + v_crt + v_C_P3)",
  "rel_Sternberg_P2 := (0*v_erp + v_p2 + 0*v_sternberg)/(0*v_erp + v_p2 + 0*v_sternberg + v_S_P2)",
  "rel_Sternberg_N2 := (v_erp +0 + v_sternberg)/(v_erp +0 + v_sternberg + v_S_N2)",
  "rel_Sternberg_P3 := (v_erp + v_p3 + v_sternberg)/(v_erp + v_p3 + v_sternberg + v_S_P3)")

fit_mas_16Hz_PL <- sem(model_mas_16Hz_PL, data = data, estimator = "MLR" , missing="fiml", std.lv = FALSE)
summary(fit_mas_16Hz_PL, fit.measures=TRUE,standardized = TRUE,rsquare=T, ci = TRUE)

## SEM: Linked mastoids reference, 16 Hz low-pass filter, 50 % FA latency ----

model_mas_16Hz_FA <- c(# hierarchical model
  "P2 =~ 1*zPosner_P2_FA_16Hz_mas + 1*zCRT_P2_FA_16Hz_mas + 1*zSternberg_P2_FA_16Hz_mas",
  "N2 =~ 1*zPosner_N2_FA_16Hz_mas + 1*zCRT_N2_FA_16Hz_mas + 1*zSternberg_N2_FA_16Hz_mas",
  "P3 =~ 1*zPosner_P3_FA_16Hz_mas + 1*zCRT_P3_FA_16Hz_mas + 1*zSternberg_P3_FA_16Hz_mas",
  "ERP =~ 1*N2 + 1*P3",
  
  # task-specific factors
  "Posner =~ 1*zPosner_N2_FA_16Hz_mas + 1*zPosner_P3_FA_16Hz_mas",
  "CRT =~ 1*zCRT_N2_FA_16Hz_mas + 1*zCRT_P3_FA_16Hz_mas",
  "Sternberg =~ 1*zSternberg_N2_FA_16Hz_mas + 1*zSternberg_P3_FA_16Hz_mas",
  "Posner ~~ 0*CRT + 0*Sternberg",
  "CRT ~~ 0*Sternberg",
  
  # cognitive abilities
  "gf =~ zPC + zPS + zM + zC",
  
  # structural model
  "ERP ~~ gf",
  "gf ~~ 0*N2 + 0*P3",
  "gf ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "P2 ~~ 0*Posner + 0*CRT + 0*Sternberg + 0*ERP",
  "N2 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "P3 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "ERP ~~ 0*Posner + 0*CRT + 0*Sternberg",
  
  # fix intercepts to zero
  "zPosner_P2_FA_16Hz_mas ~ 0",
  "zPosner_N2_FA_16Hz_mas ~ 0",
  "zPosner_P3_FA_16Hz_mas ~ 0",
  "zCRT_P2_FA_16Hz_mas ~ 0",
  "zCRT_N2_FA_16Hz_mas ~ 0",
  "zCRT_P3_FA_16Hz_mas ~ 0",
  "zSternberg_P2_FA_16Hz_mas ~ 0",
  "zSternberg_N2_FA_16Hz_mas ~ 0",
  "zSternberg_P3_FA_16Hz_mas ~ 0",
  "zPC ~ 0",
  "zPS ~ 0",
  "zM ~ 0",
  "zC ~ 0",
  
  # variances
  "ERP ~~ v_erp*ERP",
  "CRT ~~ v_crt*CRT",
  "Sternberg ~~ v_sternberg*Sternberg",
  "Posner ~~ v_posner*Posner",
  "P2 ~~ v_p2*P2",
  "N2 ~~ 0*N2",
  "P3 ~~ v_p3*P3",
  "zPosner_P2_FA_16Hz_mas ~~ v_P_P2*zPosner_P2_FA_16Hz_mas",
  "zPosner_N2_FA_16Hz_mas ~~ v_P_N2*zPosner_N2_FA_16Hz_mas",
  "zPosner_P3_FA_16Hz_mas~~ v_P_P3*zPosner_P3_FA_16Hz_mas",
  "zCRT_P2_FA_16Hz_mas ~~ v_C_P2*zCRT_P2_FA_16Hz_mas",
  "zCRT_N2_FA_16Hz_mas ~~ v_C_N2*zCRT_N2_FA_16Hz_mas",
  "zCRT_P3_FA_16Hz_mas ~~ v_C_P3*zCRT_P3_FA_16Hz_mas",
  "zSternberg_P2_FA_16Hz_mas ~~ v_S_P2*zSternberg_P2_FA_16Hz_mas",
  "zSternberg_N2_FA_16Hz_mas ~~ v_S_N2*zSternberg_N2_FA_16Hz_mas",
  "zSternberg_P3_FA_16Hz_mas ~~ v_S_P3*zSternberg_P3_FA_16Hz_mas",
  
  # trait specifities
  "trait_Posner_P2 := (0*v_erp)/(0*v_erp + v_p2 + 0*v_posner + v_P_P2)",
  "trait_Posner_N2 := (v_erp)/(v_erp + 0 + v_posner + v_P_N2)",
  "trait_Posner_P3 := (v_erp)/(v_erp + v_p3 + v_posner + v_P_P3)",
  "trait_CRT_P2 := (0*v_erp)/(0*v_erp + v_p2 + 0*v_crt + v_C_P2)",
  "trait_CRT_N2 := (v_erp)/(v_erp + 0 + v_crt + v_C_N2)",
  "trait_CRT_P3 := (v_erp)/(v_erp + v_p3 + v_crt + v_C_P3)",
  "trait_Sternberg_P2 := (0*v_erp)/(0*v_erp + v_p2 + 0*v_sternberg + v_S_P2)",
  "trait_Sternberg_N2 := (v_erp)/(v_erp +0 + v_sternberg + v_S_N2)",
  "trait_Sternberg_P3 := (v_erp)/(v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # component specifities
  "comp_Posner_P2 := (v_p2)/(0*v_erp + v_p2 + 0*v_posner + v_P_P2)",
  "comp_Posner_N2 := (0)/(v_erp + 0 + v_posner + v_P_N2)",
  "comp_Posner_P3 := (v_p3)/(v_erp + v_p3 + v_posner + v_P_P3)",
  "comp_CRT_P2 := (v_p2)/(0*v_erp + v_p2 + 0*v_crt + v_C_P2)",
  "comp_CRT_N2 := (0)/(v_erp + 0 + v_crt + v_C_N2)",
  "comp_CRT_P3 := (v_p3)/(v_erp + v_p3 + v_crt + v_C_P3)",
  "comp_Sternberg_P2 := (v_p2)/(0*v_erp + v_p2 + 0*v_sternberg + v_S_P2)",
  "comp_Sternberg_N2 := (0)/(v_erp +0 + v_sternberg + v_S_N2)",
  "comp_Sternberg_P3 := (v_p3)/(v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # task specifities
  "task_Posner_P2 := (0*v_posner)/(0*v_erp + v_p2 + 0*v_posner + v_P_P2)",
  "task_Posner_N2 := (v_posner)/(v_erp + 0 + v_posner + v_P_N2)",
  "task_Posner_P3 := (v_posner)/(v_erp + v_p3 + v_posner + v_P_P3)",
  "task_CRT_P2 := (0*v_crt)/(0*v_erp + v_p2 + 0*v_crt + v_C_P2)",
  "task_CRT_N2 := (v_crt)/(v_erp + 0 + v_crt + v_C_N2)",
  "task_CRT_P3 := (v_crt)/(v_erp + v_p3 + v_crt + v_C_P3)",
  "task_Sternberg_P2 := (0*v_sternberg)/(0*v_erp + v_p2 + 0*v_sternberg + v_S_P2)",
  "task_Sternberg_N2 := (v_sternberg)/(v_erp +0 + v_sternberg + v_S_N2)",
  "task_Sternberg_P3 := (v_sternberg)/(v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # reliabilities
  "rel_Posner_P2 := (0*v_erp + v_p2 + 0*v_posner)/(0*v_erp + v_p2 + 0*v_posner + v_P_P2)",
  "rel_Posner_N2 := (v_erp + 0 + v_posner)/(v_erp + 0 + v_posner + v_P_N2)",
  "rel_Posner_P3 := (v_erp + v_p3 + v_posner)/(v_erp + v_p3 + v_posner + v_P_P3)",
  "rel_CRT_P2 := (0*v_erp + v_p2 + 0*v_crt)/(0*v_erp + v_p2 + 0*v_crt + v_C_P2)",
  "rel_CRT_N2 := (v_erp + 0 + v_crt)/(v_erp + 0 + v_crt + v_C_N2)",
  "rel_CRT_P3 := (v_erp + v_p3 + v_crt)/(v_erp + v_p3 + v_crt + v_C_P3)",
  "rel_Sternberg_P2 := (0*v_erp + v_p2 + 0*v_sternberg)/(0*v_erp + v_p2 + 0*v_sternberg + v_S_P2)",
  "rel_Sternberg_N2 := (v_erp +0 + v_sternberg)/(v_erp +0 + v_sternberg + v_S_N2)",
  "rel_Sternberg_P3 := (v_erp + v_p3 + v_sternberg)/(v_erp + v_p3 + v_sternberg + v_S_P3)")

fit_mas_16Hz_FA <- sem(model_mas_16Hz_FA, data = data, estimator = "MLR" , missing="fiml", std.lv = FALSE)
summary(fit_mas_16Hz_FA, fit.measures=TRUE,standardized = TRUE,rsquare=T, ci = TRUE)

## SEM: Linked mastoids reference, 32 Hz low-pass filter, peak latency ----

model_mas_32Hz_PL <- c(# hierarchical model
  "P2 =~ 1*zPosner_P2_PL_32Hz_mas + 1*zCRT_P2_PL_32Hz_mas + 1*zSternberg_P2_PL_32Hz_mas",
  "N2 =~ 1*zPosner_N2_PL_32Hz_mas + 1*zCRT_N2_PL_32Hz_mas + 1*zSternberg_N2_PL_32Hz_mas",
  "P3 =~ 1*zPosner_P3_PL_32Hz_mas + 1*zCRT_P3_PL_32Hz_mas + 1*zSternberg_P3_PL_32Hz_mas",
  "ERP =~ 1*N2 + 1*P3",
  
  # task-specific factors
  "Posner =~ 1*zPosner_N2_PL_32Hz_mas + 1*zPosner_P3_PL_32Hz_mas",
  "CRT =~ 1*zCRT_N2_PL_32Hz_mas + 1*zCRT_P3_PL_32Hz_mas",
  "Sternberg =~ 1*zSternberg_N2_PL_32Hz_mas + 1*zSternberg_P3_PL_32Hz_mas",
  "Posner ~~ 0*CRT + 0*Sternberg",
  "CRT ~~ 0*Sternberg",
  
  # cognitive abilities
  "gf =~ zPC + zPS + zM + zC",
  
  # structural model
  "ERP ~~ gf",
  "gf ~~ 0*N2 + 0*P3",
  "gf ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "P2 ~~ 0*Posner + 0*CRT + 0*Sternberg + 0*ERP",
  "N2 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "P3 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "ERP ~~ 0*Posner + 0*CRT + 0*Sternberg",
  
  # fix intercepts to zero
  "zPosner_P2_PL_32Hz_mas ~ 0",
  "zPosner_N2_PL_32Hz_mas ~ 0",
  "zPosner_P3_PL_32Hz_mas ~ 0",
  "zCRT_P2_PL_32Hz_mas ~ 0",
  "zCRT_N2_PL_32Hz_mas ~ 0",
  "zCRT_P3_PL_32Hz_mas ~ 0",
  "zSternberg_P2_PL_32Hz_mas ~ 0",
  "zSternberg_N2_PL_32Hz_mas ~ 0",
  "zSternberg_P3_PL_32Hz_mas ~ 0",
  "zPC ~ 0",
  "zPS ~ 0",
  "zM ~ 0",
  "zC ~ 0",
  
  # variances
  "ERP ~~ v_erp*ERP",
  "CRT ~~ v_crt*CRT",
  "Sternberg ~~ v_sternberg*Sternberg",
  "Posner ~~ v_posner*Posner",
  "P2 ~~ v_p2*P2",
  "N2 ~~ v_n2*N2",
  "P3 ~~ v_p3*P3",
  "zPosner_P2_PL_32Hz_mas ~~ v_P_P2*zPosner_P2_PL_32Hz_mas",
  "zPosner_N2_PL_32Hz_mas ~~ v_P_N2*zPosner_N2_PL_32Hz_mas",
  "zPosner_P3_PL_32Hz_mas~~ v_P_P3*zPosner_P3_PL_32Hz_mas",
  "zCRT_P2_PL_32Hz_mas ~~ v_C_P2*zCRT_P2_PL_32Hz_mas",
  "zCRT_N2_PL_32Hz_mas ~~ v_C_N2*zCRT_N2_PL_32Hz_mas",
  "zCRT_P3_PL_32Hz_mas ~~ v_C_P3*zCRT_P3_PL_32Hz_mas",
  "zSternberg_P2_PL_32Hz_mas ~~ v_S_P2*zSternberg_P2_PL_32Hz_mas",
  "zSternberg_N2_PL_32Hz_mas ~~ v_S_N2*zSternberg_N2_PL_32Hz_mas",
  "zSternberg_P3_PL_32Hz_mas ~~ v_S_P3*zSternberg_P3_PL_32Hz_mas",
  
  # trait specifities
  "trait_Posner_P2 := (0*v_erp)/(0*v_erp + v_p2 + 0*v_posner + v_P_P2)",
  "trait_Posner_N2 := (v_erp)/(v_erp + v_n2 + v_posner + v_P_N2)",
  "trait_Posner_P3 := (v_erp)/(v_erp + v_p3 + v_posner + v_P_P3)",
  "trait_CRT_P2 := (0*v_erp)/(0*v_erp + v_p2 + 0*v_crt + v_C_P2)",
  "trait_CRT_N2 := (v_erp)/(v_erp + v_n2 + v_crt + v_C_N2)",
  "trait_CRT_P3 := (v_erp)/(v_erp + v_p3 + v_crt + v_C_P3)",
  "trait_Sternberg_P2 := (0*v_erp)/(0*v_erp + v_p2 + 0*v_sternberg + v_S_P2)",
  "trait_Sternberg_N2 := (v_erp)/(v_erp +v_n2 + v_sternberg + v_S_N2)",
  "trait_Sternberg_P3 := (v_erp)/(v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # component specifities
  "comp_Posner_P2 := (v_p2)/(0*v_erp + v_p2 + 0*v_posner + v_P_P2)",
  "comp_Posner_N2 := (v_n2)/(v_erp + v_n2 + v_posner + v_P_N2)",
  "comp_Posner_P3 := (v_p3)/(v_erp + v_p3 + v_posner + v_P_P3)",
  "comp_CRT_P2 := (v_p2)/(0*v_erp + v_p2 + 0*v_crt + v_C_P2)",
  "comp_CRT_N2 := (v_n2)/(v_erp + v_n2 + v_crt + v_C_N2)",
  "comp_CRT_P3 := (v_p3)/(v_erp + v_p3 + v_crt + v_C_P3)",
  "comp_Sternberg_P2 := (v_p2)/(0*v_erp + v_p2 + 0*v_sternberg + v_S_P2)",
  "comp_Sternberg_N2 := (v_n2)/(v_erp +v_n2 + v_sternberg + v_S_N2)",
  "comp_Sternberg_P3 := (v_p3)/(v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # task specifities
  "task_Posner_P2 := (0*v_posner)/(0*v_erp + v_p2 + 0*v_posner + v_P_P2)",
  "task_Posner_N2 := (v_posner)/(v_erp + v_n2 + v_posner + v_P_N2)",
  "task_Posner_P3 := (v_posner)/(v_erp + v_p3 + v_posner + v_P_P3)",
  "task_CRT_P2 := (0*v_crt)/(0*v_erp + v_p2 + 0*v_crt + v_C_P2)",
  "task_CRT_N2 := (v_crt)/(v_erp + v_n2 + v_crt + v_C_N2)",
  "task_CRT_P3 := (v_crt)/(v_erp + v_p3 + v_crt + v_C_P3)",
  "task_Sternberg_P2 := (0*v_sternberg)/(0*v_erp + v_p2 + 0*v_sternberg + v_S_P2)",
  "task_Sternberg_N2 := (v_sternberg)/(v_erp +v_n2 + v_sternberg + v_S_N2)",
  "task_Sternberg_P3 := (v_sternberg)/(v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # reliabilities
  "rel_Posner_P2 := (0*v_erp + v_p2 + 0*v_posner)/(0*v_erp + v_p2 + 0*v_posner + v_P_P2)",
  "rel_Posner_N2 := (v_erp + v_n2 + v_posner)/(v_erp + v_n2 + v_posner + v_P_N2)",
  "rel_Posner_P3 := (v_erp + v_p3 + v_posner)/(v_erp + v_p3 + v_posner + v_P_P3)",
  "rel_CRT_P2 := (0*v_erp + v_p2 + 0*v_crt)/(0*v_erp + v_p2 + 0*v_crt + v_C_P2)",
  "rel_CRT_N2 := (v_erp + v_n2 + v_crt)/(v_erp + v_n2 + v_crt + v_C_N2)",
  "rel_CRT_P3 := (v_erp + v_p3 + v_crt)/(v_erp + v_p3 + v_crt + v_C_P3)",
  "rel_Sternberg_P2 := (0*v_erp + v_p2 + 0*v_sternberg)/(0*v_erp + v_p2 + 0*v_sternberg + v_S_P2)",
  "rel_Sternberg_N2 := (v_erp +v_n2 + v_sternberg)/(v_erp +v_n2 + v_sternberg + v_S_N2)",
  "rel_Sternberg_P3 := (v_erp + v_p3 + v_sternberg)/(v_erp + v_p3 + v_sternberg + v_S_P3)")

fit_mas_32Hz_PL <- sem(model_mas_32Hz_PL, data = data, estimator = "MLR" , missing="fiml", std.lv = FALSE)
summary(fit_mas_32Hz_PL, fit.measures=TRUE,standardized = TRUE,rsquare=T, ci = TRUE)

## SEM: Linked mastoids reference, 32 Hz low-pass filter, 50 % FA latency ----

model_mas_32Hz_FA <- c(# hierarchical model
  "P2 =~ 1*zPosner_P2_FA_32Hz_mas + 1*zCRT_P2_FA_32Hz_mas + 1*zSternberg_P2_FA_32Hz_mas",
  "N2 =~ 1*zPosner_N2_FA_32Hz_mas + 1*zCRT_N2_FA_32Hz_mas + 1*zSternberg_N2_FA_32Hz_mas",
  "P3 =~ 1*zPosner_P3_FA_32Hz_mas + 1*zCRT_P3_FA_32Hz_mas + 1*zSternberg_P3_FA_32Hz_mas",
  "ERP =~ 1*N2 + 1*P3",
  
  # task-specific factors
  "Posner =~ 1*zPosner_N2_FA_32Hz_mas + 1*zPosner_P3_FA_32Hz_mas",
  "CRT =~ 1*zCRT_N2_FA_32Hz_mas + 1*zCRT_P3_FA_32Hz_mas",
  "Sternberg =~ 1*zSternberg_N2_FA_32Hz_mas + 1*zSternberg_P3_FA_32Hz_mas",
  "Posner ~~ 0*CRT + 0*Sternberg",
  "CRT ~~ 0*Sternberg",
  
  # cognitive abilities
  "gf =~ zPC + zPS + zM + zC",
  
  # structural model
  "ERP ~~ gf",
  "gf ~~ 0*N2 + 0*P3",
  "gf ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "P2 ~~ 0*Posner + 0*CRT + 0*Sternberg + 0*ERP",
  "N2 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "P3 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "ERP ~~ 0*Posner + 0*CRT + 0*Sternberg",
  
  # fix intercepts to zero
  "zPosner_P2_FA_32Hz_mas ~ 0",
  "zPosner_N2_FA_32Hz_mas ~ 0",
  "zPosner_P3_FA_32Hz_mas ~ 0",
  "zCRT_P2_FA_32Hz_mas ~ 0",
  "zCRT_N2_FA_32Hz_mas ~ 0",
  "zCRT_P3_FA_32Hz_mas ~ 0",
  "zSternberg_P2_FA_32Hz_mas ~ 0",
  "zSternberg_N2_FA_32Hz_mas ~ 0",
  "zSternberg_P3_FA_32Hz_mas ~ 0",
  "zPC ~ 0",
  "zPS ~ 0",
  "zM ~ 0",
  "zC ~ 0",
  
  # variances
  "ERP ~~ v_erp*ERP",
  "CRT ~~ v_crt*CRT",
  "Sternberg ~~ v_sternberg*Sternberg",
  "Posner ~~ v_posner*Posner",
  "P2 ~~ v_p2*P2",
  "N2 ~~ 0*N2",
  "P3 ~~ v_p3*P3",
  "zPosner_P2_FA_32Hz_mas ~~ v_P_P2*zPosner_P2_FA_32Hz_mas",
  "zPosner_N2_FA_32Hz_mas ~~ v_P_N2*zPosner_N2_FA_32Hz_mas",
  "zPosner_P3_FA_32Hz_mas~~ v_P_P3*zPosner_P3_FA_32Hz_mas",
  "zCRT_P2_FA_32Hz_mas ~~ v_C_P2*zCRT_P2_FA_32Hz_mas",
  "zCRT_N2_FA_32Hz_mas ~~ v_C_N2*zCRT_N2_FA_32Hz_mas",
  "zCRT_P3_FA_32Hz_mas ~~ v_C_P3*zCRT_P3_FA_32Hz_mas",
  "zSternberg_P2_FA_32Hz_mas ~~ v_S_P2*zSternberg_P2_FA_32Hz_mas",
  "zSternberg_N2_FA_32Hz_mas ~~ v_S_N2*zSternberg_N2_FA_32Hz_mas",
  "zSternberg_P3_FA_32Hz_mas ~~ v_S_P3*zSternberg_P3_FA_32Hz_mas",
  
  # trait specifities
  "trait_Posner_P2 := (0*v_erp)/(0*v_erp + v_p2 + 0*v_posner + v_P_P2)",
  "trait_Posner_N2 := (v_erp)/(v_erp + 0 + v_posner + v_P_N2)",
  "trait_Posner_P3 := (v_erp)/(v_erp + v_p3 + v_posner + v_P_P3)",
  "trait_CRT_P2 := (0*v_erp)/(0*v_erp + v_p2 + 0*v_crt + v_C_P2)",
  "trait_CRT_N2 := (v_erp)/(v_erp + 0 + v_crt + v_C_N2)",
  "trait_CRT_P3 := (v_erp)/(v_erp + v_p3 + v_crt + v_C_P3)",
  "trait_Sternberg_P2 := (0*v_erp)/(0*v_erp + v_p2 + 0*v_sternberg + v_S_P2)",
  "trait_Sternberg_N2 := (v_erp)/(v_erp +0 + v_sternberg + v_S_N2)",
  "trait_Sternberg_P3 := (v_erp)/(v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # component specifities
  "comp_Posner_P2 := (v_p2)/(0*v_erp + v_p2 + 0*v_posner + v_P_P2)",
  "comp_Posner_N2 := (0)/(v_erp + 0 + v_posner + v_P_N2)",
  "comp_Posner_P3 := (v_p3)/(v_erp + v_p3 + v_posner + v_P_P3)",
  "comp_CRT_P2 := (v_p2)/(0*v_erp + v_p2 + 0*v_crt + v_C_P2)",
  "comp_CRT_N2 := (0)/(v_erp + 0 + v_crt + v_C_N2)",
  "comp_CRT_P3 := (v_p3)/(v_erp + v_p3 + v_crt + v_C_P3)",
  "comp_Sternberg_P2 := (v_p2)/(0*v_erp + v_p2 + 0*v_sternberg + v_S_P2)",
  "comp_Sternberg_N2 := (0)/(v_erp +0 + v_sternberg + v_S_N2)",
  "comp_Sternberg_P3 := (v_p3)/(v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # task specifities
  "task_Posner_P2 := (0*v_posner)/(0*v_erp + v_p2 + 0*v_posner + v_P_P2)",
  "task_Posner_N2 := (v_posner)/(v_erp + 0 + v_posner + v_P_N2)",
  "task_Posner_P3 := (v_posner)/(v_erp + v_p3 + v_posner + v_P_P3)",
  "task_CRT_P2 := (0*v_crt)/(0*v_erp + v_p2 + 0*v_crt + v_C_P2)",
  "task_CRT_N2 := (v_crt)/(v_erp + 0 + v_crt + v_C_N2)",
  "task_CRT_P3 := (v_crt)/(v_erp + v_p3 + v_crt + v_C_P3)",
  "task_Sternberg_P2 := (0*v_sternberg)/(0*v_erp + v_p2 + 0*v_sternberg + v_S_P2)",
  "task_Sternberg_N2 := (v_sternberg)/(v_erp +0 + v_sternberg + v_S_N2)",
  "task_Sternberg_P3 := (v_sternberg)/(v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # reliabilities
  "rel_Posner_P2 := (0*v_erp + v_p2 + 0*v_posner)/(0*v_erp + v_p2 + 0*v_posner + v_P_P2)",
  "rel_Posner_N2 := (v_erp + 0 + v_posner)/(v_erp + 0 + v_posner + v_P_N2)",
  "rel_Posner_P3 := (v_erp + v_p3 + v_posner)/(v_erp + v_p3 + v_posner + v_P_P3)",
  "rel_CRT_P2 := (0*v_erp + v_p2 + 0*v_crt)/(0*v_erp + v_p2 + 0*v_crt + v_C_P2)",
  "rel_CRT_N2 := (v_erp + 0 + v_crt)/(v_erp + 0 + v_crt + v_C_N2)",
  "rel_CRT_P3 := (v_erp + v_p3 + v_crt)/(v_erp + v_p3 + v_crt + v_C_P3)",
  "rel_Sternberg_P2 := (0*v_erp + v_p2 + 0*v_sternberg)/(0*v_erp + v_p2 + 0*v_sternberg + v_S_P2)",
  "rel_Sternberg_N2 := (v_erp +0 + v_sternberg)/(v_erp +0 + v_sternberg + v_S_N2)",
  "rel_Sternberg_P3 := (v_erp + v_p3 + v_sternberg)/(v_erp + v_p3 + v_sternberg + v_S_P3)")

fit_mas_32Hz_FA <- sem(model_mas_32Hz_FA, data = data, estimator = "MLR" , missing="fiml", std.lv = FALSE)
summary(fit_mas_32Hz_FA, fit.measures=TRUE,standardized = TRUE,rsquare=T, ci = TRUE)



# SEM analyses controlled for age differences ----

## SEM: Average reference, 8 Hz low-pass filter, peak latency (controlled for age differences) ----

model_avg_8Hz_PL <- c(# hierarchical model
  "P2 =~ 1*zPosner_P2_PL_8Hz_avg + 1*zCRT_P2_PL_8Hz_avg + 1*zSternberg_P2_PL_8Hz_avg",
  "N2 =~ 1*zPosner_N2_PL_8Hz_avg + 1*zCRT_N2_PL_8Hz_avg + 1*zSternberg_N2_PL_8Hz_avg",
  "P3 =~ 1*zPosner_P3_PL_8Hz_avg + 1*zCRT_P3_PL_8Hz_avg + 1*zSternberg_P3_PL_8Hz_avg",
  "ERP =~ 1*P2 + b_n2*N2 + b_p3*P3",
  
  # task-specific factors
  "Posner =~ 1*zPosner_P2_PL_8Hz_avg + 1*zPosner_N2_PL_8Hz_avg + 1*zPosner_P3_PL_8Hz_avg",
  "CRT =~ 1*zCRT_P2_PL_8Hz_avg + 1*zCRT_N2_PL_8Hz_avg + 1*zCRT_P3_PL_8Hz_avg",
  "Sternberg =~ 1*zSternberg_P2_PL_8Hz_avg + 1*zSternberg_N2_PL_8Hz_avg + 1*zSternberg_P3_PL_8Hz_avg",
  "Posner ~~ 0*CRT + 0*Sternberg",
  "CRT ~~ 0*Sternberg",
  
  # cognitive abilities
  "gf =~ zPC + zPS + zM + zC",
  
  # control for age differences
  "ERP ~ age",
  "gf ~ age",
  
  # structural model
  "ERP ~~ gf",
  "gf ~~ 0*P2 + 0*N2 + 0*P3",
  "gf ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "P2 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "N2 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "P3 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "ERP ~~ 0*Posner + 0*CRT + 0*Sternberg",
  
  # fix intercepts to zero
  "zPosner_P2_PL_8Hz_avg ~ 0",
  "zPosner_N2_PL_8Hz_avg ~ 0",
  "zPosner_P3_PL_8Hz_avg ~ 0",
  "zCRT_P2_PL_8Hz_avg ~ 0",
  "zCRT_N2_PL_8Hz_avg ~ 0",
  "zCRT_P3_PL_8Hz_avg ~ 0",
  "zSternberg_P2_PL_8Hz_avg ~ 0",
  "zSternberg_N2_PL_8Hz_avg ~ 0",
  "zSternberg_P3_PL_8Hz_avg ~ 0",
  "zPC ~ 0",
  "zPS ~ 0",
  "zM ~ 0",
  "zC ~ 0",
  
  # variances
  "ERP ~~ v_erp*ERP",
  "CRT ~~ v_crt*CRT",
  "Sternberg ~~ v_sternberg*Sternberg",
  "Posner ~~ v_posner*Posner",
  "P2 ~~ v_p2*P2",
  "N2 ~~ 0*N2",
  "P3 ~~ v_p3*P3",
  "zPosner_P2_PL_8Hz_avg ~~ v_P_P2*zPosner_P2_PL_8Hz_avg",
  "zPosner_N2_PL_8Hz_avg ~~ v_P_N2*zPosner_N2_PL_8Hz_avg",
  "zPosner_P3_PL_8Hz_avg~~ v_P_P3*zPosner_P3_PL_8Hz_avg",
  "zCRT_P2_PL_8Hz_avg ~~ v_C_P2*zCRT_P2_PL_8Hz_avg",
  "zCRT_N2_PL_8Hz_avg ~~ v_C_N2*zCRT_N2_PL_8Hz_avg",
  "zCRT_P3_PL_8Hz_avg ~~ v_C_P3*zCRT_P3_PL_8Hz_avg",
  "zSternberg_P2_PL_8Hz_avg ~~ v_S_P2*zSternberg_P2_PL_8Hz_avg",
  "zSternberg_N2_PL_8Hz_avg ~~ v_S_N2*zSternberg_N2_PL_8Hz_avg",
  "zSternberg_P3_PL_8Hz_avg ~~ v_S_P3*zSternberg_P3_PL_8Hz_avg",
  
  # consistencies
  "consistency_Posner_P2 := (v_erp)/(v_erp + v_p2 + v_posner + v_P_P2)",
  "consistency_N2 := (b_n2^2*v_erp)/(b_n2^2*v_erp + 0 + v_posner + v_P_N2)",
  "consistency_Posner_P3 := (b_p3^2*v_erp)/(b_p3^2*v_erp + v_p3 + v_posner + v_P_P3)",
  "consistency_CRT_P2 := (v_erp)/(v_erp + v_p2 + v_crt + v_C_P2)",
  "consistency_CRT_N2 := (b_n2^2*v_erp)/(b_n2^2*v_erp + 0 + v_crt + v_C_N2)",
  "consistency_CRT_P3 := (b_p3^2*v_erp)/(b_p3^2*v_erp + v_p3 + v_crt + v_C_P3)",
  "consistency_Sternberg_P2 := (v_erp)/(v_erp + v_p2 + v_sternberg + v_S_P2)",
  "consistency_Sternberg_N2 := (b_n2^2*v_erp)/(b_n2^2*v_erp +0 + v_sternberg + v_S_N2)",
  "consistency_Sternberg_P3 := (b_p3^2*v_erp)/(b_p3^2*v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # component specifities
  "comp_Posner_P2 := (v_p2)/(v_erp + v_p2 + v_posner + v_P_P2)",
  "comp_Posner_N2 := (0)/(b_n2^2*v_erp + 0 + v_posner + v_P_N2)",
  "comp_Posner_P3 := (v_p3)/(b_p3^2*v_erp + v_p3 + v_posner + v_P_P3)",
  "comp_CRT_P2 := (v_p2)/(v_erp + v_p2 + v_crt + v_C_P2)",
  "comp_CRT_N2 := (0)/(b_n2^2*v_erp + 0 + v_crt + v_C_N2)",
  "comp_CRT_P3 := (v_p3)/(b_p3^2*v_erp + v_p3 + v_crt + v_C_P3)",
  "comp_Sternberg_P2 := (v_p2)/(v_erp + v_p2 + v_sternberg + v_S_P2)",
  "comp_Sternberg_N2 := (0)/(b_n2^2*v_erp +0 + v_sternberg + v_S_N2)",
  "comp_Sternberg_P3 := (v_p3)/(b_p3^2*v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # task specifities
  "task_Posner_P2 := (v_posner)/(v_erp + v_p2 + v_posner + v_P_P2)",
  "task_Posner_N2 := (v_posner)/(b_n2^2*v_erp + 0 + v_posner + v_P_N2)",
  "task_Posner_P3 := (v_posner)/(b_p3^2*v_erp + v_p3 + v_posner + v_P_P3)",
  "task_CRT_P2 := (v_crt)/(v_erp + v_p2 + v_crt + v_C_P2)",
  "task_CRT_N2 := (v_crt)/(b_n2^2*v_erp + 0 + v_crt + v_C_N2)",
  "task_CRT_P3 := (v_crt)/(b_p3^2*v_erp + v_p3 + v_crt + v_C_P3)",
  "task_Sternberg_P2 := (v_sternberg)/(v_erp + v_p2 + v_sternberg + v_S_P2)",
  "task_Sternberg_N2 := (v_sternberg)/(b_n2^2*v_erp +0 + v_sternberg + v_S_N2)",
  "task_Sternberg_P3 := (v_sternberg)/(b_p3^2*v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # reliabilities
  "rel_Posner_P2 := (v_erp + v_p2 + v_posner)/(v_erp + v_p2 + v_posner + v_P_P2)",
  "rel_Posner_N2 := (b_n2^2*v_erp + 0 + v_posner)/(b_n2^2*v_erp + 0 + v_posner + v_P_N2)",
  "rel_Posner_P3 := (b_p3^2*v_erp + v_p3 + v_posner)/(b_p3^2*v_erp + v_p3 + v_posner + v_P_P3)",
  "rel_CRT_P2 := (v_erp + v_p2 + v_crt)/(v_erp + v_p2 + v_crt + v_C_P2)",
  "rel_CRT_N2 := (b_n2^2*v_erp + 0 + v_crt)/(b_n2^2*v_erp + 0 + v_crt + v_C_N2)",
  "rel_CRT_P3 := (b_p3^2*v_erp + v_p3 + v_crt)/(b_p3^2*v_erp + v_p3 + v_crt + v_C_P3)",
  "rel_Sternberg_P2 := (v_erp + v_p2 + v_sternberg)/(v_erp + v_p2 + v_sternberg + v_S_P2)",
  "rel_Sternberg_N2 := (b_n2^2*v_erp +0 + v_sternberg)/(b_n2^2*v_erp +0 + v_sternberg + v_S_N2)",
  "rel_Sternberg_P3 := (b_p3^2*v_erp + v_p3 + v_sternberg)/(b_p3^2*v_erp + v_p3 + v_sternberg + v_S_P3)")

fit_avg_8Hz_PL <- sem(model_avg_8Hz_PL, data = data, estimator = "MLR" , missing="fiml", std.lv = FALSE)
summary(fit_avg_8Hz_PL, fit.measures=TRUE,standardized = TRUE,rsquare=T, ci = TRUE)

## SEM: Average reference, 8 Hz low-pass filter, 50 % FA latency (controlled for age differences) ----

model_avg_8Hz_FA <- c(# hierarchical model
  "P2 =~ 1*zPosner_P2_FA_8Hz_avg + 1*zCRT_P2_FA_8Hz_avg + 1*zSternberg_P2_FA_8Hz_avg",
  "N2 =~ 1*zPosner_N2_FA_8Hz_avg + 1*zCRT_N2_FA_8Hz_avg + 1*zSternberg_N2_FA_8Hz_avg",
  "P3 =~ 1*zPosner_P3_FA_8Hz_avg + 1*zCRT_P3_FA_8Hz_avg + 1*zSternberg_P3_FA_8Hz_avg",
  "ERP =~ 1*P2 + b_n2*N2 + b_p3*P3",
  
  # task-specific factors
  "Posner =~ 1*zPosner_P2_FA_8Hz_avg + 1*zPosner_N2_FA_8Hz_avg + 1*zPosner_P3_FA_8Hz_avg",
  "CRT =~ 1*zCRT_P2_FA_8Hz_avg + 1*zCRT_N2_FA_8Hz_avg + 1*zCRT_P3_FA_8Hz_avg",
  "Sternberg =~ 1*zSternberg_P2_FA_8Hz_avg + 1*zSternberg_N2_FA_8Hz_avg + 1*zSternberg_P3_FA_8Hz_avg",
  "Posner ~~ 0*CRT + 0*Sternberg",
  "CRT ~~ 0*Sternberg",
  
  # cognitive abilities
  "gf =~ zPC + zPS + zM + zC",
  
  # control for age differences
  "ERP ~ age",
  "gf ~ age",
  
  # structural model
  "ERP ~~ gf",
  "gf ~~ 0*P2 + 0*N2 + 0*P3",
  "gf ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "P2 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "N2 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "P3 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "ERP ~~ 0*Posner + 0*CRT + 0*Sternberg",
  
  # fix intercepts to zero
  "zPosner_P2_FA_8Hz_avg ~ 0",
  "zPosner_N2_FA_8Hz_avg ~ 0",
  "zPosner_P3_FA_8Hz_avg ~ 0",
  "zCRT_P2_FA_8Hz_avg ~ 0",
  "zCRT_N2_FA_8Hz_avg ~ 0",
  "zCRT_P3_FA_8Hz_avg ~ 0",
  "zSternberg_P2_FA_8Hz_avg ~ 0",
  "zSternberg_N2_FA_8Hz_avg ~ 0",
  "zSternberg_P3_FA_8Hz_avg ~ 0",
  "zPC ~ 0",
  "zPS ~ 0",
  "zM ~ 0",
  "zC ~ 0",
  
  # variances
  "ERP ~~ v_erp*ERP",
  "CRT ~~ v_crt*CRT",
  "Sternberg ~~ v_sternberg*Sternberg",
  "Posner ~~ v_posner*Posner",
  "P2 ~~ v_p2*P2",
  "N2 ~~ 0*N2",
  "P3 ~~ v_p3*P3",
  "zPosner_P2_FA_8Hz_avg ~~ v_P_P2*zPosner_P2_FA_8Hz_avg",
  "zPosner_N2_FA_8Hz_avg ~~ v_P_N2*zPosner_N2_FA_8Hz_avg",
  "zPosner_P3_FA_8Hz_avg~~ v_P_P3*zPosner_P3_FA_8Hz_avg",
  "zCRT_P2_FA_8Hz_avg ~~ v_C_P2*zCRT_P2_FA_8Hz_avg",
  "zCRT_N2_FA_8Hz_avg ~~ v_C_N2*zCRT_N2_FA_8Hz_avg",
  "zCRT_P3_FA_8Hz_avg ~~ v_C_P3*zCRT_P3_FA_8Hz_avg",
  "zSternberg_P2_FA_8Hz_avg ~~ v_S_P2*zSternberg_P2_FA_8Hz_avg",
  "zSternberg_N2_FA_8Hz_avg ~~ v_S_N2*zSternberg_N2_FA_8Hz_avg",
  "zSternberg_P3_FA_8Hz_avg ~~ v_S_P3*zSternberg_P3_FA_8Hz_avg",
  
  # consistencies
  "consistency_Posner_P2 := (v_erp)/(v_erp + v_p2 + v_posner + v_P_P2)",
  "consistency_N2 := (b_n2^2*v_erp)/(b_n2^2*v_erp + 0 + v_posner + v_P_N2)",
  "consistency_Posner_P3 := (b_p3^2*v_erp)/(b_p3^2*v_erp + v_p3 + v_posner + v_P_P3)",
  "consistency_CRT_P2 := (v_erp)/(v_erp + v_p2 + v_crt + v_C_P2)",
  "consistency_CRT_N2 := (b_n2^2*v_erp)/(b_n2^2*v_erp + 0 + v_crt + v_C_N2)",
  "consistency_CRT_P3 := (b_p3^2*v_erp)/(b_p3^2*v_erp + v_p3 + v_crt + v_C_P3)",
  "consistency_Sternberg_P2 := (v_erp)/(v_erp + v_p2 + v_sternberg + v_S_P2)",
  "consistency_Sternberg_N2 := (b_n2^2*v_erp)/(b_n2^2*v_erp +0 + v_sternberg + v_S_N2)",
  "consistency_Sternberg_P3 := (b_p3^2*v_erp)/(b_p3^2*v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # component specifities
  "comp_Posner_P2 := (v_p2)/(v_erp + v_p2 + v_posner + v_P_P2)",
  "comp_Posner_N2 := (0)/(b_n2^2*v_erp + 0 + v_posner + v_P_N2)",
  "comp_Posner_P3 := (v_p3)/(b_p3^2*v_erp + v_p3 + v_posner + v_P_P3)",
  "comp_CRT_P2 := (v_p2)/(v_erp + v_p2 + v_crt + v_C_P2)",
  "comp_CRT_N2 := (0)/(b_n2^2*v_erp + 0 + v_crt + v_C_N2)",
  "comp_CRT_P3 := (v_p3)/(b_p3^2*v_erp + v_p3 + v_crt + v_C_P3)",
  "comp_Sternberg_P2 := (v_p2)/(v_erp + v_p2 + v_sternberg + v_S_P2)",
  "comp_Sternberg_N2 := (0)/(b_n2^2*v_erp +0 + v_sternberg + v_S_N2)",
  "comp_Sternberg_P3 := (v_p3)/(b_p3^2*v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # task specifities
  "task_Posner_P2 := (v_posner)/(v_erp + v_p2 + v_posner + v_P_P2)",
  "task_Posner_N2 := (v_posner)/(b_n2^2*v_erp + 0 + v_posner + v_P_N2)",
  "task_Posner_P3 := (v_posner)/(b_p3^2*v_erp + v_p3 + v_posner + v_P_P3)",
  "task_CRT_P2 := (v_crt)/(v_erp + v_p2 + v_crt + v_C_P2)",
  "task_CRT_N2 := (v_crt)/(b_n2^2*v_erp + 0 + v_crt + v_C_N2)",
  "task_CRT_P3 := (v_crt)/(b_p3^2*v_erp + v_p3 + v_crt + v_C_P3)",
  "task_Sternberg_P2 := (v_sternberg)/(v_erp + v_p2 + v_sternberg + v_S_P2)",
  "task_Sternberg_N2 := (v_sternberg)/(b_n2^2*v_erp +0 + v_sternberg + v_S_N2)",
  "task_Sternberg_P3 := (v_sternberg)/(b_p3^2*v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # reliabilities
  "rel_Posner_P2 := (v_erp + v_p2 + v_posner)/(v_erp + v_p2 + v_posner + v_P_P2)",
  "rel_Posner_N2 := (b_n2^2*v_erp + 0 + v_posner)/(b_n2^2*v_erp + 0 + v_posner + v_P_N2)",
  "rel_Posner_P3 := (b_p3^2*v_erp + v_p3 + v_posner)/(b_p3^2*v_erp + v_p3 + v_posner + v_P_P3)",
  "rel_CRT_P2 := (v_erp + v_p2 + v_crt)/(v_erp + v_p2 + v_crt + v_C_P2)",
  "rel_CRT_N2 := (b_n2^2*v_erp + 0 + v_crt)/(b_n2^2*v_erp + 0 + v_crt + v_C_N2)",
  "rel_CRT_P3 := (b_p3^2*v_erp + v_p3 + v_crt)/(b_p3^2*v_erp + v_p3 + v_crt + v_C_P3)",
  "rel_Sternberg_P2 := (v_erp + v_p2 + v_sternberg)/(v_erp + v_p2 + v_sternberg + v_S_P2)",
  "rel_Sternberg_N2 := (b_n2^2*v_erp +0 + v_sternberg)/(b_n2^2*v_erp +0 + v_sternberg + v_S_N2)",
  "rel_Sternberg_P3 := (b_p3^2*v_erp + v_p3 + v_sternberg)/(b_p3^2*v_erp + v_p3 + v_sternberg + v_S_P3)")

fit_avg_8Hz_FA <- sem(model_avg_8Hz_FA, data = data, estimator = "MLR" , missing="fiml", std.lv = FALSE)
summary(fit_avg_8Hz_FA, fit.measures=TRUE,standardized = TRUE,rsquare=T, ci = TRUE)

## SEM: Average reference, 16 Hz low-pass filter, peak latency (controlled for age differences) ----

model_avg_16Hz_PL <- c(# hierarchical model
  "P2 =~ 1*zPosner_P2_PL_16Hz_avg + 1*zCRT_P2_PL_16Hz_avg + 1*zSternberg_P2_PL_16Hz_avg",
  "N2 =~ 1*zPosner_N2_PL_16Hz_avg + 1*zCRT_N2_PL_16Hz_avg + 1*zSternberg_N2_PL_16Hz_avg",
  "P3 =~ 1*zPosner_P3_PL_16Hz_avg + 1*zCRT_P3_PL_16Hz_avg + 1*zSternberg_P3_PL_16Hz_avg",
  "ERP =~ 1*P2 + b_n2*N2 + b_p3*P3",
  
  # task-specific factors
  "Posner =~ 1*zPosner_P2_PL_16Hz_avg + 1*zPosner_N2_PL_16Hz_avg + 1*zPosner_P3_PL_16Hz_avg",
  "CRT =~ 1*zCRT_P2_PL_16Hz_avg + 1*zCRT_N2_PL_16Hz_avg + 1*zCRT_P3_PL_16Hz_avg",
  "Sternberg =~ 1*zSternberg_P2_PL_16Hz_avg + 1*zSternberg_N2_PL_16Hz_avg + 1*zSternberg_P3_PL_16Hz_avg",
  "Posner ~~ 0*CRT + 0*Sternberg",
  "CRT ~~ 0*Sternberg",
  
  # cognitive abilities
  "gf =~ zPC + zPS + zM + zC",
  
  # control for age differences
  "ERP ~ age",
  "gf ~ age",
  
  # structural model
  "ERP ~~ gf",
  "gf ~~ 0*P2 + 0*N2 + 0*P3",
  "gf ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "P2 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "N2 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "P3 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "ERP ~~ 0*Posner + 0*CRT + 0*Sternberg",
  
  # fix intercepts to zero
  "zPosner_P2_PL_16Hz_avg ~ 0",
  "zPosner_N2_PL_16Hz_avg ~ 0",
  "zPosner_P3_PL_16Hz_avg ~ 0",
  "zCRT_P2_PL_16Hz_avg ~ 0",
  "zCRT_N2_PL_16Hz_avg ~ 0",
  "zCRT_P3_PL_16Hz_avg ~ 0",
  "zSternberg_P2_PL_16Hz_avg ~ 0",
  "zSternberg_N2_PL_16Hz_avg ~ 0",
  "zSternberg_P3_PL_16Hz_avg ~ 0",
  "zPC ~ 0",
  "zPS ~ 0",
  "zM ~ 0",
  "zC ~ 0",
  
  # variances
  "ERP ~~ v_erp*ERP",
  "CRT ~~ v_crt*CRT",
  "Sternberg ~~ v_sternberg*Sternberg",
  "Posner ~~ v_posner*Posner",
  "P2 ~~ v_p2*P2",
  "N2 ~~ 0*N2",
  "P3 ~~ v_p3*P3",
  "zPosner_P2_PL_16Hz_avg ~~ v_P_P2*zPosner_P2_PL_16Hz_avg",
  "zPosner_N2_PL_16Hz_avg ~~ v_P_N2*zPosner_N2_PL_16Hz_avg",
  "zPosner_P3_PL_16Hz_avg~~ v_P_P3*zPosner_P3_PL_16Hz_avg",
  "zCRT_P2_PL_16Hz_avg ~~ v_C_P2*zCRT_P2_PL_16Hz_avg",
  "zCRT_N2_PL_16Hz_avg ~~ v_C_N2*zCRT_N2_PL_16Hz_avg",
  "zCRT_P3_PL_16Hz_avg ~~ v_C_P3*zCRT_P3_PL_16Hz_avg",
  "zSternberg_P2_PL_16Hz_avg ~~ v_S_P2*zSternberg_P2_PL_16Hz_avg",
  "zSternberg_N2_PL_16Hz_avg ~~ v_S_N2*zSternberg_N2_PL_16Hz_avg",
  "zSternberg_P3_PL_16Hz_avg ~~ v_S_P3*zSternberg_P3_PL_16Hz_avg",
  
  # consistencies
  "consistency_Posner_P2 := (v_erp)/(v_erp + v_p2 + v_posner + v_P_P2)",
  "consistency_N2 := (b_n2^2*v_erp)/(b_n2^2*v_erp + 0 + v_posner + v_P_N2)",
  "consistency_Posner_P3 := (b_p3^2*v_erp)/(b_p3^2*v_erp + v_p3 + v_posner + v_P_P3)",
  "consistency_CRT_P2 := (v_erp)/(v_erp + v_p2 + v_crt + v_C_P2)",
  "consistency_CRT_N2 := (b_n2^2*v_erp)/(b_n2^2*v_erp + 0 + v_crt + v_C_N2)",
  "consistency_CRT_P3 := (b_p3^2*v_erp)/(b_p3^2*v_erp + v_p3 + v_crt + v_C_P3)",
  "consistency_Sternberg_P2 := (v_erp)/(v_erp + v_p2 + v_sternberg + v_S_P2)",
  "consistency_Sternberg_N2 := (b_n2^2*v_erp)/(b_n2^2*v_erp +0 + v_sternberg + v_S_N2)",
  "consistency_Sternberg_P3 := (b_p3^2*v_erp)/(b_p3^2*v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # component specifities
  "comp_Posner_P2 := (v_p2)/(v_erp + v_p2 + v_posner + v_P_P2)",
  "comp_Posner_N2 := (0)/(b_n2^2*v_erp + 0 + v_posner + v_P_N2)",
  "comp_Posner_P3 := (v_p3)/(b_p3^2*v_erp + v_p3 + v_posner + v_P_P3)",
  "comp_CRT_P2 := (v_p2)/(v_erp + v_p2 + v_crt + v_C_P2)",
  "comp_CRT_N2 := (0)/(b_n2^2*v_erp + 0 + v_crt + v_C_N2)",
  "comp_CRT_P3 := (v_p3)/(b_p3^2*v_erp + v_p3 + v_crt + v_C_P3)",
  "comp_Sternberg_P2 := (v_p2)/(v_erp + v_p2 + v_sternberg + v_S_P2)",
  "comp_Sternberg_N2 := (0)/(b_n2^2*v_erp +0 + v_sternberg + v_S_N2)",
  "comp_Sternberg_P3 := (v_p3)/(b_p3^2*v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # task specifities
  "task_Posner_P2 := (v_posner)/(v_erp + v_p2 + v_posner + v_P_P2)",
  "task_Posner_N2 := (v_posner)/(b_n2^2*v_erp + 0 + v_posner + v_P_N2)",
  "task_Posner_P3 := (v_posner)/(b_p3^2*v_erp + v_p3 + v_posner + v_P_P3)",
  "task_CRT_P2 := (v_crt)/(v_erp + v_p2 + v_crt + v_C_P2)",
  "task_CRT_N2 := (v_crt)/(b_n2^2*v_erp + 0 + v_crt + v_C_N2)",
  "task_CRT_P3 := (v_crt)/(b_p3^2*v_erp + v_p3 + v_crt + v_C_P3)",
  "task_Sternberg_P2 := (v_sternberg)/(v_erp + v_p2 + v_sternberg + v_S_P2)",
  "task_Sternberg_N2 := (v_sternberg)/(b_n2^2*v_erp +0 + v_sternberg + v_S_N2)",
  "task_Sternberg_P3 := (v_sternberg)/(b_p3^2*v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # reliabilities
  "rel_Posner_P2 := (v_erp + v_p2 + v_posner)/(v_erp + v_p2 + v_posner + v_P_P2)",
  "rel_Posner_N2 := (b_n2^2*v_erp + 0 + v_posner)/(b_n2^2*v_erp + 0 + v_posner + v_P_N2)",
  "rel_Posner_P3 := (b_p3^2*v_erp + v_p3 + v_posner)/(b_p3^2*v_erp + v_p3 + v_posner + v_P_P3)",
  "rel_CRT_P2 := (v_erp + v_p2 + v_crt)/(v_erp + v_p2 + v_crt + v_C_P2)",
  "rel_CRT_N2 := (b_n2^2*v_erp + 0 + v_crt)/(b_n2^2*v_erp + 0 + v_crt + v_C_N2)",
  "rel_CRT_P3 := (b_p3^2*v_erp + v_p3 + v_crt)/(b_p3^2*v_erp + v_p3 + v_crt + v_C_P3)",
  "rel_Sternberg_P2 := (v_erp + v_p2 + v_sternberg)/(v_erp + v_p2 + v_sternberg + v_S_P2)",
  "rel_Sternberg_N2 := (b_n2^2*v_erp +0 + v_sternberg)/(b_n2^2*v_erp +0 + v_sternberg + v_S_N2)",
  "rel_Sternberg_P3 := (b_p3^2*v_erp + v_p3 + v_sternberg)/(b_p3^2*v_erp + v_p3 + v_sternberg + v_S_P3)")

fit_avg_16Hz_PL <- sem(model_avg_16Hz_PL, data = data, estimator = "MLR" , missing="fiml", std.lv = FALSE)
summary(fit_avg_16Hz_PL, fit.measures=TRUE,standardized = TRUE,rsquare=T, ci = TRUE)

## SEM: Average reference, 16 Hz low-pass filter, 50 % FA latency (controlled for age differences) ----

model_avg_16Hz_FA <- c(# hierarchical model
  "P2 =~ 1*zPosner_P2_FA_16Hz_avg + 1*zCRT_P2_FA_16Hz_avg + 1*zSternberg_P2_FA_16Hz_avg",
  "N2 =~ 1*zPosner_N2_FA_16Hz_avg + 1*zCRT_N2_FA_16Hz_avg + 1*zSternberg_N2_FA_16Hz_avg",
  "P3 =~ 1*zPosner_P3_FA_16Hz_avg + 1*zCRT_P3_FA_16Hz_avg + 1*zSternberg_P3_FA_16Hz_avg",
  "ERP =~ 1*P2 + b_n2*N2 + b_p3*P3",
  
  # task-specific factors
  "Posner =~ 1*zPosner_P2_FA_16Hz_avg + 1*zPosner_N2_FA_16Hz_avg + 1*zPosner_P3_FA_16Hz_avg",
  "CRT =~ 1*zCRT_P2_FA_16Hz_avg + 1*zCRT_N2_FA_16Hz_avg + 1*zCRT_P3_FA_16Hz_avg",
  "Sternberg =~ 1*zSternberg_P2_FA_16Hz_avg + 1*zSternberg_N2_FA_16Hz_avg + 1*zSternberg_P3_FA_16Hz_avg",
  "Posner ~~ 0*CRT + 0*Sternberg",
  "CRT ~~ 0*Sternberg",
  
  # cognitive abilities
  "gf =~ zPC + zPS + zM + zC",
  
  # control for age differences
  "ERP ~ age",
  "gf ~ age",
  
  # structural model
  "ERP ~~ gf",
  "gf ~~ 0*P2 + 0*N2 + 0*P3",
  "gf ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "P2 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "N2 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "P3 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "ERP ~~ 0*Posner + 0*CRT + 0*Sternberg",
  
  # fix intercepts to zero
  "zPosner_P2_FA_16Hz_avg ~ 0",
  "zPosner_N2_FA_16Hz_avg ~ 0",
  "zPosner_P3_FA_16Hz_avg ~ 0",
  "zCRT_P2_FA_16Hz_avg ~ 0",
  "zCRT_N2_FA_16Hz_avg ~ 0",
  "zCRT_P3_FA_16Hz_avg ~ 0",
  "zSternberg_P2_FA_16Hz_avg ~ 0",
  "zSternberg_N2_FA_16Hz_avg ~ 0",
  "zSternberg_P3_FA_16Hz_avg ~ 0",
  "zPC ~ 0",
  "zPS ~ 0",
  "zM ~ 0",
  "zC ~ 0",
  
  # variances
  "ERP ~~ v_erp*ERP",
  "CRT ~~ v_crt*CRT",
  "Sternberg ~~ v_sternberg*Sternberg",
  "Posner ~~ v_posner*Posner",
  "P2 ~~ v_p2*P2",
  "N2 ~~ 0*N2",
  "P3 ~~ v_p3*P3",
  "zPosner_P2_FA_16Hz_avg ~~ v_P_P2*zPosner_P2_FA_16Hz_avg",
  "zPosner_N2_FA_16Hz_avg ~~ v_P_N2*zPosner_N2_FA_16Hz_avg",
  "zPosner_P3_FA_16Hz_avg~~ v_P_P3*zPosner_P3_FA_16Hz_avg",
  "zCRT_P2_FA_16Hz_avg ~~ v_C_P2*zCRT_P2_FA_16Hz_avg",
  "zCRT_N2_FA_16Hz_avg ~~ v_C_N2*zCRT_N2_FA_16Hz_avg",
  "zCRT_P3_FA_16Hz_avg ~~ v_C_P3*zCRT_P3_FA_16Hz_avg",
  "zSternberg_P2_FA_16Hz_avg ~~ v_S_P2*zSternberg_P2_FA_16Hz_avg",
  "zSternberg_N2_FA_16Hz_avg ~~ v_S_N2*zSternberg_N2_FA_16Hz_avg",
  "zSternberg_P3_FA_16Hz_avg ~~ v_S_P3*zSternberg_P3_FA_16Hz_avg",
  
  # consistencies
  "consistency_Posner_P2 := (v_erp)/(v_erp + v_p2 + v_posner + v_P_P2)",
  "consistency_N2 := (b_n2^2*v_erp)/(b_n2^2*v_erp + 0 + v_posner + v_P_N2)",
  "consistency_Posner_P3 := (b_p3^2*v_erp)/(b_p3^2*v_erp + v_p3 + v_posner + v_P_P3)",
  "consistency_CRT_P2 := (v_erp)/(v_erp + v_p2 + v_crt + v_C_P2)",
  "consistency_CRT_N2 := (b_n2^2*v_erp)/(b_n2^2*v_erp + 0 + v_crt + v_C_N2)",
  "consistency_CRT_P3 := (b_p3^2*v_erp)/(b_p3^2*v_erp + v_p3 + v_crt + v_C_P3)",
  "consistency_Sternberg_P2 := (v_erp)/(v_erp + v_p2 + v_sternberg + v_S_P2)",
  "consistency_Sternberg_N2 := (b_n2^2*v_erp)/(b_n2^2*v_erp +0 + v_sternberg + v_S_N2)",
  "consistency_Sternberg_P3 := (b_p3^2*v_erp)/(b_p3^2*v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # component specifities
  "comp_Posner_P2 := (v_p2)/(v_erp + v_p2 + v_posner + v_P_P2)",
  "comp_Posner_N2 := (0)/(b_n2^2*v_erp + 0 + v_posner + v_P_N2)",
  "comp_Posner_P3 := (v_p3)/(b_p3^2*v_erp + v_p3 + v_posner + v_P_P3)",
  "comp_CRT_P2 := (v_p2)/(v_erp + v_p2 + v_crt + v_C_P2)",
  "comp_CRT_N2 := (0)/(b_n2^2*v_erp + 0 + v_crt + v_C_N2)",
  "comp_CRT_P3 := (v_p3)/(b_p3^2*v_erp + v_p3 + v_crt + v_C_P3)",
  "comp_Sternberg_P2 := (v_p2)/(v_erp + v_p2 + v_sternberg + v_S_P2)",
  "comp_Sternberg_N2 := (0)/(b_n2^2*v_erp +0 + v_sternberg + v_S_N2)",
  "comp_Sternberg_P3 := (v_p3)/(b_p3^2*v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # task specifities
  "task_Posner_P2 := (v_posner)/(v_erp + v_p2 + v_posner + v_P_P2)",
  "task_Posner_N2 := (v_posner)/(b_n2^2*v_erp + 0 + v_posner + v_P_N2)",
  "task_Posner_P3 := (v_posner)/(b_p3^2*v_erp + v_p3 + v_posner + v_P_P3)",
  "task_CRT_P2 := (v_crt)/(v_erp + v_p2 + v_crt + v_C_P2)",
  "task_CRT_N2 := (v_crt)/(b_n2^2*v_erp + 0 + v_crt + v_C_N2)",
  "task_CRT_P3 := (v_crt)/(b_p3^2*v_erp + v_p3 + v_crt + v_C_P3)",
  "task_Sternberg_P2 := (v_sternberg)/(v_erp + v_p2 + v_sternberg + v_S_P2)",
  "task_Sternberg_N2 := (v_sternberg)/(b_n2^2*v_erp +0 + v_sternberg + v_S_N2)",
  "task_Sternberg_P3 := (v_sternberg)/(b_p3^2*v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # reliabilities
  "rel_Posner_P2 := (v_erp + v_p2 + v_posner)/(v_erp + v_p2 + v_posner + v_P_P2)",
  "rel_Posner_N2 := (b_n2^2*v_erp + 0 + v_posner)/(b_n2^2*v_erp + 0 + v_posner + v_P_N2)",
  "rel_Posner_P3 := (b_p3^2*v_erp + v_p3 + v_posner)/(b_p3^2*v_erp + v_p3 + v_posner + v_P_P3)",
  "rel_CRT_P2 := (v_erp + v_p2 + v_crt)/(v_erp + v_p2 + v_crt + v_C_P2)",
  "rel_CRT_N2 := (b_n2^2*v_erp + 0 + v_crt)/(b_n2^2*v_erp + 0 + v_crt + v_C_N2)",
  "rel_CRT_P3 := (b_p3^2*v_erp + v_p3 + v_crt)/(b_p3^2*v_erp + v_p3 + v_crt + v_C_P3)",
  "rel_Sternberg_P2 := (v_erp + v_p2 + v_sternberg)/(v_erp + v_p2 + v_sternberg + v_S_P2)",
  "rel_Sternberg_N2 := (b_n2^2*v_erp +0 + v_sternberg)/(b_n2^2*v_erp +0 + v_sternberg + v_S_N2)",
  "rel_Sternberg_P3 := (b_p3^2*v_erp + v_p3 + v_sternberg)/(b_p3^2*v_erp + v_p3 + v_sternberg + v_S_P3)")

fit_avg_16Hz_FA <- sem(model_avg_16Hz_FA, data = data, estimator = "MLR" , missing="fiml", std.lv = FALSE)
summary(fit_avg_16Hz_FA, fit.measures=TRUE,standardized = TRUE,rsquare=T, ci = TRUE)

## SEM: Average reference, 32 Hz low-pass filter, peak latency (controlled for age differences) ----

model_avg_32Hz_PL <- c(# hierarchical model
  "P2 =~ 1*zPosner_P2_PL_32Hz_avg + 1*zCRT_P2_PL_32Hz_avg + 1*zSternberg_P2_PL_32Hz_avg",
  "N2 =~ 1*zPosner_N2_PL_32Hz_avg + 1*zCRT_N2_PL_32Hz_avg + 1*zSternberg_N2_PL_32Hz_avg",
  "P3 =~ 1*zPosner_P3_PL_32Hz_avg + 1*zCRT_P3_PL_32Hz_avg + 1*zSternberg_P3_PL_32Hz_avg",
  "ERP =~ 1*P2 + b_n2*N2 + b_p3*P3",
  
  # task-specific factors
  "Posner =~ 1*zPosner_P2_PL_32Hz_avg + 1*zPosner_N2_PL_32Hz_avg + 1*zPosner_P3_PL_32Hz_avg",
  "CRT =~ 1*zCRT_P2_PL_32Hz_avg + 1*zCRT_N2_PL_32Hz_avg + 1*zCRT_P3_PL_32Hz_avg",
  "Sternberg =~ 1*zSternberg_P2_PL_32Hz_avg + 1*zSternberg_N2_PL_32Hz_avg + 1*zSternberg_P3_PL_32Hz_avg",
  "Posner ~~ 0*CRT + 0*Sternberg",
  "CRT ~~ 0*Sternberg",
  
  # cognitive abilities
  "gf =~ zPC + zPS + zM + zC",
  
  # control for age differences
  "ERP ~ age",
  "gf ~ age",
  
  # structural model
  "ERP ~~ gf",
  "gf ~~ 0*P2 + 0*N2 + 0*P3",
  "gf ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "P2 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "N2 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "P3 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "ERP ~~ 0*Posner + 0*CRT + 0*Sternberg",
  
  # fix intercepts to zero
  "zPosner_P2_PL_32Hz_avg ~ 0",
  "zPosner_N2_PL_32Hz_avg ~ 0",
  "zPosner_P3_PL_32Hz_avg ~ 0",
  "zCRT_P2_PL_32Hz_avg ~ 0",
  "zCRT_N2_PL_32Hz_avg ~ 0",
  "zCRT_P3_PL_32Hz_avg ~ 0",
  "zSternberg_P2_PL_32Hz_avg ~ 0",
  "zSternberg_N2_PL_32Hz_avg ~ 0",
  "zSternberg_P3_PL_32Hz_avg ~ 0",
  "zPC ~ 0",
  "zPS ~ 0",
  "zM ~ 0",
  "zC ~ 0",
  
  # variances
  "ERP ~~ v_erp*ERP",
  "CRT ~~ v_crt*CRT",
  "Sternberg ~~ v_sternberg*Sternberg",
  "Posner ~~ v_posner*Posner",
  "P2 ~~ v_p2*P2",
  "N2 ~~ 0*N2",
  "P3 ~~ v_p3*P3",
  "zPosner_P2_PL_32Hz_avg ~~ v_P_P2*zPosner_P2_PL_32Hz_avg",
  "zPosner_N2_PL_32Hz_avg ~~ v_P_N2*zPosner_N2_PL_32Hz_avg",
  "zPosner_P3_PL_32Hz_avg~~ v_P_P3*zPosner_P3_PL_32Hz_avg",
  "zCRT_P2_PL_32Hz_avg ~~ v_C_P2*zCRT_P2_PL_32Hz_avg",
  "zCRT_N2_PL_32Hz_avg ~~ v_C_N2*zCRT_N2_PL_32Hz_avg",
  "zCRT_P3_PL_32Hz_avg ~~ v_C_P3*zCRT_P3_PL_32Hz_avg",
  "zSternberg_P2_PL_32Hz_avg ~~ v_S_P2*zSternberg_P2_PL_32Hz_avg",
  "zSternberg_N2_PL_32Hz_avg ~~ v_S_N2*zSternberg_N2_PL_32Hz_avg",
  "zSternberg_P3_PL_32Hz_avg ~~ v_S_P3*zSternberg_P3_PL_32Hz_avg",
  
  # consistencies
  "consistency_Posner_P2 := (v_erp)/(v_erp + v_p2 + v_posner + v_P_P2)",
  "consistency_N2 := (b_n2^2*v_erp)/(b_n2^2*v_erp + 0 + v_posner + v_P_N2)",
  "consistency_Posner_P3 := (b_p3^2*v_erp)/(b_p3^2*v_erp + v_p3 + v_posner + v_P_P3)",
  "consistency_CRT_P2 := (v_erp)/(v_erp + v_p2 + v_crt + v_C_P2)",
  "consistency_CRT_N2 := (b_n2^2*v_erp)/(b_n2^2*v_erp + 0 + v_crt + v_C_N2)",
  "consistency_CRT_P3 := (b_p3^2*v_erp)/(b_p3^2*v_erp + v_p3 + v_crt + v_C_P3)",
  "consistency_Sternberg_P2 := (v_erp)/(v_erp + v_p2 + v_sternberg + v_S_P2)",
  "consistency_Sternberg_N2 := (b_n2^2*v_erp)/(b_n2^2*v_erp +0 + v_sternberg + v_S_N2)",
  "consistency_Sternberg_P3 := (b_p3^2*v_erp)/(b_p3^2*v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # component specifities
  "comp_Posner_P2 := (v_p2)/(v_erp + v_p2 + v_posner + v_P_P2)",
  "comp_Posner_N2 := (0)/(b_n2^2*v_erp + 0 + v_posner + v_P_N2)",
  "comp_Posner_P3 := (v_p3)/(b_p3^2*v_erp + v_p3 + v_posner + v_P_P3)",
  "comp_CRT_P2 := (v_p2)/(v_erp + v_p2 + v_crt + v_C_P2)",
  "comp_CRT_N2 := (0)/(b_n2^2*v_erp + 0 + v_crt + v_C_N2)",
  "comp_CRT_P3 := (v_p3)/(b_p3^2*v_erp + v_p3 + v_crt + v_C_P3)",
  "comp_Sternberg_P2 := (v_p2)/(v_erp + v_p2 + v_sternberg + v_S_P2)",
  "comp_Sternberg_N2 := (0)/(b_n2^2*v_erp +0 + v_sternberg + v_S_N2)",
  "comp_Sternberg_P3 := (v_p3)/(b_p3^2*v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # task specifities
  "task_Posner_P2 := (v_posner)/(v_erp + v_p2 + v_posner + v_P_P2)",
  "task_Posner_N2 := (v_posner)/(b_n2^2*v_erp + 0 + v_posner + v_P_N2)",
  "task_Posner_P3 := (v_posner)/(b_p3^2*v_erp + v_p3 + v_posner + v_P_P3)",
  "task_CRT_P2 := (v_crt)/(v_erp + v_p2 + v_crt + v_C_P2)",
  "task_CRT_N2 := (v_crt)/(b_n2^2*v_erp + 0 + v_crt + v_C_N2)",
  "task_CRT_P3 := (v_crt)/(b_p3^2*v_erp + v_p3 + v_crt + v_C_P3)",
  "task_Sternberg_P2 := (v_sternberg)/(v_erp + v_p2 + v_sternberg + v_S_P2)",
  "task_Sternberg_N2 := (v_sternberg)/(b_n2^2*v_erp +0 + v_sternberg + v_S_N2)",
  "task_Sternberg_P3 := (v_sternberg)/(b_p3^2*v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # reliabilities
  "rel_Posner_P2 := (v_erp + v_p2 + v_posner)/(v_erp + v_p2 + v_posner + v_P_P2)",
  "rel_Posner_N2 := (b_n2^2*v_erp + 0 + v_posner)/(b_n2^2*v_erp + 0 + v_posner + v_P_N2)",
  "rel_Posner_P3 := (b_p3^2*v_erp + v_p3 + v_posner)/(b_p3^2*v_erp + v_p3 + v_posner + v_P_P3)",
  "rel_CRT_P2 := (v_erp + v_p2 + v_crt)/(v_erp + v_p2 + v_crt + v_C_P2)",
  "rel_CRT_N2 := (b_n2^2*v_erp + 0 + v_crt)/(b_n2^2*v_erp + 0 + v_crt + v_C_N2)",
  "rel_CRT_P3 := (b_p3^2*v_erp + v_p3 + v_crt)/(b_p3^2*v_erp + v_p3 + v_crt + v_C_P3)",
  "rel_Sternberg_P2 := (v_erp + v_p2 + v_sternberg)/(v_erp + v_p2 + v_sternberg + v_S_P2)",
  "rel_Sternberg_N2 := (b_n2^2*v_erp +0 + v_sternberg)/(b_n2^2*v_erp +0 + v_sternberg + v_S_N2)",
  "rel_Sternberg_P3 := (b_p3^2*v_erp + v_p3 + v_sternberg)/(b_p3^2*v_erp + v_p3 + v_sternberg + v_S_P3)")

fit_avg_32Hz_PL <- sem(model_avg_32Hz_PL, data = data, estimator = "MLR" , missing="fiml", std.lv = FALSE)
summary(fit_avg_32Hz_PL, fit.measures=TRUE,standardized = TRUE,rsquare=T, ci = TRUE)

## SEM: Average reference, 32 Hz low-pass filter, 50 % FA latency (controlled for age differences) ----

model_avg_32Hz_FA <- c(# hierarchical model
  "P2 =~ 1*zPosner_P2_FA_32Hz_avg + 1*zCRT_P2_FA_32Hz_avg + 1*zSternberg_P2_FA_32Hz_avg",
  "N2 =~ 1*zPosner_N2_FA_32Hz_avg + 1*zCRT_N2_FA_32Hz_avg + 1*zSternberg_N2_FA_32Hz_avg",
  "P3 =~ 1*zPosner_P3_FA_32Hz_avg + 1*zCRT_P3_FA_32Hz_avg + 1*zSternberg_P3_FA_32Hz_avg",
  "ERP =~ 1*P2 + b_n2*N2 + b_p3*P3",
  
  # task-specific factors
  "Posner =~ 1*zPosner_P2_FA_32Hz_avg + 1*zPosner_N2_FA_32Hz_avg + 1*zPosner_P3_FA_32Hz_avg",
  "CRT =~ 1*zCRT_P2_FA_32Hz_avg + 1*zCRT_N2_FA_32Hz_avg + 1*zCRT_P3_FA_32Hz_avg",
  "Sternberg =~ 1*zSternberg_P2_FA_32Hz_avg + 1*zSternberg_N2_FA_32Hz_avg + 1*zSternberg_P3_FA_32Hz_avg",
  "Posner ~~ 0*CRT + 0*Sternberg",
  "CRT ~~ 0*Sternberg",
  
  # cognitive abilities
  "gf =~ zPC + zPS + zM + zC",
  
  # control for age differences
  "ERP ~ age",
  "gf ~ age",
  
  # structural model
  "ERP ~~ gf",
  "gf ~~ 0*P2 + 0*N2 + 0*P3",
  "gf ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "P2 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "N2 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "P3 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "ERP ~~ 0*Posner + 0*CRT + 0*Sternberg",
  
  # fix intercepts to zero
  "zPosner_P2_FA_32Hz_avg ~ 0",
  "zPosner_N2_FA_32Hz_avg ~ 0",
  "zPosner_P3_FA_32Hz_avg ~ 0",
  "zCRT_P2_FA_32Hz_avg ~ 0",
  "zCRT_N2_FA_32Hz_avg ~ 0",
  "zCRT_P3_FA_32Hz_avg ~ 0",
  "zSternberg_P2_FA_32Hz_avg ~ 0",
  "zSternberg_N2_FA_32Hz_avg ~ 0",
  "zSternberg_P3_FA_32Hz_avg ~ 0",
  "zPC ~ 0",
  "zPS ~ 0",
  "zM ~ 0",
  "zC ~ 0",
  
  # variances
  "ERP ~~ v_erp*ERP",
  "CRT ~~ v_crt*CRT",
  "Sternberg ~~ v_sternberg*Sternberg",
  "Posner ~~ v_posner*Posner",
  "P2 ~~ v_p2*P2",
  "N2 ~~ 0*N2",
  "P3 ~~ v_p3*P3",
  "zPosner_P2_FA_32Hz_avg ~~ v_P_P2*zPosner_P2_FA_32Hz_avg",
  "zPosner_N2_FA_32Hz_avg ~~ v_P_N2*zPosner_N2_FA_32Hz_avg",
  "zPosner_P3_FA_32Hz_avg~~ v_P_P3*zPosner_P3_FA_32Hz_avg",
  "zCRT_P2_FA_32Hz_avg ~~ v_C_P2*zCRT_P2_FA_32Hz_avg",
  "zCRT_N2_FA_32Hz_avg ~~ v_C_N2*zCRT_N2_FA_32Hz_avg",
  "zCRT_P3_FA_32Hz_avg ~~ v_C_P3*zCRT_P3_FA_32Hz_avg",
  "zSternberg_P2_FA_32Hz_avg ~~ v_S_P2*zSternberg_P2_FA_32Hz_avg",
  "zSternberg_N2_FA_32Hz_avg ~~ v_S_N2*zSternberg_N2_FA_32Hz_avg",
  "zSternberg_P3_FA_32Hz_avg ~~ v_S_P3*zSternberg_P3_FA_32Hz_avg",
  
  # consistencies
  "consistency_Posner_P2 := (v_erp)/(v_erp + v_p2 + v_posner + v_P_P2)",
  "consistency_N2 := (b_n2^2*v_erp)/(b_n2^2*v_erp + 0 + v_posner + v_P_N2)",
  "consistency_Posner_P3 := (b_p3^2*v_erp)/(b_p3^2*v_erp + v_p3 + v_posner + v_P_P3)",
  "consistency_CRT_P2 := (v_erp)/(v_erp + v_p2 + v_crt + v_C_P2)",
  "consistency_CRT_N2 := (b_n2^2*v_erp)/(b_n2^2*v_erp + 0 + v_crt + v_C_N2)",
  "consistency_CRT_P3 := (b_p3^2*v_erp)/(b_p3^2*v_erp + v_p3 + v_crt + v_C_P3)",
  "consistency_Sternberg_P2 := (v_erp)/(v_erp + v_p2 + v_sternberg + v_S_P2)",
  "consistency_Sternberg_N2 := (b_n2^2*v_erp)/(b_n2^2*v_erp +0 + v_sternberg + v_S_N2)",
  "consistency_Sternberg_P3 := (b_p3^2*v_erp)/(b_p3^2*v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # component specifities
  "comp_Posner_P2 := (v_p2)/(v_erp + v_p2 + v_posner + v_P_P2)",
  "comp_Posner_N2 := (0)/(b_n2^2*v_erp + 0 + v_posner + v_P_N2)",
  "comp_Posner_P3 := (v_p3)/(b_p3^2*v_erp + v_p3 + v_posner + v_P_P3)",
  "comp_CRT_P2 := (v_p2)/(v_erp + v_p2 + v_crt + v_C_P2)",
  "comp_CRT_N2 := (0)/(b_n2^2*v_erp + 0 + v_crt + v_C_N2)",
  "comp_CRT_P3 := (v_p3)/(b_p3^2*v_erp + v_p3 + v_crt + v_C_P3)",
  "comp_Sternberg_P2 := (v_p2)/(v_erp + v_p2 + v_sternberg + v_S_P2)",
  "comp_Sternberg_N2 := (0)/(b_n2^2*v_erp +0 + v_sternberg + v_S_N2)",
  "comp_Sternberg_P3 := (v_p3)/(b_p3^2*v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # task specifities
  "task_Posner_P2 := (v_posner)/(v_erp + v_p2 + v_posner + v_P_P2)",
  "task_Posner_N2 := (v_posner)/(b_n2^2*v_erp + 0 + v_posner + v_P_N2)",
  "task_Posner_P3 := (v_posner)/(b_p3^2*v_erp + v_p3 + v_posner + v_P_P3)",
  "task_CRT_P2 := (v_crt)/(v_erp + v_p2 + v_crt + v_C_P2)",
  "task_CRT_N2 := (v_crt)/(b_n2^2*v_erp + 0 + v_crt + v_C_N2)",
  "task_CRT_P3 := (v_crt)/(b_p3^2*v_erp + v_p3 + v_crt + v_C_P3)",
  "task_Sternberg_P2 := (v_sternberg)/(v_erp + v_p2 + v_sternberg + v_S_P2)",
  "task_Sternberg_N2 := (v_sternberg)/(b_n2^2*v_erp +0 + v_sternberg + v_S_N2)",
  "task_Sternberg_P3 := (v_sternberg)/(b_p3^2*v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # reliabilities
  "rel_Posner_P2 := (v_erp + v_p2 + v_posner)/(v_erp + v_p2 + v_posner + v_P_P2)",
  "rel_Posner_N2 := (b_n2^2*v_erp + 0 + v_posner)/(b_n2^2*v_erp + 0 + v_posner + v_P_N2)",
  "rel_Posner_P3 := (b_p3^2*v_erp + v_p3 + v_posner)/(b_p3^2*v_erp + v_p3 + v_posner + v_P_P3)",
  "rel_CRT_P2 := (v_erp + v_p2 + v_crt)/(v_erp + v_p2 + v_crt + v_C_P2)",
  "rel_CRT_N2 := (b_n2^2*v_erp + 0 + v_crt)/(b_n2^2*v_erp + 0 + v_crt + v_C_N2)",
  "rel_CRT_P3 := (b_p3^2*v_erp + v_p3 + v_crt)/(b_p3^2*v_erp + v_p3 + v_crt + v_C_P3)",
  "rel_Sternberg_P2 := (v_erp + v_p2 + v_sternberg)/(v_erp + v_p2 + v_sternberg + v_S_P2)",
  "rel_Sternberg_N2 := (b_n2^2*v_erp +0 + v_sternberg)/(b_n2^2*v_erp +0 + v_sternberg + v_S_N2)",
  "rel_Sternberg_P3 := (b_p3^2*v_erp + v_p3 + v_sternberg)/(b_p3^2*v_erp + v_p3 + v_sternberg + v_S_P3)")

fit_avg_32Hz_FA <- sem(model_avg_32Hz_FA, data = data, estimator = "MLR" , missing="fiml", std.lv = FALSE)
summary(fit_avg_32Hz_FA, fit.measures=TRUE,standardized = TRUE,rsquare=T, ci = TRUE)

## SEM: Linked mastoids reference, 8 Hz low-pass filter, peak latency (controlled for age differences) ----

model_mas_8Hz_PL <- c(# hierarchical model
  "P2 =~ 1*zPosner_P2_PL_8Hz_mas + 1*zCRT_P2_PL_8Hz_mas + 1*zSternberg_P2_PL_8Hz_mas",
  "N2 =~ 1*zPosner_N2_PL_8Hz_mas + 1*zCRT_N2_PL_8Hz_mas + 1*zSternberg_N2_PL_8Hz_mas",
  "P3 =~ 1*zPosner_P3_PL_8Hz_mas + 1*zCRT_P3_PL_8Hz_mas + 1*zSternberg_P3_PL_8Hz_mas",
  "ERP =~ 1*N2 + 1*P3",
  
  # task-specific factors
  "Posner =~ 1*zPosner_N2_PL_8Hz_mas + 1*zPosner_P3_PL_8Hz_mas",
  "CRT =~ 1*zCRT_N2_PL_8Hz_mas + 1*zCRT_P3_PL_8Hz_mas",
  "Sternberg =~ 1*zSternberg_N2_PL_8Hz_mas + 1*zSternberg_P3_PL_8Hz_mas",
  "Posner ~~ 0*CRT + 0*Sternberg",
  "CRT ~~ 0*Sternberg",
  
  # cognitive abilities
  "gf =~ zPC + zPS + zM + zC",
  
  # control for age differences
  "ERP ~ age",
  "gf ~ age",
  
  # structural model
  "ERP ~~ gf",
  "gf ~~ 0*N2 + 0*P3",
  "gf ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "P2 ~~ 0*Posner + 0*CRT + 0*Sternberg + 0*ERP",
  "N2 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "P3 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "ERP ~~ 0*Posner + 0*CRT + 0*Sternberg",
  
  # fix intercepts to zero
  "zPosner_P2_PL_8Hz_mas ~ 0",
  "zPosner_N2_PL_8Hz_mas ~ 0",
  "zPosner_P3_PL_8Hz_mas ~ 0",
  "zCRT_P2_PL_8Hz_mas ~ 0",
  "zCRT_N2_PL_8Hz_mas ~ 0",
  "zCRT_P3_PL_8Hz_mas ~ 0",
  "zSternberg_P2_PL_8Hz_mas ~ 0",
  "zSternberg_N2_PL_8Hz_mas ~ 0",
  "zSternberg_P3_PL_8Hz_mas ~ 0",
  "zPC ~ 0",
  "zPS ~ 0",
  "zM ~ 0",
  "zC ~ 0",
  
  # variances
  "ERP ~~ v_erp*ERP",
  "CRT ~~ v_crt*CRT",
  "Sternberg ~~ v_sternberg*Sternberg",
  "Posner ~~ v_posner*Posner",
  "P2 ~~ v_p2*P2",
  "N2 ~~ v_n2*N2",
  "P3 ~~ v_p3*P3",
  "zPosner_P2_PL_8Hz_mas ~~ v_P_P2*zPosner_P2_PL_8Hz_mas",
  "zPosner_N2_PL_8Hz_mas ~~ v_P_N2*zPosner_N2_PL_8Hz_mas",
  "zPosner_P3_PL_8Hz_mas~~ v_P_P3*zPosner_P3_PL_8Hz_mas",
  "zCRT_P2_PL_8Hz_mas ~~ v_C_P2*zCRT_P2_PL_8Hz_mas",
  "zCRT_N2_PL_8Hz_mas ~~ v_C_N2*zCRT_N2_PL_8Hz_mas",
  "zCRT_P3_PL_8Hz_mas ~~ v_C_P3*zCRT_P3_PL_8Hz_mas",
  "zSternberg_P2_PL_8Hz_mas ~~ v_S_P2*zSternberg_P2_PL_8Hz_mas",
  "zSternberg_N2_PL_8Hz_mas ~~ v_S_N2*zSternberg_N2_PL_8Hz_mas",
  "zSternberg_P3_PL_8Hz_mas ~~ v_S_P3*zSternberg_P3_PL_8Hz_mas",
  
  # trait specifities
  "trait_Posner_P2 := (0*v_erp)/(0*v_erp + v_p2 + 0*v_posner + v_P_P2)",
  "trait_Posner_N2 := (v_erp)/(v_erp + v_n2 + v_posner + v_P_N2)",
  "trait_Posner_P3 := (v_erp)/(v_erp + v_p3 + v_posner + v_P_P3)",
  "trait_CRT_P2 := (0*v_erp)/(0*v_erp + v_p2 + 0*v_crt + v_C_P2)",
  "trait_CRT_N2 := (v_erp)/(v_erp + v_n2 + v_crt + v_C_N2)",
  "trait_CRT_P3 := (v_erp)/(v_erp + v_p3 + v_crt + v_C_P3)",
  "trait_Sternberg_P2 := (0*v_erp)/(0*v_erp + v_p2 + 0*v_sternberg + v_S_P2)",
  "trait_Sternberg_N2 := (v_erp)/(v_erp +v_n2 + v_sternberg + v_S_N2)",
  "trait_Sternberg_P3 := (v_erp)/(v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # component specifities
  "comp_Posner_P2 := (v_p2)/(0*v_erp + v_p2 + 0*v_posner + v_P_P2)",
  "comp_Posner_N2 := (v_n2)/(v_erp + v_n2 + v_posner + v_P_N2)",
  "comp_Posner_P3 := (v_p3)/(v_erp + v_p3 + v_posner + v_P_P3)",
  "comp_CRT_P2 := (v_p2)/(0*v_erp + v_p2 + 0*v_crt + v_C_P2)",
  "comp_CRT_N2 := (v_n2)/(v_erp + v_n2 + v_crt + v_C_N2)",
  "comp_CRT_P3 := (v_p3)/(v_erp + v_p3 + v_crt + v_C_P3)",
  "comp_Sternberg_P2 := (v_p2)/(0*v_erp + v_p2 + 0*v_sternberg + v_S_P2)",
  "comp_Sternberg_N2 := (v_n2)/(v_erp +v_n2 + v_sternberg + v_S_N2)",
  "comp_Sternberg_P3 := (v_p3)/(v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # task specifities
  "task_Posner_P2 := (0*v_posner)/(0*v_erp + v_p2 + 0*v_posner + v_P_P2)",
  "task_Posner_N2 := (v_posner)/(v_erp + v_n2 + v_posner + v_P_N2)",
  "task_Posner_P3 := (v_posner)/(v_erp + v_p3 + v_posner + v_P_P3)",
  "task_CRT_P2 := (0*v_crt)/(0*v_erp + v_p2 + 0*v_crt + v_C_P2)",
  "task_CRT_N2 := (v_crt)/(v_erp + v_n2 + v_crt + v_C_N2)",
  "task_CRT_P3 := (v_crt)/(v_erp + v_p3 + v_crt + v_C_P3)",
  "task_Sternberg_P2 := (0*v_sternberg)/(0*v_erp + v_p2 + 0*v_sternberg + v_S_P2)",
  "task_Sternberg_N2 := (v_sternberg)/(v_erp +v_n2 + v_sternberg + v_S_N2)",
  "task_Sternberg_P3 := (v_sternberg)/(v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # reliabilities
  "rel_Posner_P2 := (0*v_erp + v_p2 + 0*v_posner)/(0*v_erp + v_p2 + 0*v_posner + v_P_P2)",
  "rel_Posner_N2 := (v_erp + v_n2 + v_posner)/(v_erp + v_n2 + v_posner + v_P_N2)",
  "rel_Posner_P3 := (v_erp + v_p3 + v_posner)/(v_erp + v_p3 + v_posner + v_P_P3)",
  "rel_CRT_P2 := (0*v_erp + v_p2 + 0*v_crt)/(0*v_erp + v_p2 + 0*v_crt + v_C_P2)",
  "rel_CRT_N2 := (v_erp + v_n2 + v_crt)/(v_erp + v_n2 + v_crt + v_C_N2)",
  "rel_CRT_P3 := (v_erp + v_p3 + v_crt)/(v_erp + v_p3 + v_crt + v_C_P3)",
  "rel_Sternberg_P2 := (0*v_erp + v_p2 + 0*v_sternberg)/(0*v_erp + v_p2 + 0*v_sternberg + v_S_P2)",
  "rel_Sternberg_N2 := (v_erp +v_n2 + v_sternberg)/(v_erp +v_n2 + v_sternberg + v_S_N2)",
  "rel_Sternberg_P3 := (v_erp + v_p3 + v_sternberg)/(v_erp + v_p3 + v_sternberg + v_S_P3)")

fit_mas_8Hz_PL <- sem(model_mas_8Hz_PL, data = data, estimator = "MLR" , missing="fiml", std.lv = FALSE)
summary(fit_mas_8Hz_PL, fit.measures=TRUE,standardized = TRUE,rsquare=T, ci = TRUE)

## SEM: Linked mastoids reference, 8 Hz low-pass filter, 50 % FA latency (controlled for age differences) ----

model_mas_8Hz_FA <- c(# hierarchical model
  "P2 =~ 1*zPosner_P2_FA_8Hz_mas + 1*zCRT_P2_FA_8Hz_mas + 1*zSternberg_P2_FA_8Hz_mas",
  "N2 =~ 1*zPosner_N2_FA_8Hz_mas + 1*zCRT_N2_FA_8Hz_mas + 1*zSternberg_N2_FA_8Hz_mas",
  "P3 =~ 1*zPosner_P3_FA_8Hz_mas + 1*zCRT_P3_FA_8Hz_mas + 1*zSternberg_P3_FA_8Hz_mas",
  "ERP =~ 1*N2 + 1*P3",
  
  # task-specific factors
  "Posner =~ 1*zPosner_N2_FA_8Hz_mas + 1*zPosner_P3_FA_8Hz_mas",
  "CRT =~ 1*zCRT_N2_FA_8Hz_mas + 1*zCRT_P3_FA_8Hz_mas",
  "Sternberg =~ 1*zSternberg_N2_FA_8Hz_mas + 1*zSternberg_P3_FA_8Hz_mas",
  "Posner ~~ 0*CRT + 0*Sternberg",
  "CRT ~~ 0*Sternberg",
  
  # cognitive abilities
  "gf =~ zPC + zPS + zM + zC",
  
  # control for age differences
  "ERP ~ age",
  "gf ~ age",
  
  # structural model
  "ERP ~~ gf",
  "gf ~~ 0*N2 + 0*P3",
  "gf ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "P2 ~~ 0*Posner + 0*CRT + 0*Sternberg + 0*ERP",
  "N2 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "P3 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "ERP ~~ 0*Posner + 0*CRT + 0*Sternberg",
  
  # fix intercepts to zero
  "zPosner_P2_FA_8Hz_mas ~ 0",
  "zPosner_N2_FA_8Hz_mas ~ 0",
  "zPosner_P3_FA_8Hz_mas ~ 0",
  "zCRT_P2_FA_8Hz_mas ~ 0",
  "zCRT_N2_FA_8Hz_mas ~ 0",
  "zCRT_P3_FA_8Hz_mas ~ 0",
  "zSternberg_P2_FA_8Hz_mas ~ 0",
  "zSternberg_N2_FA_8Hz_mas ~ 0",
  "zSternberg_P3_FA_8Hz_mas ~ 0",
  "zPC ~ 0",
  "zPS ~ 0",
  "zM ~ 0",
  "zC ~ 0",
  
  # variances
  "ERP ~~ v_erp*ERP",
  "CRT ~~ v_crt*CRT",
  "Sternberg ~~ v_sternberg*Sternberg",
  "Posner ~~ v_posner*Posner",
  "P2 ~~ v_p2*P2",
  "N2 ~~ v_n2*N2",
  "P3 ~~ v_p3*P3",
  "zPosner_P2_FA_8Hz_mas ~~ v_P_P2*zPosner_P2_FA_8Hz_mas",
  "zPosner_N2_FA_8Hz_mas ~~ v_P_N2*zPosner_N2_FA_8Hz_mas",
  "zPosner_P3_FA_8Hz_mas~~ v_P_P3*zPosner_P3_FA_8Hz_mas",
  "zCRT_P2_FA_8Hz_mas ~~ v_C_P2*zCRT_P2_FA_8Hz_mas",
  "zCRT_N2_FA_8Hz_mas ~~ v_C_N2*zCRT_N2_FA_8Hz_mas",
  "zCRT_P3_FA_8Hz_mas ~~ v_C_P3*zCRT_P3_FA_8Hz_mas",
  "zSternberg_P2_FA_8Hz_mas ~~ v_S_P2*zSternberg_P2_FA_8Hz_mas",
  "zSternberg_N2_FA_8Hz_mas ~~ v_S_N2*zSternberg_N2_FA_8Hz_mas",
  "zSternberg_P3_FA_8Hz_mas ~~ v_S_P3*zSternberg_P3_FA_8Hz_mas",
  
  # trait specifities
  "trait_Posner_P2 := (0*v_erp)/(0*v_erp + v_p2 + 0*v_posner + v_P_P2)",
  "trait_Posner_N2 := (v_erp)/(v_erp + v_n2 + v_posner + v_P_N2)",
  "trait_Posner_P3 := (v_erp)/(v_erp + v_p3 + v_posner + v_P_P3)",
  "trait_CRT_P2 := (0*v_erp)/(0*v_erp + v_p2 + 0*v_crt + v_C_P2)",
  "trait_CRT_N2 := (v_erp)/(v_erp + v_n2 + v_crt + v_C_N2)",
  "trait_CRT_P3 := (v_erp)/(v_erp + v_p3 + v_crt + v_C_P3)",
  "trait_Sternberg_P2 := (0*v_erp)/(0*v_erp + v_p2 + 0*v_sternberg + v_S_P2)",
  "trait_Sternberg_N2 := (v_erp)/(v_erp +v_n2 + v_sternberg + v_S_N2)",
  "trait_Sternberg_P3 := (v_erp)/(v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # component specifities
  "comp_Posner_P2 := (v_p2)/(0*v_erp + v_p2 + 0*v_posner + v_P_P2)",
  "comp_Posner_N2 := (v_n2)/(v_erp + v_n2 + v_posner + v_P_N2)",
  "comp_Posner_P3 := (v_p3)/(v_erp + v_p3 + v_posner + v_P_P3)",
  "comp_CRT_P2 := (v_p2)/(0*v_erp + v_p2 + 0*v_crt + v_C_P2)",
  "comp_CRT_N2 := (v_n2)/(v_erp + v_n2 + v_crt + v_C_N2)",
  "comp_CRT_P3 := (v_p3)/(v_erp + v_p3 + v_crt + v_C_P3)",
  "comp_Sternberg_P2 := (v_p2)/(0*v_erp + v_p2 + 0*v_sternberg + v_S_P2)",
  "comp_Sternberg_N2 := (v_n2)/(v_erp +v_n2 + v_sternberg + v_S_N2)",
  "comp_Sternberg_P3 := (v_p3)/(v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # task specifities
  "task_Posner_P2 := (0*v_posner)/(0*v_erp + v_p2 + 0*v_posner + v_P_P2)",
  "task_Posner_N2 := (v_posner)/(v_erp + v_n2 + v_posner + v_P_N2)",
  "task_Posner_P3 := (v_posner)/(v_erp + v_p3 + v_posner + v_P_P3)",
  "task_CRT_P2 := (0*v_crt)/(0*v_erp + v_p2 + 0*v_crt + v_C_P2)",
  "task_CRT_N2 := (v_crt)/(v_erp + v_n2 + v_crt + v_C_N2)",
  "task_CRT_P3 := (v_crt)/(v_erp + v_p3 + v_crt + v_C_P3)",
  "task_Sternberg_P2 := (0*v_sternberg)/(0*v_erp + v_p2 + 0*v_sternberg + v_S_P2)",
  "task_Sternberg_N2 := (v_sternberg)/(v_erp +v_n2 + v_sternberg + v_S_N2)",
  "task_Sternberg_P3 := (v_sternberg)/(v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # reliabilities
  "rel_Posner_P2 := (0*v_erp + v_p2 + 0*v_posner)/(0*v_erp + v_p2 + 0*v_posner + v_P_P2)",
  "rel_Posner_N2 := (v_erp + v_n2 + v_posner)/(v_erp + v_n2 + v_posner + v_P_N2)",
  "rel_Posner_P3 := (v_erp + v_p3 + v_posner)/(v_erp + v_p3 + v_posner + v_P_P3)",
  "rel_CRT_P2 := (0*v_erp + v_p2 + 0*v_crt)/(0*v_erp + v_p2 + 0*v_crt + v_C_P2)",
  "rel_CRT_N2 := (v_erp + v_n2 + v_crt)/(v_erp + v_n2 + v_crt + v_C_N2)",
  "rel_CRT_P3 := (v_erp + v_p3 + v_crt)/(v_erp + v_p3 + v_crt + v_C_P3)",
  "rel_Sternberg_P2 := (0*v_erp + v_p2 + 0*v_sternberg)/(0*v_erp + v_p2 + 0*v_sternberg + v_S_P2)",
  "rel_Sternberg_N2 := (v_erp +v_n2 + v_sternberg)/(v_erp +v_n2 + v_sternberg + v_S_N2)",
  "rel_Sternberg_P3 := (v_erp + v_p3 + v_sternberg)/(v_erp + v_p3 + v_sternberg + v_S_P3)")

fit_mas_8Hz_FA <- sem(model_mas_8Hz_FA, data = data, estimator = "MLR" , missing="fiml", std.lv = FALSE)
summary(fit_mas_8Hz_FA, fit.measures=TRUE,standardized = TRUE,rsquare=T, ci = TRUE)

## SEM: Linked mastoids reference, 16 Hz low-pass filter, peak latency (controlled for age differences) ----

model_mas_16Hz_PL <- c(# hierarchical model
  "P2 =~ 1*zPosner_P2_PL_16Hz_mas + 1*zCRT_P2_PL_16Hz_mas + 1*zSternberg_P2_PL_16Hz_mas",
  "N2 =~ 1*zPosner_N2_PL_16Hz_mas + 1*zCRT_N2_PL_16Hz_mas + 1*zSternberg_N2_PL_16Hz_mas",
  "P3 =~ 1*zPosner_P3_PL_16Hz_mas + 1*zCRT_P3_PL_16Hz_mas + 1*zSternberg_P3_PL_16Hz_mas",
  "ERP =~ 1*N2 + 1*P3",
  
  # task-specific factors
  "Posner =~ 1*zPosner_N2_PL_16Hz_mas + 1*zPosner_P3_PL_16Hz_mas",
  "CRT =~ 1*zCRT_N2_PL_16Hz_mas + 1*zCRT_P3_PL_16Hz_mas",
  "Sternberg =~ 1*zSternberg_N2_PL_16Hz_mas + 1*zSternberg_P3_PL_16Hz_mas",
  "Posner ~~ 0*CRT + 0*Sternberg",
  "CRT ~~ 0*Sternberg",
  
  # cognitive abilities
  "gf =~ zPC + zPS + zM + zC",
  
  # control for age differences
  "ERP ~ age",
  "gf ~ age",
  
  # structural model
  "ERP ~~ gf",
  "gf ~~ 0*N2 + 0*P3",
  "gf ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "P2 ~~ 0*Posner + 0*CRT + 0*Sternberg + 0*ERP",
  "N2 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "P3 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "ERP ~~ 0*Posner + 0*CRT + 0*Sternberg",
  
  # fix intercepts to zero
  "zPosner_P2_PL_16Hz_mas ~ 0",
  "zPosner_N2_PL_16Hz_mas ~ 0",
  "zPosner_P3_PL_16Hz_mas ~ 0",
  "zCRT_P2_PL_16Hz_mas ~ 0",
  "zCRT_N2_PL_16Hz_mas ~ 0",
  "zCRT_P3_PL_16Hz_mas ~ 0",
  "zSternberg_P2_PL_16Hz_mas ~ 0",
  "zSternberg_N2_PL_16Hz_mas ~ 0",
  "zSternberg_P3_PL_16Hz_mas ~ 0",
  "zPC ~ 0",
  "zPS ~ 0",
  "zM ~ 0",
  "zC ~ 0",
  
  # variances
  "ERP ~~ v_erp*ERP",
  "CRT ~~ v_crt*CRT",
  "Sternberg ~~ v_sternberg*Sternberg",
  "Posner ~~ v_posner*Posner",
  "P2 ~~ v_p2*P2",
  "N2 ~~ 0*N2",
  "P3 ~~ v_p3*P3",
  "zPosner_P2_PL_16Hz_mas ~~ v_P_P2*zPosner_P2_PL_16Hz_mas",
  "zPosner_N2_PL_16Hz_mas ~~ v_P_N2*zPosner_N2_PL_16Hz_mas",
  "zPosner_P3_PL_16Hz_mas~~ v_P_P3*zPosner_P3_PL_16Hz_mas",
  "zCRT_P2_PL_16Hz_mas ~~ v_C_P2*zCRT_P2_PL_16Hz_mas",
  "zCRT_N2_PL_16Hz_mas ~~ v_C_N2*zCRT_N2_PL_16Hz_mas",
  "zCRT_P3_PL_16Hz_mas ~~ v_C_P3*zCRT_P3_PL_16Hz_mas",
  "zSternberg_P2_PL_16Hz_mas ~~ v_S_P2*zSternberg_P2_PL_16Hz_mas",
  "zSternberg_N2_PL_16Hz_mas ~~ v_S_N2*zSternberg_N2_PL_16Hz_mas",
  "zSternberg_P3_PL_16Hz_mas ~~ v_S_P3*zSternberg_P3_PL_16Hz_mas",
  
  # trait specifities
  "trait_Posner_P2 := (0*v_erp)/(0*v_erp + v_p2 + 0*v_posner + v_P_P2)",
  "trait_Posner_N2 := (v_erp)/(v_erp + 0 + v_posner + v_P_N2)",
  "trait_Posner_P3 := (v_erp)/(v_erp + v_p3 + v_posner + v_P_P3)",
  "trait_CRT_P2 := (0*v_erp)/(0*v_erp + v_p2 + 0*v_crt + v_C_P2)",
  "trait_CRT_N2 := (v_erp)/(v_erp + 0 + v_crt + v_C_N2)",
  "trait_CRT_P3 := (v_erp)/(v_erp + v_p3 + v_crt + v_C_P3)",
  "trait_Sternberg_P2 := (0*v_erp)/(0*v_erp + v_p2 + 0*v_sternberg + v_S_P2)",
  "trait_Sternberg_N2 := (v_erp)/(v_erp +0 + v_sternberg + v_S_N2)",
  "trait_Sternberg_P3 := (v_erp)/(v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # component specifities
  "comp_Posner_P2 := (v_p2)/(0*v_erp + v_p2 + 0*v_posner + v_P_P2)",
  "comp_Posner_N2 := (0)/(v_erp + 0 + v_posner + v_P_N2)",
  "comp_Posner_P3 := (v_p3)/(v_erp + v_p3 + v_posner + v_P_P3)",
  "comp_CRT_P2 := (v_p2)/(0*v_erp + v_p2 + 0*v_crt + v_C_P2)",
  "comp_CRT_N2 := (0)/(v_erp + 0 + v_crt + v_C_N2)",
  "comp_CRT_P3 := (v_p3)/(v_erp + v_p3 + v_crt + v_C_P3)",
  "comp_Sternberg_P2 := (v_p2)/(0*v_erp + v_p2 + 0*v_sternberg + v_S_P2)",
  "comp_Sternberg_N2 := (0)/(v_erp +0 + v_sternberg + v_S_N2)",
  "comp_Sternberg_P3 := (v_p3)/(v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # task specifities
  "task_Posner_P2 := (0*v_posner)/(0*v_erp + v_p2 + 0*v_posner + v_P_P2)",
  "task_Posner_N2 := (v_posner)/(v_erp + 0 + v_posner + v_P_N2)",
  "task_Posner_P3 := (v_posner)/(v_erp + v_p3 + v_posner + v_P_P3)",
  "task_CRT_P2 := (0*v_crt)/(0*v_erp + v_p2 + 0*v_crt + v_C_P2)",
  "task_CRT_N2 := (v_crt)/(v_erp + 0 + v_crt + v_C_N2)",
  "task_CRT_P3 := (v_crt)/(v_erp + v_p3 + v_crt + v_C_P3)",
  "task_Sternberg_P2 := (0*v_sternberg)/(0*v_erp + v_p2 + 0*v_sternberg + v_S_P2)",
  "task_Sternberg_N2 := (v_sternberg)/(v_erp +0 + v_sternberg + v_S_N2)",
  "task_Sternberg_P3 := (v_sternberg)/(v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # reliabilities
  "rel_Posner_P2 := (0*v_erp + v_p2 + 0*v_posner)/(0*v_erp + v_p2 + 0*v_posner + v_P_P2)",
  "rel_Posner_N2 := (v_erp + 0 + v_posner)/(v_erp + 0 + v_posner + v_P_N2)",
  "rel_Posner_P3 := (v_erp + v_p3 + v_posner)/(v_erp + v_p3 + v_posner + v_P_P3)",
  "rel_CRT_P2 := (0*v_erp + v_p2 + 0*v_crt)/(0*v_erp + v_p2 + 0*v_crt + v_C_P2)",
  "rel_CRT_N2 := (v_erp + 0 + v_crt)/(v_erp + 0 + v_crt + v_C_N2)",
  "rel_CRT_P3 := (v_erp + v_p3 + v_crt)/(v_erp + v_p3 + v_crt + v_C_P3)",
  "rel_Sternberg_P2 := (0*v_erp + v_p2 + 0*v_sternberg)/(0*v_erp + v_p2 + 0*v_sternberg + v_S_P2)",
  "rel_Sternberg_N2 := (v_erp +0 + v_sternberg)/(v_erp +0 + v_sternberg + v_S_N2)",
  "rel_Sternberg_P3 := (v_erp + v_p3 + v_sternberg)/(v_erp + v_p3 + v_sternberg + v_S_P3)")

fit_mas_16Hz_PL <- sem(model_mas_16Hz_PL, data = data, estimator = "MLR" , missing="fiml", std.lv = FALSE)
summary(fit_mas_16Hz_PL, fit.measures=TRUE,standardized = TRUE,rsquare=T, ci = TRUE)

## SEM: Linked mastoids reference, 16 Hz low-pass filter, 50 % FA latency (controlled for age differences) ----

model_mas_16Hz_FA <- c(# hierarchical model
  "P2 =~ 1*zPosner_P2_FA_16Hz_mas + 1*zCRT_P2_FA_16Hz_mas + 1*zSternberg_P2_FA_16Hz_mas",
  "N2 =~ 1*zPosner_N2_FA_16Hz_mas + 1*zCRT_N2_FA_16Hz_mas + 1*zSternberg_N2_FA_16Hz_mas",
  "P3 =~ 1*zPosner_P3_FA_16Hz_mas + 1*zCRT_P3_FA_16Hz_mas + 1*zSternberg_P3_FA_16Hz_mas",
  "ERP =~ 1*N2 + 1*P3",
  
  # task-specific factors
  "Posner =~ 1*zPosner_N2_FA_16Hz_mas + 1*zPosner_P3_FA_16Hz_mas",
  "CRT =~ 1*zCRT_N2_FA_16Hz_mas + 1*zCRT_P3_FA_16Hz_mas",
  "Sternberg =~ 1*zSternberg_N2_FA_16Hz_mas + 1*zSternberg_P3_FA_16Hz_mas",
  "Posner ~~ 0*CRT + 0*Sternberg",
  "CRT ~~ 0*Sternberg",
  
  # cognitive abilities
  "gf =~ zPC + zPS + zM + zC",
  
  # control for age differences
  "ERP ~ age",
  "gf ~ age",
  
  # structural model
  "ERP ~~ gf",
  "gf ~~ 0*N2 + 0*P3",
  "gf ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "P2 ~~ 0*Posner + 0*CRT + 0*Sternberg + 0*ERP",
  "N2 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "P3 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "ERP ~~ 0*Posner + 0*CRT + 0*Sternberg",
  
  # fix intercepts to zero
  "zPosner_P2_FA_16Hz_mas ~ 0",
  "zPosner_N2_FA_16Hz_mas ~ 0",
  "zPosner_P3_FA_16Hz_mas ~ 0",
  "zCRT_P2_FA_16Hz_mas ~ 0",
  "zCRT_N2_FA_16Hz_mas ~ 0",
  "zCRT_P3_FA_16Hz_mas ~ 0",
  "zSternberg_P2_FA_16Hz_mas ~ 0",
  "zSternberg_N2_FA_16Hz_mas ~ 0",
  "zSternberg_P3_FA_16Hz_mas ~ 0",
  "zPC ~ 0",
  "zPS ~ 0",
  "zM ~ 0",
  "zC ~ 0",
  
  # variances
  "ERP ~~ v_erp*ERP",
  "CRT ~~ v_crt*CRT",
  "Sternberg ~~ v_sternberg*Sternberg",
  "Posner ~~ v_posner*Posner",
  "P2 ~~ v_p2*P2",
  "N2 ~~ 0*N2",
  "P3 ~~ v_p3*P3",
  "zPosner_P2_FA_16Hz_mas ~~ v_P_P2*zPosner_P2_FA_16Hz_mas",
  "zPosner_N2_FA_16Hz_mas ~~ v_P_N2*zPosner_N2_FA_16Hz_mas",
  "zPosner_P3_FA_16Hz_mas~~ v_P_P3*zPosner_P3_FA_16Hz_mas",
  "zCRT_P2_FA_16Hz_mas ~~ v_C_P2*zCRT_P2_FA_16Hz_mas",
  "zCRT_N2_FA_16Hz_mas ~~ v_C_N2*zCRT_N2_FA_16Hz_mas",
  "zCRT_P3_FA_16Hz_mas ~~ v_C_P3*zCRT_P3_FA_16Hz_mas",
  "zSternberg_P2_FA_16Hz_mas ~~ v_S_P2*zSternberg_P2_FA_16Hz_mas",
  "zSternberg_N2_FA_16Hz_mas ~~ v_S_N2*zSternberg_N2_FA_16Hz_mas",
  "zSternberg_P3_FA_16Hz_mas ~~ v_S_P3*zSternberg_P3_FA_16Hz_mas",
  
  # trait specifities
  "trait_Posner_P2 := (0*v_erp)/(0*v_erp + v_p2 + 0*v_posner + v_P_P2)",
  "trait_Posner_N2 := (v_erp)/(v_erp + 0 + v_posner + v_P_N2)",
  "trait_Posner_P3 := (v_erp)/(v_erp + v_p3 + v_posner + v_P_P3)",
  "trait_CRT_P2 := (0*v_erp)/(0*v_erp + v_p2 + 0*v_crt + v_C_P2)",
  "trait_CRT_N2 := (v_erp)/(v_erp + 0 + v_crt + v_C_N2)",
  "trait_CRT_P3 := (v_erp)/(v_erp + v_p3 + v_crt + v_C_P3)",
  "trait_Sternberg_P2 := (0*v_erp)/(0*v_erp + v_p2 + 0*v_sternberg + v_S_P2)",
  "trait_Sternberg_N2 := (v_erp)/(v_erp +0 + v_sternberg + v_S_N2)",
  "trait_Sternberg_P3 := (v_erp)/(v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # component specifities
  "comp_Posner_P2 := (v_p2)/(0*v_erp + v_p2 + 0*v_posner + v_P_P2)",
  "comp_Posner_N2 := (0)/(v_erp + 0 + v_posner + v_P_N2)",
  "comp_Posner_P3 := (v_p3)/(v_erp + v_p3 + v_posner + v_P_P3)",
  "comp_CRT_P2 := (v_p2)/(0*v_erp + v_p2 + 0*v_crt + v_C_P2)",
  "comp_CRT_N2 := (0)/(v_erp + 0 + v_crt + v_C_N2)",
  "comp_CRT_P3 := (v_p3)/(v_erp + v_p3 + v_crt + v_C_P3)",
  "comp_Sternberg_P2 := (v_p2)/(0*v_erp + v_p2 + 0*v_sternberg + v_S_P2)",
  "comp_Sternberg_N2 := (0)/(v_erp +0 + v_sternberg + v_S_N2)",
  "comp_Sternberg_P3 := (v_p3)/(v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # task specifities
  "task_Posner_P2 := (0*v_posner)/(0*v_erp + v_p2 + 0*v_posner + v_P_P2)",
  "task_Posner_N2 := (v_posner)/(v_erp + 0 + v_posner + v_P_N2)",
  "task_Posner_P3 := (v_posner)/(v_erp + v_p3 + v_posner + v_P_P3)",
  "task_CRT_P2 := (0*v_crt)/(0*v_erp + v_p2 + 0*v_crt + v_C_P2)",
  "task_CRT_N2 := (v_crt)/(v_erp + 0 + v_crt + v_C_N2)",
  "task_CRT_P3 := (v_crt)/(v_erp + v_p3 + v_crt + v_C_P3)",
  "task_Sternberg_P2 := (0*v_sternberg)/(0*v_erp + v_p2 + 0*v_sternberg + v_S_P2)",
  "task_Sternberg_N2 := (v_sternberg)/(v_erp +0 + v_sternberg + v_S_N2)",
  "task_Sternberg_P3 := (v_sternberg)/(v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # reliabilities
  "rel_Posner_P2 := (0*v_erp + v_p2 + 0*v_posner)/(0*v_erp + v_p2 + 0*v_posner + v_P_P2)",
  "rel_Posner_N2 := (v_erp + 0 + v_posner)/(v_erp + 0 + v_posner + v_P_N2)",
  "rel_Posner_P3 := (v_erp + v_p3 + v_posner)/(v_erp + v_p3 + v_posner + v_P_P3)",
  "rel_CRT_P2 := (0*v_erp + v_p2 + 0*v_crt)/(0*v_erp + v_p2 + 0*v_crt + v_C_P2)",
  "rel_CRT_N2 := (v_erp + 0 + v_crt)/(v_erp + 0 + v_crt + v_C_N2)",
  "rel_CRT_P3 := (v_erp + v_p3 + v_crt)/(v_erp + v_p3 + v_crt + v_C_P3)",
  "rel_Sternberg_P2 := (0*v_erp + v_p2 + 0*v_sternberg)/(0*v_erp + v_p2 + 0*v_sternberg + v_S_P2)",
  "rel_Sternberg_N2 := (v_erp +0 + v_sternberg)/(v_erp +0 + v_sternberg + v_S_N2)",
  "rel_Sternberg_P3 := (v_erp + v_p3 + v_sternberg)/(v_erp + v_p3 + v_sternberg + v_S_P3)")

fit_mas_16Hz_FA <- sem(model_mas_16Hz_FA, data = data, estimator = "MLR" , missing="fiml", std.lv = FALSE)
summary(fit_mas_16Hz_FA, fit.measures=TRUE,standardized = TRUE,rsquare=T, ci = TRUE)

## SEM: Linked mastoids reference, 32 Hz low-pass filter, peak latency (controlled for age differences) ----

model_mas_32Hz_PL <- c(# hierarchical model
  "P2 =~ 1*zPosner_P2_PL_32Hz_mas + 1*zCRT_P2_PL_32Hz_mas + 1*zSternberg_P2_PL_32Hz_mas",
  "N2 =~ 1*zPosner_N2_PL_32Hz_mas + 1*zCRT_N2_PL_32Hz_mas + 1*zSternberg_N2_PL_32Hz_mas",
  "P3 =~ 1*zPosner_P3_PL_32Hz_mas + 1*zCRT_P3_PL_32Hz_mas + 1*zSternberg_P3_PL_32Hz_mas",
  "ERP =~ 1*N2 + 1*P3",
  
  # task-specific factors
  "Posner =~ 1*zPosner_N2_PL_32Hz_mas + 1*zPosner_P3_PL_32Hz_mas",
  "CRT =~ 1*zCRT_N2_PL_32Hz_mas + 1*zCRT_P3_PL_32Hz_mas",
  "Sternberg =~ 1*zSternberg_N2_PL_32Hz_mas + 1*zSternberg_P3_PL_32Hz_mas",
  "Posner ~~ 0*CRT + 0*Sternberg",
  "CRT ~~ 0*Sternberg",
  
  # cognitive abilities
  "gf =~ zPC + zPS + zM + zC",
  
  # control for age differences
  "ERP ~ age",
  "gf ~ age",
  
  # structural model
  "ERP ~~ gf",
  "gf ~~ 0*N2 + 0*P3",
  "gf ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "P2 ~~ 0*Posner + 0*CRT + 0*Sternberg + 0*ERP",
  "N2 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "P3 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "ERP ~~ 0*Posner + 0*CRT + 0*Sternberg",
  
  # fix intercepts to zero
  "zPosner_P2_PL_32Hz_mas ~ 0",
  "zPosner_N2_PL_32Hz_mas ~ 0",
  "zPosner_P3_PL_32Hz_mas ~ 0",
  "zCRT_P2_PL_32Hz_mas ~ 0",
  "zCRT_N2_PL_32Hz_mas ~ 0",
  "zCRT_P3_PL_32Hz_mas ~ 0",
  "zSternberg_P2_PL_32Hz_mas ~ 0",
  "zSternberg_N2_PL_32Hz_mas ~ 0",
  "zSternberg_P3_PL_32Hz_mas ~ 0",
  "zPC ~ 0",
  "zPS ~ 0",
  "zM ~ 0",
  "zC ~ 0",
  
  # variances
  "ERP ~~ v_erp*ERP",
  "CRT ~~ v_crt*CRT",
  "Sternberg ~~ v_sternberg*Sternberg",
  "Posner ~~ v_posner*Posner",
  "P2 ~~ v_p2*P2",
  "N2 ~~ v_n2*N2",
  "P3 ~~ v_p3*P3",
  "zPosner_P2_PL_32Hz_mas ~~ v_P_P2*zPosner_P2_PL_32Hz_mas",
  "zPosner_N2_PL_32Hz_mas ~~ v_P_N2*zPosner_N2_PL_32Hz_mas",
  "zPosner_P3_PL_32Hz_mas~~ v_P_P3*zPosner_P3_PL_32Hz_mas",
  "zCRT_P2_PL_32Hz_mas ~~ v_C_P2*zCRT_P2_PL_32Hz_mas",
  "zCRT_N2_PL_32Hz_mas ~~ v_C_N2*zCRT_N2_PL_32Hz_mas",
  "zCRT_P3_PL_32Hz_mas ~~ v_C_P3*zCRT_P3_PL_32Hz_mas",
  "zSternberg_P2_PL_32Hz_mas ~~ v_S_P2*zSternberg_P2_PL_32Hz_mas",
  "zSternberg_N2_PL_32Hz_mas ~~ v_S_N2*zSternberg_N2_PL_32Hz_mas",
  "zSternberg_P3_PL_32Hz_mas ~~ v_S_P3*zSternberg_P3_PL_32Hz_mas",
  
  # trait specifities
  "trait_Posner_P2 := (0*v_erp)/(0*v_erp + v_p2 + 0*v_posner + v_P_P2)",
  "trait_Posner_N2 := (v_erp)/(v_erp + v_n2 + v_posner + v_P_N2)",
  "trait_Posner_P3 := (v_erp)/(v_erp + v_p3 + v_posner + v_P_P3)",
  "trait_CRT_P2 := (0*v_erp)/(0*v_erp + v_p2 + 0*v_crt + v_C_P2)",
  "trait_CRT_N2 := (v_erp)/(v_erp + v_n2 + v_crt + v_C_N2)",
  "trait_CRT_P3 := (v_erp)/(v_erp + v_p3 + v_crt + v_C_P3)",
  "trait_Sternberg_P2 := (0*v_erp)/(0*v_erp + v_p2 + 0*v_sternberg + v_S_P2)",
  "trait_Sternberg_N2 := (v_erp)/(v_erp +v_n2 + v_sternberg + v_S_N2)",
  "trait_Sternberg_P3 := (v_erp)/(v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # component specifities
  "comp_Posner_P2 := (v_p2)/(0*v_erp + v_p2 + 0*v_posner + v_P_P2)",
  "comp_Posner_N2 := (v_n2)/(v_erp + v_n2 + v_posner + v_P_N2)",
  "comp_Posner_P3 := (v_p3)/(v_erp + v_p3 + v_posner + v_P_P3)",
  "comp_CRT_P2 := (v_p2)/(0*v_erp + v_p2 + 0*v_crt + v_C_P2)",
  "comp_CRT_N2 := (v_n2)/(v_erp + v_n2 + v_crt + v_C_N2)",
  "comp_CRT_P3 := (v_p3)/(v_erp + v_p3 + v_crt + v_C_P3)",
  "comp_Sternberg_P2 := (v_p2)/(0*v_erp + v_p2 + 0*v_sternberg + v_S_P2)",
  "comp_Sternberg_N2 := (v_n2)/(v_erp +v_n2 + v_sternberg + v_S_N2)",
  "comp_Sternberg_P3 := (v_p3)/(v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # task specifities
  "task_Posner_P2 := (0*v_posner)/(0*v_erp + v_p2 + 0*v_posner + v_P_P2)",
  "task_Posner_N2 := (v_posner)/(v_erp + v_n2 + v_posner + v_P_N2)",
  "task_Posner_P3 := (v_posner)/(v_erp + v_p3 + v_posner + v_P_P3)",
  "task_CRT_P2 := (0*v_crt)/(0*v_erp + v_p2 + 0*v_crt + v_C_P2)",
  "task_CRT_N2 := (v_crt)/(v_erp + v_n2 + v_crt + v_C_N2)",
  "task_CRT_P3 := (v_crt)/(v_erp + v_p3 + v_crt + v_C_P3)",
  "task_Sternberg_P2 := (0*v_sternberg)/(0*v_erp + v_p2 + 0*v_sternberg + v_S_P2)",
  "task_Sternberg_N2 := (v_sternberg)/(v_erp +v_n2 + v_sternberg + v_S_N2)",
  "task_Sternberg_P3 := (v_sternberg)/(v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # reliabilities
  "rel_Posner_P2 := (0*v_erp + v_p2 + 0*v_posner)/(0*v_erp + v_p2 + 0*v_posner + v_P_P2)",
  "rel_Posner_N2 := (v_erp + v_n2 + v_posner)/(v_erp + v_n2 + v_posner + v_P_N2)",
  "rel_Posner_P3 := (v_erp + v_p3 + v_posner)/(v_erp + v_p3 + v_posner + v_P_P3)",
  "rel_CRT_P2 := (0*v_erp + v_p2 + 0*v_crt)/(0*v_erp + v_p2 + 0*v_crt + v_C_P2)",
  "rel_CRT_N2 := (v_erp + v_n2 + v_crt)/(v_erp + v_n2 + v_crt + v_C_N2)",
  "rel_CRT_P3 := (v_erp + v_p3 + v_crt)/(v_erp + v_p3 + v_crt + v_C_P3)",
  "rel_Sternberg_P2 := (0*v_erp + v_p2 + 0*v_sternberg)/(0*v_erp + v_p2 + 0*v_sternberg + v_S_P2)",
  "rel_Sternberg_N2 := (v_erp +v_n2 + v_sternberg)/(v_erp +v_n2 + v_sternberg + v_S_N2)",
  "rel_Sternberg_P3 := (v_erp + v_p3 + v_sternberg)/(v_erp + v_p3 + v_sternberg + v_S_P3)")

fit_mas_32Hz_PL <- sem(model_mas_32Hz_PL, data = data, estimator = "MLR" , missing="fiml", std.lv = FALSE)
summary(fit_mas_32Hz_PL, fit.measures=TRUE,standardized = TRUE,rsquare=T, ci = TRUE)

## SEM: Linked mastoids reference, 32 Hz low-pass filter, 50 % FA latency (controlled for age differences) ----

model_mas_32Hz_FA <- c(# hierarchical model
  "P2 =~ 1*zPosner_P2_FA_32Hz_mas + 1*zCRT_P2_FA_32Hz_mas + 1*zSternberg_P2_FA_32Hz_mas",
  "N2 =~ 1*zPosner_N2_FA_32Hz_mas + 1*zCRT_N2_FA_32Hz_mas + 1*zSternberg_N2_FA_32Hz_mas",
  "P3 =~ 1*zPosner_P3_FA_32Hz_mas + 1*zCRT_P3_FA_32Hz_mas + 1*zSternberg_P3_FA_32Hz_mas",
  "ERP =~ 1*N2 + 1*P3",
  
  # task-specific factors
  "Posner =~ 1*zPosner_N2_FA_32Hz_mas + 1*zPosner_P3_FA_32Hz_mas",
  "CRT =~ 1*zCRT_N2_FA_32Hz_mas + 1*zCRT_P3_FA_32Hz_mas",
  "Sternberg =~ 1*zSternberg_N2_FA_32Hz_mas + 1*zSternberg_P3_FA_32Hz_mas",
  "Posner ~~ 0*CRT + 0*Sternberg",
  "CRT ~~ 0*Sternberg",
  
  # cognitive abilities
  "gf =~ zPC + zPS + zM + zC",
  
  # control for age differences
  "ERP ~ age",
  "gf ~ age",
  
  # structural model
  "ERP ~~ gf",
  "gf ~~ 0*N2 + 0*P3",
  "gf ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "P2 ~~ 0*Posner + 0*CRT + 0*Sternberg + 0*ERP",
  "N2 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "P3 ~~ 0*Posner + 0*CRT + 0*Sternberg",
  "ERP ~~ 0*Posner + 0*CRT + 0*Sternberg",
  
  # fix intercepts to zero
  "zPosner_P2_FA_32Hz_mas ~ 0",
  "zPosner_N2_FA_32Hz_mas ~ 0",
  "zPosner_P3_FA_32Hz_mas ~ 0",
  "zCRT_P2_FA_32Hz_mas ~ 0",
  "zCRT_N2_FA_32Hz_mas ~ 0",
  "zCRT_P3_FA_32Hz_mas ~ 0",
  "zSternberg_P2_FA_32Hz_mas ~ 0",
  "zSternberg_N2_FA_32Hz_mas ~ 0",
  "zSternberg_P3_FA_32Hz_mas ~ 0",
  "zPC ~ 0",
  "zPS ~ 0",
  "zM ~ 0",
  "zC ~ 0",
  
  # variances
  "ERP ~~ v_erp*ERP",
  "CRT ~~ v_crt*CRT",
  "Sternberg ~~ v_sternberg*Sternberg",
  "Posner ~~ v_posner*Posner",
  "P2 ~~ v_p2*P2",
  "N2 ~~ 0*N2",
  "P3 ~~ v_p3*P3",
  "zPosner_P2_FA_32Hz_mas ~~ v_P_P2*zPosner_P2_FA_32Hz_mas",
  "zPosner_N2_FA_32Hz_mas ~~ v_P_N2*zPosner_N2_FA_32Hz_mas",
  "zPosner_P3_FA_32Hz_mas~~ v_P_P3*zPosner_P3_FA_32Hz_mas",
  "zCRT_P2_FA_32Hz_mas ~~ v_C_P2*zCRT_P2_FA_32Hz_mas",
  "zCRT_N2_FA_32Hz_mas ~~ v_C_N2*zCRT_N2_FA_32Hz_mas",
  "zCRT_P3_FA_32Hz_mas ~~ v_C_P3*zCRT_P3_FA_32Hz_mas",
  "zSternberg_P2_FA_32Hz_mas ~~ v_S_P2*zSternberg_P2_FA_32Hz_mas",
  "zSternberg_N2_FA_32Hz_mas ~~ v_S_N2*zSternberg_N2_FA_32Hz_mas",
  "zSternberg_P3_FA_32Hz_mas ~~ v_S_P3*zSternberg_P3_FA_32Hz_mas",
  
  # trait specifities
  "trait_Posner_P2 := (0*v_erp)/(0*v_erp + v_p2 + 0*v_posner + v_P_P2)",
  "trait_Posner_N2 := (v_erp)/(v_erp + 0 + v_posner + v_P_N2)",
  "trait_Posner_P3 := (v_erp)/(v_erp + v_p3 + v_posner + v_P_P3)",
  "trait_CRT_P2 := (0*v_erp)/(0*v_erp + v_p2 + 0*v_crt + v_C_P2)",
  "trait_CRT_N2 := (v_erp)/(v_erp + 0 + v_crt + v_C_N2)",
  "trait_CRT_P3 := (v_erp)/(v_erp + v_p3 + v_crt + v_C_P3)",
  "trait_Sternberg_P2 := (0*v_erp)/(0*v_erp + v_p2 + 0*v_sternberg + v_S_P2)",
  "trait_Sternberg_N2 := (v_erp)/(v_erp +0 + v_sternberg + v_S_N2)",
  "trait_Sternberg_P3 := (v_erp)/(v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # component specifities
  "comp_Posner_P2 := (v_p2)/(0*v_erp + v_p2 + 0*v_posner + v_P_P2)",
  "comp_Posner_N2 := (0)/(v_erp + 0 + v_posner + v_P_N2)",
  "comp_Posner_P3 := (v_p3)/(v_erp + v_p3 + v_posner + v_P_P3)",
  "comp_CRT_P2 := (v_p2)/(0*v_erp + v_p2 + 0*v_crt + v_C_P2)",
  "comp_CRT_N2 := (0)/(v_erp + 0 + v_crt + v_C_N2)",
  "comp_CRT_P3 := (v_p3)/(v_erp + v_p3 + v_crt + v_C_P3)",
  "comp_Sternberg_P2 := (v_p2)/(0*v_erp + v_p2 + 0*v_sternberg + v_S_P2)",
  "comp_Sternberg_N2 := (0)/(v_erp +0 + v_sternberg + v_S_N2)",
  "comp_Sternberg_P3 := (v_p3)/(v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # task specifities
  "task_Posner_P2 := (0*v_posner)/(0*v_erp + v_p2 + 0*v_posner + v_P_P2)",
  "task_Posner_N2 := (v_posner)/(v_erp + 0 + v_posner + v_P_N2)",
  "task_Posner_P3 := (v_posner)/(v_erp + v_p3 + v_posner + v_P_P3)",
  "task_CRT_P2 := (0*v_crt)/(0*v_erp + v_p2 + 0*v_crt + v_C_P2)",
  "task_CRT_N2 := (v_crt)/(v_erp + 0 + v_crt + v_C_N2)",
  "task_CRT_P3 := (v_crt)/(v_erp + v_p3 + v_crt + v_C_P3)",
  "task_Sternberg_P2 := (0*v_sternberg)/(0*v_erp + v_p2 + 0*v_sternberg + v_S_P2)",
  "task_Sternberg_N2 := (v_sternberg)/(v_erp +0 + v_sternberg + v_S_N2)",
  "task_Sternberg_P3 := (v_sternberg)/(v_erp + v_p3 + v_sternberg + v_S_P3)",
  
  # reliabilities
  "rel_Posner_P2 := (0*v_erp + v_p2 + 0*v_posner)/(0*v_erp + v_p2 + 0*v_posner + v_P_P2)",
  "rel_Posner_N2 := (v_erp + 0 + v_posner)/(v_erp + 0 + v_posner + v_P_N2)",
  "rel_Posner_P3 := (v_erp + v_p3 + v_posner)/(v_erp + v_p3 + v_posner + v_P_P3)",
  "rel_CRT_P2 := (0*v_erp + v_p2 + 0*v_crt)/(0*v_erp + v_p2 + 0*v_crt + v_C_P2)",
  "rel_CRT_N2 := (v_erp + 0 + v_crt)/(v_erp + 0 + v_crt + v_C_N2)",
  "rel_CRT_P3 := (v_erp + v_p3 + v_crt)/(v_erp + v_p3 + v_crt + v_C_P3)",
  "rel_Sternberg_P2 := (0*v_erp + v_p2 + 0*v_sternberg)/(0*v_erp + v_p2 + 0*v_sternberg + v_S_P2)",
  "rel_Sternberg_N2 := (v_erp +0 + v_sternberg)/(v_erp +0 + v_sternberg + v_S_N2)",
  "rel_Sternberg_P3 := (v_erp + v_p3 + v_sternberg)/(v_erp + v_p3 + v_sternberg + v_S_P3)")

fit_mas_32Hz_FA <- sem(model_mas_32Hz_FA, data = data, estimator = "MLR" , missing="fiml", std.lv = FALSE)
summary(fit_mas_32Hz_FA, fit.measures=TRUE,standardized = TRUE,rsquare=T, ci = TRUE)
