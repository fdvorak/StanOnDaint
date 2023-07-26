####################################################################################################
# A brief guide to fitting Bayesian models on Piz Daint (cscs.ch)
# Fabian Dvorak, ESS, Eawag
# 2023-07-26
####################################################################################################
library(cmdstanr)                                  # R package for stan
rm(list=ls())                                      # clear all existing variables

# load and filter data
d <- read.csv("./scratch/RedcardData.csv", stringsAsFactors = FALSE)
d2 <- d[!is.na(d$rater1),]
redcard_data <- list(n_redcards = d2$redCards, n_games = d2$games, rating = d2$rater1)
redcard_data$N <- nrow(d2)

# basic model without within-chain parallelization
logistic0 <- cmdstan_model("./scratch/logistic0.stan")
time0 = system.time(fit0 <- logistic0$sample(redcard_data,
                                             chains = 4,
                                             parallel_chains = 4,
                                             refresh = 1000,
                                             output_dir = "./scratch/"))

# model with within-chain parallelization (multiple threads per chain) 
logistic1 <- cmdstan_model("./scratch/logistic1.stan", cpp_options = list(stan_threads = TRUE))
redcard_data$grainsize <- 1
time1 = system.time(fit1 <- logistic1$sample(redcard_data,
                                             chains = 4,
                                             parallel_chains = 4,
                                             threads_per_chain = 17,
                                             refresh = 1000,
                                             output_dir = "./scratch"))

# compare elapsed time
time0
time1