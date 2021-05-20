# Bayes Factor Simulation -------------------------------------------------

library(BayesFactor)
library(dplyr)
library(ggplot2)
library(tidyr)
library(gridExtra)

# Functions

# This fuction is simply a utils for displaying simulation progress

progress <- function(iter, index){
    step <- iter/10
    
    if(i %% step == 0){
        cat((index/step) * 10, "% completed...", "\n")
    }
}

# Setup

mean_eff <- c(0.5, 0.6, 0.8) # range of effect size % of accuracy
sd_eff <- 0.2 # standard deviation of the effect
null_value <- 0.5 # the null value for the one sample t.test
nsample <- 30 # sample size
nsim <- 1e4 # number of simulations
scale_cauchy <- c(0.01, 0.1, 0.707, 3) # different cauchy standard deviation values

# The effect size can be computed as (mu - null value) / sd
# for the 0.6 effect --> (0.6 - 0.5)/0.2 = ~0.5 so the real effect size is 0.5 in cohen's d


# Creating the grid for the simulation

sim <- expand_grid(mean_eff, 
                   sd_eff, 
                   nsample, 
                   nsim = 1:nsim, 
                   scale_cauchy)

# this is the population effect from which we sample our data. Changing the index or the value
# of mean_eff[i], you can visualize different real distributions

curve(dnorm(x, mean_eff[2], sd_eff), -1, 1.5)

# Simulation - one-sample t-test against 0.5 ------------------------------

# Init vectors for speed up the for loop
# for loop are not very efficient in R, better use a map/apply approach but
# preallocation can render for loop fast enough

bf <- vector(mode = "double", length = nrow(sim))
p_value <- vector(mode = "double", length = nrow(sim))
obs_mean <- vector(mode = "double", length = nrow(sim))
obs_sd <- vector(mode = "double", length = nrow(sim))

# Running simulation

for(i in 1:nrow(sim)){
    dat <- rnorm(sim$nsample[i], sim$mean_eff[i], sim$sd_eff[i]) # generate data
    bf_dat <- ttestBF(x = dat, mu = null_value, rscale = sim$scale_cauchy[i]) # compute one sample t.test with prior width
    p_value[i] <- t.test(x = dat, mu = null_value)$p.value # p value from frequentist t-test
    bf[i] <- extractBF(bf_dat, onlybf = TRUE) # extract the bf
    obs_mean[i] <- mean(dat) # compute the mean of each dataset
    obs_sd[i] <- sd(dat) # compute sd of each dataset
    
    # Progress
    progress(iter = nrow(sim), index = i)
}

sim$bf <- bf
sim$log_bf <- log(bf) # log of the bf
sim$p_value = p_value
sim$obs_mean <- obs_mean
sim$obs_sd <- obs_sd
sim$obs_eff <- (sim$obs_mean - null_value)/sim$obs_sd # observed effect size

# Saving

save(sim, file = "results/sim.rda") # saving an .rda file to results/