# load package
library(lavaan)
library(tidyverse)

# load data

data <- read.csv("Christoph/raw_data_behavior/z_abilities.txt", sep = " ")

path_to_eeg <- "Christoph/data_prep_eeg/"

memset_p3 <- read.csv(paste0(path_to_eeg, "memset_p3_latencies.csv"))
probe_p3 <- read.csv(paste0(path_to_eeg, "probe_p3_latencies.csv"))
response_p3 <- read.csv(paste0(path_to_eeg, "response_p3_latencies.csv"))
subject_order <- read.csv(paste0(path_to_eeg, "subject_order.csv"))

colnames(memset_p3) = c("aparam_memset", "bparam_memset", "latency_memset", "fitcor_memset", "fitdist_memset", "review_memset")
colnames(probe_p3) = c("aparam_probe", "bparam_probe", "latency_probe", "fitcor_probe", "fitdist_probe", "review_probe")
colnames(response_p3) = c("aparam_response", "bparam_response", "latency_response", "fitcor_response", "fitdist_response", "review_response")

memset_p3$Subject = subject_order$X100
probe_p3$Subject = subject_order$X100
response_p3$Subject = subject_order$X100

full_data <- data %>% 
  left_join(., memset_p3) %>% 
  left_join(., probe_p3) %>% 
  left_join(., response_p3)

clean_data <- full_data %>% 
  mutate(
    latency_memset = ifelse(review_memset == -1, NA, latency_memset),
    latency_probe = ifelse(review_memset == -1, NA, latency_probe),
    latency_response = ifelse(review_memset == -1, NA, latency_response),
  ) %>% 
  mutate(
    z_latency_memset = scale(latency_memset)[,1 ],
    z_latency_probe = scale(latency_probe)[,1 ],
    z_latency_response = scale(latency_response)[,1 ],
  )

cor(clean_data %>% select(contains("latency"), starts_with("z")), use="pairwise.complete.obs")

model_sternberg_memset <- c(# hierarchical model
  "ERP =~ 1*z_latency_memset",
  
  # cognitive abilities
  "gf =~ zPC + zPS + zM + zC",
  
  # structural model
  "ERP ~~ gf",
  
  # fix intercepts to zero
  "z_latency_memset ~ 0",
  "zPC ~ 0",
  "zPS ~ 0",
  "zM ~ 0",
  "zC ~ 0"
  
  # variances
  # "ERP ~~ v_erp*ERP",
  # "z_latency_memset ~~ v_S_P3*z_latency_memset"
)

fit_sternberg_memset <- sem(model_sternberg_memset, data = clean_data, estimator = "MLR" , missing="fiml", std.lv = FALSE)
summary(fit_sternberg_memset, fit.measures=TRUE,standardized = TRUE,rsquare=T, ci = TRUE)

model_sternberg_probe <- c(# hierarchical model
  "ERP =~ 1*z_latency_probe",
  
  # cognitive abilities
  "gf =~ zPC + zPS + zM + zC",
  
  # structural model
  "ERP ~~ gf",
  
  # fix intercepts to zero
  "z_latency_probe ~ 0",
  "zPC ~ 0",
  "zPS ~ 0",
  "zM ~ 0",
  "zC ~ 0"
  
  # variances
  # "ERP ~~ v_erp*ERP",
  # "z_latency_probe ~~ v_S_P3*z_latency_probe"
)

fit_sternberg_probe <- sem(model_sternberg_probe, data = clean_data, estimator = "MLR" , missing="fiml", std.lv = FALSE)
summary(fit_sternberg_probe, fit.measures=TRUE,standardized = TRUE,rsquare=T, ci = TRUE)

model_sternberg_response <- c(# hierarchical model
  "ERP =~ 1*z_latency_response",
  
  # cognitive abilities
  "gf =~ zPC + zPS + zM + zC",
  
  # structural model
  "ERP ~~ gf",
  
  # fix intercepts to zero
  "z_latency_response ~ 0",
  "zPC ~ 0",
  "zPS ~ 0",
  "zM ~ 0",
  "zC ~ 0"
  
  # variances
  # "ERP ~~ v_erp*ERP",
  # "z_latency_response ~~ v_S_P3*z_latency_response"
)

fit_sternberg_response <- sem(model_sternberg_response, data = clean_data, estimator = "MLR" , missing="fiml", std.lv = FALSE)
summary(fit_sternberg_response, fit.measures=TRUE,standardized = TRUE,rsquare=T, ci = TRUE)
