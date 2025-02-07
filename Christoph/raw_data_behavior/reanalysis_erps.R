# load package
library(lavaan)
library(tidyverse)

# load data

data <- read.csv("Christoph/raw_data_behavior/z_abilities.txt", sep = " ")

path_to_eeg <- "Christoph/data_prep_eeg/"

subject_order <- read.csv(paste0(path_to_eeg, "subject_order.csv"), header = FALSE)
subject_order_christoph <-  read.csv(paste0(path_to_eeg, "subject_order_christoph.csv"), header = FALSE)


response_p3 <- read.csv(paste0(path_to_eeg, "response_p3_automatic_odd_even.csv"), header = FALSE) 
stims_p3 <- read.csv(paste0(path_to_eeg, "stims_p3_automatic_odd_even.csv"), header = FALSE) 
christoph_p3 <-  read.csv(paste0(path_to_eeg, "stims_p3_automatic_odd_even_christoph.csv"), header = FALSE) 

colnames(response_p3) = c("bin", "erp_num", "aparam", "bparam", "latency", "fitcor", "fitdist")
colnames(stims_p3) = c("bin", "erp_num", "aparam", "bparam", "latency", "fitcor", "fitdist")
colnames(christoph_p3) = c("bin", "erp_num", "aparam", "bparam", "latency", "fitcor", "fitdist")

cutoff = 0.3
bpar_cutoff = 2
response_p3 <- response_p3 %>% 
  mutate(
    latency = ifelse(fitcor < cutoff, NA, latency),
  ) %>% 
  mutate(
    latency = ifelse(bparam > bpar_cutoff | bparam < 1/bpar_cutoff, NA, latency),
  ) %>% 
  pivot_wider(names_from = bin, id_cols = erp_num, values_from = -c(bin, erp_num), names_prefix = "response_bin") %>% 
  mutate(Subject = subject_order$V1)

stims_p3 <- stims_p3 %>% 
  mutate(
    latency = ifelse(fitcor < cutoff, NA, latency),
  ) %>% 
  mutate(
    latency = ifelse(bparam > bpar_cutoff | bparam < 1/bpar_cutoff, NA, latency),
  ) %>% 
  pivot_wider(names_from = bin, id_cols = erp_num, values_from = -c(bin, erp_num), names_prefix = "stims_bin") %>%
  mutate(Subject = subject_order$V1)

christoph_p3 <- christoph_p3 %>% 
  mutate(
    latency = ifelse(fitcor < cutoff, NA, latency),
  ) %>% 
  mutate(
    latency = ifelse(bparam > bpar_cutoff | bparam < 1/bpar_cutoff, NA, latency),
  ) %>% 
  pivot_wider(names_from = bin, id_cols = erp_num, values_from = -c(bin, erp_num), names_prefix = "christoph_bin") %>%
  mutate(Subject = parse_number(subject_order_christoph$V1))

full_data <- data %>% 
  left_join(., stims_p3, by = "Subject") %>% 
  left_join(., response_p3, by = "Subject") %>% 
  left_join(., christoph_p3, by = "Subject") 

replace_outliers <- function(vector){
  z_stand = scale(vector)[, 1]
  
  vector[z_stand > 3 | z_stand < -3] = NA
  
  print(c(sum(z_stand > 3 | z_stand < -3, na.rm = TRUE), " outliers replaced"))
  
  return(vector)
}

clean_data <- full_data %>% 
  mutate(
    across(
      contains("latency"),
      replace_outliers
    )
  ) %>% 
  mutate(
    across(
      contains("latency"),
      ~scale(.)[, 1],
      .names = "z_{.col}"
    )
  )

# cor(clean_data %>% select(contains("latency"), starts_with("z")), use="pairwise.complete.obs") %>% View()
hist(clean_data$latency_stims_bin1)
hist(clean_data$latency_stims_bin2)

cor(clean_data %>% select(starts_with("latency_stims")), use = "pairwise.complete.obs") 
cor(clean_data %>% select(starts_with("latency_response")), use = "pairwise.complete.obs") 
cor(clean_data %>% select(starts_with("latency_christoph")), use = "pairwise.complete.obs") 

fit_sem <- function(data, param_name){
  model = c(# hierarchical model
    paste0("ERP =~ 1*", param_name),
    
    # cognitive abilities
    "gf =~ zPC + zPS + zM + zC",
    
    # structural model
    "ERP ~~ gf",
    
    # fix intercepts to zero
    paste0(param_name, " ~ 0"),
    "zPC ~ 0",
    "zPS ~ 0",
    "zM ~ 0",
    "zC ~ 0"
    
    # variances
    # "ERP ~~ v_erp*ERP",
    # "z_latency_memset ~~ v_S_P3*z_latency_memset"
  )
  
  fit = sem(model, data = data, estimator = "MLR", std.lv = FALSE)
  summary(fit, fit.measures=TRUE,standardized = TRUE,rsquare=T, ci = TRUE)
}
fit_sem(clean_data, "z_latency_stims_bin1")
fit_sem(clean_data, "z_latency_stims_bin2")
fit_sem(clean_data, "z_latency_response_bin1")

fit_sem(clean_data, "z_latency_christoph_bin1")


fit_sem_odd_even <- function(data, even_name, odd_name){
  model = c(# hierarchical model
    paste0("ERP =~ 1*", even_name, " + 1*", odd_name),

    # cognitive abilities
    "gf =~ zPC + zPS + zM + zC",
    
    # structural model
    "ERP ~~ gf",
    
    # fix intercepts to zero
    paste0(even_name, " ~ 0"),
    paste0(odd_name, " ~ 0"),
    "zPC ~ 0",
    "zPS ~ 0",
    "zM ~ 0",
    "zC ~ 0"
    
    # variances
    # "ERP ~~ v_erp*ERP",
    # "z_latency_memset ~~ v_S_P3*z_latency_memset"
  )
  
  fit = sem(model, data = data, estimator = "MLR", std.lv = FALSE)
  summary(fit, fit.measures=TRUE,standardized = TRUE,rsquare=T, ci = TRUE)
}

fit_sem_odd_even(clean_data, "z_latency_stims_bin3", "z_latency_stims_bin4")
fit_sem_odd_even(clean_data, "z_latency_stims_bin5", "z_latency_stims_bin6")
fit_sem_odd_even(clean_data, "z_latency_response_bin2", "z_latency_response_bin3")
fit_sem_odd_even(clean_data, "z_latency_christoph_bin2", "z_latency_christoph_bin3")
