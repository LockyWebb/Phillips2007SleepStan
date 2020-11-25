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

mod <- cmdstan_model("Phillips_sleep_20072008.stan")
