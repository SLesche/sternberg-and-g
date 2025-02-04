# load package
library(lavaan)
library(tidyverse)

# load data

data <- read.csv("Christoph/raw_data_behavior/z_abilities.txt", sep = " ")

path_to_eeg <- "Christoph/data_prep_eeg/"

memset_p3 <- read.csv(paste0(path_to_eeg, "memset_p3_latencies.csv"), header = FALSE)
probe_p3 <- read.csv(paste0(path_to_eeg, "probe_p3_latencies.csv"), header = FALSE)
response_p3 <- read.csv(paste0(path_to_eeg, "response_p3_latencies.csv"), header = FALSE)
liesefeld_probe_p3 <- read.csv(paste0(path_to_eeg, "probe_p3_liesefeld.csv"), sep = "", header = FALSE)

subject_order <- read.csv(paste0(path_to_eeg, "subject_order.csv"), header = FALSE)

colnames(memset_p3) = c("aparam_memset", "bparam_memset", "latency_memset", "fitcor_memset", "fitdist_memset", "review_memset")
colnames(probe_p3) = c("aparam_probe", "bparam_probe", "latency_probe", "fitcor_probe", "fitdist_probe", "review_probe")
colnames(response_p3) = c("aparam_response", "bparam_response", "latency_response", "fitcor_response", "fitdist_response", "review_response")

memset_p3$Subject = subject_order$V1
probe_p3$Subject = subject_order$V1
response_p3$Subject = subject_order$V1
liesefeld_probe_p3$Subject <- subject_order$V1

full_data <- data %>% 
  left_join(., memset_p3) %>% 
  left_join(., probe_p3) %>% 
  left_join(., response_p3) %>% 
  left_join(., liesefeld_probe_p3)

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
    z_latency_liesefeld = scale(V1)[, 1]
  )

cor(clean_data %>% filter(review_probe == 2) %>% select(contains("latency"), starts_with("z")), use="pairwise.complete.obs")

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

fit_sternberg_memset <- sem(model_sternberg_memset, data = clean_data %>% filter(review_memset == 2), estimator = "MLR" , missing="fiml", std.lv = FALSE)
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

fit_sternberg_probe <- sem(model_sternberg_probe, data = clean_data %>% filter(review_probe >= 1), estimator = "MLR" , missing="fiml", std.lv = FALSE)
summary(fit_sternberg_probe, fit.measures=TRUE,standardized = TRUE,rsquare=T, ci = TRUE)


model_sternberg_liesefeld <- c(# hierarchical model
  "ERP =~ 1*z_latency_liesefeld",
  
  # cognitive abilities
  "gf =~ zPC + zPS + zM + zC",
  
  # structural model
  "ERP ~~ gf",
  
  # fix intercepts to zero
  "z_latency_liesefeld ~ 0",
  "zPC ~ 0",
  "zPS ~ 0",
  "zM ~ 0",
  "zC ~ 0"
  
  # variances
  # "ERP ~~ v_erp*ERP",
  # "z_latency_liesefeld ~~ v_S_P3*z_latency_liesefeld"
)

fit_sternberg_liesefeld <- sem(model_sternberg_liesefeld, data = clean_data, estimator = "MLR" , missing="fiml", std.lv = FALSE)
summary(fit_sternberg_liesefeld, fit.measures=TRUE,standardized = TRUE,rsquare=T, ci = TRUE)
