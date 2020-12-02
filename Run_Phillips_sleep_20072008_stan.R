rm(list = ls())

library(cmdstanr)
library(posterior)
library(bayesplot)

library(ggplot2)
library(tidyverse)

set_cmdstan_path("C:/cmdstan_dir/cmdstan-2.25.0")

# set directory for where model is (whichever device you are on)
#setwd()
setwd("L:/Lab_JamesR/lachlanW/sleep model/Phillips2007SleepStan")

cmdstan_path()
cmdstan_version()

#check_cmdstan_toolchain(fix=TRUE)

# compile model
mod <- cmdstan_model("Phillips_sleep_20072008.stan")

# get data 
source("Data_Phillips_sleep_20072008_stan.R")
#data_sleep <- list(T_n = T_n, ts = ts, y0 = y0)
#data_sleep <- list(T_n = T_n, ts = ts, y0 = y0, state_obs = state_test)
data_sleep <- list(T_n = T_n, ts = ts, y0 = y0, prop_obs = prop_test)

fit <- mod$sample(
  data = data_sleep,
  seed = 123,
  chains = 4,
  parallel_chains = 2,
  refresh = 10
)

ests_sum <- fit$summary()

draws_array <- fit$draws()
str(draws_array)


yest <- data.frame(Vv = ests_sum$mean[c(1:T_n)+2], Vm = ests_sum$mean[c(1:T_n)+2+T_n], H = ests_sum$mean[c(1:T_n)+2+2*T_n], time = ts, state = ests_sum$mean[c(1:T_n)+2+3*T_n])


yest %>% select(-state) %>% 
  pivot_longer(Vv:H, names_to = "Variable", values_to = "values") %>%
  ggplot(aes(x = time, y = values, group = Variable, colour = Variable)) + 
  #geom_point() + 
  geom_line() + 
  #geom_line(aes(x = time, y = state*2)) + 
  facet_wrap(~Variable, scales = "free", ncol = 1)


yest %>% ggplot(aes(x = time, y = state)) +
  geom_line()

saveRDS(yest$state, "state_tester.rds")
