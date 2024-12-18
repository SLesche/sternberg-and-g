# set working directory
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# load package
library(lavaan)

# load data

data <- read.csv("data.csv", sep = ";")

### SEM: Average reference, 16 Hz low-pass filter, 50 % FA latency ----

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
#



model_sternberg_16Hz_FA <- c(# hierarchical model
  "ERP =~ 1*zSternberg_P2_FA_16Hz_avg + 1*zSternberg_N2_FA_16Hz_avg + 1*zSternberg_P3_FA_16Hz_avg",

  # cognitive abilities
  "gf =~ zPC + zPS + zM + zC",
  
  # structural model
  "ERP ~~ gf",
 
  # fix intercepts to zero
  "zSternberg_P2_FA_16Hz_avg ~ 0",
  "zSternberg_N2_FA_16Hz_avg ~ 0",
  "zSternberg_P3_FA_16Hz_avg ~ 0",
  "zPC ~ 0",
  "zPS ~ 0",
  "zM ~ 0",
  "zC ~ 0",
  
  # variances
  "ERP ~~ v_erp*ERP",
  "zSternberg_P2_FA_16Hz_avg ~~ v_S_P2*zSternberg_P2_FA_16Hz_avg",
  "zSternberg_N2_FA_16Hz_avg ~~ v_S_N2*zSternberg_N2_FA_16Hz_avg",
  "zSternberg_P3_FA_16Hz_avg ~~ v_S_P3*zSternberg_P3_FA_16Hz_avg"
)

fit_sternberg_16Hz_FA <- sem(model_sternberg_16Hz_FA, data = data, estimator = "MLR" , missing="fiml", std.lv = FALSE)
summary(fit_sternberg_16Hz_FA, fit.measures=TRUE,standardized = TRUE,rsquare=T, ci = TRUE)
